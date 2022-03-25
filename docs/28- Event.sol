// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Event store data on archives nodes. It emit a message to the blockchain, so It can be useful to response to the client-side after tx
contract Event {
  event Log(string message, uint256 val);
  event IndexedLog(address indexed sender, uint256 val); // Index this event on the blockchain

  // ⚡ However, You can't index all your params --> up to 3 max index params -> That's why I only put indexed on the address, because to find the event, it'll be more easy to search by unique indentifier aka address. On comparaison searching by value is completly useless

  // This function is nor "view" nor "pure" because emitting an event, store the event on the blockchain
  function pay() external payable {
    emit Log("Your payment: ", msg.value);
    emit IndexedLog(msg.sender, msg.value); // Imagine bob call this function 10x, next alice call it 20x, thanks to indexed events we will be able to find the bob event very quickly, without the indexed keyword, we'd have to search and loop over all the events to find the bob event (in this example we are lopping over 30 events, but in real world, it's much more)
  }
}
