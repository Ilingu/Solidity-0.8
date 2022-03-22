// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract DefaultValues {
  bool public b; // -> [DEFAULT]: false

  uint256 public u; // -> [DEFAULT]: 0
  int256 public i; // -> [DEFAULT]: 0

  address public a; // -> [DEFAULT]: 0x0000000000000000000000000000000000000000 (The "0" address, 40 bytes)
  bytes32 public b32; // -> [DEFAULT]: 0x0000000000000000000000000000000000000000000000000000000000000000 (64 bytes)
}
