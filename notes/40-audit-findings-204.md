# AUDIT FINDINGS 203

[Video](https://www.youtube.com/watch?v=poxzr4-srn0&list=PLYORQHvGMg-UuyTqPiGtmGZ-MJzJUUxhf&index=2)

## Summary

We discuss second part of audit findings in greater detail...List of audit findings, impact and likelihood (part 4)

### Audit findings #161

_Reference_
Advanced Blockchain Finding 5

_Auditor_
Trail of Bits

_Severity_

_Issue_
Testing

_Description_

- repos lack testing

_Recommendation_

- unit tests cover all public functions atleast once
- good coverage - need to monitor coverage rate on periodic basis

### Audit findings #162

_Reference_
Advanced Blockchain Finding 11

_Auditor_
Trail of Bits

_Severity_

_Issue_
Patching

_Description_

- project dependencies having vulnerabilities

_Recommendation_

- track, verify, patch and audit dependencies

### Audit findings #163

_Reference_
Advanced Blockchain Finding 16

_Auditor_
Trail of Bits

_Severity_

_Issue_
Documentation

_Description_

- lack ofdocumentation
- no high level review
- no examples
- increase chance of user and dev mistakes

_Recommendation_

- increase documentation and specification

### Audit findings #164

_Reference_
Advanced Blockchain Finding 18

_Auditor_
Trail of Bits

_Severity_

_Issue_
Patching

_Description_

- abiencodeV2 not production ready
- at the time, 3% of all github errors were attributed to experimental features, primarily abiencodeV2
- abiencoderV2 was associated with atleast 200 high security bugs

_Recommendation_

- refactor code - try avoiding abiEncoderV2

### Audit findings #165

_Reference_
dForce Lending Finding 10

_Auditor_
Trail of Bits

_Severity_

_Issue_
Access controls

_Description_

- contract owner was overpriveleged
- users could use all assets if contract owner priate key gets compromised
- owner could do following
  - upgrade contract implementation to steal funds
  - upgrade token implementation to act maliciously
  - manipulate rewards distribution
  - arbitarily update interest module contracts

_Recommendation_

- document risks
- implement least privelege philosophy - split core upgrades to multi sig
- split powers so no one account had excessive powers in system
- ensure users are aware of all risks associated

### Audit findings #166

_Reference_
dForce Lending Finding 14

_Auditor_
Trail of Bits

_Severity_

_Issue_
Error handling

_Description_

- Test suite did not have proper tests to check expected behavior
- certain components lacked error handling methods that made failed tests overlooked
- for eg. errors were silenced by try catch loop -> which meant no guarantee that a call had reverted for right reason
- if test suite passed, it gave no guarantee that error transactions reverted correctly

_Recommendation_

- Test operations against specific error message
- follow best practices for testing

_Lesson_

If `try catch` loop - is the testing taking this into account - revert with exact error message is being checked or not

### Audit findings #167

_Reference_
Synthetix Finding SEC-04

_Auditor_
Sigma Prime

_Severity_

_Issue_
Patching

_Description_

- Redundant and unused code
- return values of functions not used at calling sites

_Recommendation_

- remove redundant constructs

### Audit findings #168

_Reference_
Synthetix Finding SEC-05

_Auditor_
Sigma Prime

_Severity_

_Issue_
Data validation

_Description_

- single account could capture all supply
- didn't implement cap loan values to limit amount of ETH that can be loaned
- single account could issue a loan that could reach total minting supply

_Recommendation_

- enforce a cap
- document behavior

_Lesson_

Always look at how a whale with large capital can disrupt the platform -> will typically happen by sucking out all liquidity out of the system

### Audit findings #169

_Reference_
Synthetix Finding SEC-06

_Auditor_
Sigma Prime

_Severity_

_Issue_
Insufficient input validation

_Description_

- Ether collateral constructor did not do input validation checks or check for zero addresses
- Possible to deploy contract with incorrect addresses

_Recommendation_

- check addresses before deploying ether collateral contracts

### Audit findings #170

_Reference_
Synthetix Finding SEC-08

_Auditor_
Sigma Prime

_Severity_

_Issue_
Auditing and logging

_Description_

- unused event logs
- log events were declared but never emitted

_Recommendation_

- emit these events where they are reqired or remove completely

### Audit findings #171

_Reference_
Infinigold Finding INF-03

_Auditor_
Sigma Prime

_Severity_

_Issue_
Data Validation

_Description_

- unintentional token burn in `transferFrom`
- can convert enGD tokens to gold certificates which can be converted to physical gold
- users were supposed to specifc burn address to do above
- `transferFrom` function did not check against this burn address - users could accidentally send to this address from `transferFrom` and result in burning those tokens
  without triggering `burn` event that was triggering off-chain actions to generate gold certificates

_Recommendation_

- check if `to` address is burn address and disallow sending to this address using `transferFrom`

### Audit findings #172

_Reference_
Infinigold Finding INF-06

_Auditor_
Sigma Prime

_Severity_

_Issue_
Denial of Service - unbounded lists

_Description_

- `reset` function reset role linked list by deleting all its elements
- calling reset would exceed block gas limit for >371 elements in tole linked list
- some other functions also loop through role lists

_Recommendation_

- check list size and cap
- or while looping, use gasLeft global variable to ensure it stops at the appropriate time
- or change reset to take specific number of elements as input

### Audit findings #173

_Reference_
Infinigold Finding INF-08

_Auditor_
Sigma Prime

_Severity_

_Issue_
Timing

_Description_

- ERC20 approve function can be front run

_Recommendation_

- use `safeApprove` -> increaseAllowance or decreaseAllowance functions to change approvals

### Audit findings #174

_Reference_
Infinigold Finding INF-09

_Auditor_
Sigma Prime

_Severity_

_Issue_
Error checking

_Description_

- unneccessary check of zero address - `require` - this was already implemented in `transfer` function

_Recommendation_

- redundant checks

### Audit findings #175

_Reference_
Infinigold Finding UNI-05

_Auditor_
Sigma Prime

_Severity_

_Issue_
Data Validation

_Description_

- Rounding to 0
- reward rate rounding to 0 if duration > reward rate (reward was calculated as reward rate /duration -> and because we are dealing in uint data types, rounding to 0)
- stakers would not receive their rewards
- other implications - collection of dust tokens

_Recommendation_

- aware of this rounding error
- a way to claim rounding dust

### Audit findings #176

_Reference_
Infinigold Finding UNI-06

_Auditor_
Sigma Prime

_Severity_

_Issue_
Auditing and logging

_Description_

- Event log poisoning
- `withdraw` function could be called with 0 tokens - emitted a withdraw event
- someone could keep calling this function & create a large number of useless events
- this corruption of event list is called event poisoning

_Recommendation_

- check amount -> only when amount >0, emit event

### Audit findings #177

_Reference_
Holdefi finding M04

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Specification

_Description_

- insufficient incentive to liquidators
- Liquidation is a very imp function - to ensure system is not undercollateralized
- Design should incentivize speed of liquidation
- existing design - liquidators get no incentive except buying collateral at a cheaper price

_Recommendation_

- improve liquidation design to give higher incentives to liquidators

### Audit findings #178

_Reference_
Holdefi finding M06

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Specification

_Description_

- markets could become insolvent
- insolvent - value of all collateral < value of all borrowed assets
- having conservative collateral rations, incentivising instant liquidity, careful selection of tokens listed on platform are ways of preventing insolvency
- risk of insolvency still exists though - felt that adequate effort was not done in calculating and communicating these risks

_Recommendation_

- adequate testing to quantify this risk
- documenting risks and communicating to users

### Audit findings #179

_Reference_
Holdefi finding M09

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Patching

_Description_

- Copied and reimplemented some of Oz libraries
- Copying vs importing
- reimplementing or copying would increase amount of code that holdefi team has to maintain
- also misses all improvements and bug fixes done by OZ team

_Recommendation_

- consider importing instead of copying them
- extend them where necessary to add custom logic

### Audit findings #180

_Reference_
Holdefi finding L09

_Auditor_
Open Zeppelin

_Severity_

_Issue_
Auditing and logging

_Description_

- Lack of indexed parameters in event logs
- throughout codebase, none of parameters are indexed

_Recommendation_

- consider indexing key parameters to facilitate searching and off-chain audits
- topics are easy and faster to lookup

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
