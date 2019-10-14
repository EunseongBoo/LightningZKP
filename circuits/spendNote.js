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

function getCreateNoteParams(_pubKey, _secKey, _rpubKey, _value, _value2, _value3, _nonce, _nonce2, _nonce3) {
  console.log(arguments)
  let pubKey = new BN(_pubKey, 16).toString(16); // 32 bytes = 256 bits
  let secKey = new BN(_secKey, 16).toString(16);
  let rpubKey = new BN(_rpubKey, 16).toString(16);
  let value = new BN(_value, 16).mul(SCALING_FACTOR).toString(16, 32); // 16 bytes = 128 bits
  let value2 = new BN(_value2, 16).mul(SCALING_FACTOR).toString(16, 32);
  let value3 = new BN(_value3, 16).mul(SCALING_FACTOR).toString(16, 32);
  let nonce = new BN(_nonce, 16).toString(16, 32); // 16 bytes = 128 bits
  let nonce2 = new BN(_nonce2, 16).toString(16, 32); // 16 bytes = 128 bits
  let nonce3 = new BN(_nonce3, 16).toString(16, 32); // 16 bytes = 128 bits
  let privateParams = [pubKey.slice(0,32), pubKey.slice(32, 64), pubKey.slice(64, 96), pubKey.slice(96), secKey, rpubKey.slice(0,32), rpubKey.slice(32, 64), rpubKey.slice(64, 96), rpubKey.slice(96), value, nonce, value2, nonce2, value3, nonce3];

  let pubKeyHash = getPublicKeyHash(pubKey.slice(0, 32) + pubKey.slice(32, 64) + pubKey.slice(64,96) + pubKey.slice(96));
  let rpubKeyHash = getPublicKeyHash(rpubKey.slice(0, 32) + rpubKey.slice(32, 64) + rpubKey.slice(64,96) + rpubKey.slice(96));
  let note = pubKeyHash + value + nonce;
  let note0 = rpubKeyHash + value2 + nonce2;
  let note1 = pubKeyHash + value3 + nonce3;
  console.log('note', note);

  noteHash2 = getNoteHash(note0);
  noteHash3 = getNoteHash(note1);

  let publicParams = getNoteHash(note).concat(noteHash2).concat(noteHash3);
  printZokratesCommand(publicParams.concat(privateParams));
}
//(field[2] oh, field[2] n0h, field[2] n1h, private field [4] spk, private field ssk, private field [4] rpk, private field oVal, private field oNonce, private field n0Val, private field n0Nonce, private field n1Val, private field n1Nonce)
// this will serve as an invalid proof
getCreateNoteParams(
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', // pk
  'f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315', // sk
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', //rpk
  10, // oValue
  5, //nValue
  5,  //nValue2
  'c517f646255d5492089b881965cbd3da', // oNonce
  'c517f646255d5492089b881965cbd3da', // nNonce1
  'c517f646255d5492089b881965cbd3da' // nNonce2
)
