# SOLIDITY 102

[Video](https://www.youtube.com/watch?v=TCl1IcGl_3I)

## Summary

In this module, we do a deep dive on functions inside smart contracts

### Deep Dive into Contracts

**Functions**

- executable units of code
- defined inside contracts
- sometimes they are defined outside contracts - referred to as 'free functions'
- functions allow modifications to state & transition from one state to another
- functions are specified often with parameters. Parameters are declared as variables
- Caller of these functions assigns `arguments` that can be assigned to these parameters
- Caller -> arguments, Callee - parameters
- functions return values - return variables, single or multiple
- return variables can be named or unnamed
- treated like local variables in the context of the function
- incase of unnamed variables, an explicit `return` needs to be used to return variables
- So a caller -> calls a callee function -> returns none or single or multiple values

**Modifiers**

```
    modifier mod(){
        <check>;
        _;
    }
```

- Modifiers are assigned to functions
- Modifier checks for a condition before executing the logic of function
- `_` denotes logic of function will be executed

```
    function foo() mod {
        //control flow goes mod -> foo.
        // first mod is called and if conditions are met, foo loogic gets called
    }
```

- Checks are some pre-conditions that are evaluated before function logic getts called
- One example could be `access control` - only owner can execute a specific operation in a contract

**Function visibility**

- Similar to visibility of state variables, functions can also be assigned visibility
- Public / external /internal / private are 4 different visibilities
- `Public` functions are part of contract interface - they can be called internally or via messages
- `External` functions are also part of contract interface - they can be called from other contract via messages but NOT internally
- `Internal` functions can be called internally or from contracts deriving from current contract
- `Private` functions can be called internally but NOT from derived contracts

**Function Mutability**

- `pure` and `view` functions
- `view` functions are allowed only to read state but not modify. This is enforced at EVM level using `STATICCALL` opcode
- various actions are considered as modification to state
  - writing to state variables
  - sending ether
  - emitting events
  - creating other contracts
  - using selfdestruct
- `pure` functions can neither read state nor modify it. Not modify can be enforced by EVM (using `STATICCALL`) but not reading cannot be enforced as there is no opcode.
- various actions are considered reading from state
  - reading state variables
  - accessing balance of contract
  - accessing block members - timestamp, block number etc
  - accessing msg.sender or msg.value
  - calling other functions not marked as `pure`
  - using inline assembly that contain certain opcodes is also considered reading state

**Function overloading**

- multiple functions can have same names but different parameter types
- overloaded functions are selected by matching function in scope to arguments. Depending on number and type of arguments, correct function is selected
- **Note that return variables are not considered for choosing overloaded functions**

**Free functions**

- Defined outside scope of contracts
- Free functions always have implicit internal visibility
- Their code is included in all contracts that call them & treated like internal functions
- Free functions are similar to internal library functions
- Very rare in contracts

**Events**

- EVM logging abstraction
- Emitting events stores the arguments submitted to that event in what is called 'Transactions Log'
- This log is a special data structure in blockchain - they are tagged to the address of the contract and present onchain
- This log stays as long as block is accessible
- This log and its data is not accessible from within the contract, even though its the contract that created that event
- Logs are meant to be accessed offchain - and this is allowed using RPC access (Remote Procedure Calls)
- Applications offchain or monitoring tools can sucscribe to RPC and listen to these events
- From security perspective, they are very important from perspective of auditing and logging
- Helps in monitoring state and all changes that have happened in past

- Upto 3 parameters of an event can be indexed using `indexed` keyword
- causes those parameters to be stored in special data structure called `topics`
- non-indexed data is stored in `data`
- We can run a search/filter on topics
- indexed params use a little more gas than non-indexed one but allow a faster search
- Events are triggered using `Emit` keyword
- Events are only way for offchain apps to keep track of state changes on chain

```
    event Deposit(indexed address, uint256 id, uint256 value);

    emit Deposit(msg.sender, _id, msg.value);
```

**Structs**

- Custom data structures
- Can contain multiple variables of different data types
- Struct members can be accessed by `.` separatore (`eg. s.user, s.balance`)

**Enums**

- user-defined type
- finite set of constant values (min 1, max 256)

```
    enum Actions {run, jog, walk, sit, stand}

    Actions action;

    action = Actions.jog;
```

- Each enum value is uniquely ampped to a uint -> so they can also be referenced with integers
- Improves readability

**Constructor**

- unique to solidity
- constructor initializes contract state & is optional
- special function that gets triggered when contract is created
- **Only AFTER constructor code is executed, final code of the contract is stored on blockchain**
- if we use the 'codeSize' opcode inside constructor, we will get it as 0 -> because at the time of constructor running,
  there is no code stored inside the account

**Receive**

- callback function that gets triggered when `ether` is sent to the current address
- When ether is sent to current address via `send` or `transfer`, `receive()` callback gets triggered
- Even when `call` is triggered with empty `calldata`, `receive()` function gets triggered
- Only one receive() function, no arguments, cannot return anything
- it has to be `external` visibility and has a `payable` type - payable means the address can receive ether
- send/transfer functions are designed to only send 2300 gas -> prevents re-entrancy attacks & doesn't allow receive()
  function to do anything much more than basic logging using events
- receive() function has security implications - affects contract balance and any logic that depends on that balance

**Fallback**

- `fallback()` is similar to `receive()` function and gets triggered when

  - called function signature does not match with any function
  - no data supplied in transaction
  - send `ether` and no `receive()` function
  - send `ether` but with some data (even if `receive()` exists, fallback gets triggered)

- only once, unlike `receive` fallback can receive and return data if required, is of external visibility
- if `ether` can be sent, this will be a payable function
- cannot assume more than 2300 gas will be supplied to it because it can be triggered via send/transfer functions (not just call function)
- similar to `receive()`, balance assumptions need to be checked if fallback receives ether (from security standpoint)

### Data Types

- Solidity is a statically typed language
- Types of variables are explicitly defined at compile time and can't be changed once assigned
- This applies to state and local variables
- statically typed languages do a type-check at compile time
- Some other static types (Java, Go, Rust, C, C++)

- Two types - value types and reference types
- Value types - variables are always passed by value
- Value type variables are always copied wherever they are used (for eg. arguments of a function)
- Reference types - passed by reference - modified via multiple names -> all of them point to the same underlying variable
- Reference types are tricky from security perspective - which state is being updated & their transitions

**Value Types**

- boolean, integer, fixed size byte arrays, address, enums
- They are copied wherever they are used -> safer from a security perspective
- Copy of that value is made so that original variable/state is not modified accidentally
- At the same time, we need to check any assumptions around persistence of value types is being considered appropriately

**Reference Types**

- Passed by reference
- Multiple names of variables -> all pointing to same data
- Arrays, Structs, Mappings are all reference types
- From security standpoint, reference types are risky -> variables can be unintentionally changed
- if reference is incorrectly used, developer might not realize that the original variable can be overwritten

**Default Values**

- variables declared but not initialized have default values
- Also called the `zero-state`
- Boolean -> 0 (false),uint -> 0, address -> 0x, enum -> first member, dynamically sized arrays or string -> empty array or empty string
- Security -> important to note if default values do not adversely impact logic (for eg. 0 address can accidentally lead to 'burn' of tokens)

**Scoping**

- Scoping refers to visibility of variables -> where variables declared can be used
- Solidity uses widely used C99 (?) scoping
- variables can be used inside a declaration -> from `{` to `}`
- variables declared as parameter will be visible inside code block that follows the body
- variables are visible even before they are declared
- Security standpoint -> understanding scoping is important when we are doing data flow analysis
