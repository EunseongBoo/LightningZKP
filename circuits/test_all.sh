#!/bin/sh
./test_createNote_witness.sh
./test_createNote_proof.sh
./test_spendNote_witness.sh
./test_spendNote_proof.sh
./test_depositNote_witness.sh
./test_depositNote_proof.sh
./test_liquidateNote_witness.sh
./test_liquidateNote_proof.sh

cat time_create_proof.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_create_proof_parsing.txt
cat time_create_witness.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_create_witness_parsing.txt
cat time_spend_proof.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_spend_proof_parsing.txt
cat time_spend_witness.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_spend_witness_parsing.txt
cat time_deposit_proof.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_deposit_proof_parsing.txt
cat time_deposit_witness.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_deposit_witness_parsing.txt
cat time_liquidate_proof.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_liquidate_proof_parsing.txt
cat time_liquidate_witness.txt | cut -d"m" -f2 | cut -d"s" -f1 | tee -a time_liquidate_witness_parsing.txt
