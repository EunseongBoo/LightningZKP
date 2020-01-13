#!/bin/bash
for ((i=0; i<100; i++)) do
	( time zokrates compute-witness -a 187856320279965952841339980948727740725 286118139470290644707172881572633684732 50000000000000000000 146320807850786262991983437301034235134 306902156156468251198463848423788044411 175072639528634206110711128109039775146 40947377995798137721699038697520024784 330939537676331249669877913103689939751 234387037784339754416164328450315973397 261982333027672377144177477746906878938 --light) |&  grep "real" | tee -a time_liquidate_witness.txt
done
