#!/bin/bash
for ((i=0; i<20; i++))
do
	( time zokrates generate-proof) |&  grep "real" | tee -a pi_pour_proof.txt
done
