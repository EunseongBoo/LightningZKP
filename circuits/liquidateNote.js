const util = require('ethereumjs-util')
const crypto = require('crypto');
const BN = require('bn.js');
const SCALING_FACTOR = new BN('1000000000000000000');

function printZokratesCommand(params) {
  let cmd = 'zokrates compute-witness -a '
  params.forEach(p => {
    cmd += `${new BN(p, 16).toString(10)} `
  })
  console.log(cmd);
}

function sha256(encodedNote) {
  const buf = Buffer.from(encodedNote, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  return [digest.slice(0, 32), digest.slice(32)]
}

function getCreateNoteParams(_pubKey, _secKey, _lpubKey, _value, _nonce) {
  let pubKey = new BN(_pubKey, 16).toString(16);
  let secKey = new BN(_secKey, 16).toString(16);
  let lpubKey = new BN(_lpubKey, 16).toString(16);
  let value = new BN(_value, 16).mul(SCALING_FACTOR).toString(16, 32); // 16 bytes = 128 bits
  let nonce = new BN(_nonce, 16).toString(16, 32); // 16 bytes = 128 bits

  let secKeyHash = sha256(secKey.slice(0,32) + secKey.slice(32));

  let note = secKeyHash[0] + secKeyHash[1] + value; //original note
  let h = sha256(note);
  let nh = sha256(h[0] + h[1] + nonce);

  let privateParams = [nh[0], nh[1], value, lpubKey.slice(0,32), lpubKey.slice(32,64), lpubKey.slice(64,96), lpubKey.slice(96), secKey.slice(0,32), secKey.slice(32), nonce];
  printZokratesCommand(privateParams);
}

getCreateNoteParams(
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', // pk
  'f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315', // sk
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', // pk (liquidate)
  50, // value
  'c517f646255d5492089b881965cbd3da' // nonce
)
