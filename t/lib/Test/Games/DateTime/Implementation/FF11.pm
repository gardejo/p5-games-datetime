package Test::Games::DateTime::Implementation::FF11;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# base class(es)
# ****************************************************************

use base qw(
    Test::Games::DateTime::Implementation
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::Exception;
use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************

sub setup : Test(setup) {
    my $self = shift;

    $self->{object} = $self->{factory_class}->create('FF11');

    return;
}

sub test_base : Tests(no_plan) {
    my $self = shift;

    is $self->{object}->base_of('month'),  12 => 'base of month';
    is $self->{object}->base_of('day'),    30 => 'base of day';
    is $self->{object}->base_of('hour'),   24 => 'base of hour';
    is $self->{object}->base_of('minute'), 60 => 'base of minute';
    is $self->{object}->base_of('second'), 60 => 'base of second';

    return;
}

sub test_coefficient : Tests(no_plan) {
    my $self = shift;

    is $self->{object}->coefficient, 25 => 'coefficient';

    return;
}

sub test_days_in_a_week : Tests(no_plan) {
    my $self = shift;

    is $self->{object}->days_in_a_week, 8 => 'days in a week';

    return;
}

sub test_origin_on_real : Tests(no_plan) {
    my $self = shift;

    isa_ok $self->{object}->origin_on_real, 'DateTime';

    is $self->{object}->origin_on_real->year,   2002
        => 'origin year on real';
    is $self->{object}->origin_on_real->month,     5
        => 'origin month on real';
    is $self->{object}->origin_on_real->day,      16
        => 'origin dasy on real';
    is $self->{object}->origin_on_real->hour,      0
        => 'origin hour on real';
    is $self->{object}->origin_on_real->minute,    0
        => 'origin minute on real';
    is $self->{object}->origin_on_real->second,    0
        => 'origin second on real';

    is $self->{object}->origin_on_real->time_zone->name, 'Asia/Tokyo'
        => 'origin time zone on real';

    return;
}

sub test_standard_time_zone : Tests(no_plan) {
    my $self = shift;

    isa_ok $self->{object}->standard_time_zone, 'DateTime::TimeZone';

    is $self->{object}->standard_time_zone->name, 'Asia/Tokyo'
        => 'standard time zone';

    return;
}

sub test_get_virtual_time : Tests(no_plan) {
    my $self = shift;

    $self->set_oath_time;

    is $self->{object}->year,   1064 => 'virtual year';
    is $self->{object}->month,    12 => 'virtual month';
    is $self->{object}->day,      18 => 'virtual day';
    is $self->{object}->hour,      4 => 'virtual hour';
    is $self->{object}->minute,    5 => 'virtual minute';
    is $self->{object}->second,   50 => 'virtual second';

    is $self->{object}->ymd,      '1064-12-18' => 'virtual ymd';
    is $self->{object}->hms,        '04:05:50' => 'virtual hms';
    is $self->{object}->ymd('/'), '1064/12/18' => 'virtual ymd with slash';
    is $self->{object}->hms(':'),   '04:05:50' => 'virtual hms with colon';

    is $self->{object}->day_of_week, 3          => 'virtual day of week';
    is $self->{object}->day_name,    'Windsday' => 'virtual day name';
    is $self->{object}->day_abbr,    'Wnd'      => 'virtual day abbreviation';

    return;
}

sub test_set_virtual_time : Tests(no_plan) {
    my $self = shift;

    $self->{object}->year  (1064);
    $self->{object}->month (  12);
    $self->{object}->day   (  18);
    $self->{object}->hour  (   4);
    $self->{object}->minute(   5);
    $self->{object}->second(  50);

    is $self->{object}->real_time->set_time_zone('EST')->iso8601,
        '2009-01-20T12:05:02'
            => 'set virtual time ok';

    return;
}

sub test_set_incorrect_virtual_time : Tests(no_plan) {
    my $self = shift;

    throws_ok {
        $self->{object}->year(-1);
    } $self->get_exception_pattern('year')
        => 'exception to incorrect year (under)';

    throws_ok {
        $self->{object}->month( 0);
    } $self->get_exception_pattern('month')
        => 'exception to incorrect month (under)';
    throws_ok {
        $self->{object}->month(13);
    } $self->get_exception_pattern('month')
        => 'exception to incorrect month (over)';

    throws_ok {
        $self->{object}->day( 0);
    } $self->get_exception_pattern('day')
        => 'exception to incorrect day (under)';
    throws_ok {
        $self->{object}->day(31);
    } $self->get_exception_pattern('day')
        => 'exception to incorrect day (over)';

    throws_ok {
        $self->{object}->hour(-1);
    } $self->get_exception_pattern('hour')
        => 'exception to incorrect hour (under)';
    throws_ok {
        $self->{object}->hour(24);
    } $self->get_exception_pattern('hour')
        => 'exception to incorrect hour (over)';

    throws_ok {
        $self->{object}->minute(-1);
    } $self->get_exception_pattern('minute')
        => 'exception to incorrect minute (under)';
    throws_ok {
        $self->{object}->minute(60);
    } $self->get_exception_pattern('minute')
        => 'exception to incorrect minute (over)';

    throws_ok {
        $self->{object}->second(-1);
    } $self->get_exception_pattern('second')
        => 'exception to incorrect second (under)';
    throws_ok {
        $self->{object}->second(60);
    } $self->get_exception_pattern('second')
        => 'exception to incorrect second (over)';

    return;
}

sub test_add_real_time : Tests(no_plan) {
    my $self = shift;

    $self->set_oath_time;

    $self->{object}->real_time->add({
        years   => 1,
        months  => 2,
        days    => 3,
        hours   => 4,
        minutes => 5,
        seconds => 6,
    });

    is $self->{object}->year,   1094 => 'virtual year';
    is $self->{object}->month,     8 => 'virtual month';
    is $self->{object}->day,      17 => 'virtual day';
    is $self->{object}->hour,     10 => 'virtual hour';
    is $self->{object}->minute,   13 => 'virtual minute';
    is $self->{object}->second,   20 => 'virtual second';

    is $self->{object}->day_of_week, 2           => 'virtual day of week';
    is $self->{object}->day_name,    'Watersday' => 'virtual day name';
    is $self->{object}->day_abbr,    'Wtr'       => 'virtual day abbreviation';

    return;
}

sub test_add_virtual_time : Tests(no_plan) {
    my $self = shift;

    $self->{object}->year  (1064);
    $self->{object}->month (  12);
    $self->{object}->day   (  18);
    $self->{object}->hour  (   4);
    $self->{object}->minute(   5);
    $self->{object}->second(  50);

    $self->{object}->add(
        years   => 1,
        months  => 2,
        days    => 3,
        hours   => 4,
        minutes => 5,
        seconds => 6,
    );

    is $self->{object}->ymd, '1066-02-21' => 'virtual ymd';
    is $self->{object}->hms,   '08:10:56' => 'virtual hms';

    return;
}


# ****************************************************************
# return trule
# ****************************************************************

1;
__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

Test::Games::DateTime::Implementation::FF11 - Test for Games::DateTime::Implementation::FF11

=head1 SYNOPSIS

    use Test::Games::DateTime::Implementation::FF11;

    Test::Games::DateTime::Implementation::FF11->runtests;

=head1 DESCRIPTION

This class tests L<Games::DateTime::Implementation::FF11|
Games::DateTime::Implementation::FF11>.

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya at ermitejo dot com> >>,
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
