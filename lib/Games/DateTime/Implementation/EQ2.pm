package Games::DateTime::Implementation::EQ2;


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
# MOP dependency(-ies)
# ****************************************************************

use Moose;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


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
        en => [qw(
            Drk         Brn         Sou         Wnd
            Stl         Brw         Fst
        )], # ToDo
        ja => [qw(
            闇          燃          魂          風
            鉄          醸          宴
        )], # ToDo
        de => [qw(
            Drk.        Brn.        Sou.        Wnd.
            Stl.        Brw.        Fst.
        )], # ToDo
        fr => [qw(
            drk.        brn.        sou.        wnd.
            stl.        brw.        fst.
        )], # ToDo
    };
}

sub _build_day_names {
    return {
        en => [qw(
            Darkday     Burnday     Soulday     Windday
            Steelday    Brewday     Feastday
        )],
        ja => [qw(
            Darkday     Burnday     Soulday     Windday
            Steelday    Brewday     Feastday
        )], # ToDo
        de => [qw(
            Darkday     Burnday     Soulday     Windday
            Steelday    Brewday     Feastday
        )], # ToDo
        fr => [qw(
            Darkday     Burnday     Soulday     Windday
            Steelday    Brewday     Feastday
        )], # ToDo
    };
}

# month_names
# [qw(
#     Deepice     Grayeven    Stargazing  Weeping
#     Blossoming  Oceansfull  Scorchedsky Warmstill
#     Busheldown  Lastleaf    Firstchill  Deadening
# )];


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
__PACKAGE__->assign_delayed_type_constraints(
    year   => 'GameYear',
    month  => 'GameMonth',
    day    => 'GameDay',
    hour   => 'GameHour',
    minute => 'GameMinute',
    second => 'GameSecond',
);
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

Games::DateTime::Implementation::EQ2 - Implementation of EverQuest II for Games::DateTime

=head1 SYNOPSIS

    use Games::DateTime;

    my $eq2_datetime = Games::DateTime->create('EQ2');
    printf (
        "Norrath has %d days in a week.",
            $eq2_datetime->days_in_a_week,
    );

=head1 DESCRIPTION

This class provides several constants of EverQuset II
for L<Games::DateTime|Games::DateTime>.


# Burnday, Scorchedsky 9, of the year 3757
# http://www.lorelibrary.com/?page=book&bid=177&ss=calendar

# http://search.cpan.org/~pjf/Games-EverQuest-LogLineParser-0.09/lib/Games/EverQuest/LogLineParser.pm
[Mon Oct 13 00:42:36 2003] Game Time: Thursday, April 05, 3176 - 6 PM
[Mon Oct 13 00:42:36 2003] Earth Time: Thursday, April 05, 2003 19:25:47

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
