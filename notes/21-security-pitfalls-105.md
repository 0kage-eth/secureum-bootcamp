# SECURITY PITFALLS 305

[Video](https://www.youtube.com/watch?v=vyWLO5Dlg50)

## Summary

List of all security vulnerabilities continued..

### V61 - Compiler Bug: Storage Structs

_Background_

- Storage structs/arrays of type < 32 bytes when directly coded from storage data led to data corruption (abiencoderv2)
- fixed in 0.5.8

_Risk_
NA

_Mitigation_
NA

---

### V62 - Compiler Bug: Yul Loads

_Background_

- Yul is assembly level language
- When experimental Yul optimizer was activated manually with abiencoderV2
  - incorrect MLOAD/SLOAD calls
  - MLOAD/SLOAD instructions were replaced by stale values
  - This was a serious bug
- Persistes in 0.5.14 - 0.5.15 -> corrected since

_Risk_
NA

_Mitigation_
NA

---

### V63 - Compiler Bug: Array Slices

_Background_

- Array slices, as name suggests, slice array from a start to end index
- Accesing such array slices with dynamically encoded base types resulted in invalid data being read
- Persisted between 0.6.0 -> 0.6.8. fixed

_Risk_
NA

_Mitigation_
NA

---

### V64 - Compiler Bug: Missed escaping

_Background_

- Escaping is related to string literals
- certain characters can be escaped by double backslash `\\` characters
- string literals with `\\` when passed to externally encoded function calls resulted in different string being used when abiencoderV2 was enabled
- compiler bug was present from 0.5.14 -> 0.6.8
- was so deep that it persisted across breaking versions -> sometimes a specific use case triggers certain dormant bugs to pop up

_Risk_
NA

_Mitigation_
NA

---

### V65 - Compiler Bug: Shift operation

_Background_

- If multiple conditions were true, shifting operations resulted in overflow (unexpected values being output)
- Some conditions were `optimizer` needs to be enabled +
- these had to be double bitwise shifts whose sum overflowed 256 bits (shift > 2\*\*256 leading to overflow)
- persisted 0.5.5 -0.5.6

_Risk_
NA

_Mitigation_
NA

---

### V66 - Compiler Bug: Byte Instruction

_Background_

- Incorrect optimization of byte instructions
- when byteopcode BYTE was used with second argument 31 - incorrectly optimized
- this resulted in unexpected values being produced
- 0.5.5-0.5.7 - fixed

_Risk_
NA

_Mitigation_
NA

---

### V66 - Compiler Bug: Assigment using Yul

_Background_

- Bug related to assignment using Yul Optimizer
- Essential assignemnets removed for variables declared inside for loops
- this would happen while using Yul's `continue` or `break` statements
- compile 0.5.16- 0.6.1 - fixed

_Risk_
NA

_Mitigation_
NA

---

### V67 - Compiler Bug: Private functions

_Background_

- function visibility can be public/external/internal/private
- private functions, unlike internal, can be called only from within the contract -not event derived contracts
- but this was being violated - when a derived contract defined a function with same name and arguments
- by doing the above, we could change behavior of private function in base contract

_Risk_

- Ability to change behavior of a function even though it was declared private

_Mitigation_

- Compiler bug - this is now resolved
- 0.3.0 - 0.5.17 persisted across multiple breaking versions (interesting..)

---

### V67 - Compiler Bug: Tuple assignments

_Background_

- Nested tuples tend to use multiple stack slots
- Nested tuple assignments led to invalid vlaues
- 0.1.6 - 0.6.6 -> lasted across 5 breaking versions

_Risk_
NA

_Mitigation_
NA

---

### V68 - Compiler Bug: Dynamic Arrays

_Background_

- Compiler bug related to dynamic arrays and clearnup related to dynamic arrays
- when dynamically sized arrays were assigned to type whose size is atmost 16 bytes -> would cause assigned array to shrink and reduce their slots - deleted slots were not cleaned
- these slots were reused later leading to dirty data
- fixed in 0.7.3

_Risk_
NA

_Mitigation_
NA

---

### V68 - Compiler Bug: Byte arrays

_Background_

- Compiler bug related to empty byte arrays and copying empty byte arrays
- byte array data in memory/calldata copied to storage could result in data corruption only if target array length was subsequently increased but without storing new data in it (very very specific and niche usecase)
- It is extremely difficult to unearth certain bugs whose state conditions are so specific
- fixed in 0.7.4

_Risk_
NA

_Mitigation_
NA

---

### V69 - Compiler Bug: Memory arrays

_Background_

- When memory arrays created which are large in size - caused overflow
- memory arrays created overlappings which led to data corruption
- compiler bug 0.2.0 - 0.6.5 (again, difficult to ctach, difficult to trace)

_Risk_
NA

_Mitigation_
NA

---

### V69 - Compiler Bug: using for

_Background_

- compile bug on `using for` primitive in solidity
- `using for` is used for calling specific library for a data type (as an externsion)
- allows function calls on data type as internal functions
- bug was when function parameters were in the `calldata`
- in such cases, reading of these calldata parameters would result in invalid data

_Risk_
NA

_Mitigation_
NA

---

### V70 - Compiler Bug: Free functions

_Background_

- free functions are functions defined oustide of any contract
- bug with `redefinitions` of free functions
- bug allowed free functions to be redefined with same name and aparameter types
- this redefinition or collision was not detected by compiler as a bug
- 0.7.1-0.7.2 - fixed

_Risk_
NA

_Mitigation_
NA

---

### V70 - Initializer

_Background_

- Recall proxy and implementation -> proxy has state variables and implementation has logic
- proxy contracts are used for upgradeability of contracts
- proxy based contracts do a `delegatecall` to implementation contract - functions in implementation contract execute logic in the context of `proxy` contract, ie using state of proxy
- proxy contract cannot implement a `constructor` to initialize variables inside implementation since initializing variables might override state variables in proxy contract
- Instead of a constructor, implementation contract is expected to implement a `initialize` function that will initialize all
  variables that will be usedful to execute logic of implementation
- And that `initialize` must be public -> so that it is accessible from the proxy contract

_Risk_

- Initializer function should NOT be callable multiple times. Should be callable only once by authorized proxy contract
- This initialization has to be called as soon as the implementation contract is deployed - this is typically done using a `deploy` script or from a `factory` contract
- If multiple calls allowed, some exploiter could call the function to re-initialize variables in a way that can manipulate the logic of implementation contract

_Mitigation_
-Best practice is to use OZ `initializable` library

- Provides a `initializer` modififer that can be applied to initialize function
- this modifier prevents function from being called multiple times

---

### V71 - state variables

_Background_

- Again in the context of proxy contracts
- state variables in the implementation contract should NOT be initialized in the declarations themselves
- Instead they should always be initialized via the `initialize` function
- This is because such initializations will not be reflected when proxy contract makes a delegate call to a function in implementation contract

_Risk_

- State variables of implementation contracts are initialized in the declarations themselves
- When proxy contract makes a delegate call, such initializations would not be available -> and logic executes with default values leading to erroneous outcomes

_Mitigation_

- All state variables should be initialized inside `initialize` function

---

### V71 - import contracts in proxy setup

_Background_

- contracts imported in proxy setup can also derive from other librariers or other contracts
- base contracts from which proxy is derived should also not be using constructors
- they should initialize using the initialize function only

_Risk_

- If proxy derives from base contracts that use `constructor` to initialize instead of a specific `initialize` function
- Those states would be uninitialized and could result in serious vulnerability

_Mitigation_

- All base contracts of proxy contract MUST implement `initialize` to initialize state variables

---

### V72 - self destruct

_Background_

- specific to proxy based contracts
- 'selfdestruct' can delete all code and transfer balance ether to a terget contract
- irreversible change -> and such function should be avoided because it opens up to exploitation

_Risk_

- Again specific to proxy contracts
- If implementation contract has a `self destruct` that can be tiggered -> proxy contract will no longer be able to access code inside implementation -> all the code would be gone
- use of `delegatecall` also not recommended _(didn't understand this)_

_Mitigation_

- Use of `selfdestruct()` in proxy based implementations should be avoided as they risk the proxy contract becoming useless
- Use of `delegatecall()` in proxy based implementation has to be avoided

---

### V73 - state variables

_Background_

- State variable order/layout and type in proxy and implementation must be preserved exactly
- this is to prevent storage mismatch errors

_Risk_

- Chaing order of state variables in proxy and implementation could lead to mismatched storage

_Mitigation_

- Ensure order/layout and type of state variables storage is exactly the same
- Changed order can lead to catastrophic exploits

---

### V74 - function ID collision

_Background_

- function ID collision referes to having same function (selector + parameter types) in proxy and implementation
- function ID is a keccak256 hash of function selector & address paramaters
- function dispatcher has to take a call whether proxy function is to be called or implementation function
- when user gives a call to function ID, proxy contract will get executed, not the implementation contract
- While user might think implementation logic might be executed, its actually proxy contract logic that gets executed

_Risk_

- Malicious proxy can declare a function such that its function Id is same as one of proxy functions
- call targeting implementation is hijacked -> and proxy function gets called

_Mitigation_

- To mitigate this, we should use `upgradeable` proxy where rights of admin and user are clearly demarcated - and precedence of function calls is clearly
- check if proxy can declare functions whose ID's can collide
- Make sure there are no function id collisions

---

### V75 - shadowing

_Background_

- Another concept is for malicious proxy contracts to shadow functions in implementation contract
- Create a function in proxy contract that has exact same name and parameters as function in implementation
- same use case as above - excpet here, its more explicit

---
