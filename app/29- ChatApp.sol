// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ChatApp {
  // We can now quickly search by the sender and receiver of the message
  event Message(address indexed _from, address indexed _to, string message);

  function sendMessage(address _to, string calldata message) external {
    emit Message(msg.sender, _to, message); // Be aware that this message will be public on the entire blockchain
  }

  // Note that we don't have to store the message in mapping or arrays. Just using indexed event we can log on the blockchain a message (which is readonly). After on the client-side, we can use a library such as Ethers.js to retrieve all the message sent to the EOA.
}
