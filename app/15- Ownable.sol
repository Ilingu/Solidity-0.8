// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Ownable {
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "You're not the owner");
    _;
  }

  function setOwner(address _newOwner) external onlyOwner {
    require(_newOwner != address(0), "invalid address");
    owner = _newOwner;
  }

  function RickRollD() external pure returns (string memory) {
    return "https://youtu.be/oHg5SJYRHA0";
  }

  function AdminFunc() external onlyOwner {} // only The Current Owner Can call this func

  function PublicFunc() external {} // Anyone can call this func
}
