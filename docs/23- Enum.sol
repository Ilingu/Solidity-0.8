// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Enum {
  // Enum are just uint
  enum Status {
    None, // 0
    Pending, // 1
    Shipped, // ...
    Completed,
    Rejected,
    Canceled
  }
  Status public status;

  struct Order {
    address buyer;
    Status status;
  }
  Order[] public orders;

  function get() external view returns (Status) {
    return status;
  }

  function set(Status _status) external {
    status = _status;
  }

  function ship() external {
    status = Status.Shipped;
  }

  function reset() external {
    delete status; // Reset to 0 (So "None")
  }
}
