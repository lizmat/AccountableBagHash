class X::BagHash::Accountable is Exception {
    has $.key;
    has $.value;
    method message() { "Not allowed to set '{$!key}' to $!value" }
}

my role Accountable {
    multi method AT-KEY(::?CLASS:D: $key is raw) is raw {
        my &nextone := nextcallee;
        Proxy.new(
          FETCH => { nextone(self,$key) },
          STORE => -> $, Numeric() $value {
              $value >= 0
                ?? (nextone(self,$key) = $value)
                !! X::BagHash::Accountable.new( :$key, :$value ).throw
          }
        )
    }
}

class AccountableBagHash is BagHash does Accountable { }

class AccountableMixHash is MixHash does Accountable { }

# vim: expandtab shiftwidth=4
