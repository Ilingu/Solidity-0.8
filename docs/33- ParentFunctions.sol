// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
calling parent functions
- directly
- with "super" keyword

    E
  ↙   ↘
 F     G
  ↘   ↙
    H

Order: E, F, G, H
*/

contract E {
  event Log(string message);

  function foo() public virtual {
    emit Log("E.foo");
  }

  function bar() public virtual {
    emit Log("E.bar");
  }
}

contract F is E {
  function foo() public virtual override {
    emit Log("F.foo"); // Here we call Event Log from E contract
    E.foo(); // 1. Call The func foo of E (and not F)
  }

  function bar() public virtual override {
    emit Log("F.bar");
    super.bar(); // 1. Call The func bar of the parent contract (which is E)
  }
}

contract G is E {
  function foo() public virtual override {
    emit Log("F.foo");
    E.foo();
  }

  function bar() public virtual override {
    emit Log("F.bar");
    super.bar();
  }
}

contract H is F, G {
  function foo() public virtual override(F, G) {
    emit Log("H");
    F.foo(); // F is called
    E.foo(); // E is called
  }

  function bar() public virtual override(F, G) {
    super.bar(); // Which one gets called ?
    // --> All parents: G.bar() -> F.bar() -> E.bar()
  }
}
