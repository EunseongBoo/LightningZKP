pragma solidity ^0.5.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ZkDaiBase {
  uint256 public cooldown;
  uint256 public stake;
  ERC20 public dai;

  enum SubmissionType {Invalid, Mint, Spend, Liquidate, Deposit}
  struct Submission {
    address payable submitter;
    SubmissionType sType;
    uint256 submittedAt;
    uint256[] publicInput;
  }
  // maps proofHash to Submission
  mapping(bytes32 => Submission) public submissions;

  enum State {Invalid, Committed, Spent, Deposit}
  // maps note to State
  mapping(bytes32 => State) public notes;

  event NoteStateChange(bytes32 note, State state);
  event Submitted(address submitter, bytes32 proofHash);
  event Deposited(address mpkAddress, bytes32 poolId);
  event Challenged(address indexed challenger, bytes32 proofHash);
  event Calc(bytes32 notehash);
  event TestAddress(address mpkAddress);
  /**
  * @dev Calculates the keccak256 of the zkSnark parameters
  * @return proofHash
  */
  function getProofHash(
      uint256[2] memory a,
      uint256[2][2] memory b,
      uint256[2] memory c)
    internal
    pure
    returns(bytes32 proofHash)
  {
      proofHash = keccak256(abi.encodePacked(a, b, c));
  }

  /**
  * @dev Concatenates the 2 chunks of the sha256 hash of the note
  * @notice This method is required due to the field limitations imposed by the zokrates zkSnark library
  * @param _a Most significant 128 bits of the note hash
  * @param _b Least significant 128 bits of the note hash
  */

  ///////////////The fucntion must be modified///////////////
  ///////////////It can use only for testing in now/////////
  function concat(uint256 _a, uint256 _b)
    internal
    pure
    returns(bytes32 note)
  {
      bytes16 a = bytes16(uint128(_a));
      bytes16 b = bytes16(uint128(_b));

      note = bytes32 (uint256 (uint128 (a)) << 128 | uint128 (b));

      return note;
  }


  function getMpkAddress(uint256 _a, uint256 _b, uint256 _c, uint256 _d)
    internal
    pure
    returns (address mpkAddress)
  {
      bytes16 a = bytes16(uint128(_a));
      bytes16 b = bytes16(uint128(_b));
      bytes16 c = bytes16(uint128(_c));
      bytes16 d = bytes16(uint128(_d));
      bytes memory _mpk = new bytes(64);

      for (uint i = 0; i < 16; i++) {
        _mpk[i] = a[i];
        _mpk[16 + i] = b[i];
        _mpk[32 + i] = c[i];
        _mpk[48 + i] = d[i];
      }

      bytes32 mpkHash = keccak256(_mpk);
      assembly {
        mstore(0, mpkHash)
        mpkAddress := mload(0)
      }


  }

  function _bytesToBytes32(bytes memory b, uint offset)
    internal
    pure
    returns (bytes32 out)
  {
      for (uint i = 0; i < 32; i++) {
        out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
      }
  }
}
