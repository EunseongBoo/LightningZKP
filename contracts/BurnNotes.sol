pragma solidity ^0.5.2;

import "./verifiers/BurnVerifier.sol";
import "./ZkDaiBase.sol";

contract BurnNotes is BurnVerifier, ZkDaiBase {
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
      if (!BurnVerifier.burnVerifyTx(a, b, c, input)) {
        //verification fail
        emit VerificationFail(msg.sender);
        return false;
      } return true;
  }
}
