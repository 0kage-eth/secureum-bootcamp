# AUDIT FINDINGS 203

[Video](https://www.youtube.com/watch?v=zAzNDwu23UI&list=PLYORQHvGMg-UuyTqPiGtmGZ-MJzJUUxhf&index=5)

## Summary

We discuss second part of audit findings in greater detail...List of audit findings, impact and likelihood (part 3)

### Audit findings #141

_Reference_
Yield Finding 5

_Auditor_
Trail of Bits

_Severity_

_Issue_
Auditing & Logging

_Description_

- when user added/removed a delegate, an event was emitted
- there was no provision of stopping a delegate from adding and removing a delegate -> and hence events could be emitted continuously

_Recommendation_

- check if delegate address is already enabled or disabled for user and messages are only emitted when delegate is activated/deactivated to prevent bloated logs

### Audit findings #142

_Reference_
0x Finding 8

_Auditor_
Trail of Bits

_Severity_

_Issue_
Auditing & Logging

_Description_

- lack of events for critical operations
- several operations had no log - no way to check if protocol is working correctly once deployed
- no suscpicious events can be detected without events

_Recommendation_

- add events to all critical actions where appropriate
- long term, add a offchain monitoring system

### Audit findings #143

_Reference_
0x Finding 20

_Auditor_
Trail of Bits

_Severity_

_Issue_
Error handling

_Description_

- function `stakingPoolexists` was not returning a boolean -> although the function has a return bool type
- always returns a false -> can create problems

_Recommendation_

- add a return statement or remove `return` in signature

### Audit findings #144

_Reference_
DFX Finance Finding 2

_Auditor_
Trail of Bits

_Severity_

_Issue_
Specification

_Description_

- min target amount and max origin amount are using open ranges (ranges that exclude the value itself)
- conventional interpretation of min and max work on closed ranges

_Recommendation_

- Use strict inequalities or remove open ranges

### Audit findings #145

_Reference_
DFX Finance Finding 3

_Auditor_
Trail of Bits

_Severity_

_Issue_
Undefined behavior

_Description_

- If operator tended to create a new curve for a base ccy pair that already existed, Curve factory returned the existing curve without indicating it is existing
- naive operator can overlook the issue

_Recommendation_

- Differentiate between new and existing curve creation

### Audit findings #146

_Reference_
DFX Finance Finding 4

_Auditor_
Trail of Bits

_Severity_

_Issue_
Data validation

_Description_

- Missing checks for zero address
- Foe eg. zero address check was missing in router cnstructor

_Recommendation_

- Ensure that code that sets wstate variables has valid zero address checks

### Audit findings #147

_Reference_
DFX Finance Finding 8

_Auditor_
Trail of Bits

_Severity_

_Issue_
Error handling

_Description_

- custome `safeApprove()` return value was not used at call site

_Recommendation_

- add checkks at call sites

### Audit findings #148

_Reference_
DFX Finance Finding 9

_Auditor_
Trail of Bits

_Severity_

_Issue_
Configuration

_Description_

- Curve a ERC20 token implemented all 6 ERC20 functions
- didn't implement extremely common view methods for symbol name and decimals

_Recommendation_

- Implement name, symbol, decimals to ensure that ERC20 spec is fully implemented

### Audit findings #149

_Reference_
DFX Finance Finding 11

_Auditor_
Trail of Bits

_Severity_

_Issue_
Data Validation

_Description_

- Missing Safe Math

_Recommendation_

- Use Safe Math to prevent undeflows and overflows

### Audit findings #150

_Reference_
DFX Finance Finding 16

_Auditor_
Trail of Bits

_Severity_

_Issue_
Timing & DOS attack

_Description_

- function `setFrozen` could be used to by malicious owner to refuse deposits or swaps
- owner can unfreeze this account at a later time

_Recommendation_

- Any frozen account should not be long enough for malicious owner to execute an attack
- Or implement permanent freeze

### Audit findings #151

_Reference_
Hermez Network Finding 4

_Auditor_
Trail of Bits

_Severity_

_Issue_
DOS attack

_Description_

- No fees for account creation

- attacker could spam network by creating fake accounts and clog the contract
- contract will run out of gas leading to a DOS attack
- ethereum miners do not have to pay for gas - they themselves can create accounts to attack contract

  _Recommendation_

- Cap max accounts
- Add fee for account creation to make the array bounded
- monitor account ctreation to check how many accounts are being ceated using events

### Audit findings #152

_Reference_
Hermez Network Finding 11

_Auditor_
Trail of Bits

_Severity_

_Issue_
Undefined behavior

_Description_

- Use of empty functions instead of interfaces
- Leaves contracts error prone
- Contract called `WithdrawDelayInterafce` was a contract with empty functions - meant to be an interface
- coontract inhering from the above would not require an override of those functions and so would not benefit from compiler checks

  _Recommendation_

- recommendation is to use interface instead of contract - if the contract indeed has empty functions
- document inherent schema of contracts

### Audit findings #153

_Reference_
Hermez Network Finding 19

_Auditor_
Trail of Bits

_Severity_

_Issue_
Data validation

_Description_

- Cancel non-existing transaction
- no transaction check in cancel transaction - an attacker could confuse monitoring systems
- because an event was emitted without checking if a transaction existed

_Recommendation_

- check if a transaction to be canceled existed before emitting an event

### Audit findings #154

_Reference_
Hermez Network Finding 20

_Auditor_
Trail of Bits

_Severity_

_Issue_
Patching

_Description_

- contract used dependencies that did not track upstream changes
- third party contracts were copy pasted in the hermez repository without documenting the exact version used or if it was modified
- this would make updates and dependencies unreliable since they would have to be updated manually

_Recommendation_

- Review code base and document dependencies
- track updates to dependencies and any vulnerabilities on those dependencies

### Audit findings #155

_Reference_
Hermez Network Finding 21

_Auditor_
Trail of Bits

_Severity_

_Issue_
Access control

_Description_

- `addToken` allowed anyone to add new tokens which contradicts documentation
- docs say only governance should have this authorization
- unclear whether implementation or documentation is correct

_Recommendation_

- Sync implementation with documentation
- standardize authorization spec for adding new tokens

### Audit findings #156

_Reference_
Hermez Network Finding 22

_Auditor_
Trail of Bits

_Severity_

_Issue_
Undefined behavior

_Description_

- contract name duplication left code base error prone
- had multiple contracts that shared same name

_Recommendation_

- avoid duplicate names
- use slither to identify duplicates

### Audit findings #157

_Reference_
Advanced Blockchain Finding 27

_Auditor_
Trail of Bits

_Severity_

_Issue_
Patching

_Description_

- use of hardcoded addresses which can cause errors down the line
- each contract uses external contracts - so addresses are stored in the config files
- addresses can have errors which would deploy contract pointing to wrong address

_Recommendation_

- set addresses when contract was created, rather than using hardcoded values

### Audit findings #158

_Reference_
Advanced Blockchain Finding 28

_Auditor_
Trail of Bits

_Severity_

_Issue_
Configuration

_Description_

- borrow rate formula used an approximation of number of blocks per year
- the value assumed a new block was mined every 15 seconds
- this number could change over time and across chains

_Recommendation_

- analyze effects of a deviation in this & what happens if blocks don't get finalized over a certain period of time

### Audit findings #159

_Reference_
Advanced Blockchain Finding 25

_Auditor_
Trail of Bits

_Severity_

_Issue_
Data validation

_Description_

- no lower or upper bounds on flash loan rate implemented in contract
- allow it to set to arbitarily high rate to secure higher fees

_Recommendation_

- set lower and upper bounds to all configurable parameters to limit the privelege of users

### Audit findings #160

_Reference_
Advanced Blockchain Finding 4

_Auditor_
Trail of Bits

_Severity_

_Issue_
Patching

_Description_

- Logic had a huge amount of duplicate code
- any bug fixes would have to be copied and pasted at multiple places

_Recommendation_

- inheritance to allow code reuse
