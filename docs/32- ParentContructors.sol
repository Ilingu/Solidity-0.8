// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// 2 ways to call parent constructors
// Order of initialization --> Most base-like to most derived

contract S {
  string public name;

  constructor(string memory _name) {
    name = _name;
  }
}

contract T {
  string public text;

  constructor(string memory _text) {
    text = _text;
  }
}

// Initialize the constructor of S and T --> only work when you know the pararms value, when you are writting the code
contract U is S("s"), T("t") {
  // Order of execution
  // 1. S
  // 2. T
  // 3. U
}

// Order of execution
// 1. S
// 2. T
// 3. V
contract V is S, T {
  // Initialize S and T contructors at deploy time
  constructor(string memory _name, string memory _text) T(_text) S(_name) {
    // T(_text) S(_name) <=> S(_name) T(_text)
    // There are no order, because the order of execution will always be from the most base-like to the most derived (so S first and then T)
  }
}

// Order of execution
// 1. S
// 2. T
// 3. VV
contract VV is S("s"), T {
  constructor(string memory _text) T(_text) {}
}

// Order of execution
// 1. T
// 2. S
// 3. V2
contract V2 is S("s"), T("just a T") {

}
