package Games::DateTime::Implementation::WoW;


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

use DateTime::Locale;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# class constant(s)
# ****************************************************************

my $en = DateTime::Locale->load('en');
my $ja = DateTime::Locale->load('ja');
my $de = DateTime::Locale->load('de');
my $fr = DateTime::Locale->load('fr');


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_base {
    return {
        month  => 12,   # in a year
        day    => 30,   # in a month
        hour   => 24,   # in a day
        minute => 60,   # in a hour
        second => 60,   # in a minute
    };
}

sub _build_coefficient {
    return 20;
}

sub _build_days_in_a_week {
    return 7;
}

sub _build_origin_on_real {
    return {
        year   => 2003,
        month  =>   12,
        day    =>    1,
        hour   =>   18,
        minute =>    0,
        second =>    0,
    };
}

sub _build_origin_on_game {
    return {
        year   =>  934,
        month  =>    8,
        day    =>    4,
        hour   =>   18,
        minute =>    0,
        second =>    0,
    };
}

sub _build_standard_time_zone {
    return 'PST8PDT';
}

sub _build_day_abbrs {
    return {
        en => $en->day_stand_alone_abbreviated,
        ja => $ja->day_stand_alone_abbreviated,
        de => $de->day_stand_alone_abbreviated,
        fr => $fr->day_stand_alone_abbreviated,
    };
}

sub _build_day_names {
    return {
        en => $en->day_stand_alone_wide,
        ja => $ja->day_stand_alone_wide,
        de => $de->day_stand_alone_wide,
        fr => $fr->day_stand_alone_wide,
    };
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Games::DateTime::Implementation
    MooseX::Types::Games::DateTime
);


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->define_delayed_type_constraints;
__PACKAGE__->assign_delayed_type_constraints;
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

Games::DateTime::Implementation::WoW - Implementation of World of Warcraft for Games::DateTime

=head1 SYNOPSIS

    use Games::DateTime;

    my $wow_datetime = Games::DateTime->create('WoW');
    printf (
        "Norrath has %d days in a week.",
            $wow_datetime->days_in_a_week,
    );

=head1 DESCRIPTION

This class provides several constants of World of Warcraft
for L<Games::DateTime|Games::DateTime>.

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
