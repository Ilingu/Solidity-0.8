// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Account {
  address public bank;
  address public owner;

  constructor(address _owner) payable {
    bank = msg.sender;
    owner = _owner;
  }
}

contract AccountFactory {
  Account[] public accounts; // Note: if we look at this var we will see the deployed contracts address

  function createAccount(address _owner) external payable {
    Account accountContract = new Account{ value: msg.value }(_owner);
    accounts.push(accountContract);
  }
}
