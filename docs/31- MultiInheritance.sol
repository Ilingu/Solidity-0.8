// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Order of inheritance must be from most base-like to derived

/* Example 1
    X
  ↗ ⬆
Y   |
  ↖ |
    Z

X inherit nobody (0)
Y inherit X (1)
Z inherit Y and X (2)
-> So order of most base like to derived
--> X, Y, Z
*/

/* Example 2
      X
    ↙   ↘
   Y     A
         ⬇
         B
        ↙
      Z

X inherit nobody (0)
Y inherit X (1)
A inherit X (1)
B inherit X,A (2)
Z inherit X,A,B (3)

--> X, Y, A, B, Z
*/

// I will do the first example
contract X {
  function x() public pure returns (string memory) {
    return "X";
  }

  function bar() public pure virtual returns (string memory) {
    return "X";
  }

  function foo() public pure virtual returns (string memory) {
    return "X";
  }
}

contract Y is X {
  function bar() public pure virtual override returns (string memory) {
    return "Y";
  }

  function foo() public pure virtual override returns (string memory) {
    return "Y";
  }

  function y() public pure returns (string memory) {
    return "Y";
  }
}

// The order is important! Most base-like to most derived, so first X and then Y (if you use remix or a linter it'll throw a error is you put in the wrong order e.g: "Linearization of inheritance graph impossible")
contract Z is X, Y {
  // Because X and Y have already this func, use have to specify from where it comes --> override(X, Y)
  function bar() public pure override(X, Y) returns (string memory) {
    return "Z";
  }

  // Here the order doesn't matter
  function foo() public pure override(Y, X) returns (string memory) {
    return "Z";
  }

  // We can also access "y()" and "x()"
}
