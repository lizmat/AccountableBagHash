use v6.c;
use Test;

use AccountableBagHash;

plan 7;

my %b is AccountableBagHash = a => 42, b => 666;
isa-ok %b, AccountableBagHash;

is (%b<a> = 48), 48, 'does assignment pass value through';
is %b<a>,        48, 'did the assignment work';
is %b<a>++,      48, 'can we increment';
is %b<a>,        49, 'did the increment work';
dies-ok { %b<a> = -1 }, 'did assignment < 0 die';
is %b<a>,        49, 'did the assignment fail';

# vim: ft=perl6 expandtab sw=4
