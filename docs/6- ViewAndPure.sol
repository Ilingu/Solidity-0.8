// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract LocalVariable {
  uint256 public num;

  // Only Read From State (No change are made) -> View
  function viewFunc() external view returns (uint256) {
    return num;
  }

  // No Read, No Write --> independant
  function sum(uint256 a, uint256 b) external pure returns (uint256) {
    return a * b;
  }
}
