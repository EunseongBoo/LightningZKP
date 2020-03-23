#!/bin/bash
for ((i=0; i<20; i++))
do
	( time zokrates generate-proof) |&  grep "real" | tee -a time_pour4_proof.txt
done
