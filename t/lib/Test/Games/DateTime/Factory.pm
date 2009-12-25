package Test::Games::DateTime::Factory;


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

use Test::Moose;
use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************

sub setup : Test(setup) {
    my $self = shift;

    $self->{factory_class}->uninstall_alias;

    return;
}

sub test_create_eq1 : Tests(no_plan) {
    my $self = shift;

    my $object = $self->{factory_class}->create('EQ1');
    isa_ok  $object, 'Games::DateTime::Implementation::EQ1';
    does_ok $object, 'Games::DateTime::Implementation';

    return;
}

sub test_create_eq1_by_alias : Tests(no_plan) {
    my $self = shift;

    my $implementation = 'Games::DateTime::Implementation::EQ1';
    $self->{factory_class}->install_alias(qw(EQ1));

    foreach my $alias (
        qw(
            norrath     Norrath     NoRrAtH
            eq          everquest
            eq1         everquest1
            eqi         everquesti
        ),
        'eq 1', 'eq i', 'everquest 1', 'EVERQUEST I',
    ) {
        isa_ok $self->{factory_class}->create($alias),
            $implementation
                => sprintf(
                    q(The object from '%s'),
                        $alias,
                );
    }

    return;
}

sub test_create_eq1_by_norrath : Tests(no_plan) {
    my $self = shift;

    my $implementation = 'Games::DateTime::Implementation::EQ1';
    $self->{factory_class}->install_alias(qw(EQ2 EQ1));

    foreach my $alias (
        qw(
            norrath     Norrath     NoRrAtH
        )
    ) {
        isa_ok $self->{factory_class}->create($alias),
            $implementation
                => sprintf(
                    q(The object from '%s'),
                        $alias,
                );
    }

    return;
}

sub test_create_eq2 : Tests(no_plan) {
    my $self = shift;

    my $object = $self->{factory_class}->create('EQ2');
    isa_ok  $object, 'Games::DateTime::Implementation::EQ2';
    does_ok $object, 'Games::DateTime::Implementation';

    return;
}

sub test_create_eq2_by_alias : Tests(no_plan) {
    my $self = shift;

    my $implementation = 'Games::DateTime::Implementation::EQ2';
    $self->{factory_class}->install_alias(qw(EQ2));

    foreach my $alias (
        qw(
            norrath     Norrath     NoRrAtH
            eq2         everquest2
            eqii        everquestii
            EQ2         EverQuest2  EverQuestII
        ),
        'eq 2', 'everquest 2', 'EVERQUEST II',
    ) {
        isa_ok $self->{factory_class}->create($alias),
            $implementation
                => sprintf(
                    q(The object from '%s'),
                        $alias,
                );
    }

    return;
}

sub test_create_eq2_by_norrath : Tests(no_plan) {
    my $self = shift;

    my $implementation = 'Games::DateTime::Implementation::EQ2';
    $self->{factory_class}->install_alias(qw(EQ1 EQ2));

    foreach my $alias (
        qw(
            norrath     Norrath     NoRrAtH
        )
    ) {
        isa_ok $self->{factory_class}->create($alias),
            $implementation
                => sprintf(
                    q(The object from '%s'),
                        $alias,
                );
    }

    return;
}

sub test_create_ff11 : Tests(no_plan) {
    my $self = shift;

    my $object = $self->{factory_class}->create('FF11');
    isa_ok  $object, 'Games::DateTime::Implementation::FF11';
    does_ok $object, 'Games::DateTime::Implementation';

    return;
}

sub test_create_ff11_by_alias : Tests(no_plan) {
    my $self = shift;

    my $implementation = 'Games::DateTime::Implementation::FF11';
    $self->{factory_class}->install_alias(qw(FF11));

    foreach my $alias (
        qw(
            vanadiel        Vana'diel
            crystal         crystal_era
            c.e.
            finalfantasy11  FinalFantasyXI
        ),
        'finalfantasy 11',  'finalfantasy xi',
        'Final Fantasy 11', 'FINAL FANTASY XI',
    ) {
        isa_ok $self->{factory_class}->create($alias),
            $implementation
                => sprintf(
                    q(The object from '%s'),
                        $alias,
                );
    }

    return;
}

sub test_create_ff14 : Tests(no_plan) {
    my $self = shift;

    my $object = $self->{factory_class}->create('FF14');
    isa_ok  $object, 'Games::DateTime::Implementation::FF14';
    does_ok $object, 'Games::DateTime::Implementation';

    return;
}

sub test_create_ff14_by_alias : Tests(no_plan) {
    my $self = shift;

    my $implementation = 'Games::DateTime::Implementation::FF14';
    $self->{factory_class}->install_alias(qw(FF14));

    foreach my $alias (
        qw(
            eorzea          hydelin
            finalfantasy14  FinalFantasyXIV
        ),
        'finalfantasy 14',  'finalfantasy xiv',
        'Final Fantasy 14', 'FINAL FANTASY XIV',
    ) {
        isa_ok $self->{factory_class}->create($alias),
            $implementation
                => sprintf(
                    q(The object from '%s'),
                        $alias,
                );
    }

    return;
}

sub test_create_wow : Tests(no_plan) {
    my $self = shift;

    my $object = $self->{factory_class}->create('WoW');
    isa_ok  $object, 'Games::DateTime::Implementation::WoW';
    does_ok $object, 'Games::DateTime::Implementation';

    return;
}

sub test_create_wow_by_alias : Tests(no_plan) {
    my $self = shift;

    my $implementation = 'Games::DateTime::Implementation::WoW';
    $self->{factory_class}->install_alias(qw(WoW));

    foreach my $alias (
        qw(
        ),
        'World of Warcraft',
    ) {
        isa_ok $self->{factory_class}->create($alias),
            $implementation
                => sprintf(
                    q(The object from '%s'),
                        $alias,
                );
    }

    return;
}

sub test_create_implements_by_hashed_alias : Tests(no_plan) {
    my $self = shift;

    my $alias = {
        foo  => 'EQ1',
        bar  => 'EQ2',
        baz  => 'FF11',
        qux  => 'FF14',
        quux => 'WoW',
    };

    $self->{factory_class}->install_alias($alias);

    while (my ($alias, $part_of_implement) = each %$alias) {
        isa_ok $self->{factory_class}->create($alias),
            'Games::DateTime::Implementation::' . $part_of_implement;
    }

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

Test::Games::DateTime::Factory - Tests for the factory method of Games::DateTime

=head1 SYNOPSIS

    package Test::Games::DateTime::Factory;

    Test::Games::DateTime::Factory->runtests;

=head1 DESCRIPTION

This class tests the factory method of L<Games::DateTime|Games::DateTime> class.

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
