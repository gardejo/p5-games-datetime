#!perl

# "Insecure $ENV{PATH} while running with -T switch"
#!perl -T

use lib 'examples/lib';
use lib 't/lib';

use Test::Games::DateTime::Implementation::EQ2;

Test::Games::DateTime::Implementation::EQ2->runtests;

1;
