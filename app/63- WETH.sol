// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./51- ERC20.sol";

// WETH = Wrapped ETHc
contract WETH is ERC20 {
  event Deposit(address indexed account, uint256 amount);
  event Withdraw(address indexed account, uint256 amount);

  constructor() ERC20("Wrapped Ether", "WETH", 100000) {}

  fallback() external payable {
    deposit();
  }

  function deposit() public payable {
    mint(msg.value);
    emit Deposit(msg.sender, msg.value);
  }

  function withdraw(uint256 _amount) external payable {
    burn(msg.value);
    payable(msg.sender).transfer(_amount);
    emit Withdraw(msg.sender, _amount);
  }
}
