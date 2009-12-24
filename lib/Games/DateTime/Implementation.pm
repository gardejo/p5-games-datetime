package Games::DateTime::Implementation;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose::Role;
use MooseX::Types::DateTime qw(Duration TimeZone Locale);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use DateTime;
use Lingua::EN::Inflect::Number qw(to_S);
use Memoize qw(memoize);
use Sub::Name qw(subname);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# consuming role(s)
# ****************************************************************

# note: must consume before attribute definitions
with qw(
    MooseX::Clone
);


# ****************************************************************
# attributes
# ****************************************************************

has 'real_time' => (
    traits      => [qw(
        Clone
    )],
    is          => 'rw',
    isa         => 'DateTime',  # this is class_type 'DateTime'
    coerce      => 1,
    lazy_build  => 1,
    trigger     => \&_trigger_on_real_time,
);

# epoch 0 equals the game calendar 0000/00/00 00:00:00
# (is not the origin time on game calendar yyyy/mm/dd hh:mm:ss)
has 'epoch' => (
    is          => 'rw',
    isa         => 'Int',
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_real_time;
        $_[0]->_clear_date;
    },
);

has [qw(year month day hour minute second)] => (
    is          => 'rw',
    isa         => 'Int',       # we can assign delayed type constraints
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_real_time;
        $_[0]->clear_epoch;
        $_[0]->clear_day_of_week;
        $_[0]->clear_day_abbr;
        $_[0]->clear_day_name;
    },
);

has 'day_of_week' => (
    is          => 'ro',
    isa         => 'Int',
    init_arg    => undef,
    lazy_build  => 1,
);

has [qw(day_abbr day_name)] => (
    is          => 'ro',
    isa         => 'Str',
    init_arg    => undef,
    lazy_build  => 1,
);

has 'origin_on_real' => (
    traits      => [qw(
        Clone
    )],
    is          => 'ro',
    isa         => 'DateTime',  # this is class_type 'DateTime'
    coerce      => 1,
    init_arg    => undef,
    lazy_build  => 1,
);

has 'origin_on_game' => (
    traits      => [qw(
        Clone
    )],
    is          => 'ro',
    isa         => 'HashRef[Int]',
    auto_deref  => 1,
    init_arg    => undef,
    lazy_build  => 1,
);

has 'base' => (
    traits      => [qw(
        Clone
        Hash
    )],
    is          => 'ro',
    isa         => 'HashRef[Int]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        base_of     => 'get',
        exists_base => 'exists',
    },
);

has 'coefficient' => (
    is          => 'ro',
    isa         => 'Num',       # is not an 'Int'
    init_arg    => undef,
    lazy_build  => 1,
);

has 'days_in_a_week' => (
    is          => 'ro',
    isa         => 'Int',
    init_arg    => undef,
    lazy_build  => 1,
);

has 'day_abbrs' => (
    traits      => [qw(
        Clone
        Hash
    )],
    is          => 'ro',
    isa         => 'HashRef[ArrayRef[Str]]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        day_abbrs_of => 'get',
    },
);

has 'day_names' => (
    traits      => [qw(
        Clone
        Hash
    )],
    is          => 'ro',
    isa         => 'HashRef[ArrayRef[Str]]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        day_names_of => 'get',
    },
);

has 'locale' => (
    traits      => [qw(
        Clone
    )],
    is          => 'rw',
    isa         => Locale,
    coerce      => 1,
    lazy_build  => 1,
);

has [qw(standard_time_zone local_time_zone)] => (
    traits      => [qw(
        Clone
    )],
    is          => 'ro',
    isa         => TimeZone,
    coerce      => 1,
    init_arg    => undef,
    lazy_build  => 1,
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_real_time {
    my $self = shift;

    return $self->_has_any_date ? $self->_build_real_time_from_epoch
         :                        $self->_build_real_time_from_now;
}

sub _build_real_time_from_epoch {
    my $self = shift;

    my $duration_on_game
        = $self->epoch - $self->date_to_epoch($self->origin_on_game);
    my $duration_on_real
        = int( $duration_on_game / $self->coefficient );

    return $self->origin_on_real
                ->clone
                ->add(seconds => $duration_on_real)
                ->set_time_zone($self->local_time_zone);
}

sub _build_real_time_from_now {
    my $self = shift;

    # string 'now' which for return value does not run correctly
    # because MooseX::Types::DateTime does not coerce with 'time_zone' option
    return DateTime->now(
        time_zone => $self->local_time_zone,
    );
}

sub _build_epoch {
    my $self = shift;

    return $self->_has_any_date ? $self->_build_epoch_from_date
                                : $self->_build_epoch_from_real_time;
}

sub _build_epoch_from_real_time {
    my $self = shift;

    my $duration_on_real
        = $self->real_time
               ->clone
               ->set_time_zone( $self->standard_time_zone )
               ->epoch
        - $self->origin_on_real
               ->epoch;
    my $epoch
        = $self->date_to_epoch( $self->origin_on_game ) # epoch seconds
        + $duration_on_real * $self->coefficient;       # duration on game

    return $epoch;
}

sub _build_epoch_from_date {
    my $self = shift;

    my %date = $self->_date_as_hash;

    return $self->date_to_epoch(%date);
}

sub _build_year {
    return $_[0]->_build_date('year');
}

sub _build_month {
    return $_[0]->_build_date('month');
}

sub _build_day {
    return $_[0]->_build_date('day');
}

sub _build_hour {
    return $_[0]->_build_date('hour');
}

sub _build_minute {
    return $_[0]->_build_date('minute');
}

sub _build_second {
    return $_[0]->_build_date('second');
}

sub _build_day_of_week {
    my $self = shift;

    return int( $self->epoch / $self->seconds_in('day') )   # total passed days
                % $self->days_in_a_week;
}

sub _build_day_abbr {
    my $self = shift;

    return $self->day_abbrs_of( $self->locale->language_id )
                ->[ $self->day_of_week ];
}

sub _build_day_name {
    my $self = shift;

    return $self->day_names_of( $self->locale->language_id )
                ->[ $self->day_of_week ];
}

around _build_origin_on_real => sub {
    my ($next, $self) = @_;

    my $origin_on_real = $self->$next;
    return $origin_on_real
        if blessed $origin_on_real;

    return DateTime->new(
        %$origin_on_real,
        time_zone => $self->standard_time_zone,
    );
};

sub _build_locale {
    return 'en';
}

sub _build_local_time_zone {
    return 'local';
}


# ****************************************************************
# utilitiy(-ies) of predicator(s), builder(s), clearer(s), and trigger(s)
# ****************************************************************

after real_time => sub {
    $_[0]->_trigger_on_real_time;
};

sub _has_any_date {
    my $self = shift;

    return $self->has_year
        || $self->has_month
        || $self->has_day
        || $self->has_hour
        || $self->has_minute
        || $self->has_second;
}

sub _build_date {
    my ($self, $target_figure) = @_;

    my %date;
    if ($self->_has_any_date) {
        %date = $self->_date_as_hash;
    }
    %date = (
        %date,
        $self->epoch_to_date( $self->epoch ),
    );

    return $date{$target_figure};
}

sub _clear_date {
    my $self = shift;

    $self->clear_year;
    $self->clear_month;
    $self->clear_day;
    $self->clear_hour;
    $self->clear_minute;
    $self->clear_second;
    $self->clear_day_of_week;
    $self->clear_day_abbr;
    $self->clear_day_name;

    return;
}

sub _date_as_hash {
    my $self = shift;

    return (
        year   => $self->has_year   ? $self->year   : 0,
        month  => $self->has_month  ? $self->month  : 1,
        day    => $self->has_day    ? $self->day    : 1,
        hour   => $self->has_hour   ? $self->hour   : 0,
        minute => $self->has_minute ? $self->minute : 0,
        second => $self->has_second ? $self->second : 0,
    );
}

sub _trigger_on_real_time {
    $_[0]->clear_epoch;
    $_[0]->_clear_date;
}


# ****************************************************************
# utilitiy(-ies) of getter
# ****************************************************************

sub ymd {
    my ($self, $optional_separator) = @_;

    $optional_separator = '-'
        unless defined $optional_separator;

    return sprintf (
        '%0.4d%s%0.2d%s%0.2d',
            $self->year,  $optional_separator,
            $self->month, $optional_separator,
            $self->day,
    );
}

sub hms {
    my ($self, $optional_separator) = @_;

    $optional_separator = ':'
        unless defined $optional_separator;

    return sprintf (
        '%0.2d%s%0.2d%s%0.2d',
            $self->hour,   $optional_separator,
            $self->minute, $optional_separator,
            $self->second,
    );
}


# ****************************************************************
# converter(s)
# ****************************************************************

sub date_to_epoch {
    my ($self, %date) = @_;

    my $epoch               = 0;
    my $seconds_in_a_figure = 1;

    foreach my $figure (qw(
        second minute hour day month year
    )) {
        if (exists $date{$figure}) {
            my $duration_in_figure = $date{$figure};
            $duration_in_figure -= 1
                if $figure eq 'month' || $figure eq 'day';
            $epoch += $seconds_in_a_figure * $duration_in_figure;
        }
        $seconds_in_a_figure *= $self->base_of($figure)
            if $self->exists_base($figure);
    }

    return $epoch;
}

sub date_to_duration {
    my ($self, %date) = @_;

    while (my ($plural_figure, $value) = each %date) {
        $date{ to_S($plural_figure) } = $date{$plural_figure};
    }

    ++ $date{month};
    ++ $date{day};

    return $self->date_to_epoch(%date);
}

sub epoch_to_date {
    my ($self, $epoch) = @_;

    my %date;

    foreach my $figure (qw(
        second minute hour day month
    )) {
        $date{$figure} = $epoch % $self->base_of($figure);
        $epoch = int( $epoch / $self->base_of($figure) );
    }
    $date{year} = $epoch;

    # duration to number
    ++ $date{month};
    ++ $date{day};

    return %date;
}

sub duration_to_date {
    my ($self, $epoch) = @_;

    my %date = $self->epoch_to_date($epoch);

    -- $date{month};
    -- $date{day};

    return %date;
}

sub seconds_in {
    my ($self, $target_figure) = @_;

    my $seconds = 1;

    FIGURE:
    foreach my $figure (qw(
        second minute hour day month year
    )) {
        last FIGURE
            if $target_figure eq $figure;
        $seconds *= $self->base_of($figure);
    }

    return $seconds;
}


# ****************************************************************
# calculator(s)
# ****************************************************************

sub add {
    my ($self, %date) = @_;

    $self->epoch( $self->epoch + $self->date_to_duration(%date) );

    return $self;   # for method chain
}


# ****************************************************************
# memoization
# ****************************************************************

# cf. http://blog.eorzea.asia/2009/11/post_79.html
#     http://gist.github.com/230058
sub _memoize {
    no strict 'refs';   ## no critic
    foreach my $method (qw(
        duration_to_date    epoch_to_date
        date_to_duration    date_to_epoch
        seconds_in
    )) {
        *{ $method } = subname __PACKAGE__ . '::' . $method => memoize($method);
    }
}


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->_memoize;


# ****************************************************************
# return true
# ****************************************************************

1;
__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

Games::DateTime::Implementation - Moose role for Games::DateTime::Implementation::*

=head1 SYNOPSIS

    package Games::DateTime::Implementation::MyGame;

    use Moose;

    with qw(
        Games::DateTime::Implementation
    );

=head1 DESCRIPTION

This role provides common attributes and methods.

=head1 METHODS

See L<Games::DateTime|Games::DateTime/METHODS>.

=over 4

=item C<< $datetime->add(%duration) >>

=item C<< $datetime->ymd($optional_separator) >>

=item C<< $datetime->hms($optional_separator) >>

=back

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya at cpan dot org> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com/>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
