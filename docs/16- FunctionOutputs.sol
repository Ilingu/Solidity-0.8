// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FunctionOutputs {
  function returnMany() public pure returns (uint256, bool) {
    return (1, true);
  }

  function named() public pure returns (uint256 x, bool b) {
    return (1, true);
  }

  // Automatically return x and b at the end of the func exec
  function assigned() public pure returns (uint256 x, bool b) {
    x = 1;
    b = true;
  }

  function destructuringAssigments() public pure {
    (uint256 x, bool b) = returnMany();
    (, bool _b) = returnMany();

    _b = b = false;
    x = 0;
  }
}
