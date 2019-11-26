const ZkDai = artifacts.require("ZkDai");
const TestDai = artifacts.require("TestDai");
const mintNotes = artifacts.require("MintNotes");
const spendNotes = artifacts.require("SpendNotes");
const util = require('./util')
const assert = require('assert')
var mint_proof = require("./mintNoteProof.json").proof;
var mint_inputs = require("./mintNoteProof.json").inputs;
var spend_proof = require("./spendNoteProof.json").proof;
var spend_inputs = require("./spendNoteProof.json").inputs;
var deposit2_proof = require("./depositNote2Proof.json").proof;
var deposit2_inputs = require("./depositNote2Proof.json").inputs;
var deposit5_proof = require("./depositNote5Proof.json").proof;
var deposit5_inputs = require("./depositNote5Proof.json").inputs;
var deposit10_proof = require("./depositNote10Proof.json").proof;
var deposit10_inputs = require("./depositNote10Proof.json").inputs;
var deposit20_proof = require("./depositNote20Proof.json").proof;
var deposit20_inputs = require("./depositNote20Proof.json").inputs;
const SCALING_FACTOR = 10**18;
const tokenAmount = web3.utils.toBN(100*10**18);

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



  it('Create and Send a secret note', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(30,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again

    assert.equal(challenge.logs[1].event, 'NoteStateChange')
    //@todo assert on challenge.logs[1].args.note
    assert.equal(challenge.logs[1].args.state, 1 )

    const spend = await zkdai.spend(spend_proof.a, spend_proof.b, spend_proof.c, spend_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    console.log(challenge.logs[1].event)
    const challenge_spend = await zkdai.challenge_spend(spend_proof.a, spend_proof.b, spend_proof.c);
    console.log(challenge_spend.logs[1])
  })

  it('Create and deposit2', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(30,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again

    const spend = await zkdai.deposit_2(deposit2_proof.a, deposit2_proof.b, deposit2_proof.c, deposit2_inputs , {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge_spend = await zkdai.challenge_deposit_2(deposit2_proof.a, deposit2_proof.b, deposit2_proof.c);
    //console.log(challenge_spend.logs[1].args.state);
    //assert.equal(challenge_spend.logs[1].event, 'NoteStateChange')
    //assert.equal(challenge_spend.logs[1].args.state, 1 )
  })


  it('Create and deposit5', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(30,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again

    const spend = await zkdai.deposit_5(deposit5_proof.a, deposit5_proof.b, deposit5_proof.c, deposit5_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge_spend = await zkdai.challenge_deposit_5(deposit5_proof.a, deposit5_proof.b, deposit5_proof.c);
    //console.log(challenge_spend.logs[1].args.state, 1);
    //assert.equal(challenge_spend.logs[1].event, 'NoteStateChange')
    //assert.equal(challenge_spend.logs[1].args.state, 1)
  })

  it('Create and deposit10', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(30,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again

    const deposit10 = await zkdai.deposit_10(deposit10_proof.a, deposit10_proof.b, deposit10_proof.c, deposit10_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge_deposit10 = await zkdai.challenge_deposit_10(deposit10_proof.a, deposit10_proof.b, deposit10_proof.c);
    console.log(challenge_deposit10.logs[0]);
    console.log(challenge_deposit10.logs[1]);
    console.log(challenge_deposit10.logs[2]);
  })

  it('Create and deposit20', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(30,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again

    const deposit20 = await zkdai.deposit_20(deposit20_proof.a, deposit20_proof.b, deposit20_proof.c, deposit20_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge_deposit20 = await zkdai.challenge_deposit_20(deposit20_proof.a, deposit20_proof.b, deposit20_proof.c);
    console.log(challenge_deposit20.logs[0]);
    console.log(challenge_deposit20.logs[1]);
    console.log(challenge_deposit20.logs[2]);
  })
})

function assertEvent(event, type, ...args) {
  assert.equal(event.event, type);
  args.forEach((arg, i) => {
    assert.equal(event.args[i], arg);
  })
}
