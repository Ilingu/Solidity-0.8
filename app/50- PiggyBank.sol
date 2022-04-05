// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract PiggyBank {
  event Deposit(address indexed depositer, uint256 amount);
  event Withdraw(uint256 amount);

  address public immutable owner = msg.sender;

  receive() external payable {
    emit Deposit(msg.sender, msg.value);
  }

  function withdraw() external {
    require(msg.sender == owner, "not owner");

    emit Withdraw(address(this).balance);
    selfdestruct(payable(msg.sender)); // We already know that msg.sender is the owner
  }
}
