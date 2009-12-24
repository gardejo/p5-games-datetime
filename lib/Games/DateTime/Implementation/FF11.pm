package Games::DateTime::Implementation::FF11;


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
    return 25;
}

sub _build_days_in_a_week {
    return 8;
}

sub _build_origin_on_real {
    return {
        year   => 2002,
        month  =>    5,
        day    =>   16,
        hour   =>    0,
        minute =>    0,
        second =>    0,
    };
};

sub _build_origin_on_game {
    return {
        year   =>  895,
        month  =>    5,
        day    =>   16,
        hour   =>    0,
        minute =>    0,
        second =>    0,
    };
}

sub _build_standard_time_zone {
    return 'Asia/Tokyo';
}

sub _build_day_abbrs {
    return {
        en => [qw(
            Fir     Ert     Wtr     Wnd     Ice     Ltg     Lit     Drk
        )],
        ja => [qw(
            火      土      水      風      氷      雷      光      闇
        )],
        de => [qw(
            Fir.    Ert.    Etr.    Wnd.    Ice.    Ltg.    Lit.    Drk.
        )], # ToDo
        fr => [qw(
            fir.    ert.    wtr.    wnd.    ice.    ltg.    lit.    drk.
        )], # ToDo
    };
}

sub _build_day_names {
    return {
        en => [qw(
            Firesday        Earthsday       Watersday       Windsday
            Iceday          Lightningday    Lightsday       Darksday
        )],
        ja => [qw(
            火曜日          土曜日          水曜日          風曜日
            氷曜日          雷曜日          光曜日          闇曜日
        )],
        de => [qw(
            Firesday        Earthsday       Watersday       Windsday
            Iceday          Lightningday    Lightsday       Darksday
        )], # ToDo
        fr => [qw(
            Firesday        Earthsday       Watersday       Windsday
            Iceday          Lightningday    Lightsday       Darksday
        )], # ToDo
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

Games::DateTime::Implementation::FF11 - Implementation of Final Fantasy XI for Games::DateTime

=head1 SYNOPSIS

    use Games::DateTime;

    my $ff11_datetime = Games::DateTime->create('FF11');
    printf (
        "Vana'diel has %d days in a week.",
            $ff11_datetime->days_in_a_week,
    );

=head1 DESCRIPTION

This class provides several constants of Final Fantasy XI
for L<Games::DateTime|Games::DateTime>.

=head1 SEE ALSO

=over 4

=item Origin time of Crystal Era

L<http://wiki.ffo.jp/html/1069.html>

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
