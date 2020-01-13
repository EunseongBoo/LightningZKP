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

function getCreateNoteParams(_pubKey, _secKey, _rsecKey, _value, _value2, _value3, _nonce, _nonce2, _nonce3) {
  let pubKey = new BN(_pubKey, 16).toString(16);
  let secKey = new BN(_secKey, 16).toString(16);
  let rsecKey = new BN(_rsecKey, 16).toString(16);
  let value = new BN(_value, 16).mul(SCALING_FACTOR).toString(16, 32); // 16 bytes = 128 bits
  let value2 = new BN(_value2, 16).mul(SCALING_FACTOR).toString(16, 32);
  let value3 = new BN(_value3, 16).mul(SCALING_FACTOR).toString(16, 32);
  let nonce = new BN(_nonce, 16).toString(16, 32); // 16 bytes = 128 bits
  let nonce2 = new BN(_nonce2, 16).toString(16, 32); // 16 bytes = 128 bits
  let nonce3 = new BN(_nonce3, 16).toString(16, 32); // 16 bytes = 128 bits

  let secKeyHash = sha256(secKey.slice(0,32) + secKey.slice(32));
  let rsecKeyHash = sha256(rsecKey.slice(0,32) + rsecKey.slice(32));

  let note = secKeyHash[0] + secKeyHash[1] + value; //original note
  let note2 = rsecKeyHash[0] + rsecKeyHash[1]  + value2; //receiver note
  let note3 = secKeyHash[0] + secKeyHash[1]  + value3; //change note

  let h = sha256(note);
  let h2 = sha256(note2);
  let h3 = sha256(note3);

  let nh = sha256(h[0] + h[1] + nonce);
  let nh2 = sha256(h2[0] + h2[1] + nonce2);
  let nh3 = sha256(h3[0] + h3[1] + nonce3);

  let privateParams = [nh[0], nh[1], nh2[0], nh2[1], nh3[0], nh3[1], secKey.slice(0,32), secKey.slice(32), rsecKeyHash[0], rsecKeyHash[1], value, value2, value3, nonce, nonce2, nonce3];
  printZokratesCommand(privateParams);
}

getCreateNoteParams(
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', // pk
  'f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315', // sk
  '44c0c9e3532f9691c9a7ece9785061c57aed5c5bcc2d5c15b544e20ccaf92033', // recevier's sk
  50, // value
  10,
  40,
  'c517f646255d5492089b881965cbd3da', // nonce
  'c517f646255d5492089b881965cbd3db', // nonce2
  'c517f646255d5492089b881965cbd3dc', // nonce3
)
