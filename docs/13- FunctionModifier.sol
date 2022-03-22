// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Reuse code before and / or after function
// Basics, inputs, sandwich
contract FunctionModifier {
  // --> Like Middleware, little piece of code run when after an function execution
  // Execution Order: Function called -> Modifier Called -> Modifier Code Executed (If Error revert) -> Function Code Executed ("_;")
  bool public paused;
  uint256 public count;

  function setPause(bool _paused) external {
    paused = _paused;
  }

  modifier whenNotPaused() {
    require(!paused, "Contract Is Paused");
    _; // --> To Call The Real Function. Because A Modifier wrap the function we want to execute, it's like a "next()"
  }
  modifier cap(uint256 _x) {
    require(_x < 100, "Max Amount is 100"); // With Args
    _; // Call Func
  }
  modifier sandwich() {
    count += 10; // Before Function Call
    _; // Call the function -- function execution
    count *= 2; // After the Function Execution
  }

  function inc() external whenNotPaused {
    // require(!paused, "Contract Is Paused"); --> Moved in whenNotPaused
    count++;
  }

  function dec() external whenNotPaused {
    // require(!paused, "Contract Is Paused"); --> Moved in whenNotPaused
    count--;
  }

  // Sum Modifier on top of each other
  function incBy(uint256 _x) external whenNotPaused cap(_x) {
    count += _x;
  }

  function foo() external sandwich {
    // Modifier: count += 10;
    count += 10; // --> Main Func
    // Modifier: count * = 2;
  }
}
