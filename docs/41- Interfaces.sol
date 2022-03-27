// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/* Let's imagine we don't have access to this code, it was coded by someone else, and already deployed on blockchain */
/// PS: in real life, it's thousand lines of codes
// contract Counter {
//   uint256 public count;

//   function inc() external {
//     count += 1;
//   }

//   function dec() external {
//     count -= 1;
//   }
// }

/// However you want to call this contract "Counter", and we've seen that to call another contract you have to provide his "code". Nonetheless You don't have his code or copy thousand line of code would be very expensive at deploy time. So how can we do ? -> Interface, if you know his shape, you can create his code with an interface
interface ICounter {
  /// ICounter, means the "Interface of Counter", it's a writting convention, follow it or not.
  /// Note: we define a shape of a contract, we don't code the contract, so function ends with ";" / Also an interface is only composed of functions even for variable

  function count() external view returns (uint256); // -> Note: for state variable, we defined their getter function (it's something automatically made by solidity at compile time, state variables are in practice just getter/setter)

  function inc() external;

  function dec() external;
}

/// Now that we have the shape of the Counter contract, we can call it exactly like we learn it!
contract CallInterface {
  uint256 public count;

  function examples(address _counter) external {
    ICounter(_counter).inc(); // -> We can now apply the same methods to call contract
    count = ICounter(_counter).count();
  }
}
