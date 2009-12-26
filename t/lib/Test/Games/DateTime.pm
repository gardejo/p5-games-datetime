package Test::Games::DateTime;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# base class(es)
# ****************************************************************

use base qw(
    Test::Class
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::More;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Games::DateTime;


# ****************************************************************
# test(s)
# ****************************************************************

sub startup : Test(startup) {
    my $self = shift;

    $self->{factory_class} = 'Games::DateTime';

    return;
}

sub setup : Test(setup) {
    my $self = shift;

    return;
}

sub teardown : Test(teardown) {
    my $self = shift;

    return;
}

sub shutdown : Test(shutdown) {
    my $self = shift;

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

Test::Games::DateTime - Base class for Test::Games::DateTime::*

=head1 SYNOPSIS

    package Test::Games::DateTime::Factory;

    use base qw(
        Test::Games::DateTime
    );

=head1 DESCRIPTION

This class is base class for C<Test::Games::DateTime::*>.

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
