#!/usr/local/bin/perl


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use FindBin;
use lib $FindBin::Bin . '/lib';
use lib $FindBin::Bin . '/../lib';

use Games::DateTime::Clock;


# ****************************************************************
# main routine
# ****************************************************************

Games::DateTime::Clock->new_with_options->run;


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

clock.pl - Simple world time clock

=head1 SYNOPSIS

    $ perl clock.pl -i FF11

    or

    $ perl clock.pl -i FF11 -h "" -f ""

    or

    $ perl clock.pl -i FF11 -g "Final Fantasy XI" -w Vana'diel -r Earth

    or

    $ perl clock.pl -i FF14 -g "Final Fantasy XIV" -w Eorzea -r Earth

    or

    $ perl clock.pl --configfile clock/ff11.yml

    or

    ...

=head1 SEE ALSO

=over 4

=item *

L<Games::DateTime|Games::DateTime>

=back

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
