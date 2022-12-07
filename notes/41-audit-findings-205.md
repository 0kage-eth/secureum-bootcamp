# AUDIT FINDINGS 205

[Video](https://www.youtube.com/watch?v=0J7KI4WGd0Q&list=PLYORQHvGMg-UuyTqPiGtmGZ-MJzJUUxhf&index=1)

## Summary

We discuss second part of audit findings in greater detail...List of audit findings, impact and likelihood (part 5)

### Audit findings #181

_Reference_
Holdefi finding N06

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Readability

_Description_

- inconsistent use of named return variables across code base
- affected explicitness of return

_Recommendation_

- remove named returns
- explicit declare as local variables in function body and return those variables

### Audit findings #182

_Reference_
Holdefi finding N07

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Timing

_Description_

- critical logic used timestamps -> miners can alter timestamps slightly id the incentive of that manipulation is huge (really??/)

_Recommendation_

- test and document the issue

### Audit findings #183

_Reference_
Barnbridge finding N01

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Error checking

_Description_

- assignment was made in require statement (used = instead of == ??)
- assignment is inconsistent with `require`

_Recommendation_

- move assignment to its own line
- use require statement to strictly enforce validation

### Audit findings #184

_Reference_
Barnbridge finding N02

_Auditor_
Open Zeppelin

_Severity_

_Issue_
commented code

_Description_

- lines of commented code - lead to confusion and errors in future
- readability and auditability issues

_Recommendation_

- uncomment or remove

### Audit findings #185

_Reference_
Compound finding N02

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Error handling

_Description_

- misleading revert messages
- error messages should provide enough information to determine the source & nature of error
- msgs were uninformative and misleading

_Recommendation_

- error msgs should be meaningful and related

### Audit findings #186

_Reference_
Fei finding L04

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Configuration

_Description_

- multiple outdated solidity versions being used across contracts

_Recommendation_

- use recent, stable, single and fixed across all contracts

### Audit findings #187

_Reference_
Fei finding N22

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Testing

_Description_

- Test and production constants were in the same codebase
- `test` mode boolean variable was used that was used to define several other test constsants (in core orchestrator contract)
- decreaed legibility of production code

_Recommendation_

- have different environments for production and testing

### Audit findings #188

_Reference_
Fei finding N23

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Specification

_Description_

- integer constants size < 256 bits
- EVM has to do additional job of padding to save data to storage -> this could be useful if there is a saving in gas costs

_Recommendation_

- Review Gas cost - if savings are not significant -> consider making integer constants uint256

### Audit findings #189

_Reference_
Fei finding N28

_Auditor_
Open Zeppelin

_Severity_

_Issue_
use of uint instead of uint256

_Description_

- confuse dev on the sizew of datatype -> better to be explicit

_Recommendation_

- convert all uint to uint256
- favor explicitness

### Audit findings #190

_Reference_
UMA finding M02

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Specification

_Description_

- Function names with unexpected side effects
- `getLatestFundingRate` was also updating fundingRate - general impression is that its a view function - confuses both new devs, auditors and users
- `getPrice` was also settling a price request

_Recommendation_

- setter functions having getter like names should be modified to avoid confusion
- separating such functions into setters/getters

### Audit findings #191

_Reference_
GEB Protocol finding M06

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Unsafe casting

_Description_

- contracts were casting uint -> int and then assigning `-`ve value
- however, since uint has higher storage than int -> this could result in loss of data for a sufficiently large value (may not have been realistic but still bad code practice)

_Recommendation_

- verify if value is within acceptable range for signed integer
- use `SafeCast` library

### Audit findings #192

_Reference_
GEB Protocol Finding L06

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Error checking

_Description_

- Missing error msgs in `require()` statements
- if any revert, it would be silent where error msgs are not defined correctlky

_Recommendation_

- better readability and user experience

### Audit findings #193

_Reference_
GEB Protocol Finding L11

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Testing

_Description_

- use of assembly in multiple contracts
- this was a complicated part of system
- use of assembly discards several important safety features
- may render code unsafe and error prone

_Recommendation_

- conduct extensive testing, specially for code written in assembly

### Audit findings #194

_Reference_
GEB Protocol Finding N03

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Error checking

_Description_

- `catch` clause not being handled appropriately
- neither emitting events nor handling the error but simply continuing execution

_Recommendation_

- emit event inside catch
- handle error- fail early and loudly

### Audit findings #195

_Reference_
GEB Protocol Finding N11

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Auditing & Logging

_Description_

- unnecessary event emits
- events with no significance were being emitted

_Recommendation_

- remove such unecessary events
- save on gas

### Audit findings #196

_Reference_
Open Gamma Protocol Finding M01

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Data Validation

_Description_

- Protocol O token could be created with a non whitelisted token address

_Recommendation_

- Introduce a check to figure if assets of a product are part of whitelisted address or not

### Audit findings #197

_Reference_
Open Gamma Protocol Finding L07

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Mismatches - contracts & intefaces

_Description_

- interfaces expose defined functionality of a given contract
- however in some interfaces, there were functions defined that were not part of their c'part contracts

_Recommendation_

- Sync interface and contracts and make sure interface functions have corresponding contract counterparts

### Audit findings #197

_Reference_
Open Gamma Protocol Finding L07

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Mismatches - contracts & intefaces

_Description_

- interfaces expose defined functionality of a given contract
- however in some interfaces, there were functions defined that were not part of their c'part contracts

_Recommendation_

- Sync interface and contracts and make sure interface functions have corresponding contract counterparts

### Audit findings #198

_Reference_
Open Gamma Protocol Finding L07

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Timing

_Description_

- inconsistent state from actions not executed on chain
- `setassetPrice`, `setLockingPeriod`, `setDisputeperiod` of oracle contract executed actions that were always expected to be performed atomically
- failing to do so would lead to inconsistent states

_Recommendation_

- combine all 3 functions into one function -> executed all atomic effects in a single transaction

### Audit findings #199

_Reference_
Open Gamma Protocol Finding L11

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Deprecated API

_Description_

- function was using a deprecated chainlink API
- chainlink V2 was used whereas currently we are on chainlin V3
- might suddenly stop working
-

_Recommendation_

- use latest chainlink API

### Audit findings #200

_Reference_
PoolTogether V3 Finding C01

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Data validation

_Description_

- funds could be lost
- `sweepTimelockBalances()` function accepted a list of users with unlocked balances to distribute
- however if there are duplicate users in the list-> balances would be counted multiple times while calculating total amount to withdraw
  - could lead to loss of funds

_Recommendation_

- check duplicate users while calculating withdraw

### Audit findings #201

_Reference_
SetProtocol Finding N09

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Patching

_Description_

- Clearing address variables to 0 address instead of using `delete`
- `delete` better converys the intention although same effect

_Recommendation_

- use `delete` over setting to `0` address
- explicit over implicit
