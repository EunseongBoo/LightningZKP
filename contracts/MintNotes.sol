pragma solidity ^0.5.2;

//import {Verifier as MintNoteVerifier} from "./verifiers/MintNoteVerifier.sol";
import "./ZkDaiBase.sol";
import "./verifiers/MintNoteVerifier.sol";

contract MintNotes is MintNoteVerifier, ZkDaiBase {
  uint8 internal constant NUM_PUBLIC_INPUTS = 4;

  function mintCommit(uint256 noteHash1, uint256 noteHash2)
    internal
  {
      //Submission storage submission = submissions[proofHash];
      // check that the first note (among public params) is not already minted
      bytes32 note = concat(noteHash1, noteHash2);
      require(notes[note] == State.Invalid, "Note was already minted");
      notes[note] = State.Committed;

      emit NoteStateChange(note, State.Committed);
  }

  /**
  * @dev Challenge the proof for mint step
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  */
  function verify(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[4] memory input)
    internal
  {
      if (!MintNoteVerifier.mintVerifyTx(a, b, c, input)) {
        //verification fail
        emit VerificationFail(msg.sender);
      } else {
        //verification success
        mintCommit(input[0], input[1]);
      }
  }
}
