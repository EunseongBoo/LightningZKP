#!/bin/bash
zokrates compile -i depositNote_2.zok
zokrates setup
zokrates compute-witness -a 248418920295424573409225477809989300470 313719946243024096632399402033668159150 99265124174028319445459113885121079715 82603572717848152001885072832858504389 330846580664495983874331959024626190958 327964488221798835275551889684611191662 44803427502482157369753309077292908112 284834763916989990966258150173078497071 37753605298985300234929445004975789468 335196856752913916458631702730560164562 18660064995279846006492645005237013041 129034031732781937065545462583138253999 146320807850786262991983437301034235134 306902156156468251198463848423788044411 175072639528634206110711128109039775146 40947377995798137721699038697520024784 2 3000000000000000000 30000000000000000000 261982333027672377144177477746906878938 261982333027672377144177477746906878939 261982333027672377144177477746906878940 261982333027672377144177477746906878941 261982333027672377144177477746906878942 261982333027672377144177477746906878943 146320807850786262991983437301034235134 306902156156468251198463848423788044411 175072639528634206110711128109039775146 40947377995798137721699038697520024784 112612889188223089164322846106333497020645518262799935528047458345719983960853 146320807850786262991983437301034235134 306902156156468251198463848423788044411 175072639528634206110711128109039775146 40947377995798137721699038697520024784

for ((i=0; i<10; i++)); do
	( time zokrates generate-proof) |&  grep "real" | tee -a depositNote_2_result_proof.txt
done
