#!perl

# "Insecure $ENV{PATH} while running with -T switch"
#!perl -T

use lib 'examples/lib';
use lib 't/lib';

use Test::Games::DateTime::Implementation::FF14;

Test::Games::DateTime::Implementation::FF14->runtests;

1;
