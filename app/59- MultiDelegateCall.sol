// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MultiDelegatecall {
  error DelegatecallFailed();

  function multiDelegatecall(bytes[] calldata data)
    external
    returns (bytes[] memory results)
  {
    results = new bytes[](data.length); // Instanciate a array of bytes of length data.length

    for (uint256 i; i < data.length; i++) {
      (bool success, bytes memory result) = address(this).delegatecall(data[i]);
      if (!success) revert DelegatecallFailed();
      results[i] = result;
    }
  }
}

/// Why use multi delegatecall? Why not multi call?
/// Alice -> multi call --- call ---> test (msg.sender = multi call contract)
/// Alice -> multi delegate call --- delegatecall ---> test (msg.sender = Alice)
contract TestMultiDelegatecall is MultiDelegatecall {
  event Log(address caller, string func, uint256 i);

  function func1(uint256 x, uint256 y) external {
    emit Log(msg.sender, "func1", x + y);
  }

  function func2() external returns (uint256) {
    emit Log(msg.sender, "func1", 2);
    return 111;
  }

  mapping(address => uint256) public balanceOf;

  /// WARNING: unsafe code when used in combination with multi-delegatecall
  /// user can mint multiple times for the price of msg.value: [mint(), mint(), mint()...]
  function mint() external payable {
    balanceOf[msg.sender] += msg.value;
  }
}

contract Helper {
  function getFunc1Data(uint256 x, uint256 y)
    external
    pure
    returns (bytes memory)
  {
    return abi.encodeWithSignature("func1(uint2256, uint256)", x, y);
  }

  function getFunc2Data() external pure returns (bytes memory) {
    return abi.encodeWithSelector(TestMultiDelegatecall.func2.selector);
  }

  function getMintData() external pure returns (bytes memory) {
    return abi.encodeWithSelector(TestMultiDelegatecall.mint.selector);
  }
}
