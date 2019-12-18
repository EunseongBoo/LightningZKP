#!/bin/sh
./test_liquidateNote_witness.sh
./test_liquidateNote_proof.sh


cat pi_liquidate_proof.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a pi_liquidate_proof_parsing.txt
cat pi_liquidate_witness.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a pi_liquidate_witness_parsing.txt
