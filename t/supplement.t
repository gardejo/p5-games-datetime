#!perl

# "Insecure $ENV{PATH} while running with -T switch"
#!perl -T

use lib 'examples/lib';
use lib 't/lib';

use Test::Games::DateTime::Supplement;

Test::Games::DateTime::Supplement->runtests;

1;
