# SOLIDITY 105

[Video](https://www.youtube.com/watch?v=_oN7XuyhoZA)

## Summary

Discuss solidity functions such as selfdestruct

**Self Destruct**

- `this` keyword refers to current contract
- `this` can be converted to address type explicitly by doing `address(this)`
- `selfdestruct(address payable recipient)` destroys all state variables and code in current contract and sends ether balance in contract to recipient
- Order of self destruct is -> destroy storage -> send funds -> end execution
- Some peculiarities with `self destruct` -> if the recipient or beneficiary account who receiving funds on self destruct is a contract, account does NOT execute `receive()` fallback, even if it is defined
- Contract gets destroyed only at the end of the transaction -> if there is any logic AFTER `selfdestruct` that reverts, then `selfdestruct` will NOT be executed -> just because `selfdestruct` is called, does not mean that the contract will be destroyed

**Contract Type**

- solidity supports some primitives for contract type -> `type(X) => Contract` if X is a contract
- `type(C).name` -> gives name of the contract
- `type(C).creationCode` -> gives creation byte code
- `type(C).runtimeCode` -> gives runtime byte code
- `type(I).interfaceId` -> gives interface ID
- `type(X).min` -> if X is integer, returns minimum value supported for that type
- `type(X).max` -> if X is integer, returns maximum value supported for that type

_For eg. type(uint32).max = 2^32 -1_

**Control structures**

- Here are control structure supported by solidity

  - `if/else`
  - `while/do`
  - `for/break/continue/return`

- `()` cannot be omitted
- `{}` single statement flows can omit curly brackets
- Non boolean is not convertible to boolean (unlike in other languages). For eg. `if(1)` is not allowed

**Exceptions**

- In solidity, exceptions are state reverting
- any exception undoes or reverts all changes made to the smart contract
- Calls and sub-calls at deeper level - all will be reversed
- When exceptions happen at deeper sub-calls, they bubble up & are thrown at outermost call levels
- There are exceptions to above statement - low level calls (`send/call/delegateCall`)-> they return a `bool' that tells whether txn is success or not -> meaning, they don't revert if low level call fails -> that is very important from a security standpoint
- Exceptions made in external calls can be caught in `trycatch`statement
- Exception contains data that can be passed back to caller - exceptions contain function selector showing us what function an exception happened & also abi encoded information about the exception

- Solidity supports 2 error signatures
  - `Error(string)` - thrown by `require` and `revert`. logic or input related errors (contract specific)
  - `Panic(uint256)` - thrown by `assert`. More of programming errors that should not be violated

**Low level calls**

- 3 kinds of low level calls - `call/staticcall and delegatecall`
- **Important point here -> if these low level calls are made to a `non existent account`, they still return TRUE** _(need to be careful from security standpoint)_
- Above means that we should check if contract exists before doing a low level call -> contract.codeSize > 0
- Above led to some high profile bugs -> so need to be careful about this

**Assert**

- Should be used for programming invariants that shoulld never be violated
- `assert` violations lead to panic
- `assert()=> Panic(uint256)`
- Normal code should never cause panic -> even logic errors don't classify as 'panic'
- Assert should not be used for things like, invalid inputs, invalid sender, incorrect eth value etc
- Panic can be of many types - and the value thrown out with panic tells us the type of panic

| Code |     Panic type      |
| ---- | :-----------------: |
| 0x01 |   false argument    |
| 0x11 | overflow/underflow  |
| 0x12 |    div/mod by 0     |
| 0x31 |  pop() empty array  |
| 0x32 | out of bounds array |

**Require**

- `require()` creates Error([string]) -> error string is optional
- used to detect runtime invalid conditions
- includes
  - input validation
  - return value checks (eg. send, call)

Some common examples

- `  require(arg == false) // when argument is invalid`
- external call to contract with no code
- receives ETH without a payable modifier
- contract receives ETH via a get function

**Revert**

- revert can be triggered with customerror with arguments
- `revert CustomError(arg1, arg2,...)` or `revert([string])` - 2 ways to define revert
- useful for better user interactions and experience
- Aborts execution & all state changes are reversed

**try/catch**

```
try Expr [returns()] {...}
catch<block>{
    ....
}
```

- which block gets executed depends on whether there is external call failure
- catch block gets executed in case of failure
- No error, success block gets executed
- If error, which catch block gets executed depends on error type

**catch blocks**

- `catch Error(string reason)` - block executes when there is `revert` or `require` false
- `catch Panic(uint errorCode)` - block executes when panic gets triggered
- `catch (bytes lowLevelData)` - gets executed when error that does not match any of the above
  - lowLevelData gives us access to the error data
- `catch` - if developer is not interested in type of error, a simple `catch` will catch all types of errors

- try block gets executed -> it means no revert in external call & all state changes are commited to state of contract
- catch block -> state changes in that external call have been reverted
- there is also case when `try/catch` itself can be reverted for low-level failures

**External call failure**

- External call failures can happen due to multiple reasons
- One cannot always assume that error are originating directly from contract that was called in external call
- Error could happen in a substack - deeper down in call chain
- It could well be that error bubbled up & showed up in contract call -> where it originated is usually not very straightforward
- This could also be due to OOG(out of gas exception) -> caller forwards 63/64'th gas to the callee - so still left with some gas to deal with that exception

**Programing Style**

- Coding conventions - ease of reviewing and maintenance
- key thing here is consistency - programing style has to be consistent
- if multiple ppl have multiple styles, consistency gets affected - impacts maintainability and composability

- Indentation - 4 spaces
- Prefer spaces over tabs
- Blank lines - 2
- Max line length = 79-99
- wrapped lines
- Contract, struct should be starting in Capital letters
- Contract name should match file name
- Constants should be ALL CAPITALS
- function Args, local State Variables, modifiers should all be mixed case
