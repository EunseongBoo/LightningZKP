pragma solidity ^0.5.2;

import {Verifier as DepositNoteVerifier} from "./verifiers/DepositNoteVerifier.sol";
import "./ZkDaiBase.sol";


contract DepositNotes is DepositNoteVerifier, ZkDaiBase {
  uint8 internal constant NUM_PUBLIC_INPUTS = 19;
  uint8 internal constant NUM_DEPOSIT_NOTES = 4;
  uint8 internal constant NUM_ALL_NOTES = 2 + NUM_DEPOSIT_NOTES; //original note + change note + deposit notes
  /**
  * @dev Hashes the submitted proof and adds it to the submissions mapping that tracks
  *      submission time, type, public inputs of the zkSnark and the submitter
  */
  function submit(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[NUM_PUBLIC_INPUTS] memory input)
    internal
  {
      bytes32 proofHash = getProofHash(a, b, c);
      uint256[] memory publicInput = new uint256[](NUM_PUBLIC_INPUTS);
      for(uint8 i = 0; i < NUM_PUBLIC_INPUTS; i++) {
        publicInput[i] = input[i];
      }
      submissions[proofHash] = Submission(msg.sender, SubmissionType.Deposit, now, publicInput);
      emit Submitted(msg.sender, proofHash);
  }

  /**
  * @dev Commits the proof i.e. Marks the input note as Spent and mints two new output notes that came with the proof.
  * @param proofHash Hash of the proof to be committed
  */
  function depositCommit(bytes32 proofHash)
    internal
  {
      Submission storage submission = submissions[proofHash];
      bytes32[NUM_ALL_NOTES] memory _notes = getAllNotes(submission.publicInput);

      // check that the first note (among public params) is committed and
      require(notes[_notes[0]] == State.Committed, "Note is either invalid or already spent");
      // check that the deposit notes is already minted.
      for(uint i=1; i<NUM_DEPOSIT_NOTES+2; i++){
        require(notes[_notes[i]] == State.Invalid, "output note is already minted");
      }

      notes[_notes[0]] = State.Spent;
      for(uint i=1; i<NUM_DEPOSIT_NOTES; i++){
        notes[_notes[i]] = State.Deposit;
      }

      delete submissions[proofHash];
      submission.submitter.transfer(stake);

      emit NoteStateChange(_notes[0], State.Spent);
      for(uint i=1; i<NUM_DEPOSIT_NOTES; i++){
        emit NoteStateChange(_notes[i], State.Deposit);
      }

      bytes32 poolId = keccak256(abi.encodePacked(_notes[0],now));
      address mpkAddress = submission.publicInput[0]+submission.publicInput[1];
      bytes32[] senderNotes = ;
      bytes32[] receiverNotes = ;

      depositPools[poolId] = DepositPool(mpkAddress, now + expectedTime, NUM_DEPOSIT_NOTES/2, 0, senderNotes, receiverNotes);
  }

  function getAllNotes(uint256[] memory input)
    internal
    pure
    returns(bytes32[NUM_ALL_NOTES] memory notes)
  {
      for(uint i=0; i<NUM_ALL_NOTES; i++){
        notes[i] = calcNoteHash(input[i*2], input[i*2+1]);
      }
  }

  /**
  * @dev Challenge the proof for spend step
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  * @param proofHash Hash of the proof
  */
  function challenge(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      bytes32 proofHash)
    internal
  {
      Submission storage submission = submissions[proofHash];
      uint256[NUM_PUBLIC_INPUTS] memory input;
      for(uint i = 0; i < NUM_PUBLIC_INPUTS; i++) {
        input[i] = submission.publicInput[i];
      }
      if (!depositVerifyTx(a, b, c, input)) {
        // challenge passed
        delete submissions[proofHash];
        msg.sender.transfer(stake);
        emit Challenged(msg.sender, proofHash);
      } else {
        // challenge failed
        depositCommit(proofHash);
      }
  }

   /* Commit paymentTx */
  function recoverAddress(bytes32 msgHash, uint8 v, bytes32 r, bytes32 s) public view returns (address) {
      return ecrecover(msgHash, v, r, s);
  }

  function paymentTxVerify(address addr, bytes32 msgHash, uint8 v, bytes32 r, bytes32 s) public view returns (bool) {
    return addr == recoverAddress(msgHash, v, r, s);
  }

  function commitDepositNotes(bytes32 poolId, uint8 transferNotesNum) internal {
    DepositPool storage dp = depositPools[poolId];
    require(dp.expiredTime >= now ,"Pool is expired");
    require((transferNotesNum <= dp.maxNotesNum) && (transferNotesNum > dp.lastNotesNum), "transferNotesNum is lower than lastNotesNum or bigger than maxNotesNum");

    //change recevier's deposit notes' state to avaliable
    //and change sender's deposit notes' state to spent
    //The number of notes changed = transferNotesNum - lastNotesNum
    for(uint i = dp.lastNotesNum; i < transferNotesNum; i++){
      notes[dp.receiverNotes[i]] = State.Committed;
      notes[dp.senderNotes[i]] = State.Spent;
      emit NoteStateChange(dp.receiverNotes[i], State.Committed);
      emit NoteStateChange(dp.senderNotes[i], State.Spent);
    }
    dp.lastNotesNum = transferNotesNum;
  }

  function commitPaymentTx(bytes32 poolId, address mpkAddress, bytes32 msgHash, uint8 transferNotesNum, uint8 v, bytes32 r, bytes32 s) public {
    DepositPool storage dp = depositPools[poolId];
    require(dp.mpkAddress == mpkAddress, "mpk Address does not match mpk address in paymentTx");
    require(msgHash == keccak256(abi.encodePacked(poolId,mpkAddress,transferNotesNum)), "mpk Address does not match mpk address in paymentTx");
    require(paymentTxVerify(mpkAddress, msgHash, v, r, s),"The sign does not match mpk Address");
    commitDepositNotes(poolId, transferNotesNum);
  }

  //check Pool is expired. If pool is expired, then change the remain sender notes' state to avaliable. Also change the remain reciever notes' state to spent(unavailable).
  function checkPoolIsExpired(bytes32 poolId) public {

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
