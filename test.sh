#!/usr/bin/env bash
address1="$(bitcoin-cli -datadir=1 getnewaddress)"
lastblock="$(bitcoin-cli -datadir=1 generatetoaddress 1 "$address1" | tac | grep -Pom1 '(?<=")[^"]*')"
unspent="$(bitcoin-cli -datadir=1 getblock "$lastblock" | grep -Po '(?<=    ")[^"]*')"
address2="$(bitcoin-cli -datadir=2 getnewaddress)"
unsigned="$(bitcoin-cli -datadir=1 createrawtransaction '[{"txid": "'$unspent'", "vout": 0}]' '{"'$address2'":30}')"
key="$(bitcoin-cli -datadir=1 dumpprivkey "$address1")"
signed="$(bitcoin-cli -datadir=1 signrawtransactionwithkey "$unsigned" '["'$key'"]' | grep -Po '(?<=  "hex": ")[^"]*')"
decoded="$(bitcoin-cli -datadir=1 decoderawtransaction "$signed")"
# Note the scriptSig fields match.
grep --color=always '$\|scriptSig' <<<"$decoded"

hex="$(grep -Pom1 '(?<=        "hex": ")[^"]*' <<<"$decoded")"
asm="$(grep -Pom1 '(?<=        "asm": ")[^"]*' <<<"$decoded")"
echo compare these:
echo "$hex"
echo "  $asm"
