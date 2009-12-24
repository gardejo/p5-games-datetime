package Games::DateTime::Clock;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;
use utf8;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use English;
use List::Util qw(max);
use Module::Load;
use Term::ANSIScreen qw(:color :cursor :screen);
use Unicode::EastAsianWidth;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Games::DateTime;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;
use MooseX::Types::Encode qw(Encode);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    MooseX::Getopt
    MooseX::SimpleConfig
);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(
    meta
    InFullwidth
    InHalfwidth
)];


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'implementation' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
    trigger     => sub {
        $_[0]->clear_width;
        $_[0]->clear_datetime;
    },
    cmd_aliases => [qw(
        i
        impl
    )],
);

has 'game' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'rw',
    isa         => 'Str',
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_header;
        $_[0]->clear_width;
    },
    cmd_aliases => [qw(
        g
        t
        title
    )],
);

has 'game_world' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'rw',
    isa         => 'Str',
    default     => 'Game',
    trigger     => sub {
        $_[0]->clear_width;
    },
    cmd_aliases => [qw(
        w
        gw
        world
        v
        vw
        virtual
        virtual_world
    )],
);

has 'real_world' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'rw',
    isa         => 'Str',
    default     => 'Real',
    trigger     => sub {
        $_[0]->clear_width;
    },
    cmd_aliases => [qw(
        r
        rw
        real
        earth
    )],
);

has 'interval' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Int',
    default     => 1,
    cmd_aliases => [qw(
        s
        sec
        second
        seconds
    )],
);

has 'header' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_width;
        $_[0]->clear_height;
    },
    cmd_aliases => [qw(
        h
    )],
);

has 'footer' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Str',
    default     => q(To stop the clock, press [Ctrl]+[C] keys.),
    trigger     => sub {
        $_[0]->clear_width;
        $_[0]->clear_height;
    },
    cmd_aliases => [qw(
        f
    )],
);

has 'encoding' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => Encode,
    coerce      => 1,
    lazy_build  => 1,
    handles     => {
        encode => 'encode',
        decode => 'decode',
    },
    cmd_aliases => [qw(
        e
    )],
);
MooseX::Getopt::OptionTypeMap->add_option_type_to_map(
    Encode() => '=s'
);

has 'datetime' => (
    traits      => [qw(
        NoGetopt
    )],
    is          => 'ro',
    does        => 'Games::DateTime::Implementation',
    init_arg    => undef,
    lazy_build  => 1,
);

has 'width' => (
    traits      => [qw(
        Hash
        NoGetopt
    )],
    is          => 'ro',
    isa         => 'HashRef[Int]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        width_of => 'get',
    },
);

has 'height' => (
    traits      => [qw(
        Hash
        NoGetopt
    )],
    is          => 'ro',
    isa         => 'HashRef[Int]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        height_of => 'get',
    },
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_game {
    my $self = shift;

    return $self->implementation;
}

sub _build_header {
    my $self = shift;

    return sprintf(
        '** %s Clock in operation **',
            $self->game,
    );
}

sub _build_encoding {
    if ($OSNAME eq 'MSWin32') {
        load 'Win32::Console';
        return 'cp' . Win32::Console::OutputCP();
    }
    else {
        return 'utf8';
    }
}

sub _build_datetime {
    my $self = shift;

    return Games::DateTime->create($self->implementation);
}

sub _build_width {
    my $self = shift;

    my %width;

    my $format = '| %s = YYYY/MM/DD(DDD) HH:MM:SS |';

    $width{max} = max map {
        $width{$_->[0]} = $self->_visual_length_of($_->[1]);
        $width{$_->[0]};
    } (
        [ header    => $self->header ],
        [ footer    => $self->footer ],
        [ game_time => sprintf $format, $self->game_world ],
        [ real_time => sprintf $format, $self->real_world ],
    );

    $width{max_world} = max map {
        $width{$_->[0]} = $self->_visual_length_of($_->[1]);
        $width{$_->[0]};
    } (
        [ game_world => $self->game_world ],
        [ real_world => $self->real_world ],
    );

    return \%width;
}

sub _build_height {
    my $self = shift;

    my %height;
    $height{max} = 4;   # frame, game, real, frame
    ++ $height{max}
        if $self->_has_effective_header;
    ++ $height{max}
        if $self->_has_effective_footer;

    return \%height;
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub run {
    my $self = shift;

    local $OUTPUT_AUTOFLUSH = 1;
    local $SIG{INT} = \&_finalize;

    $self->_print_frame();

    while (1) {
        $self->_print_datetime;
        sleep $self->interval;
        $self->datetime->real_time->add( seconds => $self->interval );
    }
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _center {
    my ($self, $string, $edge_visual_length) = @_;

    $edge_visual_length ||= 0;

    my $total_padding = $self->width_of('max')
                      - $edge_visual_length
                      - $self->_visual_length_of($string);
    my $left_padding  = int( $total_padding / 2 );
    my $right_padding = $total_padding
                      - $left_padding;

    return q{ } x $left_padding . $string . q{ } x $right_padding;
}

sub _print_frame {
    my $self = shift;

    load 'Win32::Console::ANSI'
        if $OSNAME eq 'MSWin32';

    print "\n" x $self->height_of('max');
    savepos();
    $self->_offset(- $self->height_of('max'), 0);
    savepos();

    # 2 is length('+' x 2) or length('|' x 2);
    my $top_and_bottom = '+' . '-' x ( $self->width_of('max') - 2 ) . '+';
    my $left_and_right = '|' . ' ' x ( $self->width_of('max') - 2 ) . '|';

    my @lines = ( 0 .. ( $self->height_of('max') - 1) );

    foreach my $line (@lines) {
        $self->_offset($line, 0);
        if ($line eq 0 && $self->_has_effective_header) {
            print colored (
                $self->_center( $self->encode( $self->header ) ),
                'bold green on black',
            );
        }
        elsif ($line eq $#lines && $self->_has_effective_footer) {
            print colored (
                $self->_center( $self->encode( $self->footer ) ),
                'cyan on black',
            );
        }
        elsif (
            ( $line eq 0           && ! $self->_has_effective_header ) ||
            ( $line eq 1           &&   $self->_has_effective_header ) ||
            ( $line eq $#lines - 1 &&   $self->_has_effective_footer ) ||
            ( $line eq $#lines     && ! $self->_has_effective_footer )
        ) {
            print colored (
                $top_and_bottom,
                'white on blue',
            );
        }
        else {
            print colored (
                $left_and_right,
                'white on blue',
            );
        }
    }

    return;
}

sub _print_datetime {
    my $self = shift;

    my $format = '%-' . $self->width_of('max_world') . 's'
               . ' = %s(%s) %s';
    my $edge_visual_length = $self->_visual_length_of('| ' . ' |');

    my $top_of_display = $self->_has_effective_header ? 2 : 1;

    $self->_offset($top_of_display, 2);
    print colored(
        $self->_center(
            sprintf (
                $format,
                    $self->encode( $self->game_world ),
                    $self->datetime->ymd('/'),
                    $self->encode( $self->datetime->day_abbr ),
                    $self->datetime->hms(':'),
            ), $edge_visual_length
        ), 'bold green on blue'
    );

    $self->_offset($top_of_display + 1, 2);
    print colored(
        $self->_center(
            sprintf (
                $format,
                    $self->encode( $self->real_world ),
                    $self->datetime->real_time->ymd('/'),
                    $self->encode( $self->datetime->real_time->day_abbr ),
                    $self->datetime->real_time->hms(':'),
            ), $edge_visual_length
        ), 'bold cyan on blue'
    );

    # move cursor to niche
    $self->_offset($self->height_of('max') - 1, $self->width_of('max'));

    return;
}

sub _has_effective_header {
    my $self = shift;

    return $self->width_of('header') > 0;
}

sub _has_effective_footer {
    my $self = shift;

    return $self->width_of('footer') > 0;
}

sub _offset {
    my ($invocant, $line, $column) = @_;

    loadpos();

    $line = 0 unless defined $line;
    if ($line > 0) {
        down  $line;
    }
    elsif ($line < 0) {
        up abs $line;
    }

    $column = 0 unless defined $column;
    if ($column > 0) {
        right  $column;
    }
    elsif ($column < 0) {
        left abs $column;
    }

    return;
}

# these codes stolen from tokuhirom-san
# http://d.hatena.ne.jp/tokuhirom/20070514/1179108961
sub _visual_length_of {
    my ($self, $string) = @_;

    my $visual_length = 0;
    while (
        $string =~ m{
            (?:
                (
                    \p{InFullwidth} +
                ) | (
                    \p{InHalfwidth} +
                )
            )
        }xmsg
    ) {
        $visual_length += ( $1 ? length($1) * 2 : length($2) )
    }

    return $visual_length;
}

sub _finalize {
    __PACKAGE__->_offset(5, 0);     # can not specify $self->any_method
    clline();
    warn "Farewell.\n";

    exit;
}


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->meta->make_immutable;


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

Games::DateTime::Clock - Simple world time clock

=head1 SYNOPSIS

    use Games::DateTime::Clock;

    Games::DateTime::Clock->new_with_config->run;

=head1 CAVEAT

Several string attributes
(namely, C<game>, C<game_world >, C<real_world>, C<header> and C<footer>)
*SHOULD BE* utf8.

If you want to set these values, I recommend
to use C<< --configfile >> option
for L<MooseX::SimpleConfig|MooseX::SimpleConfig>
and to write a config file in utf8.

=head1 SEE ALSO

=over 4

=item *

L<Games::DateTime|Games::DateTime>

=back

=head1 TO DO

=over 4

=item *

To branch off Common subclass and Win32 subclass.

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
