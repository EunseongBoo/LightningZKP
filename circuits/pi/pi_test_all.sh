./pi_test_createNote_witness.sh
./pi_test_createNote_proof.sh
./pi_test_spendNote_witness.sh
./pi_test_spendNote_proof.sh
./pi_test_depositNote_witness.sh
./pi_test_depositNote_proof.sh
./pi_test_liquidateNote_proof.sh
./pi_test_liquidateNote_witness.sh

cat pi_create_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_create_proof_parsing.txt
cat pi_create_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_create_witness_parsing.txt
cat pi_spend_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_spend_proof_parsing.txt
cat pi_spend_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_spend_witness_parsing.txt
cat pi_deposit_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_deposit_proof_parsing.txt
cat pi_deposit_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_deposit_witness_parsing.txt
