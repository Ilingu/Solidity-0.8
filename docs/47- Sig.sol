// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
0. message to sign
1. hash(message)
2. sign(hash, privateKey) | offchain
3. ecrecover(hash(message), signature) == signerAddress
*/

contract verifySig {
  function verify(
    address _signer,
    string memory _message,
    bytes memory _sig
  ) external pure returns (bool) {
    bytes32 messageHash = getMessageHash(_message); /// Normally done offchain
    bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash); /// Normally done offchain

    return recover(ethSignedMessageHash, _sig) == _signer;
  }

  function getMessageHash(string memory _message)
    public
    pure
    returns (bytes32)
  {
    return keccak256(abi.encodePacked(_message));
  }

  function getEthSignedMessageHash(bytes32 _messageHash)
    public
    pure
    returns (bytes32)
  {
    return
      keccak256(
        abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
      );
  }

  function recover(bytes32 ethMsg, bytes memory _sig)
    public
    pure
    returns (address)
  {
    (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
    return ecrecover(ethMsg, v, r, s);
  }

  function _split(bytes memory _sig)
    internal
    pure
    returns (
      bytes32 r,
      bytes32 s,
      uint8 v
    )
  {
    require(_sig.length == 65, "Invalid Sig Length");

    assembly {
      r := mload(add(_sig, 32))
      s := mload(add(_sig, 64))
      v := byte(0, mload(add(_sig, 96)))
    }
  }
}
