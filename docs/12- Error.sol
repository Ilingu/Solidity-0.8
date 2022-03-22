// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* 3 Assertion:
  - require, revert, assert
    --> gas refund, state updates are reverted
  Custom Error (Solidity 0.8) --> save gas
*/
contract Error {
  function testRequire(uint256 _i) public pure {
    require(_i <= 10, "i is greeter than 10"); // This Condition is required for the code to continute its execution,
    //                                            if condtion fail, revert all execution with the message: "i is greeter than 10"
  }

  function testRevert(uint256 _i) public pure {
    if (_i > 10) {
      revert("i > 10"); // Does the same thing than Require, but more useful when u have a lot of nested condition
    }
  }

  uint256 public num = 123;

  function testAssert() public {
    num = 1; // accidently update
    assert(num == 123); // --> Say that the StateVar "Num" should always be 123, if it is not, there is a bug in the code
  }

  error MyError(address caller, uint256 i);

  function CustomError(uint256 _i) public view {
    // -> The Longer the error message the more gas it'll use
    // -> We can save these gas with Custom Error
    if (_i > 10) {
      revert MyError(msg.sender, _i);
    }
  }
}
