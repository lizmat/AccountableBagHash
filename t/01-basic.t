use v6.c;
use Test;

use AccountableBagHash;

plan 16;

my %abh is AccountableBagHash = a => 42, b => 666;
isa-ok %abh, AccountableBagHash;

is (%abh<a> = 48), 48, 'does assignment pass value through';
is %abh<a>,        48, 'did the assignment work';
is %abh<a>++,      48, 'can we increment';
is %abh<a>,        49, 'did the increment work';

{
    my $caught = False;
    CATCH {
        $caught = True;
        when X::BagHash::Accountable {
            pass 'threw the correct exception';
            .resume;
        }
        default {
            flunk 'did not throw correct exception';
            .resume
        }
    }
    %abh<a> = -1;
    ok $caught, 'did we get an exception';
    is %abh<a>, 49, 'did the assignment fail';
}

my %amh is AccountableMixHash = a => 3.14, b => 666;
isa-ok %amh, AccountableMixHash;

is (%amh<a> = 2.71), 2.71, 'does assignment pass value through';
is %amh<a>,          2.71, 'did the assignment work';
is %amh<a>++,        2.71, 'can we increment';
is %amh<a>,          3.71, 'did the increment work';

{
    my $caught = False;
    CATCH {
        $caught = True;
        when X::BagHash::Accountable {
            pass 'threw the correct exception';
            .resume;
        }
        default {
            flunk 'did not throw correct exception';
            .resume
        }
    }
    %amh<a> = -1;
    ok $caught, 'did we get an exception';
    is %amh<a>, 3.71, 'did the assignment fail';
}

# vim: ft=perl6 expandtab sw=4
