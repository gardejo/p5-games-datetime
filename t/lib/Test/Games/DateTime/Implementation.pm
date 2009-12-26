package Test::Games::DateTime::Implementation;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# base class(es)
# ****************************************************************

use base qw(
    Test::Games::DateTime
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************

sub set_oath_time {
    my $self = shift;

    # the exact time when Pres. Barack Obama take oath of office
    $self->{object}->real_time->set_time_zone('EST')
                              ->set(
                                    year     => 2009,
                                    month    =>    1,
                                    day      =>   20,
                                    hour     =>   12,
                                    minute   =>    5,
                                    second   =>    2,   # but, it is vague
                              );

    return;
}

sub get_exception_pattern {
    my ($self, $figure) = @_;

    my $format
        = q(^Attribute \\(%s\\) does not pass the type constraint because: )
        . q(%s on the game);
    my $pattern = sprintf $format, $figure, ucfirst $figure;

    return qr{$pattern};
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

Test::Games::DateTime::Implementation - Base class for Test::Games::DateTime::Implementation::*

=head1 SYNOPSIS

    package Test::Games::DateTime::Implementation::EQ1;

    use base qw(
        Test::Games::DateTime::Implementation
    );

=head1 DESCRIPTION

This class is base class for C<Test::Games::DateTime::Implementation::*>.

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
