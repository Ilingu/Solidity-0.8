// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* HoneyPot - A honeypot is a trap to catch hackers
Exemple code - Reentrancy and hiding code (we will hide the code to debuscate the hackers from the verified code on Etherscan, so that the hacker can't figure out the honeypot, go see "Security/9- HidingMaliciousCode.sol")
*/
contract Bank {
  mapping(address => uint256) public balances;
  Logger logger;

  constructor(Logger _logger) {
    /// Here we will not pass the Logger address but our honeypot address
    logger = Logger(_logger);
  }

  function deposit() public payable {
    balances[msg.sender] += msg.value;
    logger.log(msg.sender, msg.value, "Deposit");
  }

  function withdraw(uint256 _amount) public {
    require(_amount <= balances[msg.sender], "Insufficient funds");
    (bool success, ) = msg.sender.call{ value: _amount }("");
    require(success, "Failed to send Ether");
    /// Vunerable to Reentrancy
    balances[msg.sender] -= _amount;
    logger.log(msg.sender, _amount, "Withdraw");
  }
}

contract Logger {
  event Log(address caller, uint256 amount, string action);

  function log(
    address _caller,
    uint256 _amount,
    string memory _action
  ) public {
    emit Log(_caller, _amount, _action);
  }
}

/// We don't publish this code on Etherscan
contract HoneyPot {
  event Log(address caller, uint256 amount, string action);
  error Trap(string reason);

  function log(
    address _caller,
    uint256 _amount,
    string memory _action
  ) public pure {
    /// Method to compare two string in solidity (use less gas than doing char by char)
    if (keccak256(abi.encode(_action)) == keccak256(abi.encode("Withdraw")))
      revert Trap("It's a trap"); // This will revert the entire tx, so that everybody will be able to see the address of the hacker
  }
}
