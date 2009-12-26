package Test::Games::DateTime::Implementation::WoW;


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

    $self->{object} = $self->{factory_class}->create('WoW');

    return;
}

sub test_dummy : Tests(no_plan) {
    my $self = shift;

    ok 1
        => 'Jehoshaphat!';

    return;
}


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

Test::Games::DateTime::Implementation::WoW - Test for Games::DateTime::Implementation::WoW

=head1 SYNOPSIS

    use Test::Games::DateTime::Implementation::WoW;

    Test::Games::DateTime::Implementation::WoW->runtests;

=head1 DESCRIPTION

This class tests L<Games::DateTime::Implementation::WoW|
Games::DateTime::Implementation::WoW>.

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
