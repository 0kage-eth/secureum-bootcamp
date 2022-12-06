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
