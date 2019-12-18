#!/bin/sh
./test_liquidateNote_witness.sh
./test_liquidateNote_proof.sh


cat time_liquidate_proof.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_liquidate_proof_parsing.txt
cat time_liquidate_witness.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_liquidate_witness_parsing.txt
