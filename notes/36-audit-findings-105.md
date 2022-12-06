# AUDIT FINDINGS 105

[Video](https://www.youtube.com/watch?v=GX8Z0kRRi_I&list=PLYORQHvGMg-VNo7NvPUM1Jj_qWhDotOJ2&index=6)

## Summary

We discuss few audit findings in greater detail...List of audit findings, impact and likelihood (part 5..)

### Audit findings #81

_Reference_
Futureswap V2 Finding M01

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Configuration

_Description_

- FS Token contract is an upgradeable contract but all classes FSTokenBurnable, FSTokenMintable inherited from FS token were not imported from `upgrade safe` openzeppelin library but instead from their normal, non-upgreadeable counterparts that used `constructor` instead of `initializer`

_Recommendation_
Use upgrade safe libraries that allow a safe way to initialize

_Lessons_
Whenever there is proxy contract -> check if any constructor is used. Replace with `initializer` by looking for upgradeable contracts

### Audit findings #82

_Reference_
Futureswap V2 Finding M03

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Error Handling

_Description_

- `ECDSA.recover` function was used without checking for its return value
- Function used to check oracle address from oracle signature
- Recall that this function gives an unchecked zero address -> if signature does not match, ie invalid
- if not checked, either could result in unintended behavior

_Recommendation_
Error check the function -> and make sure we handle invalid signature case
Revert if we get a zero address

_Lessons_
ECDSA verification - check for address return value

### Audit findings #83

_Reference_
Notional Finding M02

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Error Handling

_Description_

- Adding new variables to multi-level inherited, upgradeable contracts could break the storage layout in child contracts
- Notion protocol used open zeppelin to manage upgradeablitiy with unstructured storage pattern
- when using upgradability approach and when working with multi level inheritance -> if a new variable was introduced in parent contract at the beginning -> that can override the storage layout of child contract
- causes undefined behavior

_Recommendation_

- Prevent such storage layout issues by defining a `upgrade gap` at the end of declarations of variables in each parenr contract
- Such gap allows for future variable additions without impacting existing storage layout of derived contracts
-

_Lessons_
Storage layout is always crucial when working with upgradeable contracts

### Audit findings #84

_Reference_
GEB Funding M07

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Data validation

_Description_

- Unsafe division was performed -> possibility of divide by 0
- input parameter was going into denominator -> user could give a zero value and cause unintended behavior

_Recommendation_

- Add `require` or consider using `SafeMath`

### Audit findings #85

_Reference_
1inch Finding M02

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Timing

_Description_

- `safeApprove()` was used incorrectly
- `safeApprove` prevents changing allowance from non-zero value to non-zero value to prevent front running attacks

_Recommendation_

- use `safeIncreaseAllowance` and `safeDecreaseAllowance` function to increase or decrease allowance

### Audit findings #86

_Reference_
Opyn Gamma Finding H01

_Auditor_
OpenZeppelin

_Severity_
High

_Issue_
Denial of Service

_Description_

- Extra ETH got locked in a function
- If a user sent extra ETH for a batch function -> the remaining ETH got trapped in contract - no `withdraw()` function to pull out remaining eth

_Recommendation_

- either return ETH in same functin
- or implement `withdraw()` to allow users to withdraw() balance ETH

_Recommendation_

- when ETH is sent to a contract -> check how much is needed -> and if ETH is remaining, send balance
- this is especially true in applications that have slippage -> we upfront don't know how much ETH or tokens will be consumed
- if amount consumed is less than what was initially anticipated, we have to return the balcne eth/tokens

### Audit findings #87

_Reference_
Opyn Gamma Finding M04

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Denial of Service

_Description_

- `transfer()` primitive might make ETH impossible to withdraw
- while withdrawing deposits, `payable` proxy controller contract use solidity's `transfer` function which could fail with a withdrawal smart contract if we have not implemented the `fallback()` function OR payable `fallback` function uses more than 2300 gas

_Recommendation_

- Use `send` function instead of transfer
- Use reentrancy guard

### Audit findings #88

_Reference_
Endaoment Finding H02

_Auditor_
OpenZeppelin

_Severity_
High

_Issue_
Timing

_Description_

- Reentrancy risk was present because of not following the CEI pattern
- finalized `grant` function of fund contract was setting `grantComplete` storage variable after token transfer -> this is not following CEI pattern
- could lead to reentrancy attack where funds were drained

_Recommendation_

Use `CEI` pattern
Use `Reentrancy` Guard

### Audit findings #89

_Reference_
Audius Finding H03

_Auditor_
OpenZeppelin

_Severity_
High

_Issue_
Auditing/Logging

_Description_

- No events were emitted while updating Governance and guardian addresses
- registry address and guardian address are highly sensitive accounts
- no way to know when the trusted addresses were replaced by the protocol

_Recommendation_
Consider offchain monitoring

_Lesson_
Identify critical events - and check if there is logging of those events

### Audit findings #90

_Reference_
Audius Finding H07

_Auditor_
OpenZeppelin

_Severity_
High

_Issue_
Identification

_Description_

- Quorum requirement can be bypassed by sybil accounts
- final outcome of proposal was checked via token weighted vote
- Could split tokens over multiple accounts and keep voting
- anyone could bypass the quorum rule

_Recommendation_

- Check by the voting percentage
- rather than unique accounts that have voted

### Audit findings #91

_Reference_
Audius Finding M07

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Timing

_Description_

- Inconsistently checking initialization
- `initialized` modifier was not being used on some functions -> but on others

_Recommendation_

- check if contract is initialized consistently across all functions

### Audit findings #91

_Reference_
Audius Finding M06

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Data validation

_Description_

- Voting period and quorum could be set to zero
- when governance contract was initialized, they were checked to make sure voting period and quorum were non-zero
- however setter functions did not do this check -voting period = 0 -> allow spurious proposals, quorum =0 also allows the same

_Recommendation_

- add validations to setter functions

### Audit findings #92

_Reference_
Audius Finding M10

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Configuration

_Description_

- Some state variables were not set during initialization
- Audius contract could be upgraded using unstructued proxy storage pattern
- requires use of initializer instead of constructor
- some contracts, initializer was not initializing all variables

_Recommendation_

- initialize all variables in `initialize` function
- if there is a reason for not initializing, document them
- and add error checks wherever such uninitialized variables were used

### Audit findings #93

_Reference_
Audius Finding M10

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Configuration

_Description_

- Some state variables were not set during initialization
- Audius contract could be upgraded using unstructued proxy storage pattern
- requires use of initializer instead of constructor
- some contracts, initializer was not initializing all variables

_Recommendation_

- initialize all variables in `initialize` function

### Audit findings #94

_Reference_
Primitive Finding M08

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Timing

_Description_

- Expired/paused options could still be traded
- option tokens can still be transferred when option contract is paused or expired or both
- would allow malicious sellers to sell options that are paused or expired to ignorant buyers

_Recommendation_

- prevent tranfser of tokens if they are paused or expired
- related to `pausable`
- if they can be transferedd - document it for user transparency

### Audit findings #95

_Reference_
ACO Finding M01

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Data validation

_Description_

- `transferFrom` was used to transfer user funds into another contract
- was being used in `mint`, `mint2`, `validate` and `burn`
- destinaation of this transfer was the ACO token contract
- such transfers behave unexpectedly if external ERC20s charge fees (eg. usdt token has a functionality to charge fees)
- in such case - amount received < amount sent and this could impact accounting for balances

_Recommendation_

- vetting tokens used in `transferFrom`
- implement sanity checks that enforce balances increase by transfer amount when calling `transferFrom` - if not, we have a revert

### Audit findings #96

_Reference_
Compound Finding M04

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Audit & Logging

_Description_

- incorrect event emission
- data in emission was stale data

_Recommendation_

- consider emitting after changes were applied - so that event reflects correct data

### Audit findings #97

_Reference_
MCDEX Mai Finding C01

_Auditor_
OpenZeppelin

_Severity_
Critical

_Issue_
Access Control

_Description_

- anyone coulld liquidate on behalf of other account
- perpetual contract had a public `liquidateFrom` that bypass checks in liquidate fuction
- third party could confiscate and undercollateralize position by using above function
- any trader could rearrange another traders position
- could break the automated market maker invariants

_Recommendation_

- liquidateFRom change to internal visibility from public

### Audit findings #98

_Reference_
MCDEX Mai Finding C02

_Auditor_
OpenZeppelin

_Severity_
Critical

_Issue_
DOS

_Description_

- orders could not be cancelled
- when user updated cancel order -> mapping was getting updated
- but cancel order had no side effects

_Recommendation_

- add checks for cancel orders

### Audit findings #99

_Reference_
MCDEX Mai Finding M03

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Timing

_Description_

- deposit collateral - deposit was retrieved before user balance was updated
- withdraw collateral - collateral was sent before user balance was updated
- same pattern for other functions - deposit to Insurance fund, withdraw from insurance fund

_Recommendation_

- follow CEI pattern
- add reentrancy guard

### Audit findings #100

_Reference_
MCDEX Mai Finding M06

_Auditor_
OpenZeppelin

_Severity_
Medium

_Issue_
Timing

_Description_

- governance changes were set instantly
- lot size and other such params could be changed instantlu

_Recommendation_

- add timelock for governance changes

### Audit findings #101

_Reference_
UMA Finding H01

_Auditor_
OpenZeppelin

_Severity_
High

_Issue_
Data validation

_Description_

- governance votes could be duplicated
- data verification used commit-reveal - voting pattern is only visible after voting
- prevent voters from simply voting with majority
- allowed voters to copy each others submissions - votes were not cryptographically tied to voter

_Recommendation_

- include voter address in commitment to prevent duplication
- include relevant time stamp
- price identifier and round id