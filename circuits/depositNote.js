const crypto = require('crypto');
const BN = require('bn.js');
var Wallet = require('ethereumjs-wallet');
var EthUtil = require('ethereumjs-util');

const SCALING_FACTOR = new BN('1000000000000000000'); //10**18;

function getPublicKeyHash(pk) {
  const buf = Buffer.from(pk, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  console.log('pk digest', digest);
  return digest
}
function getNoteHash(encodedNote) {
  const buf = Buffer.from(encodedNote, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  console.log('digest', digest);
  console.log('digest.length', digest.length); //64 hex, 32 bytes
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

function getCreateNoteParams(_pubKey, _secKey,_value, _nonce) {
  console.log(arguments)
  let pubKey = new BN(_pubKey, 16).toString(16); // 64 bytes = 512 bits
  let secKey = new BN(_secKey, 16).toString(16);
  //console.log('pubKey: ', pubKey.length);
  console.log()
  let value = new BN(_value, 16).mul(SCALING_FACTOR).toString(16, 32); // 16 bytes = 128 bits
  //console.log('value: ', value);
  //console.log('value.length: ', value.length);
  let nonce = new BN(_nonce, 16).toString(16, 32); // 16 bytes = 128 bits
  //console.log('nonce: ', nonce);
  //let privateParams = [pubKey.slice(0, 32), pubKey.slice(32), nonce];
  let privateParams = [pubKey.slice(0, 32), pubKey.slice(32, 64), pubKey.slice(64,96), pubKey.slice(96), nonce, secKey];
  //let privateParams = [pubKey.slice(0, 64), pubKey.slice(64), nonce];
  let pubKeyHash = getPublicKeyHash(pubKey.slice(0, 32) + pubKey.slice(32, 64) + pubKey.slice(64,96) + pubKey.slice(96));
  let note = pubKeyHash + value + nonce;
  console.log('note', note);
  let publicParams = getNoteHash(note).concat(value);
  printZokratesCommand(publicParams.concat(privateParams));

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
  '30', // oValue
  '3', // Value
  '2', // NoteNum
  'c517f646255d5492089b881965cbd3da', // oNonce
  'c517f646255d5492089b881965cbd3db', // sNonce[0]
  'c517f646255d5492089b881965cbd3dc', // sNonce[1]
  'c517f646255d5492089b881965cbd3dd', // rNonce[0]
  'c517f646255d5492089b881965cbd3de', // rNonce[1]
  'c517f646255d5492089b881965cbd3df' // cNonce
)
