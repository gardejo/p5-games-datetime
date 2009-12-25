package Test::Games::DateTime::Real;


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

use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************

sub setup : Test(setup) {
    my $self = shift;

    $self->{object} = $self->{factory_class}->create('EQ1');

    return;
}

sub test_set_real_time : Tests(no_plan) {
    my $self = shift;

    $self->set_oath_time;

    is $self->{object}->real_time->year,   2009 => 'real year';
    is $self->{object}->real_time->month,     1 => 'real month';
    is $self->{object}->real_time->day,      20 => 'real day';
    is $self->{object}->real_time->hour,     12 => 'real hour';
    is $self->{object}->real_time->minute,    5 => 'real minute';
    is $self->{object}->real_time->second,    2 => 'real second';

    is $self->{object}->real_time->day_of_week, 2 => 'real day of week';

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

Test::Games::DateTime::Real - Test for Games::DateTime::Implementation

=head1 SYNOPSIS

    use Test::Games::DateTime::Real;

    Test::Games::DateTime::Real->runtests;

=head1 DESCRIPTION

This class tests L<Games::DateTime::Implementation|
Games::DateTime::Implementation>.

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
