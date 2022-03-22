// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Data Types - values and references
contract ValueTypes {
  bool public b = true;
  uint256 public u = 123;
  // Positive Only
  // uint = uint256 -> 0 to 2**256 - 1
  //        uint8 0 to 2**8 - 1
  //        uint 16 0 to 2**16 -1
  int256 public i = -123;
  // Neg && Positive
  // int = int256 -> -2**255 to 2**255 -1
  //       int128 -> -2**127 to 2**127 -1

  // Tips for min and max if interger
  int256 public maxInt = type(int256).max;
  int256 public minInt = type(int256).min;

  address public addr = 0xdC7C84966b5aaCa1174e9B5660fEC286c6c70F22; // 40 bytes max and min
  bytes32 public b32 =
    0xdC7C84966b5aaCa1174e9B5660fEC286c6c70F22dC7C84966b5aaCa1174e9B56; // 64 bytes max and min
}
