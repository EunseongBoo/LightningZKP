pragma solidity ^0.5.2;

import "./verifiers/SpendNoteVerifier.sol";
import "./ZkDaiBase.sol";


contract SpendNotes is SpendNoteVerifier {
  event VerificationFail(address submitter);
  /**
  * @dev Challenge the proof for spend step
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  */
  function verify(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[12] memory input)
    internal returns (bool r)
  {
      if (!spendVerifyTx(a, b, c, input)) {
        //Verification Fail
        emit VerificationFail(msg.sender);
        return false;
      }
      return true;
  }
}
