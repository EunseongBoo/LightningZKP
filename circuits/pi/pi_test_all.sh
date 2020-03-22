../mint/pi_test_mint_witness.sh
../mint/pi_test_mint_proof.sh
../pour/pi_test_pour_witness.sh
../pour/pi_test_pour_proof.sh
../pour4/pi_test_pour4_witness.sh
../pour4/pi_test_pour4_proof.sh
../lzkp/pi_test_lzkp_witness.sh
../lzkp/pi_test_lzkp_proof.sh
../burn/pi_test_burn_proof.sh
../burn/pi_test_burn_witness.sh
../burn4/pi_test_burn4_proof.sh
../burn4/pi_test_burn4_witness.sh

cat ../mint/pi_mint_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_mint_proof_parsing.txt
cat ../mint/pi_mint_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_mint_witness_parsing.txt
cat ../pour/pi_pour_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_pour_proof_parsing.txt
cat ../pour/pi_pour_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_pour_witness_parsing.txt
cat ../pour4/pi_pour4_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_pour4_proof_parsing.txt
cat ../pour4/pi_pour4_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_pour4_witness_parsing.txt
cat ../lzkp/pi_lzkp_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_lzkp_proof_parsing.txt
cat ../lzkp/pi_lzkp_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_lzkp_witness_parsing.txt
cat ../burn/pi_burn_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_burn_proof_parsing.txt
cat ../burn/pi_burn_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_burn_witness_parsing.txt
cat ../burn4/pi_burn4_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_burn4_proof_parsing.txt
cat ../burn4/pi_burn4_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pi_burn4_witness_parsing.txt
