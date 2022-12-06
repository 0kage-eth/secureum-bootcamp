# AUDIT FINDINGS 105

[Video](https://www.youtube.com/watch?v=IXm6JAprhuw)

## Summary

We discuss second part of audit findings in greater detail...List of audit findings, impact and likelihood (part 1)

### Audit findings #102

_Reference_
Umbra Finding 5.2

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Access Control & Input Validation

_Description_

- Anyone could force a call to a hook contract by transfering a small amount of tokens to the contract
- Potential edge cases for hook receiver contracts were not documented or validated
- hook input paremeters were not validated -> causing potential exceptional behavior

_Recommendation_

- document and validate edge cases for `receiveHook`

_Lessons_

- Some contracts have hooks that get triggered when tokens/eth are received paid
- When we have hooks, check input paremeters and whether those parameters can be exploited

### Audit findings #103

_Reference_
Umbra Finding 5.3

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Specification/Documentation

_Description_

- Specification of tokens that are compatible with protocol not specified - ???? not clear what the issue is,will revisit this when i go through audit report
- for eg. any token that supports inflationary/deflationary behavior will not be supported
  _Recommendation_

- document which tokens are used, as in which standard
- check any inflation/deflation/rebasing of those tokens allowed in the standard
- inflation -> tokens increase -> amount received > amount sent
- deflation -> tokens decrease -> amount received < amount sent
- rebasing - combination of above 2 -amount of tokens one holds is proportional to the total supply -> increase supply increases tokens held and vice versa

_Lessons_

### Audit findings #104

_Reference_
Defi Saver Finding 5.5

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Testing

_Description_

- test coverage was not up to the mark
- tests failed to execute

_Recommendation_

- Add full coverage test suite

_Lessons_

### Audit findings #105

_Reference_
Defi Saver Finding 5.6

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Naming / Documentation & Refactoring

_Description_

- Code used undocumented assumptions
- Names were misleading - name suggested a read function but it was writing states

_Recommendation_

- Refactor code
- change names so they are more intuitive
- document all assumptions

_Lessons_

### Audit findings #106

_Reference_
Defi Saver Finding 5.1

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Error checking

_Description_

- Return value of functions was not used at call site
- return value of transferred tokens was not used to figure if it was valid or not

_Recommendation_

- return value of transfer token should be check for correct control flow

_Lessons_
any time a function returns a value > it is imperative that we use that value

### Audit findings #107

_Reference_
Defi Saver Finding 5.11

_Auditor_
Consensys

_Severity_
Medium

_Issue_
Access Control & Logging

_Description_

- Missing access control for defisaver.log
- anybody can could create logs - because there was no access

_Recommendation_

- Add access control even to logging functions

_Lessons_

### Audit findings #108

_Reference_
DAOfi Finding 3.1

_Auditor_
Consensys

_Severity_
Low
_Issue_
Documentation

_Description_

- Stale comments in documentation that dont reflect actual code
- specifically this one had stale commensts on storage slots

_Recommendation_

- remove stale comments

_Lessons_

### Audit findings #109

_Reference_
MStable 1.1 Finding 6.14

_Auditor_
Consensys

_Severity_
Low

_Issue_
Documentation

_Description_
Mismatch between what code implemented v/s what comments indicate

_Recommendation_

- udpate code or comment to be consistent
- adds needless risk of some new developer making changes as per old comments

_Lessons_

### Audit findings #110

_Reference_
Daofi Finding 3.2

_Auditor_
Consensys

_Severity_
Low

_Issue_

- Unnecessary code or logic

_Description_

- Getter function to immutable address is redundant code

_Recommendation_

- if address is immutable, no need for getter functions -> replace with variable names
- principle of `economy of mechanism`

_Lessons_

### Audit findings #111

_Reference_
Daofi Finding 3.4

_Auditor_
Consensys

_Severity_
Low

_Issue_

- Lack of tests

_Description_

- Insufficient validation for complex math
- presence of unit tests would identify the problem immediately

_Recommendation_

Increase amount of unit tests
Add fuzzing

_Lessons_

### Audit findings #112

_Reference_
Fei Protocol Finding 3.1

_Auditor_
Consensys

_Severity_
Low

_Issue_
Application Logic

_Description_

- governor proposals can be cancelled by proposer even after they are accepted and queued
- governor proposals can be cancelled by proposer -but the logic did not care about status of proposal -> whether it is pending, active, defeated, queued, succedded etc

_Recommendation_

- proposals can only be cancelled if in pending or active states
- do a error validation inside the `cancelProposal` function

_Lessons_
Key lesson is to ask common sensical questions -> if after proposing and voting of proposals, does it make sense for proposer to cancel then?
If so what was the point of whole voting -> asking questions will tell us more about application logic

### Audit findings #113

_Reference_
eRLC Finding 4.3

_Auditor_
Consensys

_Severity_
NA

_Issue_
Access Control & Timing

_Description_

- kyc admin had power to freeze funds of any user by revoking kyc member role -> any user with this role cannot withdraw funds - > its not user specific lock but fund specific
- should kyc admin have such kind of powers to lock out users own funds? obv answer is no
- trust requirements of users would be slightly low if `kyc admin` role assignment to a new address has some time delay & its not immediate -> would protect platform also if a malicious users gets to upgrade his role somehow to kyc admin

_Recommendation_

- Add timelock to granting priveleges - especially if they can assign & revoke new roles

_Lessons_
Ideally speaking such role threatens user funds and should not exist
But if it exists, timelocks make sense to detect any malicious attack and respond by withdrawing funds

### Audit findings #114

_Reference_
1inch finding 4.1

_Auditor_
Consensys

_Severity_
Low

_Issue_
Minimal comments - low test coverage

_Description_

- code had no comments and test coverage was limited
- for a public facing exchange contract, system test coverage should have been extensive

_Recommendation_

- Add inline code comments & natspec format to all contracts/functions as applicable
- describe functions - what they were used for and who is supposed to use them
- document assumptions used for the code
- document external dependencies and trust/threat models studied
- increase test coverage

_Lessons_

### Audit findings #115

_Reference_
1inch Finding 4.6

_Auditor_
Consensys

_Severity_
NA

_Issue_
pragma version floating

_Description_

- pragma version was floating with ^0.6.0
- maybe a security risk for application implementation itself
- known buggy version of compiler maybe accidentally selected for compiling OR security tools might fall back to stable version while testing whereas contract was deployed with another version - all such complications happen when the pragma version is floating

_Recommendation_

- use a fixed version and choose a concrete, compiler version

_Lessons_

### Audit findings #116

_Reference_
1inch Finding 4.7

_Auditor_
Consensys

_Severity_
NA

_Issue_
Denial of Service

_Description_

- hard coded gas assumptions were problematic - because gas economics in ethereum have chnaged in the past (EIP1559)
- and gas economics may change again in future
- a hard coded gas may lead to DOS attacks at some point in future

_Recommendation_
be aware of this potential limitation
document and validate gas assumptions
avoid hard coded gas figures

_Lessons_

### Audit findings #117

_Reference_
1inch Finding 5.1

_Auditor_
Consensys

_Severity_
Critical

_Issue_
Access control & input data validation

_Description_

- anyone could steal all funds that belonged to referral fee receiver
- by providing a custom uniswap pool contract that referenced existing token holdings
- none of the validations in the `feereceiver` were checking if the uniswap pool contract was actually deployed in the uniswap pool fatcor

(seems very unique - will get a better colot when i go through the audit report of 1 inch)

_Recommendation_

- enforce user provided uniswap pool address was actually deployed because other contracts cannot be trusted
- consider token sorting and deduplication in pool contract constructor
- have reentrancy guard to safeguard against reentrancy attacks
- improve testing, vulnerable functions were not covered at all
- improve documentation

_Lessons_

### Audit findings #118

_Reference_
1inch Finding 5.7
_Auditor_
Consensys

_Severity_

_Issue_
Priveleged roles and timing

_Description_

- Critical changes - upgrade of contracts could be done by priveleged users instantly
- malicious priveleged users could front run any changes
- priveleged users can get unfair advantage by front running system parameter changes

_Recommendation_

- all critical parameter changes should have a time window and should be 2 step process
- first step should broadcast users that a particular change was coming
- second step is to commit that change after suitable waiting period
- implement timelocks

_Lessons_

### Audit findings #33

_Reference_
Growth Defi Finding 4.2

_Auditor_
Consensys

_Severity_
NA

_Issue_
Specification/Documentation

_Description_

- Single README file with code comments
- documentation is integral for user confidence
- protocol should always err on more documentation side
- without documentation - only resource is code - vast majority of users don't know how to read code

_Recommendation_

- improve system documentation and create specifications

_Lessons_

### Audit findings #120

_Reference_
Growth Defin Finding 4.3

_Auditor_
Consensys

_Severity_

_Issue_
Access Control

_Description_

- system states, roles and permissions were not sufficiently restricted
- strict access control reduces chance of exploits - loosely defined access gives access attack vectors to users

_Recommendation_
document and monitor roles/permissions
have the strict access control rules

_Lessons_
