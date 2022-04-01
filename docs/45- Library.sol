// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

library Math {
  /// Cannot Declare State var (it's not a contract, just helper function)
  function max(uint256 x, uint256 y) internal pure returns (uint256) {
    return x >= y ? x : y;
  }

  function min(uint256 x, uint256 y) internal pure returns (uint256) {
    return x <= y ? x : y;
  }

  function add(uint256 x, uint256 y) internal pure returns (uint256) {
    return x + y;
  }

  function sub(uint256 x, uint256 y) internal pure returns (uint256) {
    return x - y;
  }

  function mul(uint256 x, uint256 y) internal pure returns (uint256) {
    return x * y;
  }

  function div(uint256 x, uint256 y) internal pure returns (uint256) {
    return x / y;
  }
}

library ArrayLib {
  function find(uint256[] storage arr, uint256 x)
    internal
    view
    returns (uint256)
  {
    for (uint256 i = 0; i < arr.length; i++) {
      if (arr[i] == x) {
        return i;
      }
    }
    revert("not found");
  }
}

contract Test {
  using Math for uint256; // Method 2 declaring extra function for a type

  function testMax(uint256 x, uint256 y) external pure returns (uint256) {
    return Math.max(x, y); // Method 1: Direct call
  }

  function testMin(uint256 x, uint256 y) external pure returns (uint256) {
    return x.min(y); /// Method 2 Application
  }
}

contract TestArray {
  using ArrayLib for uint256[]; // Method 2
  uint256[] public arr = [3, 2, 1];

  function testFind() external view returns (uint256 i) {
    // return ArrayLib.find(arr, 2);
    return arr.find(2);
  }
}
