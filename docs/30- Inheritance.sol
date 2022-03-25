// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract A {
  // virutal means that this func can be inherited and customized
  function ThisContract() public pure virtual returns (string memory) {
    return "A";
  }

  // This func can be inherited but not overrided
  function ParentContract() public pure returns (string memory) {
    return "A";
  }

  // This func can be inherited but not overrided
  function BestProgrammer() public pure virtual returns (string memory) {
    return "Me!";
  }
}

/* Lot of duplicate codes just for using same functions as contract A and rename the output -_- */
// contract B_Wrong_Way {
//   function ThisContract() public pure returns (string memory) {
//     return "B";
//   }
// }

// Contract B inherit all Contract A varaible/functions
contract B is A {
  // we write the func to override and put the "override" to change the code inside
  function ThisContract() public pure override returns (string memory) {
    return "B"; // If we call this func from contract B, the output will now be "B"
  }

  // If we call "ParentContract()" form contract B, the output will be "A"

  // We override this func, and put it "virtual" so the children of B will be able to reoverride it
  function BestProgrammer()
    public
    pure
    virtual
    override
    returns (string memory)
  {
    return
      "Like Not Me, but we you will read it, you will read 'Me', so it's YOU! ";
  }
}

// C inherit B which inherit A --> So C inherit both B and A var/func
contract C is B {
  // If we call "ParentContract()" form contract C, the output will be "A"

  function BestProgrammer() public pure override returns (string memory) {
    return "To flatten a bit; YOU ARE THE BEST PROGRAMMER EVER!!";
  }
}
