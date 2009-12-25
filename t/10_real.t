#!perl

# "Insecure $ENV{PATH} while running with -T switch"
#!perl -T

use lib 'examples/lib';
use lib 't/lib';

use Test::Games::DateTime::Real;

Test::Games::DateTime::Real->runtests;

1;
