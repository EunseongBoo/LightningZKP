pragma solidity ^0.5.2;

import "../ZkDai.sol";

contract TestZkDai is ZkDai {
  constructor(uint256 _cooldown, uint256 _stake, address daiTokenAddress)
    ZkDai(_cooldown, _stake, daiTokenAddress) public {}

  function setCooldown(uint256 _cooldown) public {
    cooldown = _cooldown;
  }
}
