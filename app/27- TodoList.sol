// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Insert, update, read from array of struct
contract TodoList {
  struct Todo {
    string text;
    bool completed;
  }

  Todo[] public todos;

  function create(string calldata _text) external {
    todos.push(Todo({ text: _text, completed: false }));
  }

  function updateText(uint256 _index, string calldata _text) external {
    todos[_index].text = _text;

    // Todo storage todo = todos[_index];
    // todo.text = _text;
  }

  function get(uint256 _index) external view returns (string memory, bool) {
    Todo storage todo = todos[_index]; // Here I use "storage" because it use less gas // when you're just reading the data, consider using "storage" over "memory", because memory will copy the entire var, whereas storage will only copy the pointer (so less gas)
    return (todo.text, todo.completed);
  }

  function tooggleCompleted(uint256 _index) external {
    Todo storage todo = todos[_index];
    todo.completed = !todo.completed;
  }
}
