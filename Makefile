all:
	solc --bin --optimize --optimize-runs 9999999 contracts/*.sol
