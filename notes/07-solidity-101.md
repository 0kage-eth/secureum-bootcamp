# SOLIDITY 101

[Video](https://www.youtube.com/watch?v=5eLqFac5Tkg)

## Summary

Cover basics of solidity from a security standpoint. Not focusing on writing contracts, but analyzing from security perspective. In this we cover solidity basics, file layout and state variables

### Intro

- High level language for smart contracts in ethereum
- Converts programmer instructions into bytecode that is interpreted by EVM
- 2014 - Gavin Wood
- Extensively used, few alternatives, solidity is fundamental primitive of crypto
- Influenced by C++, to minor extend Python and Javascript
- Vyper is catching up as an alternative
- Solidity is mature -> supporting ecosystem and toolchains

---

### Features

- curly bracker language
- object oriented
- statically typed - types of variables are static
- inheritance, libraries and user-defined types are supported

---

### File Layout

**SPDX**

- SPDX License Identifier - (Software Package Data Exchange). Its a comment that is defined at beginning. Defines License type of contract. This is included by compiler in bytecode (becomes machine readable)

eg.

```
   //SPDX-License-Identifier:MIT
```

**pragma**

- `pragma` keyword - used to enable compiler version and make some checks

  - specify version of compiler `pragma solidity ^0.8.0` denotes version number 0.8.0 and above
  - version of abi coder can also be specified `pragma abicoder v1` or `pragma abicoder v2`. By default after 0.8.0, abicoder v2 is activated.
  - you can also add experimental features eg `pragma experimental SMTChecker`
  - Every file has its own pragma - if a file has an imported file, pragmas from imported file do NOT carry over to current file
  - `pragma version x.y.z` instructs compiler during compilation time to check if its version matches with the version on file specified by developer. In `x.y.z`, change in `y` means there are 1 or more breaking changes.
  - floating pragma looks like `pragma version ^x.y.z` -> contract can be compiled with versions starting with `x.y.z` to `x.y+1.0`. For eg. if we have a version ^0.8.4, all versions 0.8.5/0.8.6 etc are supported upto 0.9.0. Breaking change version update will still not be supported

  - we can also provide a complex pragma where version > x.y.z and version < x.y.z+4. For example, `pragma solidity >=0.0.0 <0.8.7`
  - note that different versions can bring in different features, optimization and security updates
  - abicoder v1 and v2 -> encoding/decoding of nested arrays and structs is supported in v2. Its now default activated in latest versions
  - `Experimental` is used to specify features considered experimental - not enabled by default and have to be mentioned explicitly. One such feature is SMT checker - does a safety check for require/assert/ overflow/underflow, unreachable code etc. - has security implications

  **import**

- 'import' directives help to modularize code
- similar to javascript
- Code reuse
- improves readability

**others**

- structs/enums and contract definitions

**contract**

- Each contract can itself contain following (order below is considered best practice for layout)
  - structs/enums
  - state variables
  - events
  - errors
  - modifiers
  - constructor
  - functions
- Conceptually, contracts are similar to `classes` in Object Oriented Programing
- Contracts can interact with other contracts
- Contracts can be regular contracts, libraries or interfaces
- Fundamental primitive of Ethereum

**comments**

- single line `//`
- multi line `/*..*/`
- Comment assumptions, implementation details
- Critical part of documentation
- NATSPEC - standard format of commenting
- readability and maintainability

**NATSPEC**

- solidity supports special comments called NATSPEC
- NATSPEC - Ethereum Natural Language Specification Format
- Written with `///` or `/**..*/` directly above function or contract implementation
- supports tags - `@title` `@author` `@notice` `@dev` `@param` `@return`
- comments are meant to generate automatic JSON documentation for users and developers

---

### Deep Dive into Contracts

**State Variables**

- State variables are persistent
- Data location where state variables are stored - contract storage
- Visibility - public, private, internal
  - _Public variables_ - part of contract inteface and can be accessed externally (using getter functions) and internally
  - _Internal variables_ - can onlybe accessed internally within contract and all contracts that derive from this contract
  - _Private variables_ - only accessed from within contract and not even from contracts that derive from this contrct
- Private variable data is also present onchain & can be accessed - only thing is it can't be accessed via getter functions (imp to understand)

- _State Mutability_ - define immutability of state variables, ie when they can be changed or cannot be
  - _constant_ - constant variables once defined cannot be changed, ever. Fixed at compile time
  - _immutable_ - are fixed at the time of calling constructor. cannot be read during construction time and only assigned once
  - No storage slot for these variables. Gas efficient.
  - Constant variables - expression assigned to constant variable is copied to all places where its used & evaluated each time. So no need for storage
  - immutable - only evaluated once in constructor and values are copied to all places where they are used. Still take 32 bytes
  - constant is cheaper than immutable
  - Only supported types are strings and value types (does not support structs or arrays)
