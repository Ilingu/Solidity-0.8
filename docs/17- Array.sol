// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Array - dynamic (more gas) or fixed size
// -> Initialization (type[])
// -> Insert (push), get, update, delete, pop, length
// -> Creating array in memory
// -> Returning array from function
contract Array {
  uint256[] public nums; // Dynamics
  uint256[3] public numsFixed; // Fixed size (here 3 elems)

  constructor() {
    nums = [1, 2, 3];
    numsFixed = [
      4,
      5,
      6 /*, 7 --> Error: max length = 3 */
    ];
  }

  function examples() external {
    nums.push(4); // Insert to the end of array -> [1, 2, 3, 4]
    // numsFixed.push(4); -> Error, No, I won't explain why. You already know it.

    uint256 MyGrades = nums[0]; // --> Get the 1st elems of the array (like every others langages -_-)
    nums[MyGrades] = 777; // Update the array at index 1 (because MyGrades is nums[0] which is equal to 1 -_-, yea that useless but my linter arguing that I weren't using the variable so...) and replace it with 777 --> [1, 777, 3, 4]

    delete nums[1]; // "delete" the elem at index 1: [1, 0, 3, 4] --> In reality it just update it to 0, it doesn't remove it (yea too many "it" in this sentence, I know...).
    nums.pop(); // Remove the last elem of the array --> [1, 0, 3]

    uint256 len = nums.length; // --> Return the current length of the array, here 3

    // Create Array in memory
    uint256[] memory a = new uint256[](5); // For localvar array, always create in memory, with fixed size
    // You can only update/assign value (no pop or push)
    a[2] = len; // --> [0, 0, 3, 0, 0]
  }

  // In the most cases, Nobody do that (and it's not recommended), because the bigger the array is the more gas it'll use (so this func can take all the gas)
  function returnsArray() external view returns (uint256[] memory) {
    return nums;
  }
}
