pragma solidity ^0.5.2;

import "./verifiers/DepositNoteVerifier.sol";
import "./ZkDaiBase.sol";
import "./DepositBase.sol";
import "./SignVerifier.sol";

contract DepositNotes is DepositNoteVerifier, ZkDaiBase, DepositBase, SignVerifier {
  uint8 internal constant NUM_PUBLIC_INPUTS = 17;


  function depositCommit(uint256[17] memory input)
    internal
  {
      
      bytes32 oh = concat(input[0],input[1]);
      bytes32 ch = concat(input[2], input[3]);
      bytes32 shSeed = concat(input[4], input[5]);
      bytes32 rhSeed = concat(input[6], input[7]);
      address mpkAddress = getAddress(input[8], input[9],input[10], input[11]);//8,9,10,11 mpk
      uint depositNum = input[12]; //depositNum
      uint dValue = input[13];
      uint sNonce = input[14];
      uint rNonce = input[15];

      bytes32[] memory sh = new bytes32[](depositNum);
      bytes32[] memory rh = new bytes32[](depositNum);

      for(uint i=0; i<depositNum; i++){
        sh[i] = getDepositHash(shSeed, sNonce+i);
        rh[i] = getDepositHash(rhSeed, rNonce+i);
      }

      // check that the first note (among public params) is committed and
      require(notes[oh] == State.Committed, "Note is either invalid or already spent");

      // check that the deposit notes is already minted.
      for(uint i=0; i<depositNum; i++){
        require(notes[sh[i]] == State.Invalid, "New note is already minted");
        require(notes[rh[i]] == State.Invalid, "New note is already minted");
      }
      require(notes[ch] == State.Invalid, "Change note is already minted");

      notes[oh] = State.Spent; // Change the state of an original note.
      for(uint i=0; i<depositNum; i++){
        notes[sh[i]] = State.Deposit;
        notes[rh[i]] = State.Deposit;
      }
      notes[ch] = State.Committed; // Change the state of a "change note".

      emit NoteStateChange(oh, State.Spent);
      for(uint i=1; i<depositNum; i++){
        emit NoteStateChange(sh[i], State.Deposit); //
        emit NoteStateChange(rh[i], State.Deposit);
      }
      emit NoteStateChange(ch, State.Committed);

      //create pool ID
      bytes32 poolId = keccak256(abi.encodePacked(oh,now));
      uint aliveTime = 5 minutes; //pool's alive time
      depositPools[poolId] = DepositPool(mpkAddress, dValue, now + aliveTime, uint8(depositNum), 0, sh, rh);
      emit Deposited(mpkAddress, poolId, dValue, uint8(depositNum), rhSeed); // notification for data seller.
  }

  function getDepositHash(bytes32 seed, uint nonce) internal returns (bytes32 notes) {

      bytes memory context = new bytes(64);
      nonce = nonce << 128;

      assembly {
        mstore(add(context,32),seed)
        mstore(add(context,64),nonce)
      }

      bytes memory note = new bytes(48);
      for(uint i=0; i<48; i++){
        note[i] = context[i];
      }
      notes = sha256(note);
  }

  /**
  * @dev Challenge the proof for spend step
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  */
  function verify(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[17] memory input)
    internal
  {
      if (!DepositNoteVerifier.verifyTx(a, b, c, input))
      {
        //Verification Fail
        emit VerificationFail(msg.sender);
      } else {
        //Verification Success
        depositCommit(input);
      }
  }

  function commit_singedTx(string memory message, uint8 v, bytes32 r, bytes32 s) public {
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
      notes[dp.receiverNotes[i]] = State.Committed;
      notes[dp.senderNotes[i]] = State.Spent;
      emit NoteStateChange(dp.receiverNotes[i], State.Committed);
      emit NoteStateChange(dp.senderNotes[i], State.Spent);
    }
    dp.lastNotesNum = num;
  }

  //check Pool is expired. If pool is expired, then change the remain sender notes' state to avaliable. Also change the remain reciever notes' state to spent(unavailable).
  function ClaimExpiredPool(bytes32 poolId) public { //ClaimExpiredPool

    DepositPool storage dp = depositPools[poolId];
    require(dp.expiredTime < now, "Not expired yet");

    //If pool is expired, then return change to sender
    for(uint i = dp.lastNotesNum; i < dp.maxNotesNum; i++){
      notes[dp.receiverNotes[i]] = State.Spent;
      notes[dp.senderNotes[i]] = State.Committed;
      emit NoteStateChange(dp.receiverNotes[i], State.Spent);
      emit NoteStateChange(dp.senderNotes[i], State.Committed);
    }

    delete depositPools[poolId];
  }

}
