// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract IfElse {
  function PRO_DEVELOPPER(
    /* 😎 */
    uint256 _x
  ) external pure returns (uint256) {
    return _x < 10 ? 1 : 2; // Turnary Operators (little bit inspired by JS 🙄)
  }

  function basic(uint256 _x) external pure returns (uint256) {
    if (_x < 10) {
      return 1;
    } else if (_x < 20) {
      return 2;
    } else {
      return 3;
    }
  }

  function Advanced(uint256 _x) external pure returns (uint256) {
    if (_x < 10) {
      return 1;
    }

    if (_x < 20) {
      return 2;
    }
    return 3;
  }
}
