// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Visibilities of func/var:
// private - only inside of this contract
// internal - only inside of contract and child contracts
// public - inside and outside of contract
// external - only from outside of contract

/*
 ___________________
| Contract A        | (A cannot access ext())
|                   |
| private pri()     |
| internal inter()  | <--- C
| public pub()      |   pub() and ext()
| external ext()    |
|___________________|

 ___________________
| Contract B is A   |
|                   |
| inter()           |
| pub()             |   
|___________________|

*/

contract VisibilityBase {
  uint256 private x = 0;
  uint256 internal y = 1;
  uint256 public z = 2;

  function privateFunc() private pure returns (uint256) {
    return 0;
  }

  function internalFunc() internal pure returns (uint256) {
    return 100;
  }

  function publicFunc() public pure returns (uint256) {
    return 200;
  }

  function externalFunc() external pure returns (uint256) {
    return 300;
  }

  // In these examples we are *inside* the contract
  function examples() external view {
    x + y + z; // We have access to "x" (private: only *inside*), "y" (internal: only *inside* + childs), and "z" (public: *inside* and outside)

    privateFunc(); // private: only *inside* so ✅
    internalFunc(); // internal: only *inside* + child so ✅
    publicFunc(); // public: *inside*/outside so ✅
    // externalFunc(); --> Error "externalFunc" does not exist? Yes it exist but only OUTSIDE of the contract. If the call comes from the inside of the contract, it won't exist ❌

    // [DISCLAMER]: the next line of code is gas inefficient, so don't do it (if you want to access an External Func from the insider just simply rename the visibility of func to either public/private or internal)

    // If you want to call an external func within the contract you can do this trick:
    this.externalFunc(); // It's not a hack, it just calling "externalFunc" from "this" contract, it's like calling it from the outside of the contract (PS: see "calling other contract" lesson)
  }
}

contract VisibilityChild is VisibilityBase {
  // In these examples we are inside VisibilityChild (this contract) and the child of VisibilityBase
  function examples2() external view {
    y + z; // This time we can't access "x" because it's private to the baseContract, if we want to access it from a child we have to rename it with the "internal" keywork, like y.
    // z is public, so it's accessible from anywhere

    internalFunc(); // internal: from inside + *child* so ✅
    publicFunc(); // public: from anywhere so ✅
    // privateFunc(); --> Error, only from inside "VisibilityBase" so ❌
    // externalFunc(); --> Error, only from outside so ❌ (when we inherit, it's like copying the func into this func, so can we call an external func within the inside of the contract ? NO.)
  }
}
