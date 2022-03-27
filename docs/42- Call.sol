// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TestCall {
  string public message;
  uint256 public x;

  event Log(string message);

  fallback() external payable {
    emit Log("Fallback was called");
  }

  function foo(string memory _message, uint256 _x)
    external
    payable
    returns (bool, uint256)
  {
    message = _message;
    x = _x;
    return (true, 999);
  }
}

/// Call can be used to call any address on the blockchain (EOA/contract) without his shape (in case of contract)
/// It's also known as the 3rd method to call contracts functions (See Section 40)
contract Call {
  bytes public data;

  function callFoo(address _test) external {
    /// Here we call "TestCall" only with by his address, so to call a func, we have to specify which func to call (without spaces for params) and pass the params data
    /// Then call will return if the tx success and the data that the function called returned
    /// Here we specify the value of ETH to send, and the restriction of gas we want to use (gas max)
    (bool success, bytes memory _data) = _test.call{ value: 111, gas: 5000 }(
      abi.encodeWithSignature("foo(string,uint256)", "call foo", 123) /// We'll discover the ABI api later
    );
    require(success, "call failed"); // This call is very likely to revert, because we send 5000 gasmax, and 5000 is not enough to set state variable

    data = _data;
  }

  function callDoesNotExist(address _test) external {
    /// We are trying to call a function that does not exist, but since "TestCall" have a fallback, fallback will be trigger.
    (bool success, ) = _test.call(abi.encodeWithSignature("doesNotExist()"));
    require(success, "call failed"); // If "TestCall" doesn't have a fallback, this tx would fail
  }
}
