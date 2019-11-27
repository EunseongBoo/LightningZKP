#!/bin/bash
zokrates compile -i depositNote_10.zok
for ((i=0; i<10; i++)); do
	( time zokrates compute-witness -a 46883888403747357017014268190917267898 338197514604990778642130848636064617655 99265124174028319445459113885121079715 82603572717848152001885072832858504389 330846580664495983874331959024626190958 327964488221798835275551889684611191662 44803427502482157369753309077292908112 284834763916989990966258150173078497071 37753605298985300234929445004975789468 335196856752913916458631702730560164562 332855667721979480755470276455565368026 315113973444372450891933992425577753546 324522021930515738731339707577854904424 190104918159650031118506820864670014408 324522021930515738731339707577854904424 190104918159650031118506820864670014408 324522021930515738731339707577854904424 190104918159650031118506820864670014408 324522021930515738731339707577854904424 190104918159650031118506820864670014408 324522021930515738731339707577854904424 190104918159650031118506820864670014408 84588925221176359319651632818813696545 34411283890163878221723631616627814734 111400827935757668607964836024840533989 130975687960516360694661006672651270560 79092308030987897431521442219727070109 22563597755418141315764975934736593290 128387337795899998922484853124888213675 155802255340344615002333902146316945094 246160988192873112105492993543102508546 138999210730071784965288507126978268045 90584201525463164580185744666214513484 160056322644575457365306882738841718657 241102471444174566755490754004773881816 194184844937892171215532094221774310128 107652779689970043284360154613087921579 190522733166792190114451447874526504122 81536840142061096420102755625753972758 284481573652909348208776065469279631143 74640006844116206866723737294984494944 63684138756899798698108770933283594556 15492553599467307605341899271644719372 118974038715730817744045731063016507599 146320807850786262991983437301034235134 306902156156468251198463848423788044411 175072639528634206110711128109039775146 40947377995798137721699038697520024784 10 3000000000000000000 40000000000000000000 261982333027672377144177477746906878938 261982333027672377144177477746906878939 261982333027672377144177477746906878940 261982333027672377144177477746906878941 261982333027672377144177477746906878942 261982333027672377144177477746906878943 261982333027672377144177477746906878687 261982333027672377144177477746906878687 261982333027672377144177477746906878687 261982333027672377144177477746906878687 261982333027672377144177477746906878687 261982333027672377144177477746906878890 261982333027672377144177477746906878891 261982333027672377144177477746906878892 261982333027672377144177477746906878893 261982333027672377144177477746906878894 262065409777408934386233965688174400426 262065409777408934386233965688174400427 262065409777408934386233965688174400428 262065409777408934386233965688174400429 262065409777408934386233965688174400430 261982333027672377144177477746906878975 146320807850786262991983437301034235134 306902156156468251198463848423788044411 175072639528634206110711128109039775146 40947377995798137721699038697520024784 112612889188223089164322846106333497020645518262799935528047458345719983960853 146320807850786262991983437301034235134 306902156156468251198463848423788044411 175072639528634206110711128109039775146 40947377995798137721699038697520024784
) |&  grep "real" |tee -a depositNote_10_result_witness.txt
done
