# SECURITY PITFALLS 301

[Video](https://www.youtube.com/watch?v=M0C7z3TE5Go)

## Summary

List of all security vulnerabilities

### V1 - Unlocked pragma

_Background_

- Most users are now > 0.8.0 => arithmetic checks and stable verion
- Unlocked pragma refers to using a pragma version with ^
- ^ means any compiler version until the next breaking version can be used to compile a contract
- _eg. pragma solidity ^0.8.3 indicates any compiler version from 0.8.3 to 0.9.0 (excluding) can be used to compile this smart contract_

_Risk_

- One solidity compiler version can be used for testing & another version can be used for deployment
- Different versions for testing & deloyment are a source of risk

_Mitigation_

- Remove `^` and force a specific compiler verion - Lock Pragma
- This will ensure testing and deployment is done in same compiler verion

---

### V2 - Different pragma across different contracts

_Background_

- Different contracts in same project can have different pragmas
- A specific pragma only applies for the contract where it is used

_Risk_

- Different versions have different bugs and features - compiling multiple versions with different versions can create incompatible errors that might spread across application

_Mitigation_

- Recommend to use the same pragma version across all contracts in a single application.
- This will result in all contracts having same set of bugs, features and security checks

---

### V3 - Access control

_Background_

- Access to functions is a fundamental aspect of security
- Not everyone has same level of access to make state changes on blockchain

_Risk_

- Incorrect access controls can lead to exploitations where state/balance is changed by exploiters or hackers

_Mitigation_

- Check every function if it needs a owner or role based access control
- Check use of correct modifiers & if some modifiers are missing and enforce access control as per protocol logic

---

### V4 - Withdraw funds

_Background_

- Smart contracts hold balances - both in ether and other tokens
- Functions to deposit funds into contract and withdraw funds from contract
- `Withdraw` functionality is critical because it allows funds to be withdrawn from contracts
- These functions are also honey pots that are attacked by exploiters

_Risk_

- Withdraw functions are unprotected and don't have proper access controls
- Any attacker call unprotected withdraw functions & unauthorized calls leads to loss of funds

_Mitigation_

- Access control for `withdraw()` functions has to be carefully designed and analyzed

### V5 - SelfDestruct

_Background_

- Use of `selfdestruct` is very dangerous as it can delete all state and contract bytecode & transfer funds to an external contract

_Risk_

- Exploiter maliciously gets to access `selfdestruct` on a contract and give his address as target address to receive funds
- Either by accident or by exploit, contract's existence is wiped out along with all data and funds

_Mitigation_

- Any smart contract that uses `selfdestruct` in a particular function needs to protect access to that function
- Carefully design and analyze the access control rights to functions that use `selfdestruct` feature
- Only authorized users can call these functions
- At a very high level, `selfdestruct` itself has to be completely avoided, if possible

---

### V6 - Modfier side effects

_Background_

- Modifiers in solidity are used to check balances, access control, inputs etc
- Modifiers have access to state variables but use of these states should only be done for checks
- Modifier making state changes or external calls can create 'side effects'

_Risk_

- Modifier making state changes or external calls creates side effects which could be ignored by developer or security auditor
- This is because function logic and modifier logic are at 2 separate places
- And general convention is that modifiers don't make state changes - this might lead to devs ignoring the state change or forget that it exists

_Mitigation_

- Modifiers should NOT have side effects - ie no state changes or external calls to non view/pure functions

---

### V7 - Incorrect Modifiers

_Background_

- Modifiers do checks (access controls or input validations or balance checks)
- Once done, modifier control flow either reverts (ie no state changes) OR
- modifier executes actual function logic
- Control flow has binary outcome - either reverts or executes

_Risk_

- Orphaned control flows that DONT end in either revert or execution causes function to return default value
- This might cause unexpected behaviour because dev was either expecting revert or actual outcome
- default values might create flawed execution

_Mitigation_

- Make sure that all modifier control flows should either 'revert' or 'execute' - no control flow can end in default outcome

---

### V8 - Constructor Names

_Background_

- Solidity version <0.4.22, `constructor` was defined using `contract name`
- <0.5.0, `constructor` key word could be used along with `contract name` and their was a precedence
- only >= 0.5.0, only `constructor` keyword was used for defining constructor

_Risk_

- Old contracts unexpected behaviour when contract name was spelt wrong - dev was assuming he was writing a constructor but compiler understood it as just another function
- When `constructor` and `contract name` were both used, there was a precedence given to `constructor` - created more confusion
- Constructor naming could create bugs in older contracts

_Mitigation_

- handled in newer versions - not a concern anymore
- For old contracts, make sure spell check is correct

---

### V9 - Void constructors

_Background_

- If a contract derives from base contract, constructor of derived contract assumes base contract is implemented

_Risk_

- If derived contract assumes that base contract is implemented when it is not, it leads to security implications
- When derived contract calls constructor of base contract & base contract is not implemented, there is nothing there to call

_Mitigation_

- check if base constructor is implemented first before calling base contract functions or constructors
- if not implemented, prevent call to base constructor

---

### V10 - Implicit Constructor (Payable)

_Background_

- Constructors by default do not accept ether, ie they do not have `payable` key word
- If we send ether to constructor not marked `payable`, then constructor reverts

_Risk_

- When contract is derived from a base contract wthat has a constructor BUT the derived contract did not have a explicit constructor, then we could send ether to derived contract
- This compiler bug was present from v0.4.5 -> v0.6.8

_Mitigation_

- If a derived contract does not have explicit constructor -> check if any of Base constructors are payable

---

### V11 - delegate call

_Background_

- Delegate call is where caller contract calls the callee contract logic but with the state of caller contract

_Risk_

- Risk is when callee contract is a user controlled address
- User can maliciously call a malicious contract that can make unauthorized modifications to the calling contract state

_Mitigation_

- delegate call should ensure that destination address is a trusted address
- always track the destination address ownership in a delegate Call

---

### V12 - Reentrancy

_Background_

- External calls made by caller address can lead to callbacks to same caller address
- And this callback can change the state of the caller contract

_Risk_

- When a external call causes a callback to a caller contract that causes recursive loops
- C1 -> calls C2 -> callsback C1 -> calls C2 -> callback C1 ---- this loop can go endless
- Need not necessarily loop always- a single callback, if not handled properly, can cause a state imbalance
- state imbalance - is state before calling external contract is no longer state after callback
- this callback can cause state change which can change logic

- Callbacks could be
  - withdrawing funds over and over
  - out of order emission of events (less serious but can create issues to front ends)

_Mitigation_

- Best practice is to follow CEI Pattern (Checks -> Effects -> Interactions)
- CEI pattern is, make a check, effect changes to state variables, and only once this complete, make an external call
- Reentrancy Guards by OZ libraries are also recommended to use -> all vulnerable functions (eg. ones changing balances) should use reentrancy modifiers

---

### V13 - ERC777 callbacks

_Background_

- Recall that ERC777 is an improvement to ERC20 token that defines operators who can send or receive tokens
- ERC777 has concept of hooks
- A hook is simply a function in a contract that is called when tokens are sent to it, meaning accounts and contracts can react to receiving tokens.
- Note that hooks can define logic before/after an action takes place

_Risk_

- If a calling contract calls a ERC777 contract, a hook can be defined that can cause a callback into calling contract
- C1 -> ERC777 -> hook -> C1 (callback)
- This is again a re-entrancy attack but this time using hooks concept of ERC777 contracts
- ERC20 does not support hooks

_Mitigation_

- Best practice is to follow CEI Pattern (Checks -> Effects -> Interactions)
- Again, use reentrancy guard libraries on calling contract

---

### V14 - Transfer() and Send() functions

_Background_

- Note that `transfer()` and `send()` are low level functions to prevent re-entrancy attacks
- Way they do this is by sending a fixed gas of 2300 wei - gas is low enough for any meaningful instructions
- just enough for basic processing

_Risk_

- Fixed gas price of 2300 wei has caused some error reverts because gas opcodes have seen repricing
- gas costs for txns have increased and there is a risk that 2300 wei is insufficient after this repricing

_Mitigation_

- Recommened to use `call` which transfers balance gas (67/68 gas available) to the callee function
- Chance of a revert due to insufficient gas does not exist
- Also `call` is superior because we can send `data` to the callee function
- Couple this `call` usage with rentrancy guard

---

### V15 - private data

_Background_

- Recall that state variables on chain have a `private` visibility keyword
- `private` means that the state variable is not accessible via external/public calls

_Risk_

- Storing sensitive contract data in private variables assumes that private variables are inaccessible
- This is incorrect - every data stored onchain is accessible - private just means its not accessible via regular function calls
- People having access to EVM storage/mempools will be able to access private data

_Mitigation_

- Do not have any sensistive data, keys etc on contract, even if the visibility is made private
- Any data that must be stored on chain as `private` must be encrypted and stored offchain

---

### V16 - psuedo random number generators

_Background_

- Random numbers are needed for several use cases (betting, NFT minting etc)
- Random numbers need a seed that is truly random - generating seed has multiple algorithms
- one of practice has been to use block number or block timestamp or txn nonce - this is not really random and hence the name, psuedo random number

_Risk_

- Variables such as `block.timestamp`, `blockhash` and `nonce` can be controlled by validators and hence are not truly random
- If stakes of these random numbers are very high, then malicious actors can use the above to generate a rigged random number

_Mitigation_

- Use chain link VRF (Verified Random Number Generator) service to generate a random number verifiable onchain

---

### V17 - overflow/underflow

_Background_

- We have seen that integer operatins beyond min/max range of a specific integer type leads to overflows/underflow
- Such unexpected behaviour will lead to vulnerabilities

_Risk_

- When a overflow happens, number goes back to 0, if undeflow happens, number goes to type(uint).max - 1
- This behavior can cause unexpected changes to the logic, creating vulnerabiklities

_Mitigation_

- All contracts >0.8.0 have arithemtic underflows/overflows automatically handled
- To unhandle, we can use the `uncheck` keyword to block (although not recommended)
- if using <0.8.0, use `SafeMath` library

---

### V18 - using divide before multiply

_Background_

- Solidity does not handle floating points
- Order of operation is from left to right
- If a divide happens before multiple, floating point complications can happen

_Risk_

- If divide happens before multiply, solidity will truncate the floating point number due to division
- This truncation could result in wrong number when multiplied and can cause logic errors- this is because of loss of precision

_Mitigation_

- Always multiply before you divide in any expressiion involving `uint` type
