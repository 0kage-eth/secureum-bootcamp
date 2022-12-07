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
