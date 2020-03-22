pragma solidity ^0.5.2;

import "./verifiers/Burn4Verifier.sol";
import "./ZkDaiBase.sol";

contract BurnMiniNotes is Burn4Verifier, ZkDaiBase {
  /**
  * @dev Verification the proof
  */
  function verify(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[1] memory input)
    internal returns (bool r)
    {
      // zk circuit for liquidate
      if (!Burn4Verifier.burn4VerifyTx(a, b, c, input)) {
        //verification fail
        emit VerificationFail(msg.sender);
        return false;
      } return true;
  }
}
