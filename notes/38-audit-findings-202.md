# AUDIT FINDINGS 202

[Video](https://www.youtube.com/watch?v=yphqu2N35X4&list=PLYORQHvGMg-UuyTqPiGtmGZ-MJzJUUxhf&index=4)

## Summary

We discuss second part of audit findings in greater detail...List of audit findings, impact and likelihood (part 2)

### Audit findings #121

_Reference_
Growth Defi Finding 5.2

_Auditor_
Consensys

_Severity_

_Issue_
Specification/Access Control

_Description_

- tokens come with different specs - ERC777 (hooks), inflationary/deflationary tokens and rebasing
- not knowing properties of tokens will lead to unexpected behavior

_Recommendation_

- evaluate token behavior before inclusion

### Audit findings #122

_Reference_
Growth Defi Finding 5.6

_Auditor_
Consensys

_Severity_

_Issue_
Naming convention/readability

_Description_

- used multiple contracts - abstracts, upgradeable but without any naming conventions
- readability of code was an issue

_Recommendation_

- use descriptive names for contracts

_Lessons_

### Audit findings #123

_Reference_
Growth Defi Finding 5.8

_Auditor_
Consensys

_Severity_

_Issue_
timing/initialization

_Description_

- allowed users to access deposit and withdraw before contract initialization

_Recommendation_

- initialize before interaction

_Lessons_

### Audit findings #124

_Reference_
Growth Defi Finding 6.2

_Auditor_
Consensys

_Severity_

_Issue_
DOS

_Description_

- requestFlashLoan was going into an unbound loop
- worstcase, changes to system state would be impossible to execute due to block gas limit

_Recommendation_

- reconsider logic of unbound loop

_Lessons_

### Audit findings #125

_Reference_
Paxos finding 3.1

_Auditor_
Consensys

_Severity_

_Issue_
Stale priveleges in access control

_Description_

- setOwners intention is to change old owners and replace with new owners
- old owners could never be removed
- isOwner mapping was never updated -> owner was permanently considered owner for purpose of signing txns

_Recommendation_

- when adding new owners, code would loop through existing owners and change the `isOwner` mapping

_Lessons_

### Audit findings #126

_Reference_
Aave V2 Finding 5.6

_Auditor_
Consensys

_Severity_

_Issue_
Flash Loans - Application Logic

_Description_

- by momentarily removing or adding large amount of liquidity to reserves, can change the interest rate
-

_Recommendation_

- make sure interest rates rebalanced to same values - keep monitoring interest rates
- this is by design - so couldn't change much here - but how well the logic holds had to be checked

_Lessons_

### Audit findings #127

_Reference_
Aave Gov Finding 5.6

_Auditor_
Consensys

_Severity_

_Issue_
validation

_Description_

- malicious token if whitelisted - that doesn't follow token mint/burn/transfer rules
- can stop people from voting with that token or gain unfair advantage if balance could be manipulated

_Recommendation_

- Audit any new whitelisted tokens on platform

_Lessons_

### Audit findings #128

_Reference_
Aave CPM Finding 6.2

_Auditor_
Consensys

_Severity_

_Issue_
specification & validation

_Description_

- assumption was made token decimals < 18
- can lead to overflow related errors

_Recommendation_

- add a validation that token decimals <18

_Lessons_

### Audit findings #129

_Reference_
Aave Gov Finding 5.1

_Auditor_
Consensys

_Severity_

_Issue_
Testing

_Description_

- chainlink oracle price during times of volatility -> needed testing using previous data
- specially in times of high volatility

_Recommendation_

- back-testing to find external contract bulnerability

_Lessons_

### Audit findings #130

_Reference_
Lien Protocol Finding 2.1

_Auditor_
Consensys

_Severity_

_Issue_
Configuration

_Description_

- Complex protocol with lot of moving parts and a high attack surface

_Recommendation_

- Take a mininum viable product and do a iterative/guarded launch
- keep attack vectors low and slowly expand on it
- have a method to pause and update the system during guarded launch

_Lessons_

### Audit findings #131

_Reference_
Balancer Finding 3.6

_Auditor_
Consensys

_Severity_

_Issue_
Code Refactoring

_Description_

- Same checks were repeated across code base

_Recommendation_

- Recommended to use modifiers - in future, if any check changes, it needs to be updated at only one place
- Code readability also improves

_Lessons_

### Audit findings #132

_Reference_
Balancer Finding 5.4

_Auditor_
Consensys

_Severity_

_Issue_
Ordering

_Description_

- `bpool` function uses modifiers `logs` and `lock` in that order
- because `locks` is a reentrancy guard - it should have precedence over `logs`

_Recommendation_

- Place `logs` before `lock`

_Lessons_

### Audit findings #133

_Reference_
MCDEX V2 Finding 2.3

_Auditor_
Consensys

_Severity_

_Issue_
Fragile code

_Description_

- Fragile is when issues addressed in one aspect have unintentional side effects on other aspect of system
- interdependence that can break easily
- challenging to maintain
-

_Recommendation_

- stick to 1 function -> 1 purpose
- reduce dependence on external systems
- high code coverage

_Lessons_

### Audit findings #134

_Reference_
Liquidity Finding 6

_Auditor_
Trail of Bits

_Severity_

_Issue_
Undefined behavior with logging

_Description_

- reentrancy could lead to incorrect event emisisons
- there were events emitted after external calls in some functions
- event from second operation could be emitted before event from first operation
- causing logging and audit issues down the line & incorrect functioning of offchain tools

_Recommendation_

- Apply CEI pattern
- Move any events before external calls

_Lessons_

### Audit findings #135

_Reference_
Origin Dollar Fining 16

_Auditor_
Trail of Bits

_Severity_

_Issue_

- variable shadowing in `OUSD` from erc20 could result in undefined behavior

_Description_

- `OUSD` inherited from ERC20 but redefined `allowances` and `total supply` - could create issues down the line
- these variables were `private` in ERC20 - there was a concern on developer clarity

_Recommendation_

- Remove variables from OUSD and rename them to something else
- Post 0.6.0 naming shadowed variables throws out an error

_Lessons_

### Audit findings #136

_Reference_
Origin Dollar Fining 17

_Auditor_
Trail of Bits

_Severity_

_Issue_

error handling

_Description_

- function had a `return` in signature but lacked `return` statement in its body
- by default will return 0 as it was supposed to retuen uint
- any user checking for the fucntion call value at call site would see 0 returned - and this could have vulnerabilities

_Recommendation_

- Add missing return statements
- OR remove `return` type in those functions

_Lessons_

### Audit findings #137

_Reference_
Origin Dollar Finding 18

_Auditor_
Trail of Bits

_Severity_

_Issue_

- Missing inheritance

_Description_

- Multiple contracts inferred names from their interfaces inferred names and implemented functions
- but did not inherit from those contracts

_Recommendation_

- ensure that contracts inherit from their interfaces

_Lessons_

### Audit findings #138

_Reference_
Yield Finding 7

_Auditor_
Trail of Bits

_Severity_

_Issue_
Solidity compiler optimizations could be dangerous

_Description_

- there have been bugs with security implications when optimization was turned on
- disabled by default
- not sure how many contracts in wild are using optimizations - when such contracts interact with our contract, there can be potential issues

_Recommendation_

- Measure gas savings from optimization vs the risk - and check tradeoff
- if gas benefits are not huge, just skip the optimization

_Lessons_

### Audit findings #139

_Reference_
Yield Finding 2

_Auditor_
Trail of Bits

_Severity_

_Issue_
access control

_Description_

- permission granting was too simplistic
- implemented several privelege users who could do muiltiple tasks
- was not clear which user could execute which operation - no specific checks
- there has to be role separation and rules surrounding it
- privelege access was supposed to be smart contracts but there was no check for that
- once an address got added, it could not be deleted

_Recommendation_

- have role based access permissions
- check if addresses are contracts
- give least privelege to every user
- have provision to delete a particular privelege user

_Lessons_

### Audit findings #140

_Reference_
Yield Finding 4

_Auditor_
Trail of Bits

_Severity_

_Issue_
data validation

_Description_

- lack of validation when setting maturity value
- point at which fiDAI could be redeemed for underlying DAI
- no validation on timestamp to ensure it is within validation range

_Recommendation_

- add maturity checks for yiDAI contract

_Lessons_
