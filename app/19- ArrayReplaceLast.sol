// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ArrayReplaceLast {
  uint256[] public arr;

  // In fact, it not "remove" the index (like in prev section (18)) but it update/replace the index to remove with the last index
  // Ex: [1, 2, 3, 4] -- remove(1) --> [1, 4, 3]
  // [1, 4, 3]        -- remove(2) --> [1, 4]
  function remove(uint256 _index) public {
    arr[_index] = arr[arr.length - 1];
    arr.pop();
    // --> Always 2 operations against "len of the array" operations (n) for Sec.18
    // --> Gas Saver, more efficient, but order not preserve
  }

  function test() external {
    arr = [1, 2, 3, 4];
    remove(1);

    assert(arr[0] == 1);
    assert(arr[1] == 4);
    assert(arr[2] == 3);
    assert(arr.length == 3);

    remove(2);
    assert(arr[0] == 1);
    assert(arr[1] == 4);
    assert(arr.length == 2);
  }
}
