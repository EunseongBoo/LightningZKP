./mint/test_mint_witness.sh
./mint/test_mint_proof.sh
./pour/test_pour_witness.sh
./pour/test_pour_proof.sh
./pour4/test_pour4_witness.sh
./pour4/test_pour4_proof.sh
./lzkp/test_lzkp_witness.sh
./lzkp/test_lzkp_proof.sh
./burn/test_burn_proof.sh
./burn/test_burn_witness.sh
./burn4/test_burn4_proof.sh
./burn4/test_burn4_witness.sh

cat ./mint/time_mint_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a mint_proof_parsing.txt
cat ./mint/time_mint_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a mint_witness_parsing.txt
cat ./pour/time_pour_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pour_proof_parsing.txt
cat ./pour/time_pour_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pour_witness_parsing.txt
cat ./pour4/time_pour4_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pour4_proof_parsing.txt
cat ./pour4/time_pour4_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a pour4_witness_parsing.txt
cat ./lzkp/time_lzkp_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a lzkp_proof_parsing.txt
cat ./lzkp/time_lzkp_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a lzkp_witness_parsing.txt
cat ./burn/time_burn_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a burn_proof_parsing.txt
cat ./burn/time_burn_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a burn_witness_parsing.txt
cat ./burn4/time_burn4_proof.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a burn4_proof_parsing.txt
cat ./burn4/time_burn4_witness.txt | cut -d" " -f2 | cut -d"s" -f1 | tee -a burn4_witness_parsing.txt
