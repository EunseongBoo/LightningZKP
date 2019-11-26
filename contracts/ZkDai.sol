pragma solidity ^0.5.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./MintNotes.sol";
import "./SpendNotes.sol";
import "./LiquidateNotes.sol";
import "./DepositNotes2.sol";
import "./DepositNotes5.sol";
import "./DepositNotes10.sol";
import "./DepositNotes20.sol";

contract ZkDai is MintNotes, SpendNotes, DepositNotes2, DepositNotes5, DepositNotes10, DepositNotes20, LiquidateNotes {

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
    validStake(msg.value)
  {
      require(
        dai.transferFrom(msg.sender, address(this), uint256(input[2]) /* value */),
        "daiToken transfer failed"
      );
      MintNotes.submit(a, b, c, input);
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
    validStake(msg.value)
  {
      SpendNotes.submit(a, b, c, input);
  }


  function deposit_2(
    uint256[2] calldata a,
    uint256[2][2] calldata b,
    uint256[2] calldata c,
    uint256[19] calldata input)
  external
  payable
  validStake(msg.value)
  {
    DepositNotes2.submit(a, b, c, input);
  }

  function deposit_5(
    uint256[2] calldata a,
    uint256[2][2] calldata b,
    uint256[2] calldata c,
    uint256[31] calldata input)
  external
  payable
  validStake(msg.value)
  {
    DepositNotes5.submit(a, b, c, input);
  }

  function deposit_10(
    uint256[2] calldata a,
    uint256[2][2] calldata b,
    uint256[2] calldata c,
    uint256[51] calldata input)
  external
  payable
  validStake(msg.value)
  {
    DepositNotes10.submit(a, b, c, input);
  }

  function deposit_20(
    uint256[2] calldata a,
    uint256[2][2] calldata b,
    uint256[2] calldata c,
    uint256[91] calldata input)
  external
  payable
  validStake(msg.value)
  {
    DepositNotes20.submit(a, b, c, input);
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
      uint256[4] calldata input)
    external
    payable
    validStake(msg.value)
  {
      LiquidateNotes.submit(to, a, b, c,input);
  }

  /**
  * @dev Challenge the mint or spend proofs and claim the stake amount if challenge passes.
  * @notice If challenge passes, the challenger claims the stake amount,
  *         otherwise note(s) are committed/spent and stake is transferred back to proof submitter.
  * @notice params: a, a_p, b, b_p, c, c_p, h, k zkSnark parameters of the challenged proof
  */
  function challenge(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c)
    external
  {
      bytes32 proofHash = getProofHash(a, b, c);
      Submission storage submission = submissions[proofHash];
      require(submission.sType != SubmissionType.Invalid, "Corresponding hash of proof doesnt exist");
      require(submission.submittedAt + cooldown >= now, "Note cannot be challenged anymore");
      if (submission.sType == SubmissionType.Mint) {
        MintNotes.challenge(a, b, c, proofHash);
      } else if (submission.sType == SubmissionType.Spend) {
        SpendNotes.challenge(a, b, c, proofHash);
      } else if (submission.sType == SubmissionType.Liquidate) {
        LiquidateNotes.challenge(a, b, c, proofHash);
      } else if (submission.sType == SubmissionType.Deposit) {
        DepositNotes2.challenge(a, b, c, proofHash);
      }
  }

  function challenge_spend(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c)
    external
  {
      bytes32 proofHash = getProofHash(a, b, c);
      Submission storage submission = submissions[proofHash];
      require(submission.sType != SubmissionType.Invalid, "Corresponding hash of proof doesnt exist");
      require(submission.submittedAt + cooldown >= now, "Note cannot be challenged anymore");
      require(submission.sType == SubmissionType.Spend, "Submission Type is not Spend");

      SpendNotes.challenge(a, b, c, proofHash);
  }

  function challenge_deposit_2(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c)
    external
  {
      bytes32 proofHash = getProofHash(a, b, c);
      Submission storage submission = submissions[proofHash];
      require(submission.sType != SubmissionType.Invalid, "Corresponding hash of proof doesnt exist");
      require(submission.submittedAt + cooldown >= now, "Note cannot be challenged anymore");
      require(submission.sType == SubmissionType.Deposit, "Submission Type is not deposit");

      DepositNotes2.challenge(a, b, c, proofHash);
  }

  function challenge_deposit_5(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c)
    external
  {
      bytes32 proofHash = getProofHash(a, b, c);
      Submission storage submission = submissions[proofHash];
      require(submission.sType != SubmissionType.Invalid, "Corresponding hash of proof doesnt exist");
      require(submission.submittedAt + cooldown >= now, "Note cannot be challenged anymore");
      require(submission.sType == SubmissionType.Deposit, "Submission Type is not deposit");

      DepositNotes5.challenge(a, b, c, proofHash);
  }

  function challenge_deposit_10(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c)
    external
  {
      bytes32 proofHash = getProofHash(a, b, c);
      Submission storage submission = submissions[proofHash];
      require(submission.sType != SubmissionType.Invalid, "Corresponding hash of proof doesnt exist");
      require(submission.submittedAt + cooldown >= now, "Note cannot be challenged anymore");
      require(submission.sType == SubmissionType.Deposit, "Submission Type is not deposit");

      DepositNotes10.challenge(a, b, c, proofHash);
  }

  function challenge_deposit_20(
      uint256[2] calldata a,
      uint256[2][2] calldata b,
      uint256[2] calldata c)
    external
  {
      bytes32 proofHash = getProofHash(a, b, c);
      Submission storage submission = submissions[proofHash];
      require(submission.sType != SubmissionType.Invalid, "Corresponding hash of proof doesnt exist");
      require(submission.submittedAt + cooldown >= now, "Note cannot be challenged anymore");
      require(submission.sType == SubmissionType.Deposit, "Submission Type is not deposit");

      DepositNotes20.challenge(a, b, c, proofHash);
  }
  /**
  * @dev Commit a particular proof once the challenge period has ended
  * @param proofHash Hash of the proof that needs to be committed
  */
  function commit(bytes32 proofHash)
    public
  {
      Submission storage submission = submissions[proofHash];
      require(submission.sType != SubmissionType.Invalid, "proofHash is invalid");
      require(submission.submittedAt + cooldown < now, "Note is still hot");
      if (submission.sType == SubmissionType.Mint) {
        mintCommit(proofHash);
      } else if (submission.sType == SubmissionType.Spend) {
        spendCommit(proofHash);
      } else if (submission.sType == SubmissionType.Liquidate) {
        liquidateCommit(proofHash);
      } else if (submission.sType == SubmissionType.Deposit) {
        DepositNotes2.depositCommit_2(proofHash);
      }
  }
}
