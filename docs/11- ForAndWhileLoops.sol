// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ForAndWhileLoops {
  function loopsFor() external pure returns (uint256) {
    uint256 j;
    for (uint256 i = 0; i < 10; i++) {
      if (i == 3) {
        j -= 1;
        continue;
      }

      if (i == 8) {
        break;
      }

      j += 1;
    }

    return j;
  }

  function loopsWhile() external pure returns (uint256) {
    uint256 j;
    while (j < 69) {
      j++;
    }
    return j;
  }

  function sum(uint256 _n) external pure returns (uint256) {
    // BEWARE!! The Bigger the numbers of loops the more gas will be use!
    uint256 s;
    for (uint256 i = 1; i <= _n; i++) {
      s += i;
    }
    return s;
  }
}
