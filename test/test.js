const ZkDai = artifacts.require("ZkDai");
const TestDai = artifacts.require("TestDai");
const Wallet = require('ethereumjs-wallet');
const util = require('./util')
const assert = require('assert')
const crypto = require('crypto');
const utils = require("./zkpUtils");
const config = require("./config");
const cv = require ('./compute-vectors');
const Element = require('./Element');
const BN = require('bn.js');

var ethers = require('ethers');

var mint_proof1 = require("./mintProof1.json").proof;
var mint_inputs1 = require("./mintProof1.json").inputs;
var mint_proof2 = require("./mintProof2.json").proof;
var mint_inputs2 = require("./mintProof2.json").inputs;

var pour_proof = require("./pourProof.json").proof;
var pour_inputs = require("./pourProof.json").inputs;

var pour4_proof = require("./pour4Proof.json").proof;
var pour4_inputs = require("./pour4Proof.json").inputs;

var lzkp_proof = require("./lzkpProof.json").proof;
var lzkp_inputs = require("./lzkpProof.json").inputs;

var burn_proof = require("./burnProof.json").proof;
var burn_inputs = require("./burnProof.json").inputs;

var burn4_proof = require("./burn4Proof.json").proof;
var burn4_inputs = require("./burn4Proof.json").inputs;

var spend_proof = require("./spendNoteProof.json").proof;
var spend_inputs = require("./spendNoteProof.json").inputs;
var deposit_proof = require("./depositNoteProof_50.json").proof;
var deposit_inputs = require("./depositNoteProof_50.json").inputs;
var num = 50;

var liquidate_proof = require("./liquidateNoteProof.json").proof;
var liquidate_inputs = require("./liquidateNoteProof.json").inputs;

const SCALING_FACTOR = 10**18;
const tokenAmount = web3.utils.toBN(100*10**18);

let privateKey = '0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349';
let wallet_mpk = new ethers.Wallet(privateKey);

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

contract('mintNote', function(accounts) {
  params = {
    'gasPrice':20000000000,
    'gas': 100000000,
    'from':accounts[0],
  }

  let dai, zkdai;
  const value1 = '0x00000000000000000000000000000200'; // 128 bits = 16 bytes = 32 chars // 512 (10)
  const value2 = '0x00000000000000000000000000000100'; //256 (10)
  const value3 = '0x00000000000000000000000000000100';
  const value4 = '0x00000000000000000000000000000200'; // don't forget to make C+D=E+F
  const value5 = '0x00000000000000000000000000000044'; //68(10)
  const dvalue = '0x00000000000000000000000000000046'; //70(10)
  const depositNum = '0x0000000000000000000000000000000a';
  const G = '0x00000000000000000000000000000030';
  const H = '0x00000000000000000000000000000020'; // these constants used to enable a second transfer
  const I = '0x00000000000000000000000000000050';
  const sk1 = '0xf8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315';
  const sk2 = '0xf8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315';
  const sk3 = '0xf8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315';
  const sk4 = '0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349';
  const sk5 = '0xf8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315';
  const msk = '0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349'; //msk
  let salt1 = '0x0000000000aae43a4732ef7525b3ffe13e079e30478517a1a5d0f9cb25e67541';
  let salt2 = '0x0000000000b230519599b2491b851fe712cf715a75e6482bcb26373ccdb820e4';
  let salt3 = '0x0000000000081363f655cff6c879141af9d05e89bd79953c6d275125512b67cb';
  let salt4 = '0x0000000000728f5e4b4f97a00b54b65e8ffe91428395fd46e207de6669c16d43';
  let salt5 = '0x0000000000668f5e4b4f97a00b54b65e8ffe91428395fd46e207de6669c16d66';
  let mpk_address = "0x06644cDeB4899a5f8f5f655aFffAfB4F0625B304";
  const pk1 = utils.zeroMSBs(utils.hash(sk1));
  const pk2 = utils.zeroMSBs(utils.hash(sk2));
  const pk3 = utils.zeroMSBs(utils.hash(sk3));
  const pk4 = utils.zeroMSBs(utils.hash(sk4));
  const pk5 = utils.zeroMSBs(utils.hash(sk5));
  const mpk = '0x6c9a44419b52ff7f7e02406def3b41fa57d8482c01ed04e56b6475c8e04466f11f2b61d057d73066a78a684a3099a4df6d2defbc3844d4dd72a2e545a4ebc595';
  const pkE = '0x0000000000111111111111111111111111111111111111111111111111111112';
  let cm1;
  let cm2;
  let S_B_G;
  let sBToEH;
  let sBToBI;
  let Z_B_G;
  let cm3;
  let cm4;
  let nullifier1;
  let nullifier2;
  // storage for z indexes
  let cmIndex1;
  let cmIndex2;
  let cmIndex3;
  let cmIndex4;
  const PRE_LEAF_COUNT = 2;
  const MINI_MERKLE_DEPTH = 4;
  const MINI_MERKLE_WIDTH = 2 ** (MINI_MERKLE_DEPTH -1);

  const inputCommitments = [
    { value: value1, salt: salt1, commitment: cm1, index: cmIndex1 },
    { value: value2, salt: salt2, commitment: cm2, index: cmIndex2 },
  ];

  const outputCommitments = [
    { value: value3, salt: salt3 },
    { value: value4, salt: salt4 }
  ];

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

  async function mint(amount, _ownerPublicKey, _salt) {
    // zero the most significant bits, just in case variables weren't supplied like that
    const ownerPublicKey = utils.zeroMSBs(_ownerPublicKey);
    const salt = utils.zeroMSBs(_salt);


    let preimage_ = utils.concatenateThenHash(amount, ownerPublicKey);
    const commitment = utils.zeroMSBs(utils.concatenateThenHash(preimage_, salt));
    //console.log('cm:', commitment)

    const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(amount, commitment));
  }

  async function computePath(_myToken, myTokenIndex) {
    //console.group('Computing path on local machine...');
    const myToken = utils.strip0x(_myToken);
    //console.log('myToken', myToken);
    if (myToken.length !== INPUTS_HASHLENGTH * 2) {
      throw new Error(`tokens have incorrect length: ${myToken.length}, ${INPUTS_HASHLENGTH}`);
    }
    const myTokenTruncated = myToken.slice(-MERKLE_HASHLENGTH * 2);
    //console.log('myTokenTruncated', myTokenTruncated);
    //console.log(`myTokenIndex: ${myTokenIndex}`);
    const leafIndex = utils.getLeafIndexFromZCount(myTokenIndex);
    //console.log('leafIndex', leafIndex);

    // get the relevant token data from the contract
    let leaf = await zkdai.merkleTree(leafIndex);

    leaf = utils.strip0x(leaf);
    if (leaf === myTokenTruncated) {
      /*console.log(
        `Found a matching token commitment, ${leaf} in the on-chain Merkle Tree at the specified index ${leafIndex}`,
      );*/
    } else {
      throw new Error(
        `Failed to find the token commitment, ${myToken} in the on-chain Merkle Tree at the specified index ${leafIndex} (when truncated to ${myTokenTruncated}). Found ${leaf} at this index instead.`,
      );
    }

    // let p = []; // direct path
    let p0 = leafIndex; // index of path node in the merkle tree
    let nodeHash;
    // now we've verified the location of myToken in the Merkle Tree, we can extract the rest of the path and the sister-path:
    let s = []; // sister path
    let s0 = 0; // index of sister path node in the merkle tree
    let t0 = 0; // temp index for next highest path node in the merkle tree

    let sisterSide = '';

    for (let r = MERKLE_DEPTH - 1; r > 0; r -= 1) {
      if (p0 % 2 === 0) {
        // p even
        s0 = p0 - 1;
        t0 = Math.floor((p0 - 1) / 2);
        sisterSide = '0'; // if p is even then the sister will be on the left. Encode this as 0
      } else {
        // p odd
        s0 = p0 + 1;
        t0 = Math.floor(p0 / 2);
        sisterSide = '1'; // conversly if p is odd then the sister will be on the right. Encode this as 1
      }

      nodeHash = await zkdai.merkleTree(s0);

      s[r] = {
        merkleIndex: s0,
        nodeHashOld: nodeHash,
        sisterSide,
      };

      p0 = t0;
    }

    // separate case for the root:
    nodeHash = await zkdai.latestRoot(); //
    s[0] = {
      merkleIndex: 0,
      nodeHashOld: nodeHash,
    };

    // and strip the '0x' from s
    s = s.map(async el => {
      return {
        merkleIndex: el.merkleIndex,
        sisterSide: el.sisterSide,
        nodeHashOld: utils.strip0x(await el.nodeHashOld),
      };
    });

    s = await Promise.all(s);

    // Check the lengths of the hashes of the path and the sister-path - they should all be a set length (except the more secure root):

    // Handle the root separately:
    s[0].nodeHashOld = utils.strip0x(s[0].nodeHashOld);
    if (s[0].nodeHashOld.length !== 0 && s[0].nodeHashOld.length !== INPUTS_HASHLENGTH * 2)
      // the !==0 check is for the very first path calculation
      throw new Error(`path nodeHash has incorrect length: ${s[0].nodeHashOld}`);

    // Now the rest of the nodes:
    for (let i = 1; i < s.length; i += 1) {
      s[i].nodeHashOld = utils.strip0x(s[i].nodeHashOld);

      if (s[i].nodeHashOld.length !== 0 && s[i].nodeHashOld.length !== MERKLE_HASHLENGTH * 2)
        // the !==0 check is for the very first path calculation
        throw new Error(`sister path nodeHash has incorrect length: ${s[i].nodeHashOld}`);
    }

    // next work out the path from our token or coin to the root
    /*
    E.g.
                   ABCDEFG
          ABCD                EFGH
      AB        CD        EF        GH
    A    B    C    D    E    F    G    H

    If C were the token, then the X's mark the 'path' (the path is essentially a path of 'siblings'):

                   root
          ABCD                 X
       X        CD        EF        GH
    A    B    C    X    E    F    G    H
    */


    let sisterPositions = s
      .map(pos => pos.sisterSide)
      .join('')
      .padEnd(ZOKRATES_PACKING_SIZE, '0');
    //console.log('sisterPositions binary encoding:', sisterPositions);

    sisterPositions = utils.binToHex(sisterPositions);
    //console.log('sisterPositions hex encoding:', sisterPositions);
    //console.groupEnd();

    // create a hex encoding of all the sister positions
    const sisterPath = s.map(pos => utils.ensure0x(pos.nodeHashOld));

    return { path: sisterPath, positions: sisterPositions }; // return the sister-path of nodeHashes together with the encoding of which side each is on

  }

  async function computePath_miniMerkle(_myToken, myTokenIndex, merkleIndex) {

    let index;
    let merkleTree = [];
    if(myTokenIndex <= MINI_MERKLE_WIDTH) {
      index = myTokenIndex*1;
    } else {
      index = myTokenIndex*1 - (MINI_MERKLE_WIDTH - PRE_LEAF_COUNT) * merkleIndex;
    }

    let j = myTokenIndex - index
    let leaf;
    for(i = 0; i < MINI_MERKLE_WIDTH; i++){
      leaf = await zkdai.commitments(j+i);
      merkleTree[MINI_MERKLE_WIDTH - 1 + i] = leaf.slice(-MERKLE_HASHLENGTH * 2);
    }

    let latestMerkleIndex = new BN(await zkdai.merkleIndex(),10);
    // let p = []; // direct path
    let p0 = MINI_MERKLE_WIDTH - 1 + index; // index of path node in the merkle tree

    let nodeHash;
    // now we've verified the location of myToken in the Merkle Tree, we can extract the rest of the path and the sister-path:
    let s = []; // sister path
    let s0 = 0; // index of sister path node in the merkle tree
    let t0 = 0; // temp index for next highest path node in the merkle tree

    let sisterSide = '';
    //console.log("latest Merkle index", latestMerkleIndex.toString());
    //console.log("Merkle index", merkleIndex);
    if(latestMerkleIndex == merkleIndex){

      for (let r = MINI_MERKLE_DEPTH - 1; r > 0; r -= 1) {
        if (p0 % 2 === 0) {
          // p even
          s0 = p0 - 1;
          t0 = Math.floor((p0 - 1) / 2);
          sisterSide = '0'; // if p is even then the sister will be on the left. Encode this as 0
        } else {
          // p odd
          s0 = p0 + 1;
          t0 = Math.floor(p0 / 2);
          sisterSide = '1'; // conversly if p is odd then the sister will be on the right. Encode this as 1
        }

        nodeHash = await zkdai.merkleTree(s0);
        //console.log('merkleTree [%d] = %s', s0,nodeHash);

        s[r] = {
          merkleIndex: s0,
          nodeHashOld: nodeHash,
          sisterSide,
        };

        p0 = t0;
      }

    } else {
      for (let r = MINI_MERKLE_DEPTH - 1; r > 0; r -= 1) {
        for(let t = 2**r - 1; t < 2**r - 1 + 2**r; t += 2){
            const pair = [merkleTree[t], merkleTree[t+1]];
            hash256 = utils.concatenateThenHash(...pair);
            merkleTree[(t-1)/2] = hash256.slice(-MERKLE_HASHLENGTH * 2);
        }
      }

      for (let r = MINI_MERKLE_DEPTH - 1; r > 0; r -= 1) {
        if (p0 % 2 === 0) {
          // p even
          s0 = p0 - 1;
          t0 = Math.floor((p0 - 1) / 2);
          sisterSide = '0'; // if p is even then the sister will be on the left. Encode this as 0
        } else {
          // p odd
          s0 = p0 + 1;
          t0 = Math.floor(p0 / 2);
          sisterSide = '1'; // conversly if p is odd then the sister will be on the right. Encode this as 1
        }

        nodeHash = merkleTree[s0];

        s[r] = {
          merkleIndex: s0,
          nodeHashOld: nodeHash,
          sisterSide,
        };

        p0 = t0;
      }
    }

    // separate case for the root:
    nodeHash = await zkdai.roots(merkleIndex); //
    s[0] = {
      merkleIndex: 0,
      nodeHashOld: nodeHash,
    };

    // and strip the '0x' from s
    s = s.map(async el => {
      return {
        merkleIndex: el.merkleIndex,
        sisterSide: el.sisterSide,
        nodeHashOld: utils.strip0x(await el.nodeHashOld),
      };
    });

    s = await Promise.all(s);

    // Handle the root separately:
    s[0].nodeHashOld = utils.strip0x(s[0].nodeHashOld);
    if (s[0].nodeHashOld.length !== 0 && s[0].nodeHashOld.length !== INPUTS_HASHLENGTH * 2)
      // the !==0 check is for the very first path calculation
      throw new Error(`path nodeHash has incorrect length: ${s[0].nodeHashOld}`);

    // Now the rest of the nodes:
    for (let i = 1; i < s.length; i += 1) {
      s[i].nodeHashOld = utils.strip0x(s[i].nodeHashOld);

      if (s[i].nodeHashOld.length !== 0 && s[i].nodeHashOld.length !== MERKLE_HASHLENGTH * 2)
        // the !==0 check is for the very first path calculation
        throw new Error(`sister path nodeHash has incorrect length: ${s[i].nodeHashOld}`);
    }

    let sisterPositions = s
      .map(pos => pos.sisterSide)
      .join('')
      .padEnd(ZOKRATES_PACKING_SIZE, '0');

    sisterPositions = utils.binToHex(sisterPositions);

    // create a hex encoding of all the sister positions
    const sisterPath = s.map(pos => utils.ensure0x(pos.nodeHashOld));

    return { path: sisterPath, positions: sisterPositions }; // return the sister-path of nodeHashes together with the encoding of which side each is on

  }

  function checkRoot4(commitment, path, root) {

    const truncatedCommitment = commitment.slice(-MERKLE_HASHLENGTH * 2); // truncate to the desired 216 bits for Merkle Path computations
    const order = utils.hexToBin(path.positions);

    let hash216 = truncatedCommitment;
    let hash256;

    for (let r = MINI_MERKLE_DEPTH - 1; r > 0; r -= 1) {
      const pair = [hash216, path.path[r]];
      const orderedPair = orderBeforeConcatenation(order[r - 1], pair);
      hash256 = utils.concatenateThenHash(...orderedPair);

      hash216 = `0x${hash256.slice(-MERKLE_HASHLENGTH * 2)}`;
    }

    if (root !== hash256 && root !== utils.zeroMSBs(hash256)) {
      throw new Error(
        `Root ${root} cannot be recalculated from the path and commitment ${commitment}. An attempt to recalculate gives ${hash256} or ${hash216} as the root.`,
      );
    } else {
      /*console.log(
        '\nRoot successfully reconciled from first principles using the commitment and its sister-path.',
      );*/
    }
  }


  /*
  it('Create and LZKP',async function(){
    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    //const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1);
    console.log(mint1.logs);
    cmIndex1 = mint1.logs[1].args.commitment_index.toString();
    merkleIndex1 = mint1.logs[1].args.merkle_index.toString();

    await dai.approve(zkdai.address, parseInt(value2,16));
    const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    console.log(mint2.logs);
    cmIndex2 = mint2.logs[1].args.commitment_index.toString();
    merkleIndex2 = mint2.logs[1].args.merkle_index.toString();

    //===============Pour====================//

    const root = await zkdai.latestRoot();
    const root1 = await zkdai.roots(merkleIndex1);
    const root2 = await zkdai.roots(merkleIndex2);
    //console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));
    nullifier2 = utils.zeroMSBs(utils.concatenateThenHash(salt2, sk2));

    cm3_seed = utils.concatenateThenHash(dvalue, pk3);
    cm3 = utils.zeroMSBs(utils.concatenateThenHash(cm3_seed, salt3));

    cm4_seed = utils.concatenateThenHash(dvalue, pk4);
    cm4 = utils.zeroMSBs(utils.concatenateThenHash(cm4_seed, salt4));

    preimage = utils.concatenateThenHash(value5, pk5);
    cm5 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt5));

    //console.log("leafIndex1: ", mint1.logs[2].args.leafIndex.toString());
    //console.log("leafIndex2: ", mint2.logs[2].args.leafIndex.toString());
    /// it needs to be implemented in smart contract

    const path1 = await computePath_miniMerkle(
      cm1,
      cmIndex1,
      merkleIndex1,
    );

    const path2 = await computePath_miniMerkle(
      cm2,
      cmIndex2,
      merkleIndex2,
    );

    checkRoot4(cm1, path1, root1);
    checkRoot4(cm2, path2, root2);


    const publicInputHash = utils.concatenateThenHash(root1, nullifier1, nullifier2, cm5);

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    const root1_ = utils.hexToFieldPreserve(root1.toString(16),128,2,1); //2
    const root2_ = utils.hexToFieldPreserve(root2.toString(16),128,2,1); //2
    let cm3_seed_ = utils.hexToFieldPreserve(cm3_seed.toString(16), 128,2,1); //2
    let cm4_seed_ = utils.hexToFieldPreserve(cm4_seed.toString(16), 128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let nullifier2_ = utils.hexToFieldPreserve(nullifier2.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1
    let value2_ = utils.hexToFieldPreserve(value2.toString(16),128,1,1); //1
    let sk2_ = utils.hexToFieldPreserve(sk2.toString(16),128,2,1); //2
    let salt2_ = utils.hexToFieldPreserve(salt2.toString(16),128,2,1); //2
    const path2_ =  path2.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions2_ = utils.hexToFieldPreserve(path2.positions, 128, 1, 1); //1
    let value3_ = utils.hexToFieldPreserve(value3.toString(16),128,1,1); //1
    let pk3_ = utils.hexToFieldPreserve(pk3.toString(16),128,2,1); //2
    let salt3_ = utils.hexToFieldPreserve(salt3.toString(16),128,2,1); //2
    let value4_ = utils.hexToFieldPreserve(value4.toString(16),128,1,1); //1
    let pk4_ = utils.hexToFieldPreserve(pk4.toString(16),128,2,1); //2
    let salt4_ = utils.hexToFieldPreserve(salt4.toString(16),128,2,1); //2

    let mpk_address_ = utils.hexToFieldPreserve(mpk_address.toString(16),128,2,1);
    let depositNum_ = utils.hexToFieldPreserve(depositNum.toString(16),128,1,1);
    let dvalue_ = utils.hexToFieldPreserve(dvalue.toString(16),128,1,1);

    let value5_ = utils.hexToFieldPreserve(value5.toString(16),128,1,1); //1
    let pk5_ = utils.hexToFieldPreserve(pk5.toString(16),128,2,1); //2
    let salt5_ = utils.hexToFieldPreserve(salt5.toString(16),128,2,1); //2
    let cm5_ = utils.hexToFieldPreserve(cm5.toString(16), 128,2,1);;

    let params = [publicInputHash_, root1_, root2_, cm3_seed_, cm4_seed_, cm5_, mpk_address_, depositNum_, dvalue_, nullifier1_, nullifier2_, salt3_, salt4_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, value2_, sk2_, salt2_, path2_.slice(1), positions2_, pk3_, pk4_, value5_, pk5_, salt5_];

    printZokratesCommand(params);
    //const pour = await zkdai.lzkp(lzkp_proof.a, lzkp_proof.b, lzkp_proof.c, lzkp_inputs, merkleIndex1, merkleIndex2, root1, root2, nullifier1, nullifier2, cm3_seed, cm4_seed, cm5, mpk, depositNum, dvalue, salt3, salt4);

    const lzkp = await zkdai.lzkp(lzkp_proof.a, lzkp_proof.b, lzkp_proof.c, lzkp_inputs, merkleIndex1, merkleIndex2, root1, root2, nullifier1, nullifier2, cm5, mpk_address);
    console.log(lzkp.logs);


    let sh = [];
    let rh = [];

    for(let i=0; i<depositNum_; i++){
      sh[i] = utils.zeroMSBs(utils.concatenateThenHash(cm3_seed, new BN(salt3.slice(2),16).addn(i).toString(16).padStart(64,'0')));
      rh[i] = utils.zeroMSBs(utils.concatenateThenHash(cm4_seed, new BN(salt4.slice(2),16).addn(i).toString(16).padStart(64,'0')));
      console.log("sh[%d]:%s",i, sh[i]);
      console.log("rh[%d]:%s",i, rh[i]);
    }
    let poolId = lzkp.logs[2].args.poolId;
    let mpkAddress = lzkp.logs[2].args.mpkAddress;
    console.log('mpkAddress:',mpkAddress);

    let num = 10;
    var msg = poolId+num;
    let flatSig = await wallet_mpk.signMessage(msg);
    // For Solidity, we need the expanded-format of a signature
    let sig = ethers.utils.splitSignature(flatSig);
    // Call the verifyString function
    let signedTx = await zkdai.commit_signedTx(msg, sig.v, sig.r, sig.s);
    console.log(signedTx.logs);

  })*/

  /*
  it('Create and pour4', async function() {

    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    //const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1);
    console.log(mint1.logs);
    cmIndex1 = mint1.logs[1].args.commitment_index.toString();
    merkleIndex1 = mint1.logs[1].args.merkle_index.toString();

    await dai.approve(zkdai.address, parseInt(value2,16));
    const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    //console.log(mint2.logs);
    cmIndex2 = mint2.logs[1].args.commitment_index.toString();
    merkleIndex2 = mint2.logs[1].args.merkle_index.toString();

    //===============Pour====================//

    const root = await zkdai.latestRoot();
    const root1 = await zkdai.roots(merkleIndex1);
    const root2 = await zkdai.roots(merkleIndex2);
    //console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));
    nullifier2 = utils.zeroMSBs(utils.concatenateThenHash(salt2, sk2));

    preimage = utils.concatenateThenHash(value3, pk3);
    cm3 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt3));

    preimage = utils.concatenateThenHash(value4, pk4);
    cm4 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt4));

    //console.log("leafIndex1: ", mint1.logs[2].args.leafIndex.toString());
    //console.log("leafIndex2: ", mint2.logs[2].args.leafIndex.toString());
    /// it needs to be implemented in smart contract

    const path1 = await computePath_miniMerkle(
      cm1,
      cmIndex1,
      merkleIndex1,
    );

    const path2 = await computePath_miniMerkle(
      cm2,
      cmIndex2,
      merkleIndex2,
    );

    checkRoot4(cm1, path1, root1);
    checkRoot4(cm2, path2, root2);
    console.log('root1', root1);
    console.log('root1', root1.length);
    console.log('root1', root1.slice(1));
    console.log('root1', root1.slice(2));
    console.log('root1', root1.slice(3));
    console.log('root1', root1.slice(2,34));
    console.log('root1', root1.slice(2,34).length);
    console.log('root1', root1.slice(34,66));
    console.log('root1', root2.slice(0,2) +root2.slice(34,66));

    const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(root1.slice(0,34), root2.slice(0,2) +root2.slice(34,66), nullifier1, nullifier2, cm3, cm4));

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    const root1_ = utils.hexToFieldPreserve(root1.toString(16),128,2,1); //2
    const root2_ = utils.hexToFieldPreserve(root2.toString(16),128,2,1); //2
    let cm3_ = utils.hexToFieldPreserve(cm3.toString(16), 128,2,1); //2
    let cm4_ = utils.hexToFieldPreserve(cm4.toString(16), 128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let nullifier2_ = utils.hexToFieldPreserve(nullifier2.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1
    let value2_ = utils.hexToFieldPreserve(value2.toString(16),128,1,1); //1
    let sk2_ = utils.hexToFieldPreserve(sk2.toString(16),128,2,1); //2
    let salt2_ = utils.hexToFieldPreserve(salt2.toString(16),128,2,1); //2
    const path2_ =  path2.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions2_ = utils.hexToFieldPreserve(path2.positions, 128, 1, 1); //1
    let value3_ = utils.hexToFieldPreserve(value3.toString(16),128,1,1); //1
    let pk3_ = utils.hexToFieldPreserve(pk3.toString(16),128,2,1); //2
    let salt3_ = utils.hexToFieldPreserve(salt3.toString(16),128,2,1); //2
    let value4_ = utils.hexToFieldPreserve(value4.toString(16),128,1,1); //1
    let pk4_ = utils.hexToFieldPreserve(pk4.toString(16),128,2,1); //2
    let salt4_ = utils.hexToFieldPreserve(salt4.toString(16),128,2,1); //2

    let params = [publicInputHash_, root1_, root2_, cm3_, cm4_, nullifier1_, nullifier2_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, value2_, sk2_, salt2_, path2_.slice(1), positions2_, value3_, pk3_, salt3_, value4_, pk4_, salt4_];

    printZokratesCommand(params);

    const pour = await zkdai.pour_miniMerkle(pour4_proof.a, pour4_proof.b, pour4_proof.c, pour4_inputs, merkleIndex1, merkleIndex2, root1, root2, nullifier1, nullifier2, cm3, cm4);
    console.log(pour.logs);
    //cmIndex3 = pour.logs[1].args.commitment_index.toString();
    //cmIndex4 = pour.logs[1].args.commitment_index.toString();

  })*/
  it('Gas estimation for Mint4 and Burn4 (20 iteration)', async function() {

    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    await dai.approve(zkdai.address, parseInt(value1,16));
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});

    cmIndex1 = mint1.logs[1].args.commitment_index.toString();
    merkleIndex1 = mint1.logs[1].args.merkle_index.toString();

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));


    for(let i =0; i<20; i++){
    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
      await dai.approve(zkdai.address, parseInt(value1,16));
      cm_temp = utils.zeroMSBs(utils.concatenateThenHash(cm1, new BN(salt1.slice(2),16).addn(i).toString(16).padStart(64,'0')));
      const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm_temp);

    }

    //////////////
    const root1 = await zkdai.roots(merkleIndex1);
    //console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));

    const path1 = await computePath_miniMerkle(
      cm1,
      cmIndex1,
      merkleIndex1,
    );

    const payTo = "0x06644cDeB4899a5f8f5f655aFffAfB4F0625B304";
    const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(root, nullifier1, value1, payTo));

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    let payTo_ = utils.hexToFieldPreserve(payTo.toString(16),128,2,1); //2
    const root_ = utils.hexToFieldPreserve(root1.toString(16),128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1

    let params = [publicInputHash_, payTo_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, nullifier1_, root_];

    for(let i =0; i<20; i++){
    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
      const burn = await zkdai.burn_mini(burn4_proof.a, burn4_proof.b, burn4_proof.c, burn4_inputs, merkleIndex1, root1, nullifier1, value1, payTo, {
        gas: 5000000,
        gasPrice: 10,
      });
    }


  })
  /*it('Create and pour4 (20 iterations)', async function() {
    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    //const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1);
    console.log(mint1.logs);
    cmIndex1 = mint1.logs[1].args.commitment_index.toString();
    merkleIndex1 = mint1.logs[1].args.merkle_index.toString();

    await dai.approve(zkdai.address, parseInt(value2,16));
    const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    console.log(mint2.logs);
    cmIndex2 = mint2.logs[1].args.commitment_index.toString();
    merkleIndex2 = mint2.logs[1].args.merkle_index.toString();

    for(let i =0; i<20; i++){
    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
      await dai.approve(zkdai.address, parseInt(value1,16));
      cm_temp = utils.zeroMSBs(utils.concatenateThenHash(cm1, new BN(salt1.slice(2),16).addn(i).toString(16).padStart(64,'0')));
      const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm_temp);
    }

    //===============Pour====================//

    const root = await zkdai.latestRoot();
    const root1 = await zkdai.roots(merkleIndex1);
    const root2 = await zkdai.roots(merkleIndex2);
    //console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));
    nullifier2 = utils.zeroMSBs(utils.concatenateThenHash(salt2, sk2));

    preimage = utils.concatenateThenHash(value3, pk3);
    cm3 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt3));

    preimage = utils.concatenateThenHash(value4, pk4);
    cm4 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt4));

    //console.log("leafIndex1: ", mint1.logs[2].args.leafIndex.toString());
    //console.log("leafIndex2: ", mint2.logs[2].args.leafIndex.toString());
    /// it needs to be implemented in smart contract

    const path1 = await computePath_miniMerkle(
      cm1,
      cmIndex1,
      merkleIndex1,
    );

    const path2 = await computePath_miniMerkle(
      cm2,
      cmIndex2,
      merkleIndex2,
    );

    console.log('root1', root1);
    console.log('root1', root1.length);
    console.log('root1', root1.slice(1));
    console.log('root1', root1.slice(2));
    console.log('root1', root1.slice(3));
    console.log('root1', root1.slice(2,34));
    console.log('root1', root1.slice(2,34).length);
    console.log('root1', root1.slice(34,66));
    console.log('root1', root2.slice(0,2) +root2.slice(34,66));

    const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(root1.slice(0,34), root2.slice(0,2) +root2.slice(34,66), nullifier1, nullifier2, cm3, cm4));

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    const root1_ = utils.hexToFieldPreserve(root1.toString(16),128,2,1); //2
    const root2_ = utils.hexToFieldPreserve(root2.toString(16),128,2,1); //2
    let cm3_ = utils.hexToFieldPreserve(cm3.toString(16), 128,2,1); //2
    let cm4_ = utils.hexToFieldPreserve(cm4.toString(16), 128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let nullifier2_ = utils.hexToFieldPreserve(nullifier2.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1
    let value2_ = utils.hexToFieldPreserve(value2.toString(16),128,1,1); //1
    let sk2_ = utils.hexToFieldPreserve(sk2.toString(16),128,2,1); //2
    let salt2_ = utils.hexToFieldPreserve(salt2.toString(16),128,2,1); //2
    const path2_ =  path2.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions2_ = utils.hexToFieldPreserve(path2.positions, 128, 1, 1); //1
    let value3_ = utils.hexToFieldPreserve(value3.toString(16),128,1,1); //1
    let pk3_ = utils.hexToFieldPreserve(pk3.toString(16),128,2,1); //2
    let salt3_ = utils.hexToFieldPreserve(salt3.toString(16),128,2,1); //2
    let value4_ = utils.hexToFieldPreserve(value4.toString(16),128,1,1); //1
    let pk4_ = utils.hexToFieldPreserve(pk4.toString(16),128,2,1); //2
    let salt4_ = utils.hexToFieldPreserve(salt4.toString(16),128,2,1); //2

    let params = [publicInputHash_, root1_, root2_, cm3_, cm4_, nullifier1_, nullifier2_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, value2_, sk2_, salt2_, path2_.slice(1), positions2_, value3_, pk3_, salt3_, value4_, pk4_, salt4_];

    printZokratesCommand(params);

    for (let i=0; i<20; i++){
        const pour = await zkdai.pour_miniMerkle(pour4_proof.a, pour4_proof.b, pour4_proof.c, pour4_inputs, merkleIndex1, merkleIndex2, root1, root2, nullifier1, nullifier2, cm3, cm4);
    }


  })*/

  /*it('Gas consumption of Transfer and Burn (20 iterations)', async function() {

    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    //const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1);
    //console.log(mint1.logs);
    cmIndex1 = mint1.logs[1].args.commitment_index.toString();

    await dai.approve(zkdai.address, parseInt(value2,16));
    const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    //console.log(mint2.logs);
    cmIndex2 = mint2.logs[1].args.commitment_index.toString();

    for(let i =0; i<20; i++){
    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
      await dai.approve(zkdai.address, parseInt(value1,16));
      cm_temp = utils.zeroMSBs(utils.concatenateThenHash(cm1, new BN(salt1.slice(2),16).addn(i).toString(16).padStart(64,'0')));
      const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm_temp);
    }
    //===============Pour====================//
    const root = await zkdai.latestRoot();
    //console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));
    nullifier2 = utils.zeroMSBs(utils.concatenateThenHash(salt2, sk2));

    preimage = utils.concatenateThenHash(value3, pk3);
    cm3 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt3));

    preimage = utils.concatenateThenHash(value4, pk4);
    cm4 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt4));

    //console.log("leafIndex1: ", mint1.logs[2].args.leafIndex.toString());
    //console.log("leafIndex2: ", mint2.logs[2].args.leafIndex.toString());
    /// it needs to be implemented in smart contract
    const path1 = await computePath(
      cm1,
      cmIndex1,
    );

    const path2 = await computePath(
      cm2,
      cmIndex2,
    );

    checkRoot(cm1, path1, root);
    checkRoot(cm2, path2, root);

    const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(root, nullifier1, nullifier2, cm3, cm4));

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    const root_ = utils.hexToFieldPreserve(root.toString(16),128,2,1); //2
    let cm3_ = utils.hexToFieldPreserve(cm3.toString(16), 128,2,1); //2
    let cm4_ = utils.hexToFieldPreserve(cm4.toString(16), 128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let nullifier2_ = utils.hexToFieldPreserve(nullifier2.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1
    let value2_ = utils.hexToFieldPreserve(value2.toString(16),128,1,1); //1
    let sk2_ = utils.hexToFieldPreserve(sk2.toString(16),128,2,1); //2
    let salt2_ = utils.hexToFieldPreserve(salt2.toString(16),128,2,1); //2
    const path2_ =  path2.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions2_ = utils.hexToFieldPreserve(path2.positions, 128, 1, 1); //1
    let value3_ = utils.hexToFieldPreserve(value3.toString(16),128,1,1); //1
    let pk3_ = utils.hexToFieldPreserve(pk3.toString(16),128,2,1); //2
    let salt3_ = utils.hexToFieldPreserve(salt3.toString(16),128,2,1); //2
    let value4_ = utils.hexToFieldPreserve(value4.toString(16),128,1,1); //1
    let pk4_ = utils.hexToFieldPreserve(pk4.toString(16),128,2,1); //2
    let salt4_ = utils.hexToFieldPreserve(salt4.toString(16),128,2,1); //2

    let params = [publicInputHash_, root_, cm3_, cm4_, nullifier1_, nullifier2_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, value2_, sk2_, salt2_, path2_.slice(1), positions2_, value3_, pk3_, salt3_, value4_, pk4_, salt4_];

    //printZokratesCommand(params);
    const payTo = "0x06644cDeB4899a5f8f5f655aFffAfB4F0625B304";
    for (let i=0; i<20; i++){
        const pour = await zkdai.spend(pour_proof.a, pour_proof.b, pour_proof.c, pour_inputs, root, nullifier1, nullifier2, cm3, cm4);
        const burn = await zkdai.burn(burn_proof.a, burn_proof.b, burn_proof.c, burn_inputs, root, nullifier1, value1, payTo, {
          gas: 5000000,
          gasPrice: 10,
        });
    }
    //const pour = await zkdai.spend(pour_proof.a, pour_proof.b, pour_proof.c, pour_inputs, root, nullifier1, nullifier2, cm3, cm4);
    //console.log(pour.logs);
    //cmIndex3 = pour.logs[1].args.commitment_index.toString();
    //cmIndex4 = pour.logs[1].args.commitment_index.toString();

  })*/

  /*it('Create and LZKP (20 iterations)',async function(){
    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    //const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1);
    console.log(mint1.logs);
    cmIndex1 = mint1.logs[1].args.commitment_index.toString();
    merkleIndex1 = mint1.logs[1].args.merkle_index.toString();

    await dai.approve(zkdai.address, parseInt(value2,16));
    const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    console.log(mint2.logs);
    cmIndex2 = mint2.logs[1].args.commitment_index.toString();
    merkleIndex2 = mint2.logs[1].args.merkle_index.toString();

    for(let i =0; i<20; i++){
    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
      await dai.approve(zkdai.address, parseInt(value1,16));
      cm_temp = utils.zeroMSBs(utils.concatenateThenHash(cm1, new BN(salt1.slice(2),16).addn(i).toString(16).padStart(64,'0')));
      const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm_temp);
    }

    //===============Pour====================//

    //const root = await zkdai.latestRoot();
    const root1 = await zkdai.roots(merkleIndex1);
    const root2 = await zkdai.roots(merkleIndex2);
    //console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));
    nullifier2 = utils.zeroMSBs(utils.concatenateThenHash(salt2, sk2));

    cm3_seed = utils.concatenateThenHash(dvalue, pk3);
    cm3 = utils.zeroMSBs(utils.concatenateThenHash(cm3_seed, salt3));

    cm4_seed = utils.concatenateThenHash(dvalue, pk4);
    cm4 = utils.zeroMSBs(utils.concatenateThenHash(cm4_seed, salt4));

    preimage = utils.concatenateThenHash(value5, pk5);
    cm5 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt5));

    //console.log("leafIndex1: ", mint1.logs[2].args.leafIndex.toString());
    //console.log("leafIndex2: ", mint2.logs[2].args.leafIndex.toString());
    /// it needs to be implemented in smart contract

    const path1 = await computePath_miniMerkle(
      cm1,
      cmIndex1,
      merkleIndex1,
    );

    const path2 = await computePath_miniMerkle(
      cm2,
      cmIndex2,
      merkleIndex2,
    );

    //checkRoot4(cm1, path1, root1);
    //checkRoot4(cm2, path2, root2);


    const publicInputHash = utils.concatenateThenHash(root1, nullifier1, nullifier2, cm5);

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    const root1_ = utils.hexToFieldPreserve(root1.toString(16),128,2,1); //2
    const root2_ = utils.hexToFieldPreserve(root2.toString(16),128,2,1); //2
    let cm3_seed_ = utils.hexToFieldPreserve(cm3_seed.toString(16), 128,2,1); //2
    let cm4_seed_ = utils.hexToFieldPreserve(cm4_seed.toString(16), 128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let nullifier2_ = utils.hexToFieldPreserve(nullifier2.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1
    let value2_ = utils.hexToFieldPreserve(value2.toString(16),128,1,1); //1
    let sk2_ = utils.hexToFieldPreserve(sk2.toString(16),128,2,1); //2
    let salt2_ = utils.hexToFieldPreserve(salt2.toString(16),128,2,1); //2
    const path2_ =  path2.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions2_ = utils.hexToFieldPreserve(path2.positions, 128, 1, 1); //1
    let value3_ = utils.hexToFieldPreserve(value3.toString(16),128,1,1); //1
    let pk3_ = utils.hexToFieldPreserve(pk3.toString(16),128,2,1); //2
    let salt3_ = utils.hexToFieldPreserve(salt3.toString(16),128,2,1); //2
    let value4_ = utils.hexToFieldPreserve(value4.toString(16),128,1,1); //1
    let pk4_ = utils.hexToFieldPreserve(pk4.toString(16),128,2,1); //2
    let salt4_ = utils.hexToFieldPreserve(salt4.toString(16),128,2,1); //2

    let mpk_address_ = utils.hexToFieldPreserve(mpk_address.toString(16),128,2,1);
    let depositNum_ = utils.hexToFieldPreserve(depositNum.toString(16),128,1,1);
    let dvalue_ = utils.hexToFieldPreserve(dvalue.toString(16),128,1,1);

    let value5_ = utils.hexToFieldPreserve(value5.toString(16),128,1,1); //1
    let pk5_ = utils.hexToFieldPreserve(pk5.toString(16),128,2,1); //2
    let salt5_ = utils.hexToFieldPreserve(salt5.toString(16),128,2,1); //2
    let cm5_ = utils.hexToFieldPreserve(cm5.toString(16), 128,2,1);;

    let params = [publicInputHash_, root1_, root2_, cm3_seed_, cm4_seed_, cm5_, mpk_address_, depositNum_, dvalue_, nullifier1_, nullifier2_, salt3_, salt4_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, value2_, sk2_, salt2_, path2_.slice(1), positions2_, pk3_, pk4_, value5_, pk5_, salt5_];

    //printZokratesCommand(params);
    //const pour = await zkdai.lzkp(lzkp_proof.a, lzkp_proof.b, lzkp_proof.c, lzkp_inputs, merkleIndex1, merkleIndex2, root1, root2, nullifier1, nullifier2, cm3_seed, cm4_seed, cm5, mpk, depositNum, dvalue, salt3, salt4);

    let num = 90;
    for (let i=0; i<20; i++){
      //const lzkp = await zkdai.lzkp(lzkp_proof.a, lzkp_proof.b, lzkp_proof.c, lzkp_inputs, merkleIndex1, merkleIndex2, root1, root2, nullifier1, nullifier2, cm5, mpk_address, new BN(depositNum.slice(2),16).addn(0).toString(16).padStart(32,'0'));
      const lzkp = await zkdai.lzkp(lzkp_proof.a, lzkp_proof.b, lzkp_proof.c, lzkp_inputs, merkleIndex1, merkleIndex2, root1, root2, nullifier1, nullifier2, cm5, mpk_address, num);
      //console.log(lzkp.logs);
      let poolId = lzkp.logs[2].args.poolId;
      var msg = poolId+num;
      let flatSig = await wallet_mpk.signMessage(msg);
      // For Solidity, we need the expanded-format of a signature
      let sig = ethers.utils.splitSignature(flatSig);
      // Call the verifyString function
      let signedTx = await zkdai.commit_signedTx(msg, sig.v, sig.r, sig.s);
      console.log(signedTx.logs);
    }

  })*/

  /*
  it('Create and burn_4 a note', async function() {

    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1);
    cmIndex1 = mint1.logs[1].args.commitment_index.toString();
    merkleIndex1 = mint1.logs[1].args.merkle_index.toString();

    //await dai.approve(zkdai.address, parseInt(value2,16));
    //const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    //console.log(mint2.logs);
    //cmIndex2 = mint2.logs[1].args.commitment_index.toString();

    //console.log("cmIndex2: ", cmIndex2.toString());

    //===============Burn====================//
    const root1 = await zkdai.roots(merkleIndex1);
    //console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));

    const path1 = await computePath_miniMerkle(
      cm1,
      cmIndex1,
      merkleIndex1,
    );


    checkRoot4(cm1, path1, root1);
    //checkRoot(cm2, path2, root);
    const payTo = "0x06644cDeB4899a5f8f5f655aFffAfB4F0625B304";
    const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(root, nullifier1, value1, payTo));

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    let payTo_ = utils.hexToFieldPreserve(payTo.toString(16),128,2,1); //2
    const root_ = utils.hexToFieldPreserve(root1.toString(16),128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1

    let params = [publicInputHash_, payTo_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, nullifier1_, root_];

    printZokratesCommand(params);

    const burn = await zkdai.burn_mini(burn4_proof.a, burn4_proof.b, burn4_proof.c, burn4_inputs, merkleIndex1, root1, nullifier1, value1, payTo, {
      gas: 5000000,
      gasPrice: 10,
    });
    console.log(burn.logs);
    //console.log(pour.logs);
    //cmIndex3 = pour.logs[1].args.commitment_index.toString();
    //cmIndex4 = pour.logs[1].args.commitment_index.toString();

  })*/

  /*
  it('Create and burn a note', async function() {

    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    //const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1,{
      gas: 5000000,
      gasPrice: 10,
    });
    //console.log(mint1.logs);
    cmIndex1 = mint1.logs[1].args.commitment_index.toString();

    //await dai.approve(zkdai.address, parseInt(value2,16));
    //const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    //console.log(mint2.logs);
    //cmIndex2 = mint2.logs[1].args.commitment_index.toString();

    //console.log("cmIndex2: ", cmIndex2.toString());

    //===============Burn====================//
    const root = await zkdai.latestRoot();
    console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));
    nullifier2 = utils.zeroMSBs(utils.concatenateThenHash(salt2, sk2));

    const path1 = await computePath(
      cm1,
      cmIndex1,
    );

    checkRoot(cm1, path1, root);
    //checkRoot(cm2, path2, root);
    const payTo = "0x06644cDeB4899a5f8f5f655aFffAfB4F0625B304";
    const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(root, nullifier1, value1, payTo));

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    let payTo_ = utils.hexToFieldPreserve(payTo.toString(16),128,2,1); //2
    const root_ = utils.hexToFieldPreserve(root.toString(16),128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1

    let params = [publicInputHash_, payTo_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, nullifier1_, root_];

    printZokratesCommand(params);

    const burn = await zkdai.burn(burn_proof.a, burn_proof.b, burn_proof.c, burn_inputs, root, nullifier1, value1, payTo, {
      gas: 5000000,
      gasPrice: 10,
    });
    console.log(burn.logs);
    //cmIndex3 = pour.logs[1].args.commitment_index.toString();
    //cmIndex4 = pour.logs[1].args.commitment_index.toString();

  })*/

  /*
  it('Create and Send a secret note', async function() {

    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    //const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1);
    //console.log(mint1.logs);
    cmIndex1 = mint1.logs[1].args.commitment_index.toString();

    await dai.approve(zkdai.address, parseInt(value2,16));
    const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    //console.log(mint2.logs);
    cmIndex2 = mint2.logs[1].args.commitment_index.toString();

    //console.log("cmIndex2: ", cmIndex2.toString());

    //===============Pour====================//
    const root = await zkdai.latestRoot();
    //console.log(`Merkle Root: ${root}`);

    nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));
    nullifier2 = utils.zeroMSBs(utils.concatenateThenHash(salt2, sk2));

    preimage = utils.concatenateThenHash(value3, pk3);
    cm3 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt3));

    preimage = utils.concatenateThenHash(value4, pk4);
    cm4 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt4));

    //console.log("leafIndex1: ", mint1.logs[2].args.leafIndex.toString());
    //console.log("leafIndex2: ", mint2.logs[2].args.leafIndex.toString());
    /// it needs to be implemented in smart contract
    const path1 = await computePath(
      cm1,
      cmIndex1,
    );

    const path2 = await computePath(
      cm2,
      cmIndex2,
    );

    checkRoot(cm1, path1, root);
    checkRoot(cm2, path2, root);

    const publicInputHash = utils.zeroMSBs(utils.concatenateThenHash(root, nullifier1, nullifier2, cm3, cm4));

    let publicInputHash_ = utils.hexToFieldPreserve(publicInputHash.toString(16),248,1,1); //1
    const root_ = utils.hexToFieldPreserve(root.toString(16),128,2,1); //2
    let cm3_ = utils.hexToFieldPreserve(cm3.toString(16), 128,2,1); //2
    let cm4_ = utils.hexToFieldPreserve(cm4.toString(16), 128,2,1); //2
    let nullifier1_ = utils.hexToFieldPreserve(nullifier1.toString(16), 128,2,1); //2
    let nullifier2_ = utils.hexToFieldPreserve(nullifier2.toString(16), 128,2,1); //2
    let value1_ = utils.hexToFieldPreserve(value1.toString(16),128,1,1); //1
    let sk1_ = utils.hexToFieldPreserve(sk1.toString(16),128,2,1); //2
    let salt1_ = utils.hexToFieldPreserve(salt1.toString(16),128,2,1); //2
    const path1_ =  path1.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions1_ = utils.hexToFieldPreserve(path1.positions, 128, 1, 1); //1
    let value2_ = utils.hexToFieldPreserve(value2.toString(16),128,1,1); //1
    let sk2_ = utils.hexToFieldPreserve(sk2.toString(16),128,2,1); //2
    let salt2_ = utils.hexToFieldPreserve(salt2.toString(16),128,2,1); //2
    const path2_ =  path2.path.map(el => utils.hexToFieldPreserve(el, MERKLE_HASHLENGTH * 8,1, 1)); //32
    const positions2_ = utils.hexToFieldPreserve(path2.positions, 128, 1, 1); //1
    let value3_ = utils.hexToFieldPreserve(value3.toString(16),128,1,1); //1
    let pk3_ = utils.hexToFieldPreserve(pk3.toString(16),128,2,1); //2
    let salt3_ = utils.hexToFieldPreserve(salt3.toString(16),128,2,1); //2
    let value4_ = utils.hexToFieldPreserve(value4.toString(16),128,1,1); //1
    let pk4_ = utils.hexToFieldPreserve(pk4.toString(16),128,2,1); //2
    let salt4_ = utils.hexToFieldPreserve(salt4.toString(16),128,2,1); //2

    let params = [publicInputHash_, root_, cm3_, cm4_, nullifier1_, nullifier2_, value1_, sk1_, salt1_, path1_.slice(1), positions1_, value2_, sk2_, salt2_, path2_.slice(1), positions2_, value3_, pk3_, salt3_, value4_, pk4_, salt4_];

    printZokratesCommand(params);

    //onst pour = await zkdai.spend(pour_proof.a, pour_proof.b, pour_proof.c, pour_inputs, root, nullifier1, nullifier2, cm3, cm4);
    //console.log(pour.logs);
    //cmIndex3 = pour.logs[1].args.commitment_index.toString();
    //cmIndex4 = pour.logs[1].args.commitment_index.toString();

  })*/

  /*
  it('Create and Pour', async function() {
    let preimage = utils.concatenateThenHash(value1, pk1);
    cm1 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt1));

    preimage = utils.concatenateThenHash(value2, pk2);
    cm2 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt2));

    //await dai.approve(zkdai.address, web3.utils.toBN(parseInt(50,16) * 10**18));
    await dai.approve(zkdai.address, parseInt(value1,16));

    //const mint = await zkdai.mint(mint_proof.a, mint_proof.b, mint_proof.c, mint_inputs, value1, cm1, {value:web3.utils.toBN(SCALING_FACTOR)});
    const mint1 = await zkdai.mint(mint_proof1.a, mint_proof1.b, mint_proof1.c, mint_inputs1, value1, cm1);
    console.log(mint1.logs);
    const cmIndex1 = mint1.logs[0].args.commitment_index;

    await dai.approve(zkdai.address, parseInt(value2,16));
    const mint2 = await zkdai.mint(mint_proof2.a, mint_proof2.b, mint_proof2.c, mint_inputs2, value2, cm2);
    console.log(mint2.logs);
    const cmIndex2 = mint2.logs[1].args.commitment_index;
    console.log("cmIndex2: ", cmIndex2.toString());

    const root = await zkdai.latestRoot();  // it needs to be implemented in smart contract
    console.log(`Merkle Root: ${root}`);

    const pk1 = utils.zeroMSBs(utils.hash(sk1));
    const pk2 = utils.zeroMSBs(utils.hash(sk2));
    const nullifier1 = utils.zeroMSBs(utils.concatenateThenHash(salt1, sk1));
    const nullifier2 = utils.zeroMSBs(utils.concatenateThenHash(salt2, sk2));

    preimage = utils.concatenateThenHash(value3, pk3);
    cm3 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt3));

    preimage = utils.concatenateThenHash(value4, pk4);
    cm4 = utils.zeroMSBs(utils.concatenateThenHash(preimage, salt4));

    /// it needs to be implemented in smart contract
    const path1 = await computePath(
      account,
      fTokenShieldInstance,
      inputCommitments[0].commitment,
      inputCommitments[0].index,
    );
    const path2 = await computePath(
      account,
      fTokenShieldInstance,
      inputCommitments[1].commitment,
      inputCommitments[1].index,
    );

    //const pour = await zkdai.pour(pour_proof.a, pour_proof.b, pour_proof.c, pour_inputs);
    //console.log(pour);
  })

  */

})

function assertEvent(event, type, ...args) {
  assert.equal(event.event, type);
  args.forEach((arg, i) => {
    assert.equal(event.args[i], arg);
  })
}



function checkRoot(commitment, path, root) {
  // define Merkle Constants:

  //console.log(`commitment:`, commitment);
  const truncatedCommitment = commitment.slice(-MERKLE_HASHLENGTH * 2); // truncate to the desired 216 bits for Merkle Path computations
  const order = utils.hexToBin(path.positions);
  // console.log(`root:`, root);

  let hash216 = truncatedCommitment;
  let hash256;

  for (let r = MERKLE_DEPTH - 1; r > 0; r -= 1) {
    const pair = [hash216, path.path[r]];
    const orderedPair = orderBeforeConcatenation(order[r - 1], pair);
    hash256 = utils.concatenateThenHash(...orderedPair);
    // keep the below comments for future debugging:
    // console.log(`hash pre-slice at row ${r - 1}:`, hash256);
    hash216 = `0x${hash256.slice(-MERKLE_HASHLENGTH * 2)}`;
    // console.log(`hash at row ${r - 1}:`, hash216);
  }

  if (root !== hash256 && root !== utils.zeroMSBs(hash256)) {
    throw new Error(
      `Root ${root} cannot be recalculated from the path and commitment ${commitment}. An attempt to recalculate gives ${hash256} or ${hash216} as the root.`,
    );
  } else {
    /*console.log(
      '\nRoot successfully reconciled from first principles using the commitment and its sister-path.',
    );*/
  }
}

function orderBeforeConcatenation(order, pair) {
  if (parseInt(order, 10) === 1) {
    return pair;
  }
  return pair.reverse();
}

function printZokratesCommand(params) {
  let cmd = 'zokrates compute-witness -a '
  params.forEach(p => {
    for(var i=0; i<p.length; i++){
        cmd += `${p[i]} `
    }
  })
  console.log(cmd);
}
