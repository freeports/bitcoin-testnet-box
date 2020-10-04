BITCOIND=bitcoind
BITCOINGUI=bitcoin-qt
BITCOINCLI=bitcoin-cli
B1_FLAGS=
B2_FLAGS=
B1=-datadir=1 $(B1_FLAGS)
B2=-datadir=2 $(B2_FLAGS)
BLOCKS=1
ADDRESS=
AMOUNT=
ACCOUNT=

start:
	$(BITCOIND) $(B1) -addresstype=p2sh-segwit -daemon -fallbackfee=0.1
	$(BITCOIND) $(B2) -addresstype=p2sh-segwit -daemon -fallbackfee=0.1

start-gui:
	$(BITCOINGUI) $(B1) &
	$(BITCOINGUI) $(B2) &

generate:
	$(BITCOINCLI) $(B1) generatetoaddress $(BLOCKS) "$(shell $(BITCOINCLI) $(B1) getnewaddress)"

getinfo:
	$(BITCOINCLI) $(B1) -getinfo
	$(BITCOINCLI) $(B2) -getinfo

sendfrom1:
	$(BITCOINCLI) $(B1) sendtoaddress $(ADDRESS) $(AMOUNT)

sendfrom2:
	$(BITCOINCLI) $(B2) sendtoaddress $(ADDRESS) $(AMOUNT)

address1:
	$(BITCOINCLI) $(B1) getnewaddress $(ACCOUNT)

address2:
	$(BITCOINCLI) $(B2) getnewaddress $(ACCOUNT)

total-balance1:
	$(BITCOINCLI) $(B1) getbalance

total-balance2:
	$(BITCOINCLI) $(B2) getbalance

balance1:
	$(BITCOINCLI) $(B1) getreceivedbyaddress ${ADDRESS}

balance2:
	$(BITCOINCLI) $(B2) getreceivedbyaddress ${ADDRESS}

import1:
	$(BITCOINCLI) $(B1) importaddress ${ADDRESS}

stop:
	$(BITCOINCLI) $(B1) stop
	$(BITCOINCLI) $(B2) stop

clean:
	find 1/regtest -mindepth 1 -not -name 'server.*' -delete
	find 2/regtest -mindepth 1 -not -name 'server.*' -delete
