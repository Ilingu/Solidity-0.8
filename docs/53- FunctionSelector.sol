// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Receiver {
  event Log(bytes data);

  function transfer(address _to, uint256 _amount) external {
    emit Log(msg.data);
    /// -> First 4 bytes return the function to call, the rest is the args (in Hex)
    /// 0xa9059cbb --> transfer (called "Function Selector")
    /// 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc --> _to
    /// 4000000000000000000000000000000000000000000000000000000000000000b --> _amount
  }
}

contract FunctionSelector {
  function getSelector(string calldata _func) external pure returns (bytes4) {
    return bytes4(keccak256(bytes(_func)));
    /// The func selector is the first 4 bits of the hash of the func sig, so convert msg.data into bytes, then hash it and retrive the first 4 bytes by converting it into a bytes4
    /// Here the func sig of "Receiver.transfer()": "transfer(address,uint256)" and by passing it into this func it returns "0xa9059cbb", exactly the same as written above
  }
}
