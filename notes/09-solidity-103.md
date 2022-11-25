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
