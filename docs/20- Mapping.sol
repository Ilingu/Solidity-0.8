// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Mapping --> Like Object (In JS 💛) or Dictionnaries (In Python 🐍)
// How to declare a mapping (simple and nested)
// Set, Get, Delete

contract Mapping {
  // 1 LookUp whereas in a array can take x(lim 1->len) operations
  mapping(string => bool) private users; // {"alice": true, "bob": true, "charlie": true}

  mapping(address => uint256) public balances; // {0x1: 50Eth, 0x2: 25Eth ...}
  mapping(address => mapping(address => bool)) public isFriend; // {0x1: {0x3: true, 0x2a: true}, 0x3: {0x1: true}}

  constructor() {
    balances[msg.sender] = 123; // set balances at index msg.sender eq to 123 --> {..., 0x1: 123, ...}
    uint256 bal = balances[msg.sender]; // get at index msg.sender
    uint256 bal2 = balances[address(1)]; // Not set so return default val for uint: 0

    balances[msg.sender] += 456; // Update (You can also reassign) --> 123 + 456 = 579
    delete balances[msg.sender]; // -> Like Array, delete reset to default val here 0 --> {..., 0x1: 0, ...}
    // Note that you can't remove an index, only reset to 0 (Anyway all index are set to 0, so it's like an remove)

    isFriend[msg.sender][address(1)] = true;
  }
}
