package Games::DateTime::Alias::FF14;


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


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# public method(s)
# ****************************************************************

around _build_alias => sub {
    my ($next, $self) = @_;

    my $alias = $self->$next;
    my @aliases = qw(
        ff14                ffxiv
        ff_14               ff_xiv
        finalfantasy14      finalfantasyxiv
        finalfantasy_14     finalfantasy_xiv
        final_fantasy_14    final_fantasy_xiv
        eorzea
        hydelin
    );
    @$alias{@aliases} = ('FF14') x scalar @aliases;

    return $alias;
};


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

Games::DateTime::Alias::FF14 - Aliases of Final Fantasy XIV

=head1 SYNOPSIS

    use Games::DateTime;

    Games::DateTime->install_alias(qw(FF14));
    my $eorzea  = Games::DateTime->create('Eorzea');    # FF14
    my $hydelin = Games::DateTime->create('Hydelin');   # FF14

=head1 DESCRIPTION

This class provides default aliases of Final Fantasy XIV
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
