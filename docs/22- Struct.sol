// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Struct {
  // Struct -> Structure a object, defining the shape of an object
  struct Car {
    string model;
    uint256 year;
    address owner;
  }

  // Assigning Struct
  Car public car;
  Car[] public cars;
  mapping(address => Car[]) public carsByOwner;

  // Initialize a Struct
  function examples() external {
    Car memory toyota = Car("Toyota", 1990, msg.sender);
    Car memory lambo = Car({
      year: 1980,
      model: "Lamborghini",
      owner: msg.sender
    });

    Car memory tesla; // No inti: Hold default val: ("", 0, address(0))
    tesla.year = 2010;
    tesla.owner = msg.sender;
    tesla.model = "Tesla";

    cars.push(toyota);
    cars.push(lambo);
    cars.push(lambo);

    cars.push(Car("Ferrari", 2020, msg.sender)); // Same than store in memory var

    // Get and update
    Car storage _car = cars[0];
    // Memory = Clone the state var to memory, so when the func end, the memory is unloaded and all change are gone/not saved in the state var
    // Storage = Copy Pointer of the state var, so if we made changes, it'll persist after func end
    _car.year = 1999;
    _car.model = "TOyOtA";
    delete _car.owner; // Reset to default
  }
}
