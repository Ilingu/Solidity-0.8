// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// DataLocation - storage, memory and calldata

contract DataLocation {
  // storage --> the data is a state variable (can't be used for function args)
  // memory --> data loaded on memory (used for both function agrs and variables)
  // calldata --> like "memory", but can only be used for **function args** and is READONLY (compared to memory, it saves gas, because you can't change it so if you pass the arg to another func arg it won't recopy the data)

  struct MyStruct {
    uint256 foo;
    string text;
  }

  mapping(address => MyStruct) public myStructs;

  function examples(uint256[] calldata y, string memory s)
    external
    returns (
      uint256[] memory // --> The data to return is in the memory and it's of type uint
    )
  {
    myStructs[msg.sender] = MyStruct({ foo: 123, text: "bar" });

    // Storage
    MyStruct storage myStruct = myStructs[msg.sender]; // Point to myStructs var, so if we made change, we also made them on myStructs
    myStruct.text = "foo"; // The real var "myStructs" is changed in the state

    // Memory
    MyStruct memory myStructReadOnly = myStructs[msg.sender]; // Copy myStructs[msg.sender] in memory. So if we made change the real state variable "myStructs" won't change, "myStructReadOnly" is readonly and not link to myStructs
    myStructReadOnly.foo = 456; // We can change, but here we change the copy of "myStructs[msg.sender]" loaded in memory (so not the state variable "myStructs"), besides the memory is cleared at the end of a function execution, this change in memory won't be save.

    uint256[] memory memArr = new uint256[](3); // See Array Section
    memArr[0] = 234;
    return memArr;
  }
}
