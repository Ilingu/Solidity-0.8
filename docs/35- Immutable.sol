// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Exactly like "constant" but this time we can initialize it in constructor (so only once in all the contract lifetime), after the deploy we can't change the variable
// -> Reduce gas cost
contract Immutable {
  address public immutable owner; // use less gas

  constructor() {
    owner = msg.sender;
  }
}
