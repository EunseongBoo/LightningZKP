pragma solidity ^0.5.2;

import "./verifiers/Pour4Verifier.sol";
import "./ZkDaiBase.sol";


contract Pour4 is Pour4Verifier {
  event VerificationFail(address submitter);
  /**
  * @dev Challenge the proof for spend step
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  */
  function verify(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[14] memory input)
    internal returns (bool r)
  {
      if (!verifyTx(a, b, c, input)) {
        //Verification Fail
        emit VerificationFail(msg.sender);
        return false;
      }
      return true;
  }
}
