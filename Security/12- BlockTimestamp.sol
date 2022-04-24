// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Block timestamp manipulation

basic idea of the exploit:
- Miners can manipulate block.timestamp with some constraints

Constraints
- it must be after the previous block timestamp
- it cannot be too far in the future (MAX 15 secondes)

Solution: Don't use block.timestamp (especially if you use it for source of randomness, there are other solutions for randomness in solidity). But if you really have to use it, use the 15 seconde Rule: if your code don't mind that block.timestamp can varied by +15s in the future from the current time
*/
contract Roulette {
  constructor() payable {}

  function spin() external payable {
    require(msg.value >= 1 ether); // must send 1 ether to play

    /// Here a miner can manipulate block.timestamp so that it can be divisable by 7
    if (block.timestamp % 7 == 0) {
      (bool sent, ) = msg.sender.call{ value: address(this).balance }("");
      require(sent, "Failed to send Ether");
    }
  }
}
