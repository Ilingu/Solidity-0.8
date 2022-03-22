// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Constructor {
  address public owner;
  uint256 public x;

  // Contructor --> special func only called once, at deploy time. after that, it's NEVER gets call again
  constructor(uint256 _x) {
    owner = msg.sender;
    x = _x;
  }
}
