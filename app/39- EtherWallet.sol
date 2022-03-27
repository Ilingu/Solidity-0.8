// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract EtherWallet {
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  // Receive ETH
  receive() external payable {}

  function withdraw(uint256 _amount) external {
    require(msg.sender == owner, "caller is not owner");
    require(getBalance() >= _amount, "Not Enough ETH in contract");

    payable(owner).transfer(_amount); // Method 1

    // However, we know that owner is currently msg.sender, so using msg.sender will use less gas than reading the var owner
    (bool sent, ) = msg.sender.call{ value: _amount }(""); // Method 2 (When we use call, no need to convert sender to payable)
    require(sent, "Failed to send Ether");
  }

  function getBalance() public view returns (uint256) {
    return address(this).balance;
  }
}
