const crypto = require('crypto');
const BN = require('bn.js');
const SCALING_FACTOR = new BN('1000000000000000000');

function getPublicKeyHash(pk) {
  const buf = Buffer.from(pk, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  console.log('PK Hash('+pk+') :', digest);
  return digest
}

function getNoteHash(encodedNote) {
  const buf = Buffer.from(encodedNote, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  // console.log('digest', digest)
  // split into 128 bits each
  return [digest.slice(0, 32), digest.slice(32)]
}

function printZokratesCommand(params) {
  console.log(params)
  let cmd = 'zokrates compute-witness -a '
  params.forEach(p => {
    cmd += `${new BN(p, 16).toString(10)} `
  })
  console.log(cmd);
}

function getCreateNoteParams(_pubKey, _secKey, _value, _nonce) {
  console.log(arguments)
  let pubKey = new BN(_pubKey, 16).toString(16); // 32 bytes = 256 bits
  let secKey = new BN(_secKey, 16).toString(16);
  let value = new BN(_value, 16).mul(SCALING_FACTOR).toString(16, 32); // 16 bytes = 128 bits
  console.log("value: "+value);
  let test = new BN(_value, 16).mul(SCALING_FACTOR).toString(16, 32);
  console.log("test: "+test);
  let nonce = new BN(_nonce, 16).toString(16, 32); // 16 bytes = 128 bits
  let privateParams = [pubKey.slice(0,32), pubKey.slice(32, 64), pubKey.slice(64, 96), pubKey.slice(96), secKey, nonce];

  let pubKeyHash = getPublicKeyHash(pubKey.slice(0, 32) + pubKey.slice(32, 64) + pubKey.slice(64,96) + pubKey.slice(96));
  let note = pubKeyHash + value + nonce;
  console.log('\n noteHash: ', getNoteHash(note));

  let publicParams = getNoteHash(note).concat(value);
  printZokratesCommand(publicParams.concat(privateParams));
}

//create a secret note of value 10
getCreateNoteParams(
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', // pk
  'f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315', // sk
  '30', // value
  'c517f646255d5492089b881965cbd3da' // nonce
)
