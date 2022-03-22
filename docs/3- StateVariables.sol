// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract StateVariables {
  uint256 public myUint = 123; // Store forever on the blockchain

  function foo() external pure {
    uint256 notStateVar = 456; // When Foo end, this var is unloaded. This is a local var, not store on the blockchain
    notStateVar = 69;
  }
}
