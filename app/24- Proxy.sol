// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TestContract1 {
  address public owner = msg.sender;

  function setOwner(address _owner) public {
    require(msg.sender == owner, "not the owner");
    owner = _owner;
  }
}

contract TestContract2 {
  address public owner = msg.sender;
  uint256 public value = msg.value;
  uint256 public x;
  uint256 public y;

  constructor(uint256 _x, uint256 _y) payable {
    x = _x;
    y = _y;
  }
}

contract Proxy {
  event Deploy(address);

  function deploy(bytes memory _code) external payable returns (address addr) {
    assembly {
      // create(v, p, n) --> Deploy a contract with his bytecode
      // v = amount of ETH to send
      // p = pointer in memory to start the code
      // n = size of code
      addr := create(callvalue(), add(_code, 0x20), mload(_code))
    }

    require(addr != address(0), "Deploy failed");
    emit Deploy(addr);
  }

  // Execute a deployed contract function
  function execute(
    address _target,
    bytes memory _data /* We get the _data with Helper.getCalldata(); */
  ) external payable {
    (bool success, ) = _target.call{ value: msg.value }(_data);
    require(success, "failed");
  }
}

contract Helper {
  // get TestContract1
  function getBytecode1() external pure returns (bytes memory) {
    bytes memory bytecode = type(TestContract1).creationCode; // Return Bytecode of contract
    return bytecode;
  }

  // get TestContract2
  function getBytecode2(uint256 _x, uint256 _y)
    external
    pure
    returns (bytes memory)
  {
    bytes memory bytecode = type(TestContract2).creationCode; // Return Bytecode of contract
    return abi.encodePacked(bytecode, abi.encode(_x, _y)); // Append the arg of TestContract2 constructor to the bytecode
  }

  function getCalldata(address _owner) external pure returns (bytes memory) {
    return abi.encodeWithSignature("setOwner(address)", _owner);
  }
}
