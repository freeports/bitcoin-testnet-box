BITCOIND=bitcoind
BITCOINGUI=bitcoin-qt
BITCOINCLI=bitcoin-cli
B1_FLAGS=
B2_FLAGS=
B1=-datadir=1 $(B1_FLAGS)
B2=-datadir=2 $(B2_FLAGS)
BLOCKS=101
ADDRESS=
AMOUNT=
ACCOUNT=

start:
	$(BITCOIND) $(B1) -daemon -fallbackfee=0.1
	$(BITCOIND) $(B2) -daemon -fallbackfee=0.1

start-gui1:
	$(BITCOINGUI) $(B1) &

start-gui2:
	$(BITCOINGUI) $(B2) &

generate:
	$(BITCOINCLI) $(B1) generatetoaddress $(BLOCKS) $(ADDRESS)

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

stop:
	$(BITCOINCLI) $(B1) stop
	$(BITCOINCLI) $(B2) stop

clean:
	rm -rvf  1/regtest/
	rm -rvd  2/regtest/
