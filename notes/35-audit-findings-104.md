# AUDIT FINDINGS 104

[Video](https://www.youtube.com/watch?v=D1Uz0NvrqeU&list=PLYORQHvGMg-VNo7NvPUM1Jj_qWhDotOJ2&index=4)

## Summary

We discuss few audit findings in greater detail...List of audit findings, impact and likelihood (part 4..)

### Audit findings #61

_Reference_
0x Protocol Finding 17

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Unclear Specification

_Description_

- Wasn't clear how orders were fillable

_Recommendation_

- specify and warn users how orders are being filled

### Audit findings #62

_Reference_
0x Protocol Finding 2

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Time specific

_Description_

    - Market makers were being subsidized for running front-running attacks
    - Market makers were paid a part of protocol fee for making markets
    - protocol fee was dependent on the transaction gas price
    - market makers could quote a higher gas price to front run txn & get refunded partially from protocol fees

_Recommendation_

- document the issue and let users be aware of what's happening
- in future, remove the linkage between tx.gasprice & fees

_Lesson_

- this is a very complex issue - unless there is an intuitive understanding of subject, this can't be handled properly...

### Audit findings #63

_Reference_
0x Protocol finding 4

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Timing issue

_Description_

- If a validator was compromised, race condition in signature validator approval logic got compromised
- setSignatureValidtor function allowed delegation of validation to an external contract -but if that contract was compromised -it could validate any number of malicious transactions
- _Recommendation_
- short term - document behavior and make users aware of risks using a validator
- long term - monitor signatureValidator events to catch such front-running attacks

_Lessons_
Recommendation says to monitor logged events to catch front-running - so that also can be a recommendation,.interesting

### Audit findings #64

_Reference_
0x Protocol finding 6

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Denial of service

_Description_

- Batch tx processing of order matching may lead to exchange griefing
- If one txn in a batch process reverts, all txns revert - and all gas got wasted

_Recommendation_

- implement `no throw` variant -> handle the txn fail without reverting
- do input validation for functions that perform batch operations (because they are very gas expensive)

_Lessons_

- Whenever there is iteration & if one external call or logic breaks -> resulting in revert of all txns - gas gets wasted and this can also lead to denial of service
- whenever there is a loop, there is a chance of DOS - so as soon as you see a loop, look for gas griefing and DOS

### Audit findings #65

_Reference_
0x Protocol finding 7

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Data validation

_Description_

- Zero fee orders were possible if user performed transactions with zero gas price

_Recommendation_
Select a reasonable minimum value and put a validation check

_Lessons_
Easiest to check - what happens if I send 0s - needs to be done always

### Audit findings #66

_Reference_
0x protocol finding 21

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Calls to function `setParams` accepts invalid values and gives an undefined behavior

_Description_

- Lacked sanity, limit checks and thresholds on all parameters

_Recommendation_
Add proper validation checks on all parameters of all functions that are exposed to users

_Lessons_

### Audit findings #67

_Reference_
EtherCollateral Finding 1

_Auditor_
Sigma Prime

_Severity_
High

_Issue_
Data validation

_Description_

- improper enforcement of supply cap limitation
- `openLoan` function was checking if cap was not reached without considering loan amount being opened
- any entity can open any loan amount because current amount was not considered

_Recommendation_

- add `require()` to enforce supply cap that includes loan amount

_Lessons_
Conditions that check for `>` and `<` should consider the inputs provided -if not, then such conditions mioght be wrong or exploited

### Audit findings #68

_Reference_
EtherCollateral Finding 2

_Auditor_
Sigma Prime

_Severity_
High

_Issue_
Data validation and DOS

_Description_

- Improper storage management during opening of loan accounts
- when loan was opened, address wass added to the openLoans array regardless of whether it was already present
- malicious actor could exploit this to do a DOS attack - unbounded array -> keep sending small amounts to make the array bigger and bigger

_Recommendation_

- Consider changing storeLoans only if address was unique

_Lessons_

- If array is not unique -> it can lead to unbounded array sizes and hence a DOS attack
- introduce an upper limit on # of loans contract can have

### Audit findings #69

_Reference_
EtherCollateral Finding 3

_Auditor_
Sigma Prime

_Severity_
Medium

_Issue_
Configuration

_Description_

- contract owner could arbitarily change minting fees and interest rates
- owner has lot of power to exploit users - should not be the case

_Recommendation_
consider making minting fee constant and cannot be changed by owner

_Lessons_
least common privelege - owner should have least amount of powers - in this case, no power to change protocol parameters

### Audit findings #70

_Reference_
Infinigold Finding 1

_Auditor_
Sigma Prime

_Severity_
Critical

_Issue_

- Broken proxy implementation

_Description_

- Token contract in implementation contract was being initialized with name, supply, symbol using a constructor instead of `initialize`
- token contract parameters are not accessible to token implementation contract when token proxy makes a delegate call
- token proxy would access its local storage that would not contain variables set in the constructor of token implementation contract
- proxy call to implementation was made -> owner would be unintialized and effectively set to their default values
- without access to token variables, proxy contract was rendered unusable

_Recommendation_

- set fixed parameters as constants - no need for initialization
- use the `initialize()` function instead of constructor

_Lessons_

- Any initializations of any base classes used in implementation HAVE to happen via `initialize`
- Any constructor in any implementation contract is an instant bug

### Audit findings #71

_Reference_
Infinigold Finding 1

_Auditor_
Sigma Prime

_Severity_
High

_Issue_
Data validation

_Description_

- `transferFrom` did not verify that sender is blacklisted

_Recommendation_

- use `notBlackListed()` modifier for transferFrom -> for `to` address and `msg.sender`

_Lessons_

### Audit findings #72

_Reference_
unipool finding 1

_Auditor_
Sigma Prime

_Severity_
Critical

_Issue_
Ordering

_Description_
Wrong ordering operands in expression

_Recommendation_

Correct operand ordering

_Lessons_

### Audit findings #73

_Reference_
unipool finding 2

_Auditor_
Sigma Prime

_Severity_
High

_Issue_
Ordering

_Description_

- Staking before initial notify lead to disproportionate rewards
- if user staked before notifyReward amount was called for first time -> initial user reward per token paid was set to 0 -> and staker would be paid a share greater than reward

_Recommendation_
prevent `stake` before `notifyRewardAmound`

_Lessons_
function call order is important -> in business logic

### Audit findings #74

_Reference_
unipool finding 3

_Auditor_
Sigma Prime

_Severity_
High

_Issue_
Error handling

_Description_

- External call reverting leads to blocked minting
- notify reward would revert if block timestamp < period finish
- this function was called indirectly via mint function -> which meant a revert would halt the mint process

_Recommendation_
handle condition when reward period has not relapsed without reverting

### Audit findings #75

_Reference_
unipool finding 3

_Auditor_
Sigma Prime

_Severity_
Medium

_Issue_
Timing/ Dos

_Description_

- SNS rewards were earned each period based on reward rate and duration as specified in notifyReward function
- if all stakers call SNSReward function contract would not have enough SNX balance to transfer all rewards
- some stakers might not receive any rewards

_Recommendation_
Force each period to start at end of last period without any gap ???? - did not understand this

### Audit findings #76

_Reference_
chainlink finding 2

_Auditor_
Sigma Prime

_Severity_
High

_Issue_
Timing/ Dos

_Description_

- malicious actors can hijack requests from chainlink contracts by replicating or front-running legitimate requests
- requests have their own callbacks which can be front-run or force failure of legitimate requests

_Recommendation_
Restrict arbitary callbacks ????? - Didnt understand this (revisit)

### Audit findings #77

_Reference_
UMA Finding M01

_Auditor_
Open Zeppelin

_Severity_
Medium

_Issue_
Auditing and Logging

_Description_

- Sensitive actions did not have event emissions
- `getFundingRate` function was doing critical updates
  - sets funcing rate
  - update time
  - update proposal time
  - transfering reports

_Recommendation_
Consider emitting events after sensitive changes - always a good practice for audit and alerts to potential exploits

### Audit findings #78

_Reference_
UMA Finding M02

_Auditor_
Open Zeppelin

_Severity_
Medium

_Issue_
Function names

_Description_

- side effect actions were not clear in function names
- for eg. getFundingRate() was setting funding rate, proposal times etc.
- general convention is to use `get..` names for view functions
- could lead to mistakes by new developers who might overlook some changes

_Recommendation_

- Separate functions into getters and setters
- alternately, rename functions to describe all actions contained in those functions

### Audit findings #79

_Reference_
1inch Finding

_Auditor_
Open Zeppelin

_Severity_
Medium

_Issue_
DOS

_Description_

- Uniswap pairs could not be unpaused
- Uniswap factory contract had a `shutdown` function that could stop any pair
- however there was no `unpause`
- no way for factory contract to redeploy an instance for same pair of tokens
- once paused, same pair could never be traded on uniswap until a new factory contract was deployed
-

_Recommendation_

- Add an unpause library (maybe I am hearing it wrong -> is this uniswap or 1 inch - confused.....)

### Audit findings #80

_Reference_
Futureswap V2 Finding H01

_Auditor_
OpenZeppelin

_Severity_
High

_Issue_
Timing/DOS

_Description_

- Attackers could prevent instant withdrawal by users
- attacker who observed msg.call to instant withdraw in mempool could get oracle message and oracle signature parameters from users txn
- and submit same txn with a higher gas price
- use the gas limit in such a way that the gas runs out after user interaction number is adjusted
- attacker changes the user interaction number -> now next time when user is trying to withdraw -> since interaction number has increased - txn will never go through

_Recommendation_
consider access control on who could submit msgs on behalf of the user

_Lessons_

DAMN - THIS is next level -> watch mempool -> adjust gas fees such that revert happens (???? - wouldn't the entire txn revert if the out of gas exception coems in)
