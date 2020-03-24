pragma solidity ^0.5.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./DepositBase.sol";
import "./MintNotes.sol";
import "./SpendNotes.sol";
import "./SignVerifier.sol";
import "./ZkDaiBase.sol";
import "./BurnMiniNotes.sol";
import "./DepositNotes.sol";
import "./Pour4.sol";

contract ZkDai is MintNotes, SpendNotes, DepositNotes, BurnMiniNotes, Pour4 {
//contract ZkDai {

  event Mint(uint256 amount, bytes32 commitment, uint256 commitment_index, uint256 merkle_index);
  event Deposit_NewNote(bytes32 commitment, uint256 commitment_index, uint256 merkle_index);
  event MPK(address Test_mpkAddress);
  event Transfer(bytes32 nullifier1, bytes32 nullifier2, bytes32 commitment3, uint256 commitment3_index, bytes32 commitment4, uint256 commitment4_index);
  event Pour_MiniMerkle(bytes32 nullifier1, bytes32 nullifier2, bytes32 commitment3, uint256 commitment3_index, uint256 merkle_index1, bytes32 commitment4, uint256 commitment4_index, uint256 merkle_index2);
  event Burn(uint256 amount, address payTo, bytes32 nullifier);
  event SimpleBatchTransfer(bytes32 nullifier, bytes32[] commitments, uint256 commitment_index);
  event MerkleTree(uint256 leafIndex, bytes27 leafnode);
  //Verifier_Registry public verifierRegistry; // the Verifier Registry contract
  //Verifier_Interface private verifier; // the verification smart contract
  //ERC20Interface private fToken; // the  ERC-20 token contract

  uint constant bitLength = 216; // the number of LSB that we use in a hash
  uint constant batchProofSize = 20; // the number of output commitments in the batch transfer proof
  uint constant merkleDepth = 4; //33
  uint constant merkleWidth = 2**(merkleDepth -1); //2^32
  uint constant out = 2**merkleDepth -1; // MerkleTree[out] will have zero value
  uint constant pre_leaf_count = 2; //The number of pre leaves for anonymization of mini Mekrle Tree

  uint256 constant bn128Prime = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

  mapping(bytes32 => bytes32) public nullifiers; // store nullifiers of spent commitments
  mapping(uint256 => bytes32) public commitments; // array holding the commitments.  Basically the bottom row of the merkle tree
  mapping(uint256 => bytes27) public merkleTree; // the entire Merkle Tree of nodes, with 0 being the root, and the latter 'half' of the merkleTree being the leaves. //only store tree root?
  mapping(uint256 => bytes32) public roots; // holds each root we've calculated so that we can pull the one relevant to the prover

  uint256 public merkleIndex;
  uint256 public leafCount; // remembers the number of commitments we hold
  bytes32 public latestRoot; // holds the index for the latest root so that the prover can provide it later and this contract can look up the relevant root

  modifier validStake(uint256 _stake)
  {
      require(_stake == stake, "Invalid stake amount");
      _;
  }

  constructor(uint256 _cooldown, uint256 _stake, address daiTokenAddress)
    public
  {
      cooldown = _cooldown;
      stake = _stake;
      dai = ERC20(daiTokenAddress);
  }


  function mint(
      uint256[2] calldata _a,
      uint256[2][2] calldata _b,
      uint256[2] calldata _c,
      uint256[5] calldata _input,
      uint128 _value,
      bytes32 _commitment
      )
    external
    payable
  {
      require(true == MintNotes.verify(_a, _b, _c, _input), "verification fail");

      // Check that the publicInputHash equals the hash of the 'public inputs':
      bytes32 publicInputHash = bytes32(_input[0]);
      bytes32 publicInputHashCheck = zeroMSBs(bytes32(sha256(abi.encodePacked(uint128(_value), _commitment)))); // Note that we force the _value to be left-padded with zeros to fill 128-bits, so as to match the padding in the hash calculation performed within the zokrates proof.
      //require(publicInputHashCheck == publicInputHash, "publicInputHash cannot be reconciled");
      require(
        dai.transferFrom(msg.sender, address(this), uint128(_value)),
        "daiToken transfer failed"
      );

      // update contract states
      //uint256 leafIndex = merkleWidth - 1 + leafCount; // specify the index of the commitment within the merkleTree
      //merkleTree[leafIndex] = bytes27(_commitment<<40); // add the commitment to the merkleTree

      commitments[leafCount] = _commitment; // add the commitment

      uint256 index;
      //uint256 merkleIndex;
      if(leafCount <= merkleWidth) {
        merkleIndex = 0; //root[merkleIndex] = latestRoot
        index = leafCount; // The index for leaf nodes of mini merkle tree
        // When there are leaf0 leaf1 leaf2 X leaf4, index of X is 3.
      } else {
        merkleIndex = (leafCount - pre_leaf_count) / (merkleWidth - pre_leaf_count);
        index = leafCount - (merkleWidth - pre_leaf_count) * merkleIndex;
      }
      uint256 leafIndex = merkleWidth - 1 + index;

      merkleTree[leafIndex] = bytes27(_commitment<<40);
      bytes32 root = updatePathToRoot(leafIndex); // recalculate the root of the merkleTree as it's now different

      //if(leafIndex = out -1)
      roots[merkleIndex] = root;
      latestRoot = root;

      emit Mint(_value, _commitment, leafCount++, merkleIndex);
      //emit MerkleTree(leafIndex,merkleTree[leafIndex]);
  }

  function register_cm(bytes32 _commitment) private returns (uint256){
      uint256 index;
      //uint256 merkleIndex;
      if(leafCount <= merkleWidth) {
        merkleIndex = 0; //root[merkleIndex] = latestRoot
        index = leafCount; // The index for leaf nodes of mini merkle tree
        // When there are leaf0 leaf1 leaf2 X leaf4, index of X is 3.
      } else {
        merkleIndex = (leafCount - pre_leaf_count) / (merkleWidth - pre_leaf_count);
        index = leafCount - (merkleWidth - pre_leaf_count) * merkleIndex;
      }
      uint256 leafIndex = merkleWidth - 1 + index;

      merkleTree[leafIndex] = bytes27(_commitment<<40); //add the commitment to the merkleTree
      bytes32 root = updatePathToRoot(leafIndex);
      roots[merkleIndex] = root; //and save the new root to the list of roots
      latestRoot = root;
      leafCount++;
      return merkleIndex;
  }

  function pour_miniMerkle(
      uint256[2] calldata _a,
      uint256[2][2] calldata _b,
      uint256[2] calldata _c,
      uint256[14] calldata _input,
      uint256 _merkleIndex1,
      uint256 _merkleIndex2,
      bytes32 _root1,
      bytes32 _root2,
      bytes32 _nullifier1,
      bytes32 _nullifier2,
      bytes32 _commitment3,
      bytes32 _commitment4)
    external
    payable
  {

      // verify the proof
      require( true == Pour4.verify(_a, _b, _c, _input), "verification fail");


      // Check that the publicInputHash equals the hash of the 'public inputs':
      bytes32 publicInputHash = bytes32(_input[0]);
      bytes16 _root1High = bytes16(_root1);
      bytes16 _root2Low = bytes16(_root2<<128);
      bytes32 publicInputHashCheck = zeroMSBs(bytes32(sha256(abi.encodePacked(_root1High, _root2Low, _nullifier1, _nullifier2, _commitment3, _commitment4))));
      require(publicInputHashCheck == publicInputHash, "publicInputHash cannot be reconciled");

      // check inputs vs on-chain states
      require(roots[_merkleIndex1] == _root1, "The input root1 has never been the root of the Merkle Tree");
      require(roots[_merkleIndex2] == _root2, "The input root has never been the root of the Merkle Tree");
      require(_nullifier1 != _nullifier2, "The two input nullifiers must be different!");
      require(_commitment3 != _commitment4, "The new commitments (_commitment3 and _commitment4) must be different!");
      require(nullifiers[_nullifier1] == 0, "The commitment being spent (commitment1) has already been nullified!");
      require(nullifiers[_nullifier2] == 0, "The commitment being spent (commitment2) has already been nullified!");

      // update contract states
      nullifiers[_nullifier1] = _nullifier1; //remember we spent it
      nullifiers[_nullifier2] = _nullifier2; //remember we spent it

      ////////////////////////////CM3/////////////////////////////
      uint256 merkleIndex1 = register_cm(_commitment3); //add the commitment to the list of commitments

      ////////////////////////////CM4/////////////////////////////
      uint256 merkleIndex2 = register_cm(_commitment4);

      emit Pour_MiniMerkle(_nullifier1, _nullifier2, _commitment3, leafCount - 2, merkleIndex1, _commitment4, leafCount -1, merkleIndex2);

  }

  function lzkp(
    uint256[2] calldata _a,
    uint256[2][2] calldata _b,
    uint256[2] calldata _c,
    uint256[23] calldata _input,
    uint256 _merkleIndex1,
    uint256 _merkleIndex2,
    bytes32 _root1,
    bytes32 _root2,
    bytes32 _nullifier1,
    bytes32 _nullifier2,
    bytes32 _cm5,
    address mpk,
    uint _depositNum
    )
  external
  payable
  {
    require( true == DepositNotes.verify(_a, _b, _c, _input), "verification fail");


    // Check that the publicInputHash equals the hash of the 'public inputs':
    bytes32 publicInputHash = bytes32(_input[0]);
    bytes16 _root1High = bytes16(_root1);
    bytes16 _root2Low = bytes16(_root2<<128);
    bytes32 publicInputHashCheck = zeroMSBs(bytes32(sha256(abi.encodePacked(_root1High, _root2Low, _nullifier1, _nullifier2, _cm5, mpk))));
    //require(publicInputHashCheck == publicInputHash, "publicInputHash cannot be reconciled");

    // check inputs vs on-chain states
    require(roots[_merkleIndex1] == _root1, "The input root1 has never been the root of the Merkle Tree");
    require(roots[_merkleIndex2] == _root2, "The input root has never been the root of the Merkle Tree");
    require(_nullifier1 != _nullifier2, "The two input nullifiers must be different!");
    require(nullifiers[_nullifier1] == 0, "The commitment being spent (commitment1) has already been nullified!");
    require(nullifiers[_nullifier2] == 0, "The commitment being spent (commitment2) has already been nullified!");

    // update contract states
    nullifiers[_nullifier1] = _nullifier1; //remember we spent it
    nullifiers[_nullifier2] = _nullifier2; //remember we spent it

    ////////////////////////////CM3/////////////////////////////
    uint256 merkleIndex5 = register_cm(_cm5); //add the commitment to the list of commitments
    //emit Deposit_ChangeNote();
    emit Deposit_NewNote(_cm5, leafCount-1, merkleIndex5);
    DepositNotes.depositCommit(_input,mpk,_depositNum);


    ////////////////////////////CM4/////////////////////////////
    //uint256 merkleIndex2 = register_cm(_commitment4);

    //emit Pour_MiniMerkle(_nullifier1, _nullifier2, _commitment3, leafCount - 2, merkleIndex1, _commitment4, leafCount -1, merkleIndex2);

  }

  function burn_mini(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c,
      uint256[1] calldata input,
      uint256 _merkleIndex,
      bytes32 _root,
      bytes32 _nullifier,
      uint128 _value,
      uint256 _payTo)
    external
    payable
  {
      require(BurnMiniNotes.verify(a, b, c, input), "The proof has not been verified by the contract");
      bytes32 publicInputHash = bytes32(input[0]);
      bytes32 publicInputHashCheck = zeroMSBs(bytes32(sha256(abi.encodePacked(_root, _nullifier, uint128(_value), _payTo))));
      //require(publicInputHashCheck == publicInputHash, "publicInputHash cannot be reconciled");

      // check inputs vs on-chain states
      require(roots[_merkleIndex] == _root, "The input root has never been the root of the Merkle Tree");
      //require(nullifiers[_nullifier]==0, "The commitment being spent has already been nullified!");

      nullifiers[_nullifier] = _nullifier; // add the nullifier to the list of nullifiers

      //Finally, transfer the fungible tokens from this contract to the nominated address
      address payToAddress = address(_payTo); // we passed _payTo as a uint256, to ensure the packing was correct within the sha256() above
      dai.transfer(payToAddress, _value);

      emit Burn(_value, payToAddress, _nullifier);
  }


  function commit_signedTx(string memory message, uint8 v, bytes32 r, bytes32 s) public
  {
    // message is mpkAddress(0xasdasqwasda) + nonce(0~255);
    require((bytes(message).length >= 67) && (bytes(message).length <= 69), "message length is too long or too short");
    bytes memory temp = hexStringToBytes(message);
    //require(temp.length != 32);
    //emit Test3(bytes(message).length);
    bytes32 poolId;
    assembly {
      poolId := mload(add(temp, 32))
    }
    uint8 num = stringToUint(message);

    DepositPool memory dp = depositPools[poolId];
    require(dp.mpkAddress == verifyString(message, v, r, s),"signature verification failed");
    commitDepositNotes(poolId, num);
  }

  function commitDepositNotes(bytes32 poolId, uint8 num) internal {
    DepositPool storage dp = depositPools[poolId];
    require(dp.expiredTime >= now ,"Pool is expired");
    require((num <= dp.maxNotesNum) && (num > dp.lastNotesNum), "transferNotesNum is lower than lastNotesNum or bigger than maxNotesNum");

    //change recevier's deposit notes' state to avaliable
    //and change sender's deposit notes' state to spent
    //The number of notes changed = transferNotesNum - lastNotesNum
    for(uint i = dp.lastNotesNum; i < num; i++){
      uint256 mi = register_cm(dp.receiverNotes[i]);
      emit Deposit_NewNote(dp.receiverNotes[i], leafCount-1, mi);
    }
    dp.lastNotesNum = num;
  }


  function ClaimExpiredPool(bytes32 poolId) public { //ClaimExpiredPool

    DepositPool storage dp = depositPools[poolId];
    require(dp.expiredTime < now, "Not expired yet");

    //If pool is expired, then return change to sender
    for(uint i = dp.lastNotesNum; i < dp.maxNotesNum; i++){
      uint256 mi = register_cm(dp.senderNotes[i]);
      emit Deposit_NewNote(dp.senderNotes[i], leafCount-1, mi);
    }

    delete depositPools[poolId];
  }


  function zeroMSBs(bytes32 value) private pure returns (bytes32) {
    uint256 shift = 256 - bitLength;
    return (value<<shift)>>shift;
  }

  /**
  Updates each node of the Merkle Tree on the path from leaf to root.
  p - is the leafIndex of the new commitment within the merkleTree.
  */
  function updatePathToRoot(uint p) private returns (bytes32) {

      /*
      If Z were the commitment, then the p's mark the 'path', and the s's mark the 'sibling path'

                       p
              p                  s
         s         p        EF        GH
      A    B    Z    s    E    F    G    H
      */

      uint s; //s is the 'sister' path of p.
      uint t; //temp index for the next p (i.e. the path node of the row above)
      bytes32 h; //hash
      for (uint r = merkleDepth-1; r > 0; r--) {
          if (p%2 == 0) { //p even index in the merkleTree
              s = p-1;
              t = (p-1)/2;
              h = sha256(abi.encodePacked(merkleTree[s],merkleTree[p]));
              merkleTree[t] = bytes27(h<<40);
          } else { //p odd index in the merkleTree
              s = p+1;
              t = p/2;
              h = sha256(abi.encodePacked(merkleTree[p],merkleTree[out])); //
              merkleTree[t] = bytes27(h<<40);
          }
          p = t; //move to the path node on the next highest row of the tree
      }
      return zeroMSBs(h); //the (265-bit) root of the merkleTree
  }

}
