// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Forcing ether with selfdestruct
Code && Prevention
*/

/// Foo cannot in any way receive ETH (no fallback/receive/payable func)
contract Foo {
  function getBalance() external view returns (uint256) {
    return address(this).balance;
  }
}

contract Attack {
  function kill(address payable addr) public {
    /// See docs/49- Kill.sol
    selfdestruct(payable(addr));
    /// Here "selfdestruct" will kill this contract and send all its ETH to "addr"; in the case of this specific function even if the recipient address has not way to receive ether, the address will still receive this contract ETH
    /// So if "addr" is the address of "Foo", Foo will be forced to accept this contract ETH
  }

  /// To prevent this behiavor; Foo cannot rely on his balance, he will have to keep track of all address who send eth
}

/// For Real life example: [https://youtu.be/cODYglsn3bs]
