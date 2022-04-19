// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract GasGolf {
  /// start -- 50908 gas (without gas optimization)
  /// 1. using calldata -- 49163 gas (-1745)
  /// 2. loading state variable to memory -- 48952 gas (-529)
  /// 3. using short circuit -- 48634 gas (-318)
  /// 4. loop increments (i++ -> ++i) -- 48226 gas (-408)
  /// 5. cache array length -- 48191 gas (-35)
  /// 6. load array elements to memory -- 48029 gas (-162)
  /// End -- 48029 gas (-2879)

  uint256 public total;

  /// With nums = [1, 2, 3, 4, 5, 100]
  function sumIfEvenAndLessThan99(uint256[] calldata nums) external {
    uint256 _total = total; // Load start var "total" into memory

    uint256 numsLen = nums.length; // We cache the nums.length because otherwise for each iteration solidity would read nums.length again and again (which cost some gas)
    for (uint256 i; i < numsLen; ++i) {
      uint256 num = nums[i]; // By storing nums[i] into memory we save 2 read
      if (num % 2 == 0 && num < 99) _total += num;
    }

    total = _total; // Total is updated once
  }

  /// Initial Func (Without gas optimization)
  // function sumIfEvenAndLessThan99(uint256[] memory nums) external {
  //   for (uint256 i = 0; i < nums.length; i += 1) {
  //     bool isEven = nums[i] % 2 == 0;
  //     bool isLessThan99 = nums[i] < 99;
  //     if (isEven && isLessThan99) {
  //       total += nums[i];
  //     }
  //   }
  // }
}
