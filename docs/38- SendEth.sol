// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* 3 Ways to send ETH
-> transfer - 2300 gas, reverts if error --> Can be used only for sending ETH
-> call - all gas, retuns bool and data --> The most complete func, not only for sending ETH
-> send - 2300 gas, returns bool (successful of not) --> Not very useful when we have transfer
*/

contract SendEth {
  constructor() payable {}

  receive() external payable {}

  function sendViaTransfer(address payable _to) external payable {
    _to.transfer(123);
  }

  /// Send Function is not very recommanded, use Transfer or Call
  function sendViaSend(address payable _to) external payable {
    bool success = _to.send(123);
    require(success, "Send Failed");
  }

  function sendViaCall(address payable _to) external payable {
    /// We will look more deeply into call in lesson 42, but just know that call() is not just for sending eth, it goes further
    (bool success, ) = _to.call{ value: 123 }("");
    require(success, "Call Failed");
  }
}

contract EthReceiver {
  event Log(uint256 amount, uint256 gas);

  receive() external payable {
    emit Log(msg.value, gasleft());
  }
}
