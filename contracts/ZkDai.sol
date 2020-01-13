pragma solidity ^0.5.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./MintNotes.sol";
import "./SpendNotes.sol";
import "./LiquidateNotes.sol";
import "./DepositNotes.sol";

contract ZkDai is MintNotes, SpendNotes, DepositNotes, LiquidateNotes {

  modifier validStake(uint256 _stake)
  {
      require(_stake == stake, "Invalid stake amount");
      _;
  }

  constructor(uint256 _cooldown, uint256 _stake, address daiTokenAddress)
    public
  {
      cooldown = _cooldown;
      stake = _stake;
      dai = ERC20(daiTokenAddress);
  }

  /**
  * @dev Transfers specified number of dai tokens to itself and submits the zkSnark proof to mint a new note
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters
  * @param input Public inputs of the zkSnark
  */
  function mint(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c,
      uint256[4] calldata input)
    external
    payable
  {
      require(
        dai.transferFrom(msg.sender, address(this), uint256(input[2]) /* value */),
        "daiToken transfer failed"
      );
      MintNotes.verify(a, b, c, input);
      //MintNotes.submit(a, b, c, input);
  }

  /**
  * @dev Submits the zkSnark proof to be able to spend a note and create two new notes
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters
  * @param input Public inputs of the zkSnark
  */
  function spend(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c,
      uint256[7] calldata input)
    external
    payable
  {
      SpendNotes.verify(a, b, c, input);
  }


  function deposit(
    uint256[2] calldata a,
    uint256[2][2] calldata b,
    uint256[2] calldata c,
    uint256[17] calldata input)
  external
  payable
  {
    DepositNotes.verify(a, b, c, input);
  }
  /**
  * @dev Liquidate a note to transfer the equivalent amount of dai to the recipient
  * @param to Recipient of the dai tokens
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters
  * @param input Public inputs of the zkSnark
  */
  function liquidate(
      address to,
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c,
      uint256[8] calldata input)
    external
    payable
  {
      LiquidateNotes.verify(to, a, b, c,input);
  }


  function commit_signedTx(string memory message, uint8 v, bytes32 r, bytes32 s) public
  {
      //DepositNotes.commit_singedTx(poolId, num, msgHash, v, r, s);
      DepositNotes.commit_singedTx(message, v, r, s);
  }
}
