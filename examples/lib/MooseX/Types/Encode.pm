package MooseX::Types::Encode;


# ****************************************************************
# pragma(s)
# ****************************************************************

use 5.008_001;

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# general dependency(-ies) 
# ****************************************************************

use Carp qw(confess);
use Encode qw(find_encoding);
use Scalar::Util qw(blessed);


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use MooseX::Types::Moose qw(Str Object);


# ****************************************************************
# declare of exporting type name(s)
# ****************************************************************

use MooseX::Types -declare => [qw(Encode)];
# use MooseX::Types -declare => [qw(Encoding)];


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# public class variable(s)
# ****************************************************************

our $VERSION = '0.00';


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

subtype Encode,
    as Object,
        where {
               $_->isa('Encode::XS')
            || $_->isa('Encode::utf8');
        };

coerce Encode,
    from Str,
        via {
            my $encoding = find_encoding($_);
            confess qq(Validation failed for encoding failed with value ($_) )
                  . qq(because: Specified encoding does not found )
                  . qq(in an Encode implementation)
                unless blessed $encoding;
            return $encoding;
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

MooseX::Types::Encode - Encode related constraints and coercions for Moose classes

=head1 SYNOPSIS

    {
        package Foo;

        use utf8;

        use Moose;
        use MooseX::Types::Encode qw(Encode);

        use namespace::clean -except => [qw(meta)];

        has 'external_string' => (
            is          => 'rw',
            isa         => 'Str',
            lazy_build  => 1,
            trigger     => sub {
                $_[0]->clear_internal_string;
            },
        );

        has 'internal_string' => (
            is          => 'rw',
            isa         => 'Str',
            lazy_build  => 1,
            trigger     => sub {
                $_[0]->clear_external_string;
            },
        );

        has 'encoding' => (
            is          => 'rw',
            isa         => Encode,
            coerce      => 1,
            default     => 'utf8',
        );

        around BUILDARGS => sub {
            my $next  = shift;
            my $class = shift;

            my $init_arg = $class->$next(@_);

            confess 'Could not specifiy both (external/internal) strings '
                  . 'for initialization arguments'
                if exists $init_arg->{external_string}
                && exists $init_arg->{internal_string};

            return $init_arg;
        };

        sub _build_external_string {
            return $_[0]->encoding->encode( $_[0]->internal_string );
        }

        sub _build_internal_string {
            return $_[0]->encoding->decode( $_[0]->external_string );
        }

        __PACKAGE__->meta->make_immutable;
    }
    {
        package main;

        use utf8;

        my $foo = Foo->new(
            external_string => "\x{94}\x{92}",  # ja: 'shiro' (en: 'white')
            encoding        => 'cp932',
        );

        $foo->internal_string(
              $foo->internal_string
            . "\x{99F1}\x{99DD}"                # ja: 'rakuda' (en: 'camel')
        );
        print $foo->external_string;            # 'shiro-rakuda' ('white camel')
    }

=head1 DESCRIPTION

This module provides L<Encode|Encode> related
L<Moose::Util::TypeConstraints|Moose::Util::TypeConstraints>
with coercion.

=head1 CONSTRAINTS AND COERCIONS

=head2 C<< Encode >>

A subtype of C<Str>,
which should be found in an L<Encode|Encode>'s encoding implementation.

For example, initializing argument accepts
C<cp932>, C<euc-jp>, C<7bit-jis>, and so on.

If you turned C<coerce> on, C<Str> will be an encoding object.

=head1 EXPORT

None by default, you will usually want to request C<Encode> explicitly.

=head1 SEE ALSO

=over 4 *

L<Encode>

=back

=head1 TO DO

=over 4

=item *

More tests

=back

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head2 Making suggestions and reporting bugs

Please report any found bugs, feature requests, and ideas for improvements
to C<bug-moosex-types-encode at rt.cpan.org>,
or through the web interface
at L<http://rt.cpan.org/Public/Bug/Report.html?Queue=MooseX-Types-Encode>.
I will be notified, and then you'll automatically be notified of progress
on your bugs/requests as I make changes.

When reporting bugs, if possible,
please add as small a sample as you can make of the code
that produces the bug.
And of course, suggestions and patches are welcome.

=head1 SUPPORT

You can find documentation for this module with the C<perldoc> command.

    perldoc MooseX::Types::Encode

You can also find the Japanese edition of documentation for this module
with the C<perldocjp> command from L<Pod::PerldocJp|Pod::PerldocJp>.

    perldocjp MooseX::Types::Encode.ja

You can also look for information at:

=over 4

=item RT: CPAN's request tracker

L<http://rt.cpan.org/Public/Dist/Display.html?Name=MooseX-Types-Encode>

=item AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Types-Encode>

=item Search CPAN

L<http://search.cpan.org/dist/MooseX-Types-Encode>

=item CPAN Ratings

L<http://cpanratings.perl.org/dist/MooseX-Types-Encode>

=back

=head1 VERSION CONTROL

This module is maintained using I<git>.
You can get the latest version from
L<git://github.com/gardejo/p5-moosex-types-encode.git>.

=head1 CODE COVERAGE

I use L<Devel::Cover|Devel::Cover> to test the code coverage of my tests,
below is the C<Devel::Cover> summary report on this distribution's test suite.

 ---------------------------- ------ ------ ------ ------ ------ ------ ------
 File                           stmt   bran   cond    sub    pod   time  total
 ---------------------------- ------ ------ ------ ------ ------ ------ ------
 ---------------------------- ------ ------ ------ ------ ------ ------ ------

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
