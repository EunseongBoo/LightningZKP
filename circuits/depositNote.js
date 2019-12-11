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

function getCreateNoteParams(_pubKey, _secKey, _mpubKey, _msecKey, _rsecKey, _oValue, _dValue, _depositNum, _oNonce, _sNonce, _rNonce, _cNonce) {
  let pubKey = new BN(_pubKey, 16).toString(16);
  let secKey = new BN(_secKey, 16).toString(16);
  let mpubKey = new BN(_mpubKey, 16).toString(16);
  let msecKey = new BN(_msecKey, 16).toString(16);
  let rsecKey = new BN(_rsecKey, 16).toString(16);

  let oValue = new BN(_oValue, 16).mul(SCALING_FACTOR).toString(16, 32); // 16 bytes = 128 bits
  let dValue = new BN(_dValue, 16).mul(SCALING_FACTOR).toString(16, 32);
  var _cValue;
  if(_oValue >= _dValue *_depositNum){
    _cValue = _oValue - _dValue*_depositNum;
  } else console.log("balance error occurs!");
  let cValue = new BN(_cValue, 16).mul(SCALING_FACTOR).toString(16, 32);

  let depositNum = new BN(_depositNum, 16).toString(16, 32);
  let oNonce = new BN(_oNonce, 16).toString(16, 32); // 16 bytes = 128 bits
  let sNonce = new BN(_sNonce, 16).toString(16, 32); // 16 bytes = 128 bits
  let rNonce = new BN(_rNonce, 16).toString(16, 32); // 16 bytes = 128 bits
  let cNonce = new BN(_cNonce, 16).toString(16, 32); // 16 bytes = 128 bits

  let secKeyHash = sha256(secKey.slice(0,32) + secKey.slice(32));
  let msecKeyHash = sha256(msecKey.slice(0,32) + msecKey.slice(32));
  let rsecKeyHash = sha256(rsecKey.slice(0,32) + rsecKey.slice(32));

  let onote = secKeyHash[0] + secKeyHash[1] + oValue; //original note
  var snote = msecKeyHash[0] + msecKeyHash[1] + dValue; //sender's deposit note (use msecKeyHash)
  var rnote = rsecKeyHash[0] + rsecKeyHash[1]  + dValue; //receiver's deposit note
  let cnote = secKeyHash[0] + secKeyHash[1]  + cValue; //change note

  let ohSeed = sha256(onote);
  let chSeed = sha256(cnote);
  var shSeed = sha256(snote);
  var rhSeed =  sha256(rnote);

  let oh = sha256(ohSeed[0] + ohSeed[1] + oNonce);
  let ch = sha256(chSeed[0] + chSeed[1] + cNonce);
  var sh = new Array();
  var rh = new Array();

  for(var i=0; i< _depositNum; i++){
    var bni  = new BN(i,16);
    var sNonce_ =  new BN(_sNonce, 16).add(bni).toString(16, 32);
    var rNonce_ =  new BN(_rNonce, 16).add(bni).toString(16, 32);
    sh[i] = sha256(shSeed[0] + shSeed[1] + sNonce_);
    rh[i] = sha256(rhSeed[0] + rhSeed[1] + rNonce_);
  //  console.log(sh[i]);
  }

  var publicParams = [oh[0], oh[1], ch[0], ch[1], shSeed[0], shSeed[1], rhSeed[0], rhSeed[1]];

  publicParams.push(mpubKey.slice(0,32), mpubKey.slice(32,64), mpubKey.slice(64,96), mpubKey.slice(96), depositNum, dValue, sNonce, rNonce);


  let privateParams = [secKey.slice(0,32), secKey.slice(32), msecKeyHash[0], msecKeyHash[1], rsecKeyHash[0], rsecKeyHash[1], oValue, cValue, oNonce, cNonce];

  publicParams = publicParams.concat(privateParams);
  printZokratesCommand(publicParams);
  //console.log("sh: " + sha256(shSeed[0] + shSeed[1] + sNonce));
  //console.log("context: "+ shSeed[0] + " "+ " " +shSeed[1] + " " + sNonce);
}

getCreateNoteParams(
  '6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', // pk
  'f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315', // sk
  '6c9a44419b52ff7f7e02406def3b41fa57d8482c01ed04e56b6475c8e04466f11f2b61d057d73066a78a684a3099a4df6d2defbc3844d4dd72a2e545a4ebc595', //mpk
  '0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349', //msk
  '44c0c9e3532f9691c9a7ece9785061c57aed5c5bcc2d5c15b544e20ccaf92033', // recevier's sk
  50, // oValue
  1, // dValue
  10, // depositNum
  'c517f646255d5492089b881965cbd3da', // oNonce
  'c517f646255d5492089b881965cbd3db', // sNonce
  'c517f646255d5492089b881965cbd3db', // rNonce
  'c517f646255d5492089b881965cbd3dc', // cNonce
)
