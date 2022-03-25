// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Payable Function are function that can receive real Ether.
// Payable address are address that can manipulate real Ether (send or receive).
contract Payable {
  address public address1; // --> Not payable, it can't receive eth
  address payable public owner; // --> Is payable, it can receive eth

  constructor() {
    // owner = msg.sender; --> Error: msg.sender is of type address though "owner" want a payable address.
    owner = payable(msg.sender); // Here the code to transform an address to an payable address
  }

  function depositEth() external payable {
    // This Function can now receive real Ether, so if an EOA send ETH, it'll be added to the Contract balance
    // you can access the amount of ether (in wei --> 1eth = 10**18wei) with "msg.value"
    // You don't have to code anything else than "payable" to permit the function to receive eth (the transfer to the balance is automatic)
    // Note that without the "payable" keyword, this function won't be able to receive eth, so if an EOA send eth to this function it will revert and throw an error (don't worry the eth sent are returned to the EOA)
  }

  function getBalance() external view returns (uint256) {
    return address(this).balance; // "this" is the contract instance, we transform it to an address, next we ask "how many eth this address have ?" with "balance"
  }
}
