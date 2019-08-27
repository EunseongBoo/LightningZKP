pragma solidity ^0.5.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ZkDaiBase {
  uint256 public cooldown;
  uint256 public stake;
  ERC20 public dai;

  //DepositNotes struct is for deposit function
  //notes_num:
  //last_nonce: If recevier submit a last signed message, then the last nonce will be updated to the signed message's nonce to prevent replay attack
  //senderNotes:
  //receiverNotes:
  struct DepositPool {
    address mpkAddress;
    //address targetAddress;
    uint expiredTime;
    uint8 maxNotesNum;
    uint8 lastNotesNum; // 0 ~ 255
    //uint lastNonce;
    bytes32[] senderNotes;
    bytes32[] receiverNotes;
  }
  //maps poolID to DepositNotes
  mapping(bytes32 => DepositPool) public depositPools;

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
  event Challenged(address indexed challenger, bytes32 proofHash);

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
  function calcNoteHash(uint _a, uint _b)
    internal
    pure
    returns(bytes32 note)
  {
      bytes16 a = bytes16(bytes32(_a));
      bytes16 b = bytes16(bytes32(_b));
      bytes memory _note = new bytes(32);

      for (uint i = 0; i < 16; i++) {
        _note[i] = a[i];
        _note[16 + i] = b[i];
      }
      note = _bytesToBytes32(_note, 0);
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
