package MooseX::Types::Games::DateTime;


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
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw(Int);


# ****************************************************************
# delayed type constraint(s)
# ****************************************************************

sub define_delayed_type_constraints {
    my $class = shift;

    my $base = $class->_build_base;

    subtype $class . '::GameYear',
        as Int,
            where {
                0 < $_;
            },
            message {
                sprintf 'Year on the game (%d) '
                      . 'is not larger than 0',
                    $_;
            };

    subtype $class . '::GameMonth',
        as Int,
            where {
                0 < $_ && $_ <= $base->{month};
            },
            message {
                sprintf 'Month on the game (%d) gets out of range, '
                      . 'which from %d to %d',
                    $_,
                    1,
                    $base->{month};
            };

    subtype $class . '::GameDay',
        as Int,
            where {
                0 < $_ && $_ <= $base->{day};
            },
            message {
                sprintf 'Day on the game (%d) gets out of range, '
                      . 'which from %d to %d',
                    $_,
                    1,
                    $base->{day};
            };

    subtype $class . '::GameHour',
        as Int,
            where {
                0 <= $_ && $_ < $base->{hour};
            },
            message {
                sprintf 'Hour on the game (%d) gets out of range, '
                      . 'which from %d to %d',
                    $_,
                    0,
                    $base->{hour} - 1;
            };

    subtype $class . '::GameMinute',
        as Int,
            where {
                0 <= $_ && $_ < $base->{minute};
            },
            message {
                sprintf 'Minute on the game (%d) gets out of range, '
                      . 'which from %d to %d',
                    $_,
                    0,
                    $base->{minute} - 1;
            };

    subtype $class . '::GameSecond',
        as Int,
            where {
                0 <= $_ && $_ < $base->{second};
            },
            message {
                sprintf 'Second on the game (%d) gets out of range, '
                      . 'which from %d to %d',
                    $_,
                    0,
                    $base->{second} - 1;
            };

    # subtype $class . '::GameDayOfWeek',
    #     as Int,
    #         where {
    #             0 <= $_ && $_ < $class->_build_days_in_a_week;
    #         },
    #         message {
    #             '';
    #         };

    return;
};


# ****************************************************************
# assignor
# ****************************************************************

sub assign_delayed_type_constraints {
    my ($class, %alignment) = @_;

    $class->meta->make_mutable;
    while (my ($attribute, $part_of_type_name) = each %alignment) {
        $class->meta->add_attribute(
            '+' . $attribute => (
                isa => $class . '::' . $part_of_type_name
            )
        );
    }
    $class->meta->make_immutable;

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

MooseX::Types::Games::DateTime - Type constraints for Games::DateTime

=head1 SYNOPSIS

    package Games::DateTime::Implementation::MyGame;

    use Moose;

    with qw(
        Games::DateTime::Implementation
    );

    __PACKAGE__->define_delayed_type_constraints;
    __PACKAGE__->assign_delayed_type_constraints;

=head1 DESCRIPTION

This module provides type constraints and coercions
for L<Games::DateTime|Games::DateTime>.

=head1 TYPE CONSTRAINTS

=over 4

=item C<< $class . '::GameYear' >>

=item C<< $class . '::GameMonth' >>

=item C<< $class . '::GameDay' >>

=item C<< $class . '::GameHour' >>

=item C<< $class . '::GameMinute' >>

=item C<< $class . '::GameSecond' >>

=back

=head1 METHODS

=head2 Delayed type constraints

=head3 C<< $impl_class->define_delayed_type_constraints() >>

Dynamically defines I<delayed> type constraints.

=head3 C<< $impl_class->assign_delayed_type_constraints(%applicant_to_type) >>

Dynamically assigns I<delayed> type constraints.

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
