// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* When you declare a variable as "private" it juste mean other contract can't interact with it, it's private from outsite tx but that doesn't mean you can't read the variable because anything on a blockchain is PUBLIC and accessible by all

- Vulnerability
- Storage layout
- Setup
- Code
- Demo
- Preventative Technique
*/

/* EVM
 ______________
| Contract     | -> EVM will store all these variable into a huge array of 2**256 slots, in each slot you can store MAX 32 bytes
|              | 
| bytes32 foo  | -> `foo` is declare 1st, so we will take all the 1st slot space (type: bytes32 and one slot = 32 bytes)
| bytes32 bar  | -> `bar` is declare 2nd, so we will take all the 2nd slot space (type: bytes32 and one slot = 32 bytes)
| uint256 num  | -> `num` value will be stored in hex in the 3rd slot and uint256 need 32 bytes in hex: `num` take all the 3rd space
| address addr | -> `addr` stored in 4th slot, address type take 20 bytes, thus it remain 12 bytes not allocated in the 4th slot
| bool boo     | -> `bool` only need 1 bit, so EVM'll store `boo` in the 4th, now the 4th slot have 11 bytes not allocated
|______________| -> If we add a last imaginary var called "foo2" of type bytes32, it'll need a entire slot, so even though it remain 11 bytes in slot 4, "foo2" will be stored in slot 5, therefore the 11 remaining bytes of slot 4 will be never allocated 
*/

contract Vault {
  /// slot 0
  uint256 public count = 123;
  /// slot 1
  address public owner = msg.sender; // 20 bytes
  bool public isTrue = true; // 1 byte
  uint16 public u16 = 31; // 2 byte
  /// slot 2
  bytes32 private password; // Accessible by calling this contract at slot 2

  /// constant do not use storage (hardcoded in contract bytecode)
  uint256 public constant someConst = 123;

  /// slot 3, 4, 5 (one for each array element)
  bytes32[3] public data;

  struct User {
    uint256 id;
    bytes32 password;
  }

  /// slot 6 - where the length of this dynamic array is stored
  /// Array datas is stored on the keccak256(slot_of_length), so here array elements are stored in keccak256(6)
  /// Slot where array element is stored = keccak256(slot) + (index * elementSize)
  User[] private users;

  /// slot 7 - empty
  /// entries are stored at keccak256(key, slot) -> keccak256(key, 7)
  mapping(uint256 => User) private idToUser;

  /* HELPER FUNC */
  constructor(bytes32 _password) {
    password = _password;
  }

  function addUser(bytes32 _password) public {
    User memory user = User({ id: users.length, password: _password });

    users.push(user);
    idToUser[user.id] = user;
  }

  function getArrayLocation(
    uint256 slot,
    uint256 index,
    uint256 elementSize
  ) public pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(slot))) + (index * elementSize);
  }

  function getMapLocation(uint256 slot, uint256 key)
    public
    pure
    returns (uint256)
  {
    return uint256(keccak256(abi.encodePacked(key, slot)));
  }
}
