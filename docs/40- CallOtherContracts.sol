// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract CallTestContract {
  function setX(address _test, uint256 _x) external {
    TestContract(_test).setX(_x); // 1rt Method -> Init with contract struct, and pass his address, then call func
  }

  function getX(TestContract _test) external view returns (uint256 x) {
    x = _test.getX(); // 2nd Method -> Init with contract struct and address in params, then call func directly with param
  }

  function setXAndSendEth(address _test, uint256 _x) external payable {
    TestContract(_test).setXAndReceiveEther{ value: msg.value }(_x); // Syntax for sending ether to the contract function
  }

  function getXandValue(TestContract _test)
    external
    view
    returns (uint256 x, uint256 val)
  {
    (x, val) = _test.getXandValue();
  }

  /// Note: There is another way to call contracts, only by his address, see you in section 42
}

contract TestContract {
  uint256 public x;
  uint256 public value = 123;

  function setX(uint256 _x) external {
    x = _x;
  }

  function getX() external view returns (uint256) {
    return x;
  }

  function setXAndReceiveEther(uint256 _x) external payable {
    x = _x;
    value = msg.value;
  }

  function getXandValue() external view returns (uint256, uint256) {
    return (x, value);
  }
}
