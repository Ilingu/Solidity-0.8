// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// selfdesctruct
// - delete contract
// - force send Ether to any address
contract Kill {
  constructor() payable {}

  function kill() external {
    selfdestruct(payable(msg.sender)); // Delete Contract and send all the remaining ETH to msg.sender
  }

  /// If we call this func after the contract death, it'll fail
  function testCall() external pure returns (uint256) {
    return 123;
  }
}

contract Helper {
  function getBalance() external view returns (uint256) {
    return address(this).balance;
  }

  /// In this contract, the kill func is executer, so the "Kill" contract will send all its ETH to this contract
  /// Yet, this contract doesn't have any "fallback/receive" func. But in the case of "selfdestruct" it doesn't matter, this contract will still receive the ETH
  function kill(Kill _kill) external {
    _kill.kill();
  }
}
