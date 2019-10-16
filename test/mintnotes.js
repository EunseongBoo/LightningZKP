const ZkDai = artifacts.require("ZkDai");
const TestDai = artifacts.require("TestDai");
const util = require('./util')
const assert = require('assert')
var proof = require("./mintNoteProof.json").proof;
var inputs = require("./mintNoteProof.json").inputs;
const SCALING_FACTOR = 10**18;
const tokenAmount = web3.utils.toBN(100*10**18);

a = ["0x0b571d9654999c42ca71cc1fbc2bdbc3b0d84b3121587010c6cd3ab75119de35","0x099ac4e1fa6dea44202c692270918764e874995e6afbddc2bd63e7e60e564bf8"]
b = [["0x035ef341ba89f627003167af79feb51eb6bbe41a995dd3e81ea194d4da4a6bef", "0x2b59e97dfb88c76b09e519dfa5f55677f19e5ed03f3cf0c961f6df5646cfdcc6"], ["0x16b2a8a197447d5226e7bd9ebd2f2d3986284fe80a1a35bcc638faa6fc33d0d6", "0x143f0d7a6ffb19d0d5edad0b2c809ac1499e81635077acea61abdea124bbd23e"]]
c = ["0x14bf585cdc3fb6b1023b2bf0347b503682388dea5ba2e0e9f19c48a01409c05f","0x16d85f162a33345ff8e6c6ecf05670c00d7283416e856e782016c0fca1a2a691"]
d = ["0x00000000000000000000000000000000de8b8ba213d01a5db0a4137f89a3b143","0x0000000000000000000000000000000043f025080d6f8e1f71ad227573e1b1ca","0x0000000000000000000000000000000000000000000000029a2241af62c00030","0x0000000000000000000000000000000000000000000000000000000000000001"]


contract('mintNote', function(accounts) {
  let dai, zkdai;
  console.log(accounts);
  // Initial setup
  before(async () => {
    dai = await TestDai.new();
  })

  beforeEach(async () => {
    zkdai = await ZkDai.new(100000000, web3.utils.toBN(SCALING_FACTOR), dai.address);
  })

  it('transfers dai and mints note', async function() {
    // check dai balance and approve the zkdai contract to be able to move tokens
    var daiCoinBalance = (await dai.balanceOf.call(accounts[0])).toString();
    //assert.equal(daiCoinBalance, tokenAmount.toString() , '100 dai tokens were not assigned to the 1st accounct ');
    var zkdaiCoinBalance = (await dai.balanceOf.call(zkdai.address)).toString();
    assert.equal(zkdaiCoinBalance, 0, 'Zkdai contract should have 0 dai tokens');
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(30,16)*(10**18)));

    //console.log("a: " + proof.a + "\nb: " + proof.b +"\nc: " + proof.c + "\nd:"+ inputs);
    const mint = await zkdai.mint(proof.a, proof.b, proof.c, inputs,{value:web3.utils.toBN(SCALING_FACTOR)});
    assert.equal(await dai.balanceOf.call(zkdai.address), parseInt(30,16) * SCALING_FACTOR, 'Zkdai contract should have 30 dai tokens');
    assertEvent(mint.logs[0], 'Submitted', accounts[0], '0xec80f7dafd9151fd44130ebda16666171fe58d3d6c34ed5c71b805e89c21a5ea')
  })

  it('challenge fails for correct proof', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(30,16) * 10**18));
    const mint = await zkdai.mint(proof.a, proof.b, proof.c, inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const challenge = await zkdai.challenge(proof.a, proof.b, proof.c); // omit sending public params again

    assert.equal(challenge.logs[1].event, 'NoteStateChange')
    // @todo assert on challenge.logs[1].args.note
    assert.equal(challenge.logs[1].args.state, 1 /* committed */)
  })

  it('challenge passes for incorrect proof', async function() {
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    // try sending in a note hash of higher value (invalid proof)
    const mint = await zkdai.mint(proof.a, proof.b, proof.c, d, {value:web3.utils.toBN(SCALING_FACTOR)});
    const proofHash = mint.logs[0].args.proofHash;
    const challenge = await zkdai.challenge(proof.a, proof.b, proof.c); // omit sending public params again
    assert.equal(challenge.logs[0].event, 'Challenged')
    assert.equal(challenge.logs[0].args.challenger, accounts[0]);
    assert.equal(challenge.logs[0].args.proofHash, proofHash)
  })

  it('commit', async function() {
    zkdai = await ZkDai.new(0 /* low cooldown */, web3.utils.toBN(SCALING_FACTOR), dai.address);
    await dai.approve(zkdai.address, web3.utils.toBN(parseInt(30,16) * 10**18));
    const mint = await zkdai.mint(proof.a, proof.b, proof.c, inputs, {value:web3.utils.toBN(SCALING_FACTOR)});
    const proofHash = mint.logs[0].args.proofHash;

    await util.sleep(1);
    const commit = await zkdai.commit(proofHash);
    assert.equal(commit.logs[0].event, 'NoteStateChange')
    assert.equal(commit.logs[0].args.state, 1 /* committed */)
  })

  it('can not be challenged after cooldown period');
  it('can not be committed before cooldown period');
})

function assertEvent(event, type, ...args) {
  assert.equal(event.event, type);
  args.forEach((arg, i) => {
    assert.equal(event.args[i], arg);
  })
}
