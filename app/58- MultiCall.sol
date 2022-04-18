// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/// Do mutliple call at once

contract TestMultiCall {
  function func1() external view returns (uint256, uint256) {
    return (1, block.timestamp);
  }

  function func2() external view returns (uint256, uint256) {
    return (2, block.timestamp);
  }

  function getDatas1() external pure returns (bytes memory) {
    return abi.encodeWithSelector(this.func1.selector);
    // SAME AS: abi.encodeWithSignature("func1()");
  }

  function getDatas2() external pure returns (bytes memory) {
    return abi.encodeWithSignature("func2()");
    // SAME AS: abi.encodeWithSelector(this.func2.selector);
  }
}

contract MultiCall {
  /// "targets" are address (since we use "call()", here it'll be twice the TestMultiCall Contract)
  /// "data" are the functions signature to call on the target of same index
  function multiCall(address[] calldata targets, bytes[] calldata data)
    external
    view
    returns (bytes[] memory)
  {
    require(targets.length == data.length, "target length != data length");
    bytes[] memory results = new bytes[](data.length); // Instanciate a array of bytes of length data.length

    for (uint256 i; i < targets.length; i++) {
      (bool success, bytes memory result) = targets[i].staticcall(data[i]); /// staticcall is similar to call
      require(success, "call failed");
      results[i] = result;
    }

    return results;
    /// Returns: [0x000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000625dcf0,0x000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000625dcf0d]

    /// 0000000000000000000000000000000000000000000000000000000000000001 -->  func1 first return (1)
    /// 00000000000000000000000000000000000000000000000000000000625dcf0 --> func1 seconde return (timestamp)
    /// We can easily see that the func1 && func2 return timestamp are the same, that because we call these two function at the same time (batched call)
  }
}
