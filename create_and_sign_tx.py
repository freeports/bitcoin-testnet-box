import bit
import bit.wallet as wallet

RPC_USER = 'admin1'
RPC_PASSWORD = '123'
RPC_HOST = '127.0.0.1'
RPC_PORT = '19001'


rpchost = bit.network.services.RPCHost(RPC_USER, RPC_PASSWORD, RPC_HOST, RPC_PORT, False)

# bitcoin keys 
mr_burens_address = '2NFqAz5aLg2bwhAGWiYvx7u71QxengGoouW'
mr_burnes_p_k = b'c\x08dxS\x84\x83\xad{\x00\x8c\x87\x0b\xba\x00\x11\x19\xf41\xea\x9c;~U\x95\xc47\xe1\t\xfe\xcb1'

#some random address to send btc to
cumberland_address = '2MyBtStgFiT46V8BEuZ6maSQVKmaX7tbCSh'

mr_burens_unspents = rpchost.get_unspent(mr_burens_address)
print(mr_burens_unspents)
outputs = [(cumberland_address, 0.8, 'btc')]

tx_data = wallet.PrivateKeyTestnet.prepare_transaction(mr_burens_address, outputs, True, None, False, None, True, None, mr_burens_unspents)

mr_burens_private_key = wallet.PrivateKeyTestnet.from_bytes(mr_burnes_p_k)
tx = mr_burens_private_key.sign_transaction(tx_data)
print(tx)

wif = mr_burens_private_key.to_wif()
print(f"wif: {wif}")

rpchost.broadcast_tx_testnet(tx)