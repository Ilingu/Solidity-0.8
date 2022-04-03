// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HashFunc {
  /// To Hash Smt in Solidity we use keccak256, which take bytes to hash and returns his hash
  /// So if you have multiple args to hash of different type you'll have to use "abi.encode()" or encodePacked
  function hash(
    string memory text,
    uint256 num,
    address addr
  ) external pure returns (bytes32) {
    return keccak256(abi.encodePacked(text, num, addr));
  }

  /// Extra
  /// encode() encode data into bytes, e.g for "aa" and "bb" as input we might have smt like that (actually it's way more longer): 0x00000000040000000000000000000000000261610000000000000000000000000000000000000000000000000000000026262000000000000000000000000000
  /// whereas encodePacked() encode data into bytes then compress it: so with same example -- 0x61616262
  /// but that also say that with encodePacked() with two different input you can have the same output and so the same hash
  // e.g: input "aa", "bb" = 0x61616262 <=> "a", "abb" = 0x61616262 --> Collision, So be careful
  function encode(string memory text0, string memory text1)
    external
    pure
    returns (bytes memory)
  {
    return abi.encode(text0, text1);
  }

  function encodePacked(string memory text0, string memory text1)
    external
    pure
    returns (bytes memory)
  {
    return abi.encodePacked(text0, text1);
  }

  function collision(string memory text0, string memory text1)
    external
    pure
    returns (bytes32)
  {
    return keccak256(abi.encodePacked(text0, text1));
    // "a", "abb" and "aa", "bb" will output 0x61616262 so keccak will hash the same byte, therefore the hash will be the same for these two group of inputs even though they aren't the same
  }
}
