pragma solidity ^0.5.2;

//import {Verifier as MintNoteVerifier} from "./verifiers/MintNoteVerifier.sol";
import "./ZkDaiBase.sol";
import "./verifiers/MintNoteVerifier.sol";

contract MintNotes is MintNoteVerifier {
  event VerificationFail(address submitter);

  /**
  * @dev Challenge the proof for mint step
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  */
  function verify(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[5] memory input)
    internal returns (bool r)
  {
      if (!MintNoteVerifier.mintVerifyTx(a, b, c, input)) {
        //verification fail
        emit VerificationFail(msg.sender);
        return false;
      }
      return true;
  }
}
