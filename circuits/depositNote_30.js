const crypto = require('crypto');
const BN = require('bn.js');
var Wallet = require('ethereumjs-wallet');
var EthUtil = require('ethereumjs-util');

const SCALING_FACTOR = new BN('1000000000000000000'); //10**18;

function getPublicKeyHash(pk) {
  const buf = Buffer.from(pk, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  console.log('PK Hash('+pk+') :', digest);
  return digest
}
function getNoteHash(encodedNote) {
  const buf = Buffer.from(encodedNote, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  console.log('Note Hash:', digest);
  //console.log('digest.length', digest.length); //64 hex, 32 bytes
  // split into 128 bits each
  return [digest.slice(0, 32), digest.slice(32)] //16 bytes, 16 bytes
}

function printZokratesCommand(params) {
  console.log(params)
  let cmd = 'zokrates compute-witness -a '
  params.forEach(p => {
    cmd += `${new BN(p, 16).toString(10)} `
  })
  console.log(cmd);
}

function getCreateNoteParams(_spk, _ssk, _mpk, _rpk, _ovalue, _nvalue, _notenum, _ononce, _snonce0, _snonce1, _snonce2, _snonce3, _snonce4, _snonce5, _snonce6, _snonce7, _snonce8, _snonce9, _snonce10, _snonce11, _snonce12, _snonce13, _snonce14, _snonce15, _snonce16, _snonce17, _snonce18, _snonce19, _snonce20, _snonce21, _snonce22, _snonce23, _snonce24, _snonce25, _snonce26, _snonce27, _snonce28, _snonce29, _rnonce0, _rnonce1, _rnonce2, _rnonce3, _rnonce4, _rnonce5, _rnonce6, _rnonce7, _rnonce8, _rnonce9, _rnonce10,  _rnonce11,  _rnonce12,  _rnonce13,  _rnonce14,  _rnonce15,  _rnonce16,  _rnonce17,  _rnonce18, _rnonce19, _rnonce20,  _rnonce21,  _rnonce22,  _rnonce23,  _rnonce24,  _rnonce25,  _rnonce26,  _rnonce27,  _rnonce28, _rnonce29,_cnonce) {
  console.log(arguments)
  let spk = new BN(_spk, 16).toString(16); // 64 bytes = 512 bits, sender's public key = spk
  let ssk = new BN(_ssk, 16).toString(16); //sender's secret key = ssk
  let mpk = new BN(_mpk, 16).toString(16);
  let rpk = new BN(_rpk, 16).toString(16);
  console.log('spk: ', spk);
  console.log('mpk: ', mpk);
  console.log('rpk: ', rpk);

  //original note's value, new note's value, notenum
  let _cvalue = _ovalue - _nvalue*_notenum;
  let ovalue = new BN(_ovalue, 16).mul(SCALING_FACTOR).toString(16, 32); // 16 bytes = 128 bits
  let nvalue = new BN(_nvalue, 16).mul(SCALING_FACTOR).toString(16, 32);
  let notenum = new BN(_notenum, 16).toString(16, 32);
  let cvalue = new BN(_cvalue, 16).mul(SCALING_FACTOR).toString(16, 32);
  console.log("_ovalue:",_ovalue);
  console.log("_nvalue:",_nvalue);
  console.log("_notenum:",_notenum);
  console.log("ovalue:",ovalue);
  console.log("nvalue:",nvalue);
  console.log("notenum:",notenum);
  //nonce
  let ononce = new BN(_ononce, 16).toString(16, 32); // 16 bytes = 128 bits, original note's nonce
  let snonce1 = new BN(_snonce0, 16).toString(16, 32); // sender note's nonce
  let snonce2 = new BN(_snonce1, 16).toString(16, 32);
  let snonce3 = new BN(_snonce2, 16).toString(16, 32);
  let snonce4 = new BN(_snonce3, 16).toString(16, 32);
  let snonce5 = new BN(_snonce4, 16).toString(16, 32);
  let snonce6 = new BN(_snonce5, 16).toString(16, 32); // sender note's nonce
  let snonce7 = new BN(_snonce6, 16).toString(16, 32);
  let snonce8 = new BN(_snonce7, 16).toString(16, 32);
  let snonce9 = new BN(_snonce8, 16).toString(16, 32);
  let snonce10 = new BN(_snonce9, 16).toString(16, 32);
  let snonce11 = new BN(_snonce10, 16).toString(16, 32); // sender note's nonce
  let snonce12 = new BN(_snonce11, 16).toString(16, 32);
  let snonce13 = new BN(_snonce12, 16).toString(16, 32);
  let snonce14 = new BN(_snonce13, 16).toString(16, 32);
  let snonce15 = new BN(_snonce14, 16).toString(16, 32);
  let snonce16 = new BN(_snonce15, 16).toString(16, 32); // sender note's nonce
  let snonce17 = new BN(_snonce16, 16).toString(16, 32);
  let snonce18 = new BN(_snonce17, 16).toString(16, 32);
  let snonce19 = new BN(_snonce18, 16).toString(16, 32);
  let snonce20 = new BN(_snonce19, 16).toString(16, 32);
  let snonce21 = new BN(_snonce20, 16).toString(16, 32); // sender note's nonce
  let snonce22 = new BN(_snonce21, 16).toString(16, 32);
  let snonce23 = new BN(_snonce22, 16).toString(16, 32);
  let snonce24 = new BN(_snonce23, 16).toString(16, 32);
  let snonce25 = new BN(_snonce24, 16).toString(16, 32);
  let snonce26 = new BN(_snonce25, 16).toString(16, 32); // sender note's nonce
  let snonce27 = new BN(_snonce26, 16).toString(16, 32);
  let snonce28 = new BN(_snonce27, 16).toString(16, 32);
  let snonce29 = new BN(_snonce28, 16).toString(16, 32);
  let snonce30 = new BN(_snonce29, 16).toString(16, 32);
  let rnonce1 = new BN(_rnonce0, 16).toString(16, 32); // receiver note's nonce
  let rnonce2 = new BN(_rnonce1, 16).toString(16, 32);
  let rnonce3 = new BN(_rnonce2, 16).toString(16, 32);
  let rnonce4 = new BN(_rnonce3, 16).toString(16, 32);
  let rnonce5 = new BN(_rnonce4, 16).toString(16, 32);
  let rnonce6 = new BN(_rnonce5, 16).toString(16, 32); // receiver note's nonce
  let rnonce7 = new BN(_rnonce6, 16).toString(16, 32);
  let rnonce8 = new BN(_rnonce7, 16).toString(16, 32);
  let rnonce9 = new BN(_rnonce8, 16).toString(16, 32);
  let rnonce10 = new BN(_rnonce9, 16).toString(16, 32);
  let rnonce11 = new BN(_rnonce10, 16).toString(16, 32); // receiver note's nonce
  let rnonce12 = new BN(_rnonce11, 16).toString(16, 32);
  let rnonce13 = new BN(_rnonce12, 16).toString(16, 32);
  let rnonce14 = new BN(_rnonce13, 16).toString(16, 32);
  let rnonce15 = new BN(_rnonce14, 16).toString(16, 32);
  let rnonce16 = new BN(_rnonce15, 16).toString(16, 32); // receiver note's nonce
  let rnonce17 = new BN(_rnonce16, 16).toString(16, 32);
  let rnonce18 = new BN(_rnonce17, 16).toString(16, 32);
  let rnonce19 = new BN(_rnonce18, 16).toString(16, 32);
  let rnonce20 = new BN(_rnonce19, 16).toString(16, 32);
  let rnonce21 = new BN(_rnonce20, 16).toString(16, 32); // receiver note's nonce
  let rnonce22 = new BN(_rnonce21, 16).toString(16, 32);
  let rnonce23 = new BN(_rnonce22, 16).toString(16, 32);
  let rnonce24 = new BN(_rnonce23, 16).toString(16, 32);
  let rnonce25 = new BN(_rnonce24, 16).toString(16, 32);
  let rnonce26 = new BN(_rnonce25, 16).toString(16, 32); // receiver note's nonce
  let rnonce27 = new BN(_rnonce26, 16).toString(16, 32);
  let rnonce28 = new BN(_rnonce27, 16).toString(16, 32);
  let rnonce29 = new BN(_rnonce28, 16).toString(16, 32);
  let rnonce30 = new BN(_rnonce29, 16).toString(16, 32);
  let cnonce = new BN(_cnonce, 16).toString(16, 32); //change note's nonce

  // calcuale public key hash
  let spkHash = getPublicKeyHash(spk.slice(0, 32) + spk.slice(32, 64) + spk.slice(64,96) + spk.slice(96));
  let mpkHash = getPublicKeyHash(mpk.slice(0, 32) + mpk.slice(32, 64) + mpk.slice(64,96) + mpk.slice(96));
  let rpkHash = getPublicKeyHash(rpk.slice(0, 32) + rpk.slice(32, 64) + rpk.slice(64,96) + rpk.slice(96));

  // create note
  let onote = spkHash + ovalue + ononce;
  let snote1 = mpkHash + nvalue + snonce1;
  let snote2 = mpkHash + nvalue + snonce2;
  let snote3 = mpkHash + nvalue + snonce3;
  let snote4 = mpkHash + nvalue + snonce4;
  let snote5 = mpkHash + nvalue + snonce5;
  let snote6 = mpkHash + nvalue + snonce6;
  let snote7 = mpkHash + nvalue + snonce7;
  let snote8 = mpkHash + nvalue + snonce8;
  let snote9 = mpkHash + nvalue + snonce9;
  let snote10 = mpkHash + nvalue + snonce10;
  let snote11 = mpkHash + nvalue + snonce11;
  let snote12 = mpkHash + nvalue + snonce12;
  let snote13 = mpkHash + nvalue + snonce13;
  let snote14 = mpkHash + nvalue + snonce14;
  let snote15 = mpkHash + nvalue + snonce15;
  let snote16 = mpkHash + nvalue + snonce16;
  let snote17 = mpkHash + nvalue + snonce17;
  let snote18 = mpkHash + nvalue + snonce18;
  let snote19 = mpkHash + nvalue + snonce19;
  let snote20 = mpkHash + nvalue + snonce20;
  let snote21 = mpkHash + nvalue + snonce21;
  let snote22 = mpkHash + nvalue + snonce22;
  let snote23 = mpkHash + nvalue + snonce23;
  let snote24 = mpkHash + nvalue + snonce24;
  let snote25 = mpkHash + nvalue + snonce25;
  let snote26 = mpkHash + nvalue + snonce26;
  let snote27 = mpkHash + nvalue + snonce27;
  let snote28 = mpkHash + nvalue + snonce28;
  let snote29 = mpkHash + nvalue + snonce29;
  let snote30 = mpkHash + nvalue + snonce30;
  let rnote1 = rpkHash + nvalue + rnonce1;
  let rnote2 = rpkHash + nvalue + rnonce2;
  let rnote3 = rpkHash + nvalue + rnonce3;
  let rnote4 = rpkHash + nvalue + rnonce4;
  let rnote5 = rpkHash + nvalue + rnonce5;
  let rnote6 = rpkHash + nvalue + rnonce6;
  let rnote7 = rpkHash + nvalue + rnonce7;
  let rnote8 = rpkHash + nvalue + rnonce8;
  let rnote9 = rpkHash + nvalue + rnonce9;
  let rnote10 = rpkHash + nvalue + rnonce10;
  let rnote11 = rpkHash + nvalue + rnonce11;
  let rnote12 = rpkHash + nvalue + rnonce12;
  let rnote13 = rpkHash + nvalue + rnonce13;
  let rnote14 = rpkHash + nvalue + rnonce14;
  let rnote15 = rpkHash + nvalue + rnonce15;
  let rnote16 = rpkHash + nvalue + rnonce16;
  let rnote17 = rpkHash + nvalue + rnonce17;
  let rnote18 = rpkHash + nvalue + rnonce18;
  let rnote19 = rpkHash + nvalue + rnonce19;
  let rnote20 = rpkHash + nvalue + rnonce20;
  let rnote21 = rpkHash + nvalue + rnonce21;
  let rnote22 = rpkHash + nvalue + rnonce22;
  let rnote23 = rpkHash + nvalue + rnonce23;
  let rnote24 = rpkHash + nvalue + rnonce24;
  let rnote25 = rpkHash + nvalue + rnonce25;
  let rnote26 = rpkHash + nvalue + rnonce26;
  let rnote27 = rpkHash + nvalue + rnonce27;
  let rnote28 = rpkHash + nvalue + rnonce28;
  let rnote29 = rpkHash + nvalue + rnonce29;
  let rnote30 = rpkHash + nvalue + rnonce30;
  let cnote = spkHash + cvalue + cnonce;

  //calculate notes hash
  let oh = getNoteHash(onote);
  let sh1 = getNoteHash(snote1);
  let sh2 = getNoteHash(snote2);
  let sh3 = getNoteHash(snote3);
  let sh4 = getNoteHash(snote4);
  let sh5 = getNoteHash(snote5);
  let sh6 = getNoteHash(snote6);
  let sh7 = getNoteHash(snote7);
  let sh8 = getNoteHash(snote8);
  let sh9 = getNoteHash(snote9);
  let sh10 = getNoteHash(snote10);
  let sh11 = getNoteHash(snote11);
  let sh12 = getNoteHash(snote12);
  let sh13 = getNoteHash(snote13);
  let sh14 = getNoteHash(snote14);
  let sh15 = getNoteHash(snote15);
  let sh16 = getNoteHash(snote16);
  let sh17 = getNoteHash(snote17);
  let sh18 = getNoteHash(snote18);
  let sh19 = getNoteHash(snote19);
  let sh20 = getNoteHash(snote20);
  let sh21 = getNoteHash(snote21);
  let sh22 = getNoteHash(snote22);
  let sh23 = getNoteHash(snote23);
  let sh24 = getNoteHash(snote24);
  let sh25 = getNoteHash(snote25);
  let sh26 = getNoteHash(snote26);
  let sh27 = getNoteHash(snote27);
  let sh28 = getNoteHash(snote28);
  let sh29 = getNoteHash(snote29);
  let sh30 = getNoteHash(snote30);
  let rh1 = getNoteHash(rnote1);
  let rh2 = getNoteHash(rnote2);
  let rh3 = getNoteHash(rnote3);
  let rh4 = getNoteHash(rnote4);
  let rh5 = getNoteHash(rnote5);
  let rh6 = getNoteHash(rnote6);
  let rh7 = getNoteHash(rnote7);
  let rh8 = getNoteHash(rnote8);
  let rh9 = getNoteHash(rnote9);
  let rh10 = getNoteHash(rnote10);
  let rh11 = getNoteHash(rnote11);
  let rh12 = getNoteHash(rnote12);
  let rh13 = getNoteHash(rnote13);
  let rh14 = getNoteHash(rnote14);
  let rh15 = getNoteHash(rnote15);
  let rh16 = getNoteHash(rnote16);
  let rh17 = getNoteHash(rnote17);
  let rh18 = getNoteHash(rnote18);
  let rh19 = getNoteHash(rnote19);
  let rh20 = getNoteHash(rnote20);
  let rh21 = getNoteHash(rnote21);
  let rh22 = getNoteHash(rnote22);
  let rh23 = getNoteHash(rnote23);
  let rh24 = getNoteHash(rnote24);
  let rh25 = getNoteHash(rnote25);
  let rh26 = getNoteHash(rnote26);
  let rh27 = getNoteHash(rnote27);
  let rh28 = getNoteHash(rnote28);
  let rh29 = getNoteHash(rnote29);
  let rh30 = getNoteHash(rnote30);
  let ch = getNoteHash(cnote);

  //let publicParams = [oh, sh1, sh2, rh1, rh2, ch, mpk.slice(0,32), mpk.slice(32, 64), mpk.slice(64, 96), mpk.slice(96), notenum, nvalue];
  let publicParams = oh.concat(sh1, sh2, sh3, sh4, sh5, sh6,sh7,sh8,sh9,sh10, sh11, sh12, sh13, sh14, sh15, sh16, sh17, sh18, sh19, sh20, sh21, sh22, sh23, sh24, sh25, sh26, sh27, sh28, sh29, sh30,rh1, rh2, rh3, rh4, rh5, rh6, rh7, rh8, rh9,rh10, rh11, rh12, rh13, rh14, rh15, rh16, rh17, rh18, rh19, rh20, rh21, rh22, rh23, rh24, rh25, rh26, rh27, rh28, rh29, rh30, ch, [mpk.slice(0,32), mpk.slice(32, 64), mpk.slice(64, 96), mpk.slice(96), notenum, nvalue]);
  let privateParams = [ovalue, ononce, snonce1, snonce2, snonce3, snonce4, snonce5, snonce6, snonce7, snonce8, snonce9, snonce10,  snonce11,  snonce12,  snonce13,  snonce14,  snonce15,  snonce16,  snonce17,  snonce18,  snonce19,  snonce20, snonce21,  snonce22,  snonce23,  snonce24,  snonce25,  snonce26,  snonce27,  snonce28,  snonce29,  snonce30, rnonce1, rnonce2, rnonce3, rnonce4, rnonce5, rnonce6, rnonce7, rnonce8, rnonce9, rnonce10, rnonce11, rnonce12, rnonce13, rnonce14, rnonce15, rnonce16, rnonce17, rnonce18, rnonce19, rnonce20, rnonce21, rnonce22, rnonce23, rnonce24, rnonce25, rnonce26, rnonce27, rnonce28, rnonce29, rnonce30, cnonce, spk.slice(0,32), spk.slice(32,64), spk.slice(64,96), spk.slice(96), ssk, rpk.slice(0,32), rpk.slice(32,64), rpk.slice(64,96), rpk.slice(96)]
  //let privateParams = [pubKey.slice(0, 32), pubKey.slice(32, 64), pubKey.slice(64,96), pubKey.slice(96), ononce, secKey];
  //let privateParams = [pubKey.slice(0, 64), pubKey.slice(64), nonce];
  //let pubKeyHash = getPublicKeyHash(pubKey.slice(0, 32) + pubKey.slice(32, 64) + pubKey.slice(64,96) + pubKey.slice(96));
  //let onote = pubKeyHash + ovalue + ononce;
  //console.log('original note', onote);
  //let publicParams = getNoteHash(onote).concat(ovalue);
  //console.log("PublicParams length:", publicParams.length);
  //console.log("Private length:", privateParams.length);

  printZokratesCommand(publicParams.concat(privateParams));

  //console.log("oh:",oh);
  //console.log("public[0]:",publicParams[0].length);
    /*
  console.log('private', privateParams);
  let note = pubKey + value + nonce;
  console.log('note', note);

  let publicParams = getNoteHash(note).concat(value);
  console.log('public', publicParams);
  printZokratesCommand(publicParams.concat(privateParams));*/

  //let _testNum = '6013905081570834041540332865402314430519354719269569994007565376104307548281';
  //let testNum = new BN(_testNum, 10).toString(16);
  //console.log('testNUM', testNum.length);

    /*const privateKeyBuffer = EthUtil.toBuffer('0xf8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315');
  const wallet = Wallet.fromPrivateKey(privateKeyBuffer);
  const publicKey = wallet.getPublicKeyString();
  console.log(publicKey);*/

}

// this will serve as an invalid proof
getCreateNoteParams(
  //'f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315',
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', // pk
  'f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315', // sk
  '6c9a44419b52ff7f7e02406def3b41fa57d8482c01ed04e56b6475c8e04466f11f2b61d057d73066a78a684a3099a4df6d2defbc3844d4dd72a2e545a4ebc595', //mpk
  '4d65845c7426d420f8618b052ccba1e9d819ade834c9acd933f023bd1cb8bf67509e3c79b8d9aae49bd9316fe9d8fd3e8863a444a97731e12fe8d573b2f34789', //rpk
  50, // oValue
  1, // Value
  30, // NoteNum
  'c517f646255d5492089b881965cbd3da', // ononce
  'c517f646255d5492089b881965cbd3db', // sNonce[0]
  'c517f646255d5492089b881965cbd3dc', // sNonce[1]
  'c517f646255d5492089b881965cbd3dd', // sNonce[2]
  'c517f646255d5492089b881965cb13de', // sNonce[3]
  'c517f646255d5492089b881965cb23df', // sNonce[4]
  'c517f646255d5492089b881965cb32df', // sNonce[5]
  'c517f646255d5492089b881965cb42df', // sNonce[6]
  'c517f646255d5492089b881965cb52df', // sNonce[7]
  'c517f646255d5492089b881965cb62df', // sNonce[8]
  'c517f646255d5492089b881965cb72df', // sNonce[9]
  'c517f646255d5492089b881965cb83fb', // sNonce[10]
  'c517f646255d5492089b881965cbd3fc', // sNonce[11]
  'c517f646255d5492089b881965cbd3fd', // sNonce[12]
  'c517f646255d5492089b881965cbd3fe', // sNonce[13]
  'c517f646255d5492089b881965cbdaff', // sNonce[14]
  'c517f646255d5492089b881965cbdbff', // sNonce[15]
  'c517f646255d5492089b881965cbdcff', // sNonce[16]
  'c517f646255d5492089b881965cbddff', // sNonce[17]
  'c517f646255d5492089b881965cbdeff', // sNonce[18]
  'c517f646255d5492089b881965cbdfff', // sNonce[19]
  'c517f641255d5492089b881965cb83fb', // sNonce[20]
  'c517f641255d5492089b881965cbd3fc', // sNonce[21]
  'c517f641255d5492089b881965cbd3fd', // sNonce[22]
  'c517f641255d5492089b881965cbd3fe', // sNonce[23]
  'c517f641255d5492089b881965cbdaff', // sNonce[24]
  'c517f641255d5492089b881965cbdbff', // sNonce[25]
  'c517f641255d5492089b881965cbdcff', // sNonce[26]
  'c517f641255d5492089b881965cbddff', // sNonce[27]
  'c517f641255d5492089b881965cbdeff', // sNonce[28]
  'c517f641255d5492089b881965cbdfff', // sNonce[29]
  'c517f646255d5492089b881965cbd3aa', // rNonce[0]
  'c517f646255d5492089b881965cbd3ab', // rNonce[1]
  'c517f646255d5492089b881965cbd3ac', // sNonce[2]
  'c517f646255d5492089b881965cbd3ad', // sNonce[3]
  'c517f646255d5492089b881965cbd3ae', // sNonce[4]
  'c527f646255d5492089b881965cbd3aa', // rNonce[5]
  'c527f646255d5492089b881965cbd3ab', // rNonce[6]
  'c527f646255d5492089b881965cbd3ac', // sNonce[7]
  'c527f646255d5492089b881965cbd3ad', // sNonce[8]
  'c527f646255d5492089b881965cbd3ae', // sNonce[9]
  'c517f646255d5492089b881965cbd3ba', // rNonce[10]
  'c517f646255d5492089b881965cbd3cb', // rNonce[11]
  'c517f646255d5492089b881965cbd3dc', // sNonce[12]
  'c517f646255d5492089b881965cbd3ed', // sNonce[13]
  'c517f646255d5492089b881965cbd3fe', // sNonce[14]
  'c527f646255d5492089b881965cbdaaa', // rNonce[15]
  'c527f646255d5492089b881965cbdbab', // rNonce[16]
  'c527f646255d5492089b881965cbdcac', // sNonce[17]
  'c527f646255d5492089b881965cbddad', // sNonce[18]
  'c527f646255d5492089b881965cbdeae', // sNonce[19]
  'c517f646255d5492289b881965cbd3ba', // rNonce[20]
  'c517f646255d5492289b881965cbd3cb', // rNonce[21]
  'c517f646255d5492289b881965cbd3dc', // sNonce[22]
  'c517f646255d5492289b881965cbd3ed', // sNonce[23]
  'c517f646255d5492289b881965cbd3fe', // sNonce[24]
  'c527f646255d5492289b881965cbdaaa', // rNonce[25]
  'c527f646255d5492289b881965cbdbab', // rNonce[26]
  'c527f646255d5492289b881965cbdcac', // sNonce[27]
  'c527f646255d5492289b881965cbddad', // sNonce[28]
  'c527f646255d5492289b881965cbdeae', // sNonce[29]
  'c517f646255d5492089b881965cbd3ff' // cNonce
)
