# SECURITY PITFALLS 303

[Video](https://www.youtube.com/watch?v=YVewx1xVROE)

## Summary

List of all security vulnerabilities continued..

### V35 - Pre-declaration

_Background_

- Earlier versions of solidity allowed local variable use even before they were declared
- these variables could be declared later or declared in another scope
- led to undefined behavior before 0.5.0
- solidity >0.5.0 changed this and created C99 style scoping rules

_Risk_
N/A

_Mitigation_
NA

---

### V36 - Costly operations

_Background_

- Certain operations consume lot of gas
- such costly operations, when used in loops, could consume lot of gas & could result in unexpected behavior
- eg. state variable updates cost 20,000 gas (COLD SSTORAGE -> state updated first time in context of this txn) or 5000 (WARM SSTORAGE -> state was already updated in current txn context)
- If such updates happen within loops, they can consume lot of gas & end up in out-of-gas exceptions

_Risk_

- Expensive operations such as SSTORE when run in loop can exhaust all gas and throw out-of-gas exception
- Leads to DOS (denial of service) attack

_Mitigation_

- Use local variables inside loops - if any state variables are found in recursive logic, we need to convert them into local variables (MSTORE, memory storage uses only 3 gas)

---

### V36 - Costly calls

_Background_

- external calls cost 2600 gas as of latest update
- if external calls made in recursive loops, it could lead to DOS attack

_Risk_

- External calls inside a loop where loop counter is controlled by user -> an exploiter can increase loop counter and get more and more external calls until gas runs out
- Reverts with out of gas

_Mitigation_

- Reduce external calls within loops
- Check if loop index is user controlled - avoid this & analyze how this can got out of control

---

### V37 - Block Gas Limit

_Background_

- Block gas limit is total amount of gas consumed by all txns included in a block
- This was limited to 15 million gas - although undergone changes with EIP 1159 but block gas limit still exists (what change???)
- No. of txns is limited by block gas limit, not absolute limit on number

_Risk_

- Costly loops can cause out-of-gas, not only because gas provided to txn runs out but including this txn can exceed block gas limit

_Mitigation_

- Check loops - all loops that perform cost operations
- DOS attack can not only happen at txn level but also block level

---

### V38 - Lack of Events

_Background_

- Events are emitted when critical actionss are performed inside smart contract
- Events act as an audit trail for key actions
- Missing events could be a security concern because it prevents off-chain monitoring
- event arguments are stored in logs - and these logs, either topic or data can be queried by offchain tools

_Risk_

- Lack of events decrease readability of states after critical actions

_Mitigation_

- Identify key actions and emit events around these actions. Improve transparency and UX of smart contract frontends
- These could be critical operations done by owner (change ownership, create a new role etc) & also actions impacting balances (deposit, withdrawal, claim etc)

---

### V39 - Non indexed event parameters

_Background_

- Event parameters can be indexed by using `indexed` keyword
- Upto 4 parameters can be indexed - they are called topics
- Non indexed parameters become part of `data`
- Being part of `topics` allows easy querying of data offchain - we can access data faster because of use of bloom filter
- if part of `data`, access is slow

_Risk_

- Token specifications such as ERC20 must have events such as `Approve` and `Transfer` and parameters need to be indexed
- Not having event parameters indexed for standard token standards can prevent off-chain searching difficult

_Mitigation_

- If custom implementations of ERC standards are used, make sure all events are indexed as per ERC spec. Add 'indexed` for such parameters
- LAck of it might lead to erroneous front ends and UX

---

### V40 - Incorrect event signatures

_Background_

- Incorrect event signatures used in libraries
- Library passed contract name instead of address type -> and name was passed incorrectly
- as a result a wrong hash was generated and this event was throwing wrong data

- this was corrected in solidity > 0.5.8 where address type was sent to hash instead of contract name

_Risk_
NA

_Mitigation_
NA

---

### V40 - Unary Expression

_Background_

- Unary expressions are used where an operator is used on a single operand as opposed to 2 operands
- susceptible to typo errors

For eg. if dev uses `x=+1` instead of `x+=1`, the value of x is not incremented. Instead, x is just equal to 1

- so instead of increment, we are reintializing value of x to 1
- they are considered valid by compiler -so they escape scrutiny
- can be caught in logic testing but sometimes they escape tests

_Risk_

- Typographic changes in expressions are possible, specially if they don't cause compiler errors

_Mitigation_

- Check all expressions, order of operations, variables used and also typo errors
- Unary + is deprecated as of 0.5.0

---

### V41 - Zero addresses

_Background_

- Zero addresses are default addresses where all 20 bytes are 0
- Special consideration in ethereum
- Zero address are special because state variables at the time of initialization are zero addresses
- Zero address also used as burn address because private key corresponding to 0 address is not known
- Any tokens or ether sent to 0 address gets burnt - inaccessible for others to use

_Risk_

- Inadverently tokens transfered to an address that wasnt initializedc- get burnt
- Similarly any roles addresses to zero address or ownership transsfered to zero address will lock out that role because we don't have access to private keys of that role/owner

_Mitigation_

- Zero-address checks are always recommended to perform input validation
- this is very common encountered security pitfall where address parameters to constructors, setters or external calls are not checked for zero address
- in best case, they could lead to exceptional behavior at run-time
- in worst case, they could lead to token burns or even contract locks

---

### V41 - Critical addresses

_Background_

- Another critical aspect is change in value of critical addresses
- Contract can have critical addresses such as `owner` -> owner might have special permissions to execute certain functions
- Or there might be addresses of other contracts or wrapper contracts (such as WETH / USDC etc)
- When a contract address gets changed accidentally, certain functions of that contract get locked forever

_Risk_

- Changing critical addresses in a single step is very risky -> a wrong address can lock the key functions of a contract forever
- Since these are irreversible changes -> functions such as `transferOwnership` are very risky if done in a single step

_Mitigation_

- Functions that change critical addresses are recommended to be executed in 2 steps
- first step is to change the address -> although this will not immediately change the address
- second step is for the new address to actually `claim` & confirm that they are indeed in control of private keys
- only inside the `claim()` function should the critical address be changed
- Having such functions as a 2-step process mitigates accidents and locking out of contracts due to critical address change

---

### V41 - Use of assert

_Background_

- If you recollect, `assert` triggers a panic when some program invariant gets breached
- `assert` is different from `require` or `revert` because assert triggers a panic with an integer error code

_Risk_

- `assert()` should not be used to make any state changes or validate user inputs (thats the role of require)
- devs might miss state changes or user validation in `assert` because convention is to use asserts only for programming invariants

_Mitigation_

- Make sure `assert()` is used only for programming invariants & not input checks/state changes

---

### V42 - assert vs require

_Background_

- `require` is used for input checks and invalid states
- `assert` is only for programming invariants
- Before 0.8.0, `assert` was using `REVERT`opcode that refunded unused gas. whereas `require` was using `INVALID` opcode that used all gas - so there were gas implications as well earlier - now after 0.8.0, both use REVERT opcode and refund excess gas

_Risk_
NA

_Mitigation_

- No risk as such, but best practice is to use `require` for contract related checks and `assert` for programming invariants

---

### V42 - deprecated keywords

_Background_

- Over different compiler versions, different keywords have been deprecated
- Eg. `msg.gas -> gasLeft`,`throw -> revert`, `sha3->keccak256`, `callcode -> delegatecall`, `constant -> view`, `var->actual type name`

- These deprecated keywords start with compiler warnings and overtime graduate to become errors

_Risk_
NA

_Mitigation_

Avoid used deprecated keywords as best practice

---

### V42 - optional function visibility

_Background_

- before 0.5.0, functions visibility was optional -> if not defined, defaults to `public`
- post 0.5.0, functions must be defined as `public or external or private or internal`

_Risk_

- earlier risk was when dev forgot to mention visibility -> he intended to write a private function but because the visibility was not specified, it defaulted to public
- an exploiter could call the function & change state variable

_Mitigation_

- this risk is not possible now -> now devs have to explicitly define visibility upfront or complier throws an error

---

### V43 - Inheritance order

_Background_

- Contracts the inherit from multiple contracts should be mindful of inheritance order
- C3 linearization of python is used (except in solidity, we have right to left) for function calls and constructor initialization

_Risk_

- If multiple contracts implement identical function -> then function order becomes important
- Incorrect assumption of order can lead to key logic loop holes

_Mitigation_

- Avoid using same names across different base contracts
- If they are present, Implementation order goes from more general-> more specific implementation

---

### V44 - Missing Inheritance

_Background_

- Functions are used from what might appear to be inherited contracts (interfaces or abstract contracts having similar names etc creating an appearance that functions are from inherited contracts )

_Risk_

- When inheritance is missing and devs assume they are inheriting from base contracts or interfaces with similar names

_Mitigation_

- Check inheritance correctly -> make sure all functions called in derived contracts are contained in base contracts

---

### V45 - Gas griefing

_Background_

- On ethereum, users can submit txns to smart contracts on blockchain
- alternatively, users can forward meta txns to relayers where they don't need to be paid for gas -> and relayers inturn forward such txns to blockchain with appropriate amount of gas -> users compensate relayers for gas out-of-hand

_Risk_

- Relayers might not have enough gas to complete the txn. users trust relayers to have enough gas to forward txns to smart contracts

_Mitigation_

- Need to check if relayers have enough gas before forwarding meta txns to the relayer

---

### V46 - Reference parameters

_Background_

- Function parameters can be value or reference types (struct/array or mappings)
- If passed by value, pass with `storage` keyword
- If passed by reference, pass with `memory` keyword
- Passed by value creates a copy of data -> pass by reference creates a pointer to data
- Since 0.5.0, devs have to explicitly define whether they pass parameters by value or by reference

_Risk_

- When passed by reference -> any change to state variables inside function updates state
- When passed by value -> any changes are local and don't update state variables
- If a dev sends by value -> he might think state is updated but iun reality, only copy is updated and original storage is not

_Mitigation_

- Be careful if dynamic types are passed by value or by reference - be aware of value or reference type
- Look for state updates & expected behavior and check if the parameters are passed by value/reference

---

### V46 - Arbitary jumps

_Background_

- solidity supports `function` types
- function type variables are not frequently encountered - but if they are used -> specially within assembly code -> in making manipulations of variables of these types -> then they could be used to change control flow to switch to arbitary location
  **(find an example...)**

_Risk_

- Assembly use of function types and manipulations of variables of these types can result in arbitary jumps of storage

_Mitigation_

- Avoid assembly code to the extent possible & specially if there are function variables used
- cAn result in changes to control flow that is unexpected - so avoid it

`////// Exmaple is needed to understand this /////`

---

### V46 - HAsh Collisions

_Background_

- `abi.encodePacked` packs data and encodes variable length arguments - it removes all paddings and hence could lead to hash collisions, when using multiple variables
- This is possible because of zero padding & we don't store length of variables

_Risk_

- hash collisions can be possible when using `abi.encodePacked()` -

_Mitigation_

- should be avoided when encoding function signatures - better to use `abi.encode` instead
- `abi.encodePacked` is better to use when there is only one variable ->
- users who can reach a function that uses `abi.encodePacked()` should not be able to write variables passed into it - this can taint it & cause hash collisions that can be taken advantage of
