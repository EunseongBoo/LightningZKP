#!/bin/bash
for ((i=0; i<20; i++)) do
	( time zokrates compute-witness -a 3104184488619428064513003424939626624163515494113694926266052487 187028053950337497509395615 316687194309360256957246526123107055004 256705946780349363739749626 223709405847772390780955378764682875401 50783523207004973271481708 31735542431198566050979558090591879882 87747556075689821985562390 98847903001254366333523359143631622879 231597357666288527812032976 269653237111243881661536750308237841416 512 330939537676331249669877913103689939751 234387037784339754416164328450315973397 206595163934163725913948129 82451690262478039989678411258595276097 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76507953279413266718256787758098129494352115759850327698019588672 340282366841710300949110269838224261120 256 330939537676331249669877913103689939751 234387037784339754416164328450315973397 215416974448694916693696487 25003208453153173859766577191596859620 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 67038487981032291979993543084201035224211876010280774384675893652 340282366762482138434845932244680310784 256 145423099809817177181432473 298602003041833407193021691869186630004 9762975498077019085280282 332059686156419955838699927217201965003 512 43044182336036715503541522 265881132604900464741050841196943810622 138494581263783803525314142 191401393018485933776547175251784592707 --light) |&  grep "real" | tee -a pi_pour_witness.txt
done