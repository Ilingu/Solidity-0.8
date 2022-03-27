// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/// Definition: Delegate call executes code in another contract in the context of the contract that called
/// It's important to understand this notion, especially for when we'll see Reentrancy later

/*
Regular Call:
A calls B, sends 100 wei
        B calls C, sends 50 wei

A --> B --> C
Inside of C: msg.sender = B
             msg.value = 50
             execute code on C's state variables
             use ETH in C        
*/

/*
Delegate Call:
A calls B, sends 100 wei
        B delegate call C

A --> B --> C where C execute direcly inside of B (like C "hacked" B) because delegatecall preserve the context of B
Inside of C: msg.sender = A
             msg.value = 100
             execute code on B's state variables
             use ETH in B
*/

contract TestDelegateCall {
  uint256 public num;
  address public sender;
  uint256 public value;

  function setVars(uint256 _num) external payable {
    num = _num;
    sender = msg.sender;
    value = msg.value;
  }
}

contract DelegateCall {
  uint256 public num;
  address public sender;
  uint256 public value;

  function setVars(address _test, uint256 _num) external payable {
    /// encodeWithSelector & encodeWithSignature does the same: If you have the contract code inside the codebase, it's more simple to encore with selector, because if you change setVars' params, you won't have to change the string here
    // _test.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
    (bool success, ) = _test.delegatecall(
      abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
    );
    require(success, "DelegateCall failed");
    /// If you understood "delegatecall", you already know that the setVars of TestDelegateCall func won't change it's own state variable, because the context will be the contract how send the delegatecall, so the variable that setVars will change are the DelegateCall ones. Here we only borrow the "TestDelegateCall setVars" function for our own use
    /// Also you have to understand that the code inside of "TestDelegateCall setVars" can be dangerous code, and because TestDelegateCall have all YOUR contract context, he can easily take all the contract balance --> this attack is called Reentrency
    /// Advanced note: here that work because the two contract states variables are exactly the same and in the same order, if we change it or add a new variable, you will experience weird stuff, that because we change the storage layout, which is a export topic covered in /Security section (Accessing Private Data)
  }
}
