// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* Overflow / Underflow
- Code & Demo
- Preventive techniques
*/

contract Overflow {
  uint8 public x = 255; // [0; 2**8-1] --> [0; 255] / 0 <= x <= 255

  /// So uint8 cannot take a value >255; which means that "x" is already at max

  /// But what happen if we try to add one to x?
  constructor() {
    x += 1; // The answer is (IN SOLIDITY 0.8!) nothing because Solidity 0.8 prevent us from doing this mistake automatically
    /// So without doing anything, solidity will revert the tx because you can't add 1 to "x"

    unchecked {
      x += 1; // In solidity 0.8 if we add the "unchecked", we say at Solidity to not check and to not prevent
      /// So here we add 1 to x, but x cannot have 256, so we will return to original state --> 0
      /// so "x += 1" will be equal to 0; for all next tx, "x" will have 0; and that can be very bad for some SC
      /// NOTE that it apply also for int
    }

    /// Actually, if we do "x += 3", it'll not return to 0; when you add from max, it start counting from the begining, so "x += 3" will be 2
  }
}

/// Underflow are the inverse of Overflow
contract Underflow {
  uint8 public x; // [0; 2**8-1] --> [0; 255] / 0 <= x <= 255

  /// So uint8 cannot take a value >255; which means that "x" is already at min

  /// But what happen if we try to sub one to x?
  constructor() {
    x -= 1; // The answer is (IN SOLIDITY 0.8!) nothing because Solidity 0.8 prevent us from doing this mistake automatically

    unchecked {
      x += 1; // In solidity 0.8 if we add the "unchecked", we say at Solidity to not check and to not prevent
      /// So here we sub 1 to x, but x cannot have -1, so we will return to MIN state --> 255
      /// "x" is now eq to 255
      /// NOTE that it apply also for int
    }

    /// Actually, when you sub from min, it start counting from the end to start, so "x += 3" will be 253
  }
}

/// For Real life example: [https://youtu.be/zqHb-ipbmIo]
