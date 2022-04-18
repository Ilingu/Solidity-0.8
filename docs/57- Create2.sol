// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract DeployWithCreate2 {
  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }
}

contract Create2Factory {
  event Deploy(address addr);

  function deploy(uint256 _salt) external {
    /// Basic Way to create new contract (with "new" keywork)
    // DeployWithCreate2 _contract = new DeployWithCreate2(msg.sender);
    // emit Deploy(address(_contract));

    /// Create2 method, salt is a random number which can precompute the contract address (before his deploy)
    DeployWithCreate2 _contract = new DeployWithCreate2{ salt: bytes32(_salt) }(
      msg.sender
    );
    emit Deploy(address(_contract)); // Returns: 0xF7F18f02c3A1D393f588Dea0079263985746C5d3 (with salt=777)
  }

  function getAddress(bytes memory bytecode, uint256 _salt)
    public
    view
    returns (address)
  {
    bytes32 hash = keccak256(
      abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))
    );

    return address(uint160(uint256(hash))); // Returns: 0xF7F18f02c3A1D393f588Dea0079263985746C5d3 (with salt=777)
  }

  function getBytecode(address _owner) public pure returns (bytes memory) {
    bytes memory bytecode = type(DeployWithCreate2).creationCode;
    return abi.encodePacked(bytecode, abi.encode(_owner)); // Append Contract Constructor Args to the his bytecode
  }
}
