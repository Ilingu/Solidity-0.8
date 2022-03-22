// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract IterableMapping {
  mapping(address => uint256) public balances;
  mapping(address => bool) public inserted;
  address[] public keys;

  function set(address _key, uint256 _val) public {
    balances[_key] = _val;

    if (!inserted[_key]) {
      inserted[_key] = true;
      keys.push(_key);
    }
  }

  function getSize() public view returns (uint256) {
    return keys.length;
  }

  function first() external view returns (uint256) {
    return balances[keys[0]];
  }

  function last() external view returns (uint256) {
    return balances[keys[getSize() - 1]];
  }

  function get(uint256 _i) public view returns (uint256) {
    return balances[keys[_i]];
  }

  function IterateMapping() external view {
    uint256 size = getSize() - 1;
    uint256[] memory value = new uint256[](getSize()); // Please, DO NOT use this in production

    for (uint256 i = 0; i < size; i++) {
      value[i] = get(i); // Please, DO NOT use this in production
    }
  }
}
