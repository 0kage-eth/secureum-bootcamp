# SOLIDITY 103

[Video](https://www.youtube.com/watch?v=6VIJpze1jbU)

## Summary

In this module, we do a deep dive into data types, value and reference types

### Value Data Types

**Boolean**

- `bool` keyword
- `true` or `false`
- operators `==` `!=` `>` `<` `>=` `<=` `!` `&&` `||`
- `||` and `&&` are short circuit operators -> `z || y` if `z` is true, then doesn't calculate y; `z && y` `z` is false, doesn't evaluate y

**Integer**

- uint - unsigned int, int - signed int
- 8-256 bits
- `uint8`, `uint32`...`uint256`
- security perspective - overflow and underflow is very critical to analyze
- `uint256` any value from `0` to `2**256 -1`
- if a value goes beyond above range, leads to overflow or underflow -> causes wrapping
- what does wrapping mean -> so if `uint256 a = 2**256-1` => if we increase a `a++` => wraps to other side and `a` becomes `0`
- similarly if `a =0` and if `a--`, then wraps to other side -> `a = 2**256 -1`
- In solidity < 0.8.0, best practice was to use `SafeMath` library. After 0.8.0 -> this is automatically handled, default overflow and underflow checks for integers
- Make it a point to check solidity compiler version -> if <0.8.0, SafeMath should be used to prevent overflow/underflow errors
- If >0.8.0, make sure there are no `unchecked` blocks that are using expressions that can cause overflow/underflow errors

**Address**

- Address type refers to account address - EOA or contract address
- 20 bytes in size
- either plain address or `payable` address - latter indicates this address can receive ether
- address type to payable address type should be an explicit coversion
- address is used for access control, hold token balances - very imp from security standpoint
- can use operator `==` `!=` `!`
- `address` type has different members
  - `balance` - gives balance in the address
  - `code` - gives the code associated with that address
  - `codehash` - gives hash of the code
  - `transfer` and `send` can transfer eth - > make calls with 2300 stipend (can't be changed)
  - `call`, `delegatecall` and `staticcall` - low level instruction -> we can send different data payloads via these low level functions

**transfer**

- `transfer` function is used to transfer ether to a destination address
- triggers the `receive()` fallback - if its defined inside the destination address
- sends a fixed gas stipend of 2300 gas to the `receive()` fallback
- if target function used in `receive()` fallback uses more than 2300 gas - fails and reverts -> no ether sent
- security perspective - need to ensure re-entrancy risk is not present & the gas stipend cannot exceed

**send**

- used for ether transfer just like `transfer`
- also triggers `receive` or `fallback`
- sends a fixed gas stipend of 2300 gas
- DOES NOT lead to a revert if gas exceeds or failure occurs
- just returns a `bool` aas false
- Security perspective - apart from above checks, check if transfer went through or not

**External calls**

- `call`, `delegatecall` and `staticcall` are 3 types of external calls
- they all take `bytes memory` as parameter
- they return `success check` boolean and `bytes memory data` that is any output of the fallback() function
- We can pass function singatures using `abi.*` along with arguments - need to encode data and pass it to these low level functions
- they can send `gas` and `value` - custom gas and custom ether values. Applicable for `call` primitive but not `staticcall`.
- `delegateCall` is when caller contract wants to use callee contract logic but with its own state. State of caller contract can be modified by using delegateCall
- `staticCall` is more like running logic on callee contract by looking at state of caller contract but not allowing any state modifications in caller contract

- Security - low level calls that can be risky and hence avoided (unless absolutely required), reentrancy attacks and return value checks need to be evaluated

**Contract Type**

- Every contract has its own type
- `Contract` types can be explicitly converted to `address` type
- Contract types do not have any operator
- Members are external functions along with any public state variables

**Bytes arrays**

- fixed size byte arrays (value types)
- `bytes1` stores 1 byte, `bytes2` stores 2 bytes,...., `bytes32` stores 32 bytes
- if we do not know fixed size in advance we can use `bytes` type -> reference type
- note that `byte[]` can also be used -> but leads to wastage -> for every element, it wasted 32 bytes
- instead its better to use `bytes` type - common example here is to store hashes

**Literals**

- five types of literals

  - address
  - integer
  - string
  - unicode
  - hexadecimals

- A literal is something that is fixed (eg set) by a programmer during the creation of the program’s code
- Often, when a variable is declared, it is initialized to a default value, which is technically also a literal value.
- In general, integers are set to the literal “default” value 0, doubles/floats are set to literally 0.0, booleans are set to literal false,

- Address literals are hexadecimal literals that pass checksum test

  - 40 character (20 bytes)
  - passs checksum test (EIP55) to make sure there are no typos

- Integer literals have 0-9 range
- String literals are either `""` or `''`
- Use of these literals in defining constants

**Enums**

- user defined types
- can have 1 member to 256 members
- default value is first member
- used for state names or transitions - improve code readability
- can be interchanged with integers

**Function types**

- used to represent variables of function type
- can be assigned from functions
- can be sent as arguments to other functions
- can be used to return values from other functions
- internal vs external function types - accessibility
- very rare in smart contracts to use `function` as variable type

**Array types**

- Can be static (if we know size upfront) or dynamic (dont know size)
- elements of an array can be of any type
- indices are 0 based
- if element accessed is past their length -> solidity reverts with error
- security - check if correct index is used, check if index is in-range, gas for complex arrays (gas not enough, txn reverts)

- Members supported for array types

  - _length_ - size of array
  - _push_ - pushes 0 initialized element at the end of array
  - _push(x)_ pushes x at the end of the array
  - _pop_ - pops an element from the end of the array

  **bytes & string**

  - `bytes` - stores byte data when size is not known upfront
  - `string` == `bytes`, string is same as bytes type, except that string does not have access to length and cannot return a specific byte when given a byte index
  - Solidity does not support string manipulation functions but can use 3'rd party libraries

  **memory arrays**

  - Memory arrays can be used to store byte arrays using `new` operator
  - As opposed to storage arrays, memory arrays can only be static - need to know the byte array size upfront
  - Cannot resize memory arrays -> no `push` functionality for memory arrays
  - Calculate size in advance and use it for creation of memory arrays
  - OR create a new array and copy every element of old array into new memory

  eg. of creating memory arrays

  ```
    uint[] memory a = new uint[](55);
  ```

---

### Data Location

- Reference type variables, solidity expects users to define where the variable is stored
- 3 locations - storage, memory and calldata
- affect lifetime, scope and persistence of data

  - `memory` - indicates lifetime is limited to function call
  - `storage` - lifetime extends to whole contract
  - `calldata` - non-modifiable, non-persistent spot where external function parameters are stored (but can also be used for other variables)

**Assignment Semantics**

- Additionally, it is important to know if a `copy` of variable is created or is existing variable referenced - important to identify how compiler handles that variable
- if a variable is of storage type, but it is being assigned to a memory variable, a copy of that variable is created. Any changes affect copy but not original state variable
- If a variable is of memory type, but assigned locally to a memory variable, new variable is referencing to the same data storage (copy is NOT created)

- If a variable is of storage type, but assigned locally as a storage, a reference to that variable is created
- If variable is of memory type, but assigned to a storage variable, a new copy gets created

_From a security perspective, important to identify if we are dealing with 'reference pointer' risk where state variable is accidentally getting overwritten_
