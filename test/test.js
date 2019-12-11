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
var deposit_proof = require("./depositNoteProof.json").proof;
var deposit_inputs = require("./depositNoteProof.json").inputs;

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
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
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

  it('Create and deposit', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge(mint_proof.a, mint_proof.b, mint_proof.c); // omit sending public params again

    const deposit = await zkdai.deposit(deposit_proof.a, deposit_proof.b, deposit_proof.c, deposit_inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge_deposit = await zkdai.challenge_deposit(deposit_proof.a, deposit_proof.b, deposit_proof.c);
    console.log(challenge_deposit.logs[0]);
    console.log(challenge_deposit.logs[1]);
    console.log(challenge_deposit.logs[2]);
  })

})

function assertEvent(event, type, ...args) {
  assert.equal(event.event, type);
  args.forEach((arg, i) => {
    assert.equal(event.args[i], arg);
  })
}
