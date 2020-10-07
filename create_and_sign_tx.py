#!/usr/bin/env python3
"""A test."""
import base64

import bit
import bit.wallet as wallet

RPC_USER = 'admin1'
RPC_PASSWORD = '123'
RPC_HOST = '127.0.0.1'
RPC_PORT = '19001'


def test():
    """Try to send and retrieve some bitcoin."""

    input("""Please run the following:
          make clean
          make start 
          hit enter""")
    # bitcoin keys.
    mr_burns_p_k = base64.b64decode('VOQ42RAILPifvd8C4nqyhPT6WmUK02vTTmrAIrRw/OY=')
    mr_burns_address = 'n2QJopbDeRnwcAGAp2d4uYnNZfzksuoweh'
    mr_burns_private_key = wallet.PrivateKeyTestnet.from_bytes(mr_burns_p_k)
    if mr_burns_private_key.address != mr_burns_address:
        raise RuntimeError('WTF')

    rpchost = bit.network.services.RPCHost(RPC_USER, RPC_PASSWORD, RPC_HOST, RPC_PORT, False)
    rpchost.importaddress(mr_burns_address, 'Mr. Burns', True)

    cumberland_address = input(f"""
Please run the following:
make generate # Generate some bitcoin
bitcoin-cli -datadir=1 sendtoaddress '{mr_burns_address}' 1 # send one bitcoin to Mr. Burns
make generate # so the transfer gets mined
make address1

Then paste the result of the last command and hit enter: """)

    unspents = rpchost.get_unspent(mr_burns_address)

    print("before tx:")
    print(f"mr_burns balance: {rpchost.get_balance(mr_burns_address)}")
    print(f"cumberland balance: {rpchost.get_balance(cumberland_address)}")

    amount = 1*10**7
    outputs = [(cumberland_address, amount, 'satoshi')]
    # (cumberland_address, amount, 'satoshi'), (mr_burns_address, unspents[0].amount - amount - 1**4, 'satoshi')]

    unsigned = wallet.PrivateKeyTestnet.prepare_transaction(
        mr_burns_address, outputs, True, None, False, None, True, None, unspents)
    signed = mr_burns_private_key.sign_transaction(unsigned)
    rpchost.broadcast_tx_testnet(signed)

    input("""Please run the following for mining the block:
          make generate
          then press enter""")
    print("after tx:")
    print(f"mr_burns balance: {rpchost.get_balance(mr_burns_address)}")
    print(f"cumberland balance: {rpchost.get_balance(cumberland_address)}")


test()
