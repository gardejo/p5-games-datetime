package Games::DateTime;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# perl dependency
# ****************************************************************

use 5.008_001;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose::Util qw(apply_all_roles);
use MooseX::AbstractFactory;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Games::DateTime::Alias;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# class variable(s)
# ****************************************************************

our $VERSION = '0.00';
our $ALIAS   = Games::DateTime::Alias->new;


# ****************************************************************
# setting(s) for factory
# ****************************************************************

implementation_class_via sub {
    __PACKAGE__ . '::Implementation::' . shift;
};


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my $next  = shift;
    my $class = shift;

    my $init_arg = $class->$next(@_);

    $init_arg->{_implementation}
        = $class->_alias->canonical_name_of(lc $init_arg->{_implementation})
            if $class->_alias->exists_alias(lc $init_arg->{_implementation});
    $init_arg->{_options} = {}
        unless defined $init_arg->{_options};

    return $init_arg;
};


# ****************************************************************
# accessor(s) to class variable(s)
# ****************************************************************

sub _alias {
    return $ALIAS;
}


# ****************************************************************
# public class method(s)
# ****************************************************************

sub install_alias {
    my $class = shift;

    if (scalar @_ == 1 && ! blessed $_[0] && ref $_[0] eq 'HASH') {
        $class->alias->install_alias($_[0]);
    }
    else {
        foreach my $part_of_alias_role_name (@_) {
            apply_all_roles(
                $class->alias,
                __PACKAGE__ . '::Alias::' . $part_of_alias_role_name,
            );
        }
    }

    return;
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

Games::DateTime - A simple date and time object on any games

=head1 SYNOPSIS

    use Games::DateTime;

    # construction by factory
    my $ff11 = Games::DateTime->create('FF11');
    my $ff14 = Games::DateTime->create('FF14');
    my $eq1  = Games::DateTime->create('EQ1');

    # aliases are available
    Games::DateTime->install_alias(qw(FF11 EQ1));
    my $also_ff11 = Games::DateTime->create(q{Vana'diel});
    my $also_eq1  = Games::DateTime->create(q{Norrath});

    # construction with options
    my $ff11_on_specified_earth_date = Games::DateTime->create('FF11', {
        real_time => {
            year  => 2009,
            month =>    1,
            day   =>    1,
        },
    });
    my $ff11_on_specified_game_date = Games::DateTime->create('FF11', {
        year  => 1000,
        month =>    1,
        day   =>    1,
    });

    # display of game times
    printf (
        "Vana'diel: %s\nEarth: %s\n",
            $ff11->real_time->ymd('/') . ' ' . $ff11->real_time->hms(':'),
            $ff11->ymd('/')            . ' ' . $ff11->hms(':'),
    );

    # setting after construction
    $ff11->year(1000);
    $ff11->month(1);
    $ff11->day(1);

    # type constraints are available
    eval {
        $ff11->month(13);   # violates a type constraint (from 1 to 12)
    };

    # calculation date and time
    $ff11->add( years => 42, days => -1 );
    my $ff11_on_earth_yesterday = Games::DateTime->create('FF11')
                                                ->real_time
                                                ->add( days => -1 );
    my $ff11_on_game_yesterday  = Games::DateTime->create('FF11')
                                                ->add( days => -1 );
    my $stadtluft_macht_frei    = $ff11->clone
                                       ->add( years => 1, days => 1 );

=head1 DESCRIPTION



=head1 METHODS

=head2 Constructor

=head3 C<< Games::DateTime->create($implementation, \%option) >>

blah blah blah

=head2 Alias manager

=head3 C<< Games::DateTime->install_alias(@implementations) >>

blah blah blah

=head3 C<< Games::DateTime->install_alias(\%alias) >>

blah blah blah

=head2 Utilities of getters

=head3 C<< $datetime->hms($optional_separator) >>

Same as L<< DateTime's $dt->ymd()|DateTime >>.

=head3 C<< $datetime->hms($optional_separator) >>

Same as L<< DateTime's $dt->hms()|DateTime >>.

=head2 Calculator

=head3 C<< $datetime->add(%duration) >>

Same as L<< DateTime's $dt->add()|DateTime >>.

=head1 EXAMPLES

This distribution includes whole file which related
L<workflow|/How to model in your application - typical workflow> above.

Run the following command at root directory of this distribution:

    $ perl examples/clock.pl -i FF11

    or

    $ perl examples/clock.pl -i FF11 -h "" -f ""

    or

    $ perl examples/clock.pl -i FF11 -g "Final Fantasy XI" -w Vana'diel -r Earth

    or

    $ perl examples/clock.pl -i FF14 -g "Final Fantasy XIV" -w Eorzea -r Earth

    or

    $ perl examples/clock.pl --configfile examples/clock/ff11.yml

    or

    ...

=head1 SEE ALSO

=over 4

=item *

L<Games::DateTime::Implementation::EQ1|Games::DateTime::Implementation::EQ1>

=item *

L<Games::DateTime::Implementation::EQ2|Games::DateTime::Implementation::EQ2>

=item *

L<Games::DateTime::Implementation::FF11|Games::DateTime::Implementation::FF11>

=item *

L<Games::DateTime::Implementation::FF14|Games::DateTime::Implementation::FF14>

=item *

L<Games::DateTime::Implementation::WoW|Games::DateTime::Implementation::WoW>

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
to C<bug-games-datetime at rt.cpan.org>,
or through the web interface
at L<http://rt.cpan.org/Public/Bug/Report.html?Queue=Games-DateTime>.
I will be notified, and then you'll automatically be notified of progress
on your bugs/requests as I make changes.

When reporting bugs, if possible,
please add as small a sample as you can make of the code
that produces the bug.
And of course, suggestions and patches are welcome.

=head1 SUPPORT

You can find documentation for this module with the C<perldoc> command.

    perldoc Games::DateTime

You can also find the Japanese edition of documentation for this module
with the C<perldocjp> command from L<Pod::PerldocJp|Pod::PerldocJp>.

    perldocjp Games::DateTime.ja

You can also look for information at:

=over 4

=item RT: CPAN's request tracker

L<http://rt.cpan.org/Public/Dist/Display.html?Name=Games-DateTime>

=item AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-DateTime>

=item Search CPAN

L<http://search.cpan.org/dist/Games-DateTime>

=item CPAN Ratings

L<http://cpanratings.perl.org/dist/Games-DateTime>

=back

=head1 VERSION CONTROL

This module is maintained using I<git>.
You can get the latest version from
L<git://github.com/gardejo/p5-games-datetime.git>.

=head1 CODE COVERAGE

I use L<Devel::Cover|Devel::Cover> to test the code coverage of my tests,
below is the C<Devel::Cover> summary report on this distribution's test suite.

 ---------------------------- ------ ------ ------ ------ ------ ------ ------
 File                           stmt   bran   cond    sub    pod   time  total
 ---------------------------- ------ ------ ------ ------ ------ ------ ------
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
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
