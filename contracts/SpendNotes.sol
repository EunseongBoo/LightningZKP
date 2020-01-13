pragma solidity ^0.5.2;

import "./verifiers/SpendNoteVerifier.sol";
import "./ZkDaiBase.sol";


contract SpendNotes is SpendNoteVerifier, ZkDaiBase {
  uint8 internal constant NUM_PUBLIC_INPUTS = 7;

  /**
  * @dev Commits the proof i.e. Marks the input note as Spent and mints two new output notes that came with the proof.
  */
  function spendCommit(uint256[7] memory input)
    internal
  {
      bytes32[3] memory _notes = get3Notes(input);

      require(notes[_notes[0]] == State.Committed, "Note is either invalid or already spent");
      notes[_notes[0]] = State.Spent;
      notes[_notes[1]] = State.Committed;
      notes[_notes[2]] = State.Committed;

      emit NoteStateChange(_notes[0], State.Spent);
      emit NoteStateChange(_notes[1], State.Committed);
      emit NoteStateChange(_notes[2], State.Committed);
  }

  function get3Notes(uint256[7] memory input)
    internal
    //pure
    returns(bytes32[3] memory notesHash)
  {
      notesHash[0] = concat(input[0], input[1]);
      emit Calc(notesHash[0]);
      notesHash[1] = concat(input[2], input[3]);
      emit Calc(notesHash[1]);
      notesHash[2] = concat(input[4], input[5]);
      emit Calc(notesHash[2]);
  }

  /**
  * @dev Challenge the proof for spend step
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  */
  function verify(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[7] memory input)
    internal
  {
      if (!spendVerifyTx(a, b, c, input)) {
        //Verification Fail
        emit VerificationFail(msg.sender);
      } else {
        //verification success
        spendCommit(input);
      }
  }
}
