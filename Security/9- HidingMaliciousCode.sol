// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* Hiding milicious code
- Contract hiding malidicious code walkthrough
- Exploit
*/
contract Bar {
  event Log(string message);

  function log() public {
    emit Log("Bar was called");
  }
}

contract Foo {
  Bar bar;

  constructor(address _bar) {
    /// here instead of setting the contract to the Bar contract, we will set the bar address to Mal Contract, so that when we verified our contract on Etherscan the person think that it's Bar contract that is called (we just play with the code)
    bar = Bar(_bar);
  }

  function callBar() public {
    /// Yea because just to let you know that when we call bar.log(), solidity will do "address(bar).call(logSignature)"
    bar.log();
  }
}

/// In separate file (On IPFS ect...)
contract Malicious {
  event Log(string message);

  function log() public {
    emit Log("Mal was called");
    // Malicious code here
  }
}
