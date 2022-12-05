# AUDIT FINDINGS 102

[Video](https://www.youtube.com/watch?v=KLBi3Uyg0dY&list=PLYORQHvGMg-VNo7NvPUM1Jj_qWhDotOJ2&index=2)

## Summary

We discuss few audit findings in greater detail...List of audit findings, impact and likelihood (part 2..)

### Audit findings #21

_Reference_
mStable 1.1 Finding 6.2

_Auditor_
Consensys

_Severity_
Major

_Issue_
Users could get interest by staking momentarily before snapshot

_Description_

- Timewindow of 30 minutes - users could put their tokens and receive interest in BTC/ETH terms
- logic was such that users could stake a few seconds before the 30 min time snapshot
- and receive the interest for the whole window
- by staking momentarily, users could benefit from interest for entire window -> abuse of time window
- user could immediately unstake, collect all benefits and wait for the next time window

_Recommendation_

- Remove the 30 min window
- Every update should also update credit and tokens (Synthetix staking model)

_Lesson_

- Time snapshots -> review calculations of interest calculations, rewards calculation -> if they are based on `events` - they tend to be correct (event here refers to everytime someone withdraws or deposits)
- If they are based on only timestamps -> then they are prone to manipulation (not acconting for user actions)

### Audit findings #22

_Reference_
Bancor v2 Finding 5.1

_Auditor_
Consensys

_Severity_
Critical

_Issue_
Oracle update can be front-run to arbitrade rate changes by sandwich attack

_Description_

- sandiwching an oracle update between 2 transactions
- basically front-run an oracle update -> by watching mempool
- attacker could setup 2 transactions at the moment oracle update appeared in mempool
  - first transaction sent a higher gas price than oracle update -> would convert a very small amount to lock in a conversion rate so that a stale oracle price would be used in following transaction
  - second transaction sent at a lower gas price than oracle update -> would convert a large amount at a old stale rate and add a small liquidity to trigger rebalancing and then convert back at new rate - attacker could get a flash loan to obtain liquidity and use that to deplete the reserves

**Super complex - need to understand bancor platform to get this better**

_Recommendation_

- not allow users to trade on old oracle rate
- trigger an oracle update in same transaction
- enforce per block txn constraints

_Lesson_

- Understanding front-running and MEV allows us to anticipate how a user could possible attack by front/back-running
- Some combination of front-running, oracles, back-running, flash loans and rebalancing - super complex to visualize - these are the ones where critical bugs hide - one I need to build expertise on

### Audit findings #23

_Reference_
Shell Protocol finding 6.2

_Auditor_
Consensys

_Severity_
Major

_Issue_
Input validation

_Description_
Some functions lack input validation

eg. `uint > 0` when 0 input is invalid
`uint` should be within constraints or thresholds
`length` of arrays should match if more than 1 related arrays are sent as arguments
`addresses` should not be zero addresses

_Recommendation_
Add input validations and incorporate tests if all validators are properly getting triggered

_Lesson_
Input validations are low hanging fruits
Make a list of all functions and inputs -> check if function inputs are all properly validated

### Audit findings #24

_Reference_
Shell Protocol finding 6.3

_Auditor_
Consensys

_Severity_
Major

_Issue_
Access control - administrator had excessive powers

_Description_

- Administtaor had powers to lock access and tokens to protocol
- could deploy malicious or faulty code that could drain whole pool or lock up users or LPs
- `Safeapprove` to adminstrator allowed admin to move tokens to any address -> could be a backdoor to allow draining of funds

_Recommendation_

- Make code static and unchangeable after deployment
- Remove safe approvals
- Remember least privelege - admins should only have as much privelege as is needed

_Lesson_

- One key lesson is to think how administrators can drain funds of users - concept is to trust NOBODY
- so just because an admin can access function X -> does not necessarily mean X can do anything -> user funds cannot be transferred to any random address
- approvals given to protocol should not be misusec - ie no admin only function should exist that can exploit these approvals to send tokens to random address

### Audit findings #25

_Reference_
Lien Protocol finding 3.1

_Auditor_
Consensys

_Severity_
Critical

_Issue_
Denial of Service - reverting fall back function could lock out all payouts

_Description_

- `transfer ETh` function, if any of ETH recepients of a batch transfer was a contract that reverted with fallback, all payouts would fail and be unrecoverable

_Recommendation_

- ignore failed transfers and execute remaining
- implement pull over push - its a better design

_Lesson_

- When batch transfers happen - check if all of the recepients are EOA or if any contracts can also be recepients
- if contracts can be recepients, what happens if that contract does not accept ETH payments (ie. not have any fallback or receive)

### Audit findings #26

_Reference_
LOA funding 5.1

_Auditor_
Consensys

_Severity_
Critical

_Issue_
Denial of Service

_Description_

- related to `safeRageQuit` and `rageQuit` functions
- while `rageQuit` function tried to withdraw all allowed tokens, `safeRageQuit` only withdrew some subset of these tokens as defined by user
- when there was a partial withdrawal, the remaining tokens were not withdrawable - went to the DAO and needed a lot of trust, coordination for transfer to be made from DAO to the user
- potential to steal some tokens also existed

_Recommendation_
Implement a pull pattern for tokens - push is always considered more risky than pull

_Lesson_

- If contract is pushing out tokens - exposes to re-entrancy attacks and failed transfers
- pull design is better than push design - keep this recommendation in mind when thinking about transfers

### Audit findings #27

_Reference_
LAO finding 5.2

_Auditor_
Consensys

_Severity_
Critical

_Issue_

- Token transfer needed DAO to be trusted
- Denial of Service

_Description_

- If a proposal was made with a small token amount -> such token amount would not be refunded back to the user if proposal got rejected
- unless emergency processing was executed by the protocol
- tokens were not lost but went to DAO and user need to coordinate, trust and spend time interacting with DAO to get his/her tokens back
- anyone who would `ragequit` during the time would take a part of those tokens

_Recommendation_

- Implement a pull design over push

_Lesson_

- If contract is pushing out tokens - exposes to re-entrancy attacks and failed transfers
- pull design is better than push design - keep this recommendation in mind when thinking about transfers

### Audit findings #28

_Reference_
LAO finding 5.3

_Auditor_
Consensys

_Severity_
Denial-of-Service

_Issue_
Emergency processing could be blocked

_Description_

- some token transfers maybe blocked
- emergency processing helped in cases where normal token transfers were blocked

_Recommendation_

- Implement a pull design for token transfers instead of push

### Audit findings #29

_Reference_
LAO finding 5.4

_Auditor_
Consensys

_Severity_
Major

_Issue_

- Token overflows could result in system halts

_Description_

- system halt due to breaking of `process proposal` and `cancel proposal` due to safe math reverts
- oveflows could happen because supply of tokens could be artificially inflated

_Recommendation_

- Allow overflows to prevent system halt from malicious/broken tokens

### Audit findings #30

_Reference_
LAO finding 5.5

_Auditor_
Consensys

_Severity_
Major

_Issue_
Denial of service (Out of gas exception)

_Description_
If # of white listed tokens is too large, then iterating over such list could run out of gas and all funds would be blocked forever

_Recommendation_

- limit number of whitelisted tokens OR
- add a function to remove tokens from white list

_Lesson_

- Loop operations can lead to denial of service -> if loop index was controlled by users => in this case, indirect control of loop index (number of whitelisted tokens) is controlled by user -> can lanch a sybil attack -> created a huge list of whitelisted tokens -> and then make it run out of gas

### Audit findings #31

_Reference_
LAO finding 5.6

_Auditor_
Consensys

_Severity_
Major

_Issue_
Denial of Service

_Description_

- summoner could steal funds using `bailOut()` functionality
- allowes anyone to transfer kicked user funds to summoner if the user did not `safeRangeQuit`
- intention was for the summoner to then transfer funds to kicked users
- this whole procedure required trust and wasn't really permisionless
- summoner could deny transfering funds to kicked users

_Recommendation_

- use `pull` mechanism instead of `push`

### Audit findings #32

_Reference_
LAO Finding 5.7

_Auditor_
Consensys

_Severity_
Major

_Issue_
Timing and denial of service

_Description_

- If proposal submission and sponsorhip are done in 2 txns
- its possible to front-run the sponsorship by any member so thst they can block proposal thereafter

_Recommendation_

- Pull based transfer design -> instead of push based

### Audit findings #33

_Reference_
LAO Finding 5.8

_Auditor_
Consensys

_Severity_
Major

_Issue_
Timing and denial of service

_Description_

- any member could front run another member's delegate key assignments
- when someone trues to submit an address as the delegate key, someone else could try to assign deleigate address to themselves
- this makes it possible for others to block an address to be a delagate forever

_Recommendation_

- make it possible to approve delegate key assignment or cancel delegate key current
- commit-reveal methods could also be used to mitigate this attack (???)

Project decided that this is not an important issue and well within the protocol's trust-threat model

### Audit findings #34

_Reference_
Origin Dollar finding 6

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Denial-of-Service

_Description_

- queued transactions could never be canceled
- `governor` contract contained special functions to set it as admin of timelock
- only admin can call timelock cancel txns
- no functions in governor that called `timelockCancel` -> so no way to cancel timelock txns

_Recommendation_

- in short term, add a function to governor to add `timelockCancel`
- in long term, consider letting `governor` inherit from `timelock` -> allow lot of code to be removed and lower complexity of 2 contracts

_Lesson_
Key lesson here is if there is a `admin` function & if the admin is a contract instead of EOA, then there has to be a explicit function that calls the admin activity

### Audit findings #35

_Reference_
Origin Dollar finding 8

_Auditor_
Trail of Bits

_Severity_
Access control

_Issue_
Unauthorized users were able to access critical txns

_Description_
`Timelock` contract had missing access checks allowing non-governor addresses to also access timelock contract (which was never designed that way)

_Recommendation_

- Ensure Only admin can access `execute` transaction

### Audit findings #36

_Reference_
Origin Dollar finding 9

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Timelock admin change could be triggered by any user via a proposal

_Description_

- Governor contract had special functions for guardian to queue a admin change txn
- However a regular proposal was also allowed to contain a `set pending admin change` txn to change timelock admin
- attacker could create a proposal to change admin

_Recommendation_

- Prevent `setPendingAdmin` proposal to be initiated by regular user

_Lessons_

- Again, here access control is vioolating actions - some users have a permission to trigger a action -> list all actions -> then check who can do what actions in a table- good way to check all access related issues

### Audit findings #37

_Reference_
Origin Dollar finding 10

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Reentrancy

_Description_

- missing checks and no reentracncy prevention allowed untrusted contracts to be called from `mintMultiple` function that could be used by attacker to drain contracts

_Recommendation_

- add checks to cause `mintMultiple` to revert if amount was 0 or asset not supported
- also add reentrancyGuard mofidier
- incorporate slither checks which would have identified reentrancy risks

_Lessons_

- Always a good practice to add reentrancy to all non-view functions
- also make sure that slither checks are done to prevent untrusted contracts to attack via reentrancy

### Audit findings #38

_Reference_
Origin Dollar finding 10

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Error handling

_Description_

- Unchecked return values at call sites skipped error status that were left unhandled

_Recommendation_

- check return values at call sites of all functions and incorporate control flows

_Lessons_

- again return values of all functions used can be listed in a table and checked if any are being missed

### Audit findings #39

_Reference_
Origin Dollar finding 20

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Denial of service

_Description_

- external calls made with unbounded loops
- could trap contracts with failed gas exception

_Recommendation_
review all loops and make sure they are bounded

_Lessons_
Check all for, while loops and flag any loops where there is no limitation on the count
specially trigger flags when external calls are made within loops - very easy to run out of gas

### Audit findings #40

_Reference_
Origin Dollar finding 22

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Data validation

_Description_

- under certain circumstances, users could transfer tokens > their balance
- this is caused by rounding issues
- _Recommendation_
- short term solution - make sure balances correctly check before performing arithmetic operations
- use echidna to write properties on arithmetic invariants to ensure balances are not violating these invariants

_Lessons_

- When dividing before multiplying - we learnt that rounding errors can creep in -> in such cases token balances > accounting balances
- this can lead to all sorts of error
- writing solid tests to check balances
