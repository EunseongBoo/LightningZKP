pragma solidity ^0.5.2;

import "./verifiers/DepositNote5Verifier.sol";
import "./ZkDaiBase.sol";
import "./DepositBase.sol";

contract DepositNotes5 is DepositNote5Verifier, ZkDaiBase, DepositBase{
  uint8 internal constant NUM_PUBLIC_INPUTS = 31;
  uint8 internal constant NUM_DEPOSIT_NOTES = 5*2; //deposit_note_num * 2 (sender and receiver)
  uint8 internal constant NUM_ALL_NOTES = 2 + NUM_DEPOSIT_NOTES; //2 (original note + change note) + deposit notes
  uint8 internal constant MPK_INDEX = (NUM_DEPOSIT_NOTES+2)*2; // (NUM_DEPOSIT_NOTES + original note + change note) * 2 (2 public input is needed for one note hash value)
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
  function depositCommit_5(bytes32 proofHash)
    internal
  {
      Submission storage submission = submissions[proofHash];
      bytes32[NUM_ALL_NOTES] memory _notes = getALLNotes_5(submission.publicInput);

      // check that the first note (among public params) is committed and
      require(notes[_notes[0]] == State.Committed, "Note is either invalid or already spent");
      // check that the deposit notes is already minted.
      for(uint i=1; i<NUM_ALL_NOTES; i++){
        require(notes[_notes[i]] == State.Invalid, "New note is already minted");
      }

      notes[_notes[0]] = State.Spent; // Change the state of an original note.
      for(uint i=1; i<NUM_DEPOSIT_NOTES; i++){
        notes[_notes[i]] = State.Deposit;
      }
      notes[_notes[NUM_ALL_NOTES-1]] = State.Committed; // Change the state of a "change note".

      address mpkAddress = getMpkAddress(submission.publicInput[MPK_INDEX],submission.publicInput[MPK_INDEX+1],submission.publicInput[MPK_INDEX+2],submission.publicInput[MPK_INDEX+3]);

      delete submissions[proofHash];
      submission.submitter.transfer(stake);

      emit NoteStateChange(_notes[0], State.Spent);
      for(uint i=1; i<NUM_DEPOSIT_NOTES; i++){
        emit NoteStateChange(_notes[i], State.Deposit);
      }
      emit NoteStateChange(_notes[NUM_ALL_NOTES-1], State.Committed);

      bytes32 poolId = keccak256(abi.encodePacked(_notes[0],now));

      bytes32[] memory senderNotes = new bytes32[](NUM_DEPOSIT_NOTES/2);
      for(uint i =0; i< NUM_DEPOSIT_NOTES/2; i++){
        senderNotes[i] = _notes[i+1];
      }
      bytes32[] memory receiverNotes = new bytes32[](NUM_DEPOSIT_NOTES/2);
      for(uint i = 0; i< NUM_DEPOSIT_NOTES/2; i++) {
        receiverNotes[i] = _notes[i+NUM_DEPOSIT_NOTES/2+1];
      }
      uint expectedTime = 5 minutes;
      depositPools[poolId] = DepositPool(mpkAddress, now + expectedTime, NUM_DEPOSIT_NOTES/2, 0, senderNotes, receiverNotes);
      emit Deposited(mpkAddress, poolId);
  }

  function getALLNotes_5(uint256[] memory input)
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
      if (!DepositNote5Verifier.depositVerifyTx(a, b, c, input)) {
        // challenge passed
        delete submissions[proofHash];
        msg.sender.transfer(stake);
        emit Challenged(msg.sender, proofHash);
      } else {
        // challenge failed
        depositCommit_5(proofHash);
      }
  }
}
