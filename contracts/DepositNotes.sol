pragma solidity ^0.5.2;

import "./verifiers/DepositNoteVerifier.sol";
import "./ZkDaiBase.sol";
import "./DepositBase.sol";
import "./SignVerifier.sol";

contract DepositNotes is DepositNoteVerifier, ZkDaiBase, DepositBase, SignVerifier {
  event Test1(bytes32 cm, bool forReceiver, bytes32 salt);
  event Deposited(address mpkAddress, bytes32 poolId, uint8 depositNum, bytes32 first_sh, bytes32 first_rh);

  uint8 internal constant NUM_PUBLIC_INPUTS = 25;

  function zeroMSBs(bytes32 value) private pure returns (bytes32) {
    uint256 shift = 256 - bitLength;
    return (value<<shift)>>shift;
  }

  function depositCommit(uint256[23] memory input, address mpkAddress, uint depositNum)
    internal
  {

      bytes32 shSeed = concat(input[5], input[6]);
      bytes32 rhSeed = concat(input[7], input[8]);
      require(shSeed != rhSeed, "The new commitments (shSeed and rhSeed) must be different!");

      //uint depositNum = input[13]; //depositNum

      uint sNonce = uint(concat(input[18], input[19]));
      uint rNonce = uint(concat(input[20], input[21]));

      bytes32[] memory sh = new bytes32[](depositNum);
      bytes32[] memory rh = new bytes32[](depositNum);

      for(uint256 i=0; i<depositNum; i++){

        sh[i] = zeroMSBs(bytes32(sha256(abi.encodePacked(shSeed, sNonce +i))));
        rh[i] = zeroMSBs(bytes32(sha256(abi.encodePacked(rhSeed, rNonce +i))));
      }
      //emit Test1(rh[0],true, bytes32(rNonce));
      //create pool ID
      bytes32 poolId = keccak256(abi.encodePacked(rh[0],now));
      uint aliveTime = 5 minutes; //pool's alive time
      depositPools[poolId] = DepositPool(mpkAddress, now + aliveTime, uint8(depositNum), 0, sh, rh);
      emit Deposited(mpkAddress, poolId, uint8(depositNum), sh[0], rh[0]); // notification for data seller.
  }

  function getDepositHash(bytes32 seed, uint nonce) internal returns (bytes32 notes) {

      bytes memory context = new bytes(64);
      nonce = nonce << 128;

      assembly {
        mstore(add(context,32),seed)
        mstore(add(context,64),nonce)
      }

      bytes memory note = new bytes(48);
      for(uint i=0; i<48; i++){
        note[i] = context[i];
      }
      notes = sha256(note);
  }

  /**
  * @dev Challenge the proof for spend step
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  */
  function verify(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c,
      uint256[23] memory input)
    internal returns (bool r)
  {
      if (!DepositNoteVerifier.depositVerifyTx(a, b, c, input))
      {
        //Verification Fail
        emit VerificationFail(msg.sender);
        return false;
      } return true;
  }

  //check Pool is expired. If pool is expired, then change the remain sender notes' state to avaliable. Also change the remain reciever notes' state to spent(unavailable

}
