// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Counter {
  uint256 public counter;

  function increment() external {
    counter += 1;
  }

  function decrement() external {
    counter -= 1;
  }
}
