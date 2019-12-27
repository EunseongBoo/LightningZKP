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
    uint value; //value of ecah note
    uint8 maxNotesNum; //init: depositNum
    uint8 lastNotesNum; // init:0
    bytes32[] senderNotes;
    bytes32[] receiverNotes;
  }
  //maps poolID to DepositNotes
  mapping(bytes32 => DepositPool) public depositPools;

  event Deposited(address mpkAddress, bytes32 poolId, uint dValue, uint8 depositNum, bytes32 rhSeed);

  /* Commit paymentTx */
 function recoverAddress(bytes32 msgHash, uint8 v, bytes32 r, bytes32 s) public view returns (address) {
     return ecrecover(msgHash, v, r, s);
 }

 function paymentTxVerify(address addr, bytes32 msgHash, uint8 v, bytes32 r, bytes32 s) public view returns (bool) {
   return addr == recoverAddress(msgHash, v, r, s);
 }

 function commitDepositNotes(bytes32 poolId, uint8 transferNotesNum) internal {
   DepositPool storage dp = depositPools[poolId];
   require(dp.expiredTime >= now ,"Pool is expired");
   require((transferNotesNum <= dp.maxNotesNum) && (transferNotesNum > dp.lastNotesNum), "transferNotesNum is lower than lastNotesNum or bigger than maxNotesNum");

   //change recevier's deposit notes' state to avaliable
   //and change sender's deposit notes' state to spent
   //The number of notes changed = transferNotesNum - lastNotesNum
   for(uint i = dp.lastNotesNum; i < transferNotesNum; i++){
     notes[dp.receiverNotes[i]] = State.Committed;
     notes[dp.senderNotes[i]] = State.Spent;
     emit NoteStateChange(dp.receiverNotes[i], State.Committed);
     emit NoteStateChange(dp.senderNotes[i], State.Spent);
   }
   dp.lastNotesNum = transferNotesNum;
 }

 function commitPaymentTx(bytes32 poolId, address mpkAddress, bytes32 msgHash, uint8 transferNotesNum, uint8 v, bytes32 r, bytes32 s) public {
   DepositPool storage dp = depositPools[poolId];
   require(dp.mpkAddress == mpkAddress, "mpk Address does not match mpk address in paymentTx");
   require(msgHash == keccak256(abi.encodePacked(poolId,mpkAddress,transferNotesNum)), "mpk Address does not match mpk address in paymentTx");
   require(paymentTxVerify(mpkAddress, msgHash, v, r, s),"The sign does not match mpk Address");
   commitDepositNotes(poolId, transferNotesNum);
 }

 //check Pool is expired. If pool is expired, then change the remain sender notes' state to avaliable. Also change the remain reciever notes' state to spent(unavailable).
 function ClaimExpiredPool(bytes32 poolId) public { //ClaimExpiredPool

   DepositPool storage dp = depositPools[poolId];
   require(dp.expiredTime < now, "Not expired yet");

   //If pool is expired, then return change to sender
   for(uint i = dp.lastNotesNum; i < dp.maxNotesNum; i++){
     notes[dp.receiverNotes[i]] = State.Spent;
     notes[dp.senderNotes[i]] = State.Committed;
     emit NoteStateChange(dp.receiverNotes[i], State.Spent);
     emit NoteStateChange(dp.senderNotes[i], State.Committed);
   }

   delete depositPools[poolId];
 }
}
