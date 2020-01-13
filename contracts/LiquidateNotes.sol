pragma solidity ^0.5.2;

import {Verifier as LiquidateNoteVerifier} from "./verifiers/LiquidateNoteVerifier.sol";
import "./ZkDaiBase.sol";

contract LiquidateNotes is LiquidateNoteVerifier, ZkDaiBase {
  uint8 internal constant NUM_PUBLIC_INPUTS = 8;
  /**
  * @dev Commits the proof i.e. Mints the note that originally came with the proof.
  */
  function liquidateCommit(address to, uint256[8] memory input)
    internal
  {
      bytes32 note = concat(input[0], input[1]);
      require(notes[note] == State.Committed, "Note is either invalid or already spent");
      notes[note] = State.Spent;

      address to_ = getAddress(input[3], input[4], input[5], input[6]); //get to_ address from proof public input
      require(to_ == to);
      uint256 value = input[2];

      require(
        dai.transfer(to, value),
        "daiToken transfer failed"
      );

      emit NoteStateChange(note, State.Spent);
  }

  /**
  * @dev Verification the proof
  */
  function verify(
      address to,
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[8] memory input)
    internal
    {
      // zk circuit for liquidate
      if (!liquidateVerifyTx(a, b, c, input)) {
        //verification fail
        emit VerificationFail(msg.sender);
      } else {
        //verification success
        liquidateCommit(to,input);
      }
  }
}
