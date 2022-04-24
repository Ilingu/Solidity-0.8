// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* Front Running:
Front Running is when a tx is mined before you even though you send it before (higher gas was sent by other)
So Imagine you know a way to unlock 10Eth in a SC, you send the tx and it get delayed to the MiningPool, at this time a random guy see that and decide to do the same thing but send more gas, so his tx will be delayed to the MiningPool and it's more likely that he will be mine before you and therefore we will steal your 10 Eth (In reality, this random guy is a bot 🤖) 
*/

/* Exemple:
Alice creates a guessing game.
You win 10 ether if you can find the correct string that hashes to the target
hash. Let's see how this contract is vulnerable to front running.
*/

/*
1. Alice deploys FindThisHash with 10 Ether.
2. Bob finds the correct string that will hash to the target hash. ("Ethereum")
3. Bob calls solve("Ethereum") with gas price set to 15 gwei.
4. Eve is watching the transaction pool for the answer to be submitted.
5. Eve sees Bob's answer and calls solve("Ethereum") with a higher gas price
   than Bob (100 gwei).
6. Eve's transaction was mined before Bob's transaction.
   Eve won the reward of 10 ether.

What happened?
Transactions take some time before they are mined.
Transactions not yet mined are put in the transaction pool.
Transactions with higher gas price are typically mined first.
An attacker can get the answer from the transaction pool, send a transaction
with a higher gas price so that their transaction will be included in a block
before the original.
*/

contract FindThisHash {
  bytes32 public constant hash =
    0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

  constructor() payable {}

  function solve(string memory solution) public {
    require(hash == keccak256(abi.encodePacked(solution)), "Incorrect answer");

    (bool sent, ) = msg.sender.call{ value: 10 ether }("");
    require(sent, "Failed to send Ether");
  }
}
