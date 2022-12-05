# AUDIT FINDINGS 101

[Video](https://www.youtube.com/watch?v=SromSImIpHE)

## Summary

We discuss few audit findings in greater detail...List of audit findings, impact and likelihood

### Audit findings #1 ERC-20 return values

_Reference_
Aave V2 Finding 6.4

_Auditor_
Consensys

_Severity_
Medium

_Issue_
unhandled return values from `transfer` and `transferFrom`

_Description_

- these ERC20 functions may revert, return a boolean or not return at all
- Call sites should anticipate such return value -> and implement control flow accordingly
- ERC20 implementations may not be standard => it is much safer to use return values

_Recommendation_

- Check return values and handle true/false cases
- OR Use SafeERC20 Wrappers

### Audit findings #2 - Reentrancy

_Reference_
Defi Saver Finding 5.1

_Auditor_
Consensys

_Severity_
Critical

_Issue_
Reentrancy - allowed for random task execution

_Description_

- When user took a flash loan- a function gave Flash loan wrapper gave permission to execute functions on behalf of users DS proxy
- this permission was revoked on after entire execution was finished - which means if any external contract uses the function, it could perform a re-entrancy attack and call any function including transfering of user funds

_Recommendation_

- Since cause was potential reentrancy from any external calls, recommendation was to use `Reentrancy Guard`

### Audit findings #3 - Input validation

_Reference_
Defi Saver Finding 5.2

_Auditor_
Consensys

_Severity_
Major Severity

_Issue_
Tokens with decimals > 18 could create an issue

_Description_

- Contract assumed that maximum number of decimals for token is 18
- Having tokens with > 18 decimals could result in broken code flow and unpredictable outcomes

_Recommendation_

- Use SafeMatch `SUM` function to revert if decimals > 18

_Lesson_

- Any mathematical calculation - check if there is any possibility of divide by 0, overlfow/underflow
- Any possibikity of a number exceeding its data type (specially when uint8/16 data types are used)

### Audit findings #4 - Error codes of external dependencies

_Reference_
Defi Saver Finding 5.3

_Auditor_
Consensys

_Severity_
Major

_Issue_
Error codes of external dependencies were not checked

_Description_

- Error codes of Compound Protocol functions were left unchecked
- Some compound protocol functions return boolean without reverting

_Recommendation_

- Recommended function to revert incase error code is not 0

_Lesson_

- Review all error codes of external dependencies and check if native contract is handling all error codes

### Audit findings #5 -

_Reference_
Defi Saver Funding 5.4

_Auditor_
Consensys

_Severity_
Medium Severity

_Issue_
Incorrect parameter ordering

_Description_
Parameters used for allowance function call were not in the same order as what was used later in call to `transferFrom`

_Recommendation_
Fix the ordering of parameters

_Lesson_
Review all functions parameters -> if they are in correct order -> even more so with external dependency functions

### Audit findings #6

_Reference_
DAOfi finding 4.1

_Auditor_
Consensys

_Severity_
Critical

_Issue_

- Address validation missing in the `AddLiquidity` function of the LP Pool
- As a result, approvals of users can be stolen -> and funds transfeered to a random address by malicious actor

_Description_

- `AddLiquidity` function checks if pair exists, if it doesn't exist, creates a pair token and transfers funds to the pair address
- Key vulnerability is that the address to which funds were transferred was not being validated
- Since approvals were already in place for factory contract to transfer funds from user -> funds could be diverted -> and funds once transferred could be withdrawn by malicious actor

_Recommendation_

- Transfer funds from `msg.sender` instead of `lp sender`
- access control checks for correct address could solve this issue

_Lesson_

- Always check who is the beneficiary of funds -> is this address verified -> who can make the transfer of funds

### Audit findings #7

_Reference_
DAOfi finding 4.4

_Auditor_
Consensys

_Severity_
Major

_Issue_
Incorrect check -> instead of checking for `A`, error check was done on `B`

_Description_

- `SwapExactTokenForETH` checked the wrong return value
- instead of checking `amount received > min amount`, it was checking the balance in the contract before and after the function call -> this was ineffect not the right check to be made

_Recommendation_

- Check the correct return values directly obtained from function at client site

_Lesson_
Checking indirect values instead of relying on directly returned values could create complexities

### Audit findings #8

_Reference_
DAOFi Finding 4.5

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Denial-of-Service

_Description_

- `Deposit` function accepted deposits of 0 amount, blocking the pool thereafter
- function allowed only single deposit to be made & no liquidity could be added to pool after depositing funds
- since deposit amount did not check non-zero deposit, deposit feature could be locked out by any malicious user who did not hold those tokens

_Recommendation_
Require minimum deposit with non zero checks

_Lesson_

- Irreversible state changes, eg. functions that can lock out access based on inputs received from external call arguments are vulnerable to attacs
- Whenever such actions are present, always check if some zero values, negative values, random values can trigger irreversible change

### Audit findings #9

_Reference_
Fei Finding 3.1

_Auditor_
Consensys

_Severity_
Critical

_Issue_

- Application logic error - where a `genesis group commit` function overrode previous commit values (instead of adding)

_Description_

- overwriting previous values -> allowing anyone to commit 0 values to other's commited values
- this was a serious error as user funds record would be lost forever

_Recommendation_

- Add commitment values to previous commitment instead of overwiting new value

_Lesson_

- When accounting for balances -> make sure that the balance update is incremental/decremental
- When a new value completely overwrites an existing value -> could be dangerous as ppl might accidentally update
- also only the sender's details should be updateable

### Audit findings #10

_Reference_
Fei Finding 3.2

_Auditor_
Consensys

_Severity_
Critical

_Issue_
Even after launch, you could call some functions (`Purchase` & `Commit`)

_Description_
Some functions that were supposed to be called only AT launch were callable even after launch. State check was not being done properly

_Recommendation_
Track state and have function validation -> callabale only at launch
If there is any time-specific validation, make sure it is being properly accounted for (time specific validation includes something only called at launch, something only called when price > X, something on called when X days have passed)

_Lesson_
Time specific validations have to be carefully analyzed - who can trigger, how can they be triggered etc.

### Audit findings #11

_Reference_
Fei protocol finding 3.3

_Auditor_
Consensys

_Severity_
Major

_Issue_
Missing data validation - lack of which could cause overflows/underflows

_Description_

- Unssafe type casting from a `uint256` supplied by user to `int256` which is a signed integer in `mint` and `burn` function
- this leads to overflow without appropriate checks

_Recommendation_

- Recommendation was to use OZ SafeCast

_Lesson_
Type casting needs special review, from higher data types to lower -> can lead to overflow/underflow and loss of data

### Audit findings #12

_Reference_
Fei protocol finding 3.4

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Timing issue - `allocate` function was callable before launch

_Description_

- By sending even 1 wei, anyone could bypass checks and mint fei
- this could even be fone before the bonding curve was launched
- Again - state check of 'launch' is not tracked - and validation not done

_Recommendation_

- Data validation to check timing of launch

_Lesson_

- Again a timing issue & passing a non-zero amount can bypass checks and allow users to mint. Watch out for timing issues & attach validations for this

### Audit findings #13

_Reference_
Fei Protocol Finding 3.5

_Auditor_
Consensys

_Severity_
Medium

_Issue_
`IsTimeEnded` returned true even when timer was not initialized

_Description_

- `startTime` was set only when `initTime` was called
- before `initTime` was called -> `isTimeEnded` was returning true by using `startTime` default value of 0
- user can exploit the `isTimeEnded=true` condition to access a control flow that was never supposed to be used as timer was not initialized

_Recommendation_

- `isTimeEnded` should be faluse if time is not initialized

_Lesson_

- State function logic should not give a wrong value based on default states - conditional check based on default values is very important to make

### Audit findings #14

_Reference_
Fei Protocol issue 3.6

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Data validation - using math operations without overflow/underflow checks

_Description_

- All values in math operations were derived from actual eth values so they could not overflow
- Any overflow/underflow could create logic breakdowns

_Recommendation_

- Use of `SafeMath` is recommended or `Solidity > 0.8.0`

### Audit findings #15

_Reference_
Fei Protocol issue 3.7

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Error handling - no checking for unchecked return value of ERC20 transfer

_Description_
ERC20 transfer gives a transfer status - call sites should check the transfer status before moving ahead

_Recommendation_
Use of `SafeTransfer` is recommended for transfers - use `SafeERC20` Wrapper

_Lesson_
Whenever we see `transfer`, `transferFrom` -> it always makes sense to check if call sites are properly handling
If not, then just recommend SafeERC20

### Audit findings #16 - Error Handling

_Reference_
Fei Protocol issue 3.8

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Timing issue

_Description_

- `EmergencyExit` and `Launch` functions were mutually exclusive. `EmergencyExit` should be used only if `launch` fails -> but the function was accessible even after launch

_Recommendation_
Error validation -> function call is conditional on state ->

_Lesson_
Logic that is conditional on specific state needs to be specially checked -> very easy for devs to miss out on validations although such validation is part of specifications

### Audit findings #17 - ERC20 transfer validation

_Reference_
bitBank finding 5.1

_Auditor_
Consensys

_Severity_
Major

_Issue_
Error handling

_Description_

`ERC20 transfer` was not using return value at call site

_Recommendation_
Use SafeERC20 wrapper

### Audit findings #18 - Reentrancy

_Reference_
Metswap finding 4.1

_Auditor_
Consensys

_Severity_
Major

_Issue_
Reentrancy

_Description_

- Reentrancy vulnerability was in Metaswap `swap` function
- attacker was able to re-enter swap, execute their own trade using same tokens and get all the tokens for themselves

_Recommendation_
Add `Reentrancy guard` for swap function

_Lesson_

- Whenever there is a token transfer, consider the `reentrancy risk` - can I get back into the core function and disrupt
- this has to be the constant way of thinking as a hacker

### Audit findings #19 - Reentrancy

_Reference_
Metswap finding 4.2

_Auditor_
Consensys

_Severity_
Major

_Issue_
Access Control

_Description_

- Metaswap was a platform that would take user approvals for multiple aggregators in an effort to save gas cost
- By splitting trades across aggregators, Meta Swap could give users a lowest gas fee execution
- Flaw in this design was that an existing or new malicious adapter could have access to all user tokens -> an adapter in this case would be stored inside the contract

_Recommendation_

- change design of the approval process -> have metaswap contract the sole account that has user approvals
- send the tokens to another contract that could then route them to various aggregators - this new contract can only be called by its parent contract that has approvals from users -> so aggregator calls happen through an adaptor -> that gets `delegate called` by the parent contract

_Lesson_

- Access control sometimes could be complex but at its core, it is more of 'what is prevented' than 'what can be done' -> always think about what must be prevented to stop an attack

### Audit findings #20 - Timing

_Reference_
Metswap finding 4.3

_Auditor_
Consensys

_Severity_
Major

_Issue_
Timing

_Description_

- Malicious owner could front run traders by updating adapters to steal from users
- design was using multiple adapters -> which were delegate calling each other -> users had to trust every adapter because one malicious adapter could change logic of all other adapters

_Recommendation_

- Disallow modifications of existing adapters
- Instead add the new adapters and disable the earlier ones

_Lesson_

- this is a tough one - couldnt understand much unless we look at actual contract
- but broadly - front running needs to be systematically thought - can someone check a mempool to attack a particular txn
