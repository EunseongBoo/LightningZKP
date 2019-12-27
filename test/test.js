const ZkDai = artifacts.require("ZkDai");
const TestDai = artifacts.require("TestDai");
const Wallet = require('ethereumjs-wallet');
const util = require('./util')
const assert = require('assert')
var ethers = require('ethers');

var mint_proof = require("./mintNoteProof.json").proof;
var mint_inputs = require("./mintNoteProof.json").inputs;
var spend_proof = require("./spendNoteProof.json").proof;
var spend_inputs = require("./spendNoteProof.json").inputs;
var deposit_proof = require("./depositNoteProof_30.json").proof;
var deposit_inputs = require("./depositNoteProof_30.json").inputs;
var liquidate_proof = require("./liquidateNoteProof.json").proof;
var liquidate_inputs = require("./liquidateNoteProof.json").inputs;

const SCALING_FACTOR = 10**18;
const tokenAmount = web3.utils.toBN(100*10**18);

let privateKey = '0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349';
let wallet_mpk = new ethers.Wallet(privateKey);

//var wallet_mpk = Wallet.fromPrivateKey(Buffer.from('0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349'));
//console.log('address1: ' + wallet_mpk.getAddressString());
//console.log('private key: ' + wallet_mpk.getPrivateKeyString());
//console.log('public key: ' + wallet_mpk.getPublicKeyString());


contract('mintNote', function(accounts) {
  params = {
    'gasPrice':20000000000,
    'gas': 100000000,
    'from':accounts[0],
}

  let dai, zkdai;

  // Initial setup
  before(async () => {
    dai = await TestDai.new();
  })

  beforeEach(async () => {
    zkdai = await ZkDai.new(100000000, web3.utils.toBN(SCALING_FACTOR), dai.address);
    console.log(zkdai.constructor._json.deployedBytecode.length);
  })

  async function sendSignedTx(msg){
    let flatSig = await wallet_mpk.signMessage(msg);
    // For Solidity, we need the expanded-format of a signature
    let sig = ethers.utils.splitSignature(flatSig);
    // Call the verifyString function
    let signedTx = await zkdai.commit_signedTx(msg, sig.v, sig.r, sig.s);
    console.log(signedTx.logs)
  }

  it('Create and Send a secret note', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge_mint(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again

    assert.equal(challenge.logs[1].event, 'NoteStateChange')
    //@todo assert on challenge.logs[1].args.note
    assert.equal(challenge.logs[1].args.state, 1 )

    const spend = await zkdai.spend(spend_proof.a, spend_proof.b, spend_proof.c, spend_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    console.log(challenge.logs[1].event)
    const challenge_spend = await zkdai.challenge_spend(spend_proof.a, spend_proof.b, spend_proof.c);
  })
  it('Create and liquidate a secret note', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge_mint(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again

    assert.equal(challenge.logs[1].event, 'NoteStateChange')
    assert.equal(challenge.logs[1].args.state, 1 )
    let balance = await dai.balanceOf("0x001d3F1ef827552Ae1114027BD3ECF1f086bA0F9")
    console.log("balance (before): " + balance);

    const liquidate = await zkdai.liquidate("0x001d3F1ef827552Ae1114027BD3ECF1f086bA0F9", liquidate_proof.a, liquidate_proof.b, liquidate_proof.c, liquidate_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge_liquidate = await zkdai.challenge_liquidate(liquidate_proof.a, liquidate_proof.b, liquidate_proof.c);
    console.log(challenge_liquidate.logs)
    balance = await dai.balanceOf("0x001d3F1ef827552Ae1114027BD3ECF1f086bA0F9")
    console.log("balance (after): " + balance);
  })

  it('Create and deposit', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge_mint(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again
    const deposit = await zkdai.deposit(deposit_proof.a, deposit_proof.b, deposit_proof.c, deposit_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge_deposit = await zkdai.challenge_deposit(deposit_proof.a, deposit_proof.b, deposit_proof.c);
    console.log(challenge_deposit.logs);
   /*
    let length = challenge_deposit.logs.length;
    //console.log(challenge_deposit.logs[length -1].args.Result);
    //onsole.log(challenge_deposit.logs[length -1].args.Result.dValue);
    //console.log(challenge_deposit.logs[length -1]);
    //console.log(challenge_deposit.logs[length -1].args.dValue.toString());
    //console.log(challenge_deposit.logs[2]);
    let poolId = challenge_deposit.logs[length-1].args.poolId;
    //let mpkAddress = challenge_deposit.logs[length-1].args.mpkAddress;
    var num = 10;
    var msg = poolId+num;
    let flatSig = await wallet_mpk.signMessage(msg);
    // For Solidity, we need the expanded-format of a signature
    let sig = ethers.utils.splitSignature(flatSig);
    // Call the verifyString function
    let signedTx = await zkdai.commit_signedTx(msg, sig.v, sig.r, sig.s);
    */
  })

})

function assertEvent(event, type, ...args) {
  assert.equal(event.event, type);
  args.forEach((arg, i) => {
    assert.equal(event.args[i], arg);
  })
}
