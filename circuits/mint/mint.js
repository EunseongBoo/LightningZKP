const crypto = require('crypto');
const utils = require("../zkpUtils");
const {computeVectors, computePath, checkRoot } = require ('../compute-vectors');
const Element = require('../Element');
//import Element from '../Element'
//import zokrates from '@eyblockchain/zokrates.js';
const BN = require('bn.js');
const SCALING_FACTOR = new BN('1000000000000000000');

function printZokratesCommand(params) {
  let cmd = 'zokrates compute-witness -a '
  params.forEach(p => {
    cmd += `${p} `
  })
  console.log(cmd);
}

function printZokratesCommand2(params) {
  let cmd = 'zokrates compute-witness -a '
  params.forEach(p => {
    cmd += `${new BN(p, 16).toString(10)} `
  })
  console.log(cmd);
}

function sha256(encodedNote) {
  const buf = Buffer.from(encodedNote, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  return digest
}

const value1 = '0x00000000000000000000000000000200'; // 128 bits = 16 bytes = 32 chars
const value2 = '0x00000000000000000000000000000100';
const value3 = '0x00000000000000000000000000000020';
const value4 = '0x00000000000000000000000000000280'; // don't forget to make C+D=E+F
const G = '0x00000000000000000000000000000030';
const H = '0x00000000000000000000000000000020'; // these constants used to enable a second transfer
const I = '0x00000000000000000000000000000050';
const sk1 = '0xf8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315';
const sk2 = '0xf8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315';
const sk3 = '0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349';
const sk4 = '0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349';
let salt1 = '0x0000000000aae43a4732ef7525b3ffe13e079e30478517a1a5d0f9cb25e67541';
let salt2 = '0x0000000000b230519599b2491b851fe712cf715a75e6482bcb26373ccdb820e4';
let salt3 = '0x0000000000081363f655cff6c879141af9d05e89bd79953c6d275125512b67cb';
let salt4 = '0x0000000000728f5e4b4f97a00b54b65e8ffe91428395fd46e207de6669c16d43';
let pk1 = utils.zeroMSBs(utils.hash(sk1));
let pk2 = utils.zeroMSBs(utils.hash(sk2));
let pk3 = utils.zeroMSBs(utils.hash(sk3));
let pk4 = utils.zeroMSBs(utils.hash(sk4));
const pkE = '0x0000000000111111111111111111111111111111111111111111111111111112';
let cm1;
let cm2;
let S_B_G;
let sBToEH;
let sBToBI;
let Z_B_G;
let cm3;
let cm4;
// storage for z indexes
let zInd1;
let zInd2;
let zInd3;

let accounts;
let fTokenShieldJson;
let fTokenShieldAddress;


const inputCommitments = [
  { value: value1, salt: salt1, commitment: cm1, index: zInd1 },
  { value: value2, salt: salt2, commitment: cm2, index: zInd2 },
];

const outputCommitments = [
  { value: value3, salt: salt3 },
  { value: value4, salt: salt4 }
];

async function test() {

  // blockchainOptions = { account, fTokenShieldJson, fTokenShieldAddress };
  //salt1 = utils.zeroMSBs(await utils.rndHex(16));
  //console.log(salt1);
  //salt2 = utils.zeroMSBs(await utils.rndHex(32));
  //salt3 = utils.zeroMSBs(await utils.rndHex(32));
  //salt4 = utils.zeroMSBs(await utils.rndHex(32));

  cm1 = utils.zeroMSBs(utils.concatenateThenHash(value1, pk1, salt1));
  cm2 = utils.zeroMSBs(utils.concatenateThenHash(value2, pk2, salt2));
  //S_B_G = utils.zeroMSBs(utils.rndHex(32));
  //sBToEH = utils.zeroMSBs(utils.rndHex(32));
  //sBToBI = utils.zeroMSBs(await utils.rndHex(32));
  //Z_B_G = utils.zeroMSBs(utils.concatenateThenHash(G, pkB, S_B_G));
  cm3 = utils.zeroMSBs(utils.concatenateThenHash(value3, pk3, salt3));
  cm4 = utils.zeroMSBs(utils.concatenateThenHash(value4, pk4, salt4));
  mint(value2, pk2, salt2);
}

test();
/**
 * Mint a coin
 * @param {String} amount - the value of the coin
 * @param {String} ownerPublicKey - Alice's public key
 * @param {String} salt - Alice's token serial number as a hex string
 * @param {String} vkId
 * @param {Object} blockchainOptions
 * @param {String} blockchainOptions.fTokenShieldJson - ABI of fTokenShieldInstance
 * @param {String} blockchainOptions.fTokenShieldAddress - Address of deployed fTokenShieldContract
 * @param {String} blockchainOptions.account - Account that is sending these transactions
 * @returns {String} commitment - Commitment of the minted coins
 * @returns {Number} commitmentIndex
 */
async function mint(amount, _ownerPublicKey, _salt) {


  // zero the most significant bits, just in case variables weren't supplied like that
  const ownerPublicKey = utils.zeroMSBs(_ownerPublicKey);
  const salt = utils.zeroMSBs(_salt);


  const preimage = utils.concatenateThenHash(amount, ownerPublicKey);
  const commitment = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt));

  //console.log('cm:', commitment)
  const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(amount, commitment));

  let pI = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1);
  let val = utils.hexToFieldPreserve(amount.toString(16),128,1,1);
  let pk = utils.hexToFieldPreserve(_ownerPublicKey.toString(16),128,2,1);
  let s = utils.hexToFieldPreserve(salt.toString(16),128,2,1);
  let cm = utils.hexToFieldPreserve(commitment.toString(16),128,2,1);
  let params = [pI, val, pk[0], pk[1], s[0], s[1], cm[0], cm[1]];

  printZokratesCommand(params)
}

/*
/**
 * This function actually transfers a coin.
 * @param {Array} inputCommitments - Array of two commitments owned by the sender.
 * @param {Array} outputCommitments - Array of two commitments.
 * Currently the first is sent to the receiverPublicKey, and the second is sent to the sender.
 * @param {String} receiverPublicKey - Public key of the first outputCommitment
 * @param {String} senderSecretKey
 * @param {Object} blockchainOptions
 * @param {String} blockchainOptions.fTokenShieldJson - ABI of fTokenShieldInstance
 * @param {String} blockchainOptions.fTokenShieldAddress - Address of deployed fTokenShieldContract
 * @param {String} blockchainOptions.account - Account that is sending these transactions
 * @returns {Object[]} outputCommitments - Updated outputCommitments with their commitments and indexes.
 * @returns {Object} Transaction object
 */
 /*
 async function transfer(
   inputCommitments,
   outputCommitments,
   _receiverPublicKey1,
   _receiverPublicKey2,
   _senderSecretKey1,
   _senderSecretKey2,
   vkId,
   blockchainOptions,
   zokratesOptions,
 ) {
   const { fTokenShieldJson, fTokenShieldAddress } = blockchainOptions;
   const account = utils.ensure0x(blockchainOptions.account);

   const {
     codePath,
     outputDirectory,
     witnessName = 'witness',
     pkPath,
     provingScheme = 'gm17',
     createProofJson = true,
     proofName = 'proof.json',
   } = zokratesOptions;

   //const fTokenShield = contract(fTokenShieldJson);
   //fTokenShield.setProvider(Web3.connect());
   //const fTokenShieldInstance = await fTokenShield.at(fTokenShieldAddress);

   console.group('\nIN TRANSFER...');

   for (const inputCommitment of inputCommitments) {
     inputCommitment.salt = utils.zeroMSBs(inputCommitment.salt);
     inputCommitment.commitment = utils.zeroMSBs(inputCommitment.commitment);
   }
   for (const outputCommitment of outputCommitments) {
     outputCommitment.salt = utils.zeroMSBs(outputCommitment.salt);
   }
   const senderSecretKey1 = utils.zeroMSBs(_senderSecretKey1);
   const senderSecretKey2 = utils.zeroMSBs(_senderSecretKey2);
   const receiverPublicKey1 = utils.zeroMSBs(_receiverPublicKey1);
   const receiverPublicKey2 = utils.zeroMSBs(_receiverPublicKey2);

   */
