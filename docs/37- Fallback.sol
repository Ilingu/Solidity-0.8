// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Fallback is executed when
- Targeted Function in Tx doesn't exist
- Directly sending ETH without calling a function (=receive())
- Primarly used for sending eth to an contract

fallback() or receive() ?

  Ether is sent to contract
             |
      is msg.data empty ?
            /   \
          yes    no
          /       \ 
receive() exists?  fallback()
      /    \
    yes     no
    /         \
receive()      fallback()
*/
contract Fallback {
  event Log(string func, address sender, uint256 value, bytes data);

  fallback() external payable {
    emit Log("Fallback", msg.sender, msg.value, msg.data);
  }

  receive() external payable {
    emit Log("Receive", msg.sender, msg.value, "");
    // Note that you can't use msg.data inside receive(), it'll throw an error.
  }
}
