use v6.c;

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

class AccountableBagHash:ver<0.0.3>:auth<cpan:ELIZABETH>
  is BagHash
  does Accountable
{ }

class AccountableMixHash:ver<0.0.3>:auth<cpan:ELIZABETH>
  is MixHash
  does Accountable
{ }

=begin pod

=head1 NAME

AccountableBagHash - be an accountable BagHash / MixHash

=head1 SYNOPSIS

    use AccountableBagHash;

    my %abh is AccountableBagHash = a => 42, b => 666;
    %abh<a> =  5; # ok
    %abh<a> = -1; # throws

    my %amh is AccountableMixHash = a => 3.14, b => 666;
    %abh<a> =  6.28; # ok
    %abh<a> = -1;    # throws
  
    CATCH {
        when X::BagHash::Acountable {
            say "You do not have enough {.key}";
            .resume
        }
    }

=head1 DESCRIPTION

This module makes an C<AccountableBagHash> / C<AccountableMixHash> class
available that can be used instead of the normal C<BagHash> / C<MixHash>.
The only difference with a normal C<BagHash> / C<MixHash> is, is that if
an attempt is made to set the value of a key to B<less than 0>, that an
exception is thrown rather than just deleting the key from the C<BagHash>
/ C<MixHash>.

Also exports a C<X::BagHash::Accountable> error class that will be thrown
if an attempt is made to set the value to below 0.

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/AccountableBagHash .
Comments and Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018, 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
