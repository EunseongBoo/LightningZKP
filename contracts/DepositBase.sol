pragma solidity ^0.5.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ZkDaiBase.sol";

contract DepositBase is ZkDaiBase {

  uint internal constant poolTime = 10 minutes;

  //DepositNotes struct is for deposit function
  //notes_num:
  //last_nonce: If recevier submit a last signed message, then the last nonce will be updated to the signed message's nonce to prevent replay attack
  //senderNotes:
  //receiverNotes:
  struct DepositPool {
    address mpkAddress;
    uint expiredTime;
    uint8 maxNotesNum; //init: depositNum
    uint8 lastNotesNum; // init:0
    bytes32[] senderNotes;
    bytes32[] receiverNotes;
  }
  //maps poolID to DepositNotes
  mapping(bytes32 => DepositPool) public depositPools;

  /* Commit paymentTx */
 function recoverAddress(bytes32 msgHash, uint8 v, bytes32 r, bytes32 s) public view returns (address) {
     return ecrecover(msgHash, v, r, s);
 }

 function paymentTxVerify(address addr, bytes32 msgHash, uint8 v, bytes32 r, bytes32 s) public view returns (bool) {
   return addr == recoverAddress(msgHash, v, r, s);
 }


}
