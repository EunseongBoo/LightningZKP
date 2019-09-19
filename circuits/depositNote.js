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

function getCreateNoteParams(_spk, _ssk, _mpk, _rpk, _ovalue, _nvalue, _notenum, _ononce, _snonce0, _snonce1, _rnonce0, _rnonce1, _cnonce) {
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
  let _test = "30";
  let ovalue = new BN(_ovalue, 16).mul(SCALING_FACTOR).toString(16, 32); // 16 bytes = 128 bits
  let test = new BN(_test, 16).mul(SCALING_FACTOR).toString(16, 32);
  //let nvalue = new BN(_nvalue, 16).mul(SCALING_FACTOR).toString(16, 32); // new deposit note's value
  let nvalue = new BN(3, 16).mul(SCALING_FACTOR).toString(16, 32);
  let notenum = new BN(_notenum, 16).toString(16, 32);
  let cvalue = new BN(_cvalue, 16).mul(SCALING_FACTOR).toString(16, 32);
  console.log("_ovalue:",_ovalue);
  console.log("_nvalue:",_nvalue);
  console.log("_notenum:",_notenum);
  console.log("ovalue:",ovalue);
  console.log("nvalue:",nvalue);
  console.log("notenum:",notenum);
  console.log("test:",test);
  //nonce
  let ononce = new BN(_ononce, 16).toString(16, 32); // 16 bytes = 128 bits, original note's nonce
  let snonce1 = new BN(_snonce0, 16).toString(16, 32); // sender note's nonce
  let snonce2 = new BN(_snonce1, 16).toString(16, 32);
  let rnonce1 = new BN(_rnonce0, 16).toString(16, 32); // receiver note's nonce
  let rnonce2 = new BN(_rnonce1, 16).toString(16, 32);
  let cnonce = new BN(_cnonce, 16).toString(16, 32); //change note's nonce

  // calcuale public key hash
  let spkHash = getPublicKeyHash(spk.slice(0, 32) + spk.slice(32, 64) + spk.slice(64,96) + spk.slice(96));
  let mpkHash = getPublicKeyHash(mpk.slice(0, 32) + mpk.slice(32, 64) + mpk.slice(64,96) + mpk.slice(96));
  let rpkHash = getPublicKeyHash(rpk.slice(0, 32) + rpk.slice(32, 64) + rpk.slice(64,96) + rpk.slice(96));

  // create note
  let onote = spkHash + ovalue + ononce;
  let snote1 = mpkHash + nvalue + snonce1;
  let snote2 = mpkHash + nvalue + snonce2;
  let rnote1 = rpkHash + nvalue + rnonce1;
  let rnote2 = rpkHash + nvalue + rnonce2;
  let cnote = spkHash + cvalue +cnonce;

  //calculate notes hash
  let oh = getNoteHash(onote);
  let sh1 = getNoteHash(snote1);
  let sh2 = getNoteHash(snote2);
  let rh1 = getNoteHash(rnote1);
  let rh2 = getNoteHash(rnote2);
  let ch = getNoteHash(cnote);

  //let publicParams = [oh, sh1, sh2, rh1, rh2, ch, mpk.slice(0,32), mpk.slice(32, 64), mpk.slice(64, 96), mpk.slice(96), notenum, nvalue];
  let publicParams = oh.concat(sh1, sh2, rh1, rh2, ch, [mpk.slice(0,32), mpk.slice(32, 64), mpk.slice(64, 96), mpk.slice(96), notenum, nvalue]);
  let privateParams = [ovalue, ononce, snonce1, snonce2, rnonce1, rnonce2, cnonce, spk.slice(0,32), spk.slice(32,64), spk.slice(64,96), spk.slice(96), ssk, rpk.slice(0,32), rpk.slice(32,64), rpk.slice(64,96), rpk.slice(96)]
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
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', //mpk
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', //rpk
  30, // oValue
  3, // Value
  2, // NoteNum
  'c517f646255d5492089b881965cbd3da', // oNonce
  'c517f646255d5492089b881965cbd3db', // sNonce[0]
  'c517f646255d5492089b881965cbd3dc', // sNonce[1]
  'c517f646255d5492089b881965cbd3dd', // rNonce[0]
  'c517f646255d5492089b881965cbd3de', // rNonce[1]
  'c517f646255d5492089b881965cbd3df' // cNonce
)