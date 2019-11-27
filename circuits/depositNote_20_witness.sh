#!/bin/bash
zokrates compile -i depositNote_10.zok
for ((i=0; i<10; i++)); do
	( time zokrates compute-witness -a 248418920295424573409225477809989300470 313719946243024096632399402033668159150 207221874873271781576203555475155056441 200820989820090325034225607419910506027 43850376947715139423461209767122478545 18849723779848737252579454767002088804 67478604136514367075595110532500139838 184150554040092907005791763491746908908 239936719548936373090223569440546757142 64097831462500617181891256622065058578 269655534800109497683752345517387621948 211434239711261267692440725346480072279 203298075640595389944808607682803184755 113008528396150300919360653412765017708 280385534188574700494903802904695162918 85669956026673001213313318160509967625 140808716694619469737195926652016502038 185285720289373036951390353204528605156 128011053645904463848223880682341068725 54016239567633840384028670332253722871 75692256483046068208318930430874125762 256127536637044481910417560254373386353 135225152237817917564549964977222796797 254641477956883160114579951668861456067 139763743397975622175266154223972091499 214993533100735404573768050842331301957 149690203749419124578111626336256451781 289515842335938502358521501098644824327 193564283424629704332675106188924235479 276717673602917636788149119696471745495 93389907038003423097499232192713360878 10308633156223998904458294908407973239 305428129899111400390444598874519856430 339550122916147519942754617419096645558 214643625831265589737111378469621151739 272615972181127274967685847626309240127 23004642183441110203516363765414745966 47632323463937299837737399049171038324 116442614719684216073131500352787952151 120836751271661801647758264348737231767 203794835272662462072302109839043744135 16537380793205136324435461658463577225 15492553599467307605341899271644719372 118974038715730817744045731063016507599 144357621662739404463962035943372440058 116765835574857840808873955876072089329 41431320534624090299963988483298141407 145124367307394095553139976925589783957 20 1000000000000000000 30000000000000000000 261982333027672377144177477746906878938 261982333027672377144177477746906878939 261982333027672377144177477746906878940 261982333027672377144177477746906878941 261982333027672377144177477746906829790 261982333027672377144177477746906833887 261982333027672377144177477746906837727 261982333027672377144177477746906841823 261982333027672377144177477746906845919 261982333027672377144177477746906850015 261982333027672377144177477746906854111 261982333027672377144177477746906878890 261982333027672377144177477746906878891 261982333027672377144177477746906878892 261982333027672377144177477746906878893 261982333027672377144177477746906878894 262065409777408934386233965688174400426 262065409777408934386233965688174400427 262065409777408934386233965688174400428 262065409777408934386233965688174400429 262065409777408934386233965688174400430 261982333027672377144177477746906878975 146320807850786262991983437301034235134 306902156156468251198463848423788044411 175072639528634206110711128109039775146 40947377995798137721699038697520024784 112612889188223089164322846106333497020645518262799935528047458345719983960853 102877662261156375207199045266745041385 287246581765137365140418784202690445159 107159849154834041653196334220634029374 181292376570880620876335541535741527945
) |&  grep "real" |tee -a depositNote_20_result_witness.txt
done
