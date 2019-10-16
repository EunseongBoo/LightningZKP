pragma solidity ^0.5.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestDai is ERC20 {
  constructor() public {
    _mint(msg.sender, 300*(10**18));
  }
}
