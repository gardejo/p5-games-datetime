package Games::DateTime::Alias;


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

use Moose;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'alias' => (
    traits      => [qw(
        Hash
    )],
    is          => 'ro',
    isa         => 'HashRef[Str]',
    handles     => {
        install_alias         => 'set',
        canonical_name_of     => 'get',
        exists_alias          => 'exists',
        uninstall_alias       => 'delete',
        uninstall_all_aliases => 'clear',
    },
    lazy_build  => 1,
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_alias {
    return {};
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

Games::DateTime::Alias - Alias manager for Games::DateTime

=head1 SYNOPSIS

    use Games::DateTime;

    Games::DateTime->install_alias('FF11');
    my $vanadiel = Games::DateTime->create(q(Vana'diel));

    Games::DateTime->install_alias(qw(EQ1 EQ2 FF11 FF14));
    my $norrath_eq2 = Games::DateTime->create('Norrath');        # EQ2

    Games::DateTime->install_alias(qw(EQ2 EQ1));
    my $norrath_eq1 = Games::DateTime->create('Norrath');        # EQ1

    Games::DateTime->install_alias({
        'abbr_of_mygame' => 'MyGame',
        'myworld'        => 'MyGame',
    });
    my $myworld = Games::DateTime->create('myworld');


=head1 DESCRIPTION

This class manages aliases for L<Games::DateTime|Games::DateTime>.

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
