const ZkDai = artifacts.require("ZkDai");
const TestDai = artifacts.require("TestDai");
const Wallet = require('ethereumjs-wallet');
const util = require('./util')
const assert = require('assert')
var ethers = require('ethers');

var mint_proof = require("./mintNoteProof.json").proof;
var mint_inputs = require("./mintNoteProof.json").inputs;
var num = 2;
var deposit_proof = require("./depositNoteProof_2.json").proof;
var deposit_inputs = require("./depositNoteProof_" + num +".json").inputs;


const SCALING_FACTOR = 10**18;
const tokenAmount = web3.utils.toBN(100*10**18);

let privateKey = '0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349';
let wallet_mpk = new ethers.Wallet(privateKey);

let dai, zkdai;
before(async () => {
  dai = await TestDai.new();
})

beforeEach(async () => {
  zkdai = await ZkDai.new(100000000, web3.utils.toBN(SCALING_FACTOR), dai.address);
  console.log(zkdai.constructor._json.deployedBytecode.length);
})

it('Create and deposit', async function() {
  this.timeout(10000)
  await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
  const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
  const challenge = await zkdai.challenge_mint(mint_proof.a, mint_proof.b, mint_proof.c);
  console.log(challenge.logs);

  const deposit = await zkdai.deposit(deposit_proof.a, deposit_proof.b, deposit_proof.c, deposit_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
  const challenge_deposit = await zkdai.challenge_deposit(deposit_proof.a, deposit_proof.b, deposit_proof.c);
  console.log(challenge_deposit.logs);
  let length = challenge_deposit.logs.length;
  let poolId = challenge_deposit.logs[length-1].args.poolId;
  //let mpkAddress = challenge_deposit.logs[length-1].args.mpkAddress
  var msg = poolId+num;
  let flatSig = await wallet_mpk.signMessage(msg);
  // For Solidity, we need the expanded-format of a signature
  let sig = ethers.utils.splitSignature(flatSig);
  // Call the verifyString function
  let signedTx = await zkdai.commit_signedTx(msg, sig.v, sig.r, sig.s);
})

function assertEvent(event, type, ...args) {
  assert.equal(event.event, type);
  args.forEach((arg, i) => {
    assert.equal(event.args[i], arg);
  })
}
