# AUDIT FINDINGS 103

[Video](https://www.youtube.com/watch?v=RUyED_6mkqg&list=PLYORQHvGMg-VNo7NvPUM1Jj_qWhDotOJ2&index=3)

## Summary

We discuss few audit findings in greater detail...List of audit findings, impact and likelihood (part 3..)

### Audit findings #41

_Reference_
Origin Dollar Finding 23

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Data validation

_Description_

- OUSD total supply < token balances
- this unique error happens because of token rebasing - allow users to opt out of rebasing - their exchange rates would be fixed and would not be impacted by rebasing - and no change in token balances happens until user opts back in - this leads to a case when token balance sum > total supply

_Recommendation_

- specify common invariants for users
- redesign a system to prevent such violations
- accounting of tokens could get messy if such violations happen

### Audit findings #42

_Reference_
Yield protocol Finding 1

_Auditor_
Trail of bits

_Severity_
Medium

_Issue_
undefined behavior

_Description_
Flashminting of FYDAI token could be used to redeem an arbitary amount of funds from a mature token in the context of protocol

_Recommendation_
Disallow flash minting to prevent attackers from gaining leverage and breaking internal invariants

_Lessons_
Flash minting and flash loans are key tools attackers use to exploit - spend time in thinking how flash loan or minting applies to the protocol and will there be any vulnerabilities because of that

### Audit findings #43

_Reference_
Yield protocol Finding 8

_Auditor_
Trail of bits

_Severity_
High

_Issue_
Access Control

_Description_

- Lack of chain id identification allows attackers to reuse ERC20Permit signatures
- Replay signatures on forks
- ERC20Permit allows approvals to be made via signatures (gasless offchain approvals) -> implements `permit` method that allows users to change ERC20 allowance by presenting a message signed by users. By not relying on `ERC20.approve`, token holder does not need to send transaction and not required to hold Ether at all
- if chain forked after deployment, signed message would be considered valid on both forks

_Recommendation_

- Include chainId opcode in the permit schema to prevent replay attacks in the event of post deployment hardfork

_Lessons_

- When ERC20Permit is used, we are getting convenience of a gasless approval -> but remember that it brings more vulnerabilities - now we are relying on off-chain signature instead of on-chain (more reliable) state

### Audit findings #44

_Reference_
Hermez Finding 1

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Data validation

_Description_

- Lack of contract existence check allowed token theft

_Recommendation_

- Check for contract existence & `SafeTransferFrom` function before interacting with contract
- recall that low level call, delegatecall and staticall functions will return `true` even if contract does not exist
- if `true` flag is followed up by a transfer -> funds are lost permanently -> an exploiter can always use this to attack the transfer

_Lessons_

Always good practice to check contract existence

### Audit findings #45

_Reference_
Hermez Finding 2

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
No incentive for bidders to vote early

_Description_

- Hermez had a voting mechanism that allowed users to vote at any time (even last minute)
- No incentive for users to vote in early
- allowed users to add a lot of votes at the last moment before voting ends
- early voter bids were public & attacker would know exactly how many votes need to be pooled in to win the proposal

_Recommendation_

- Introduce concept of weighted bids -> higher weight for early voters

_Lessons_

- `timing` and `incentive` risks are key here -> again when a mechanism is being evaluated, it is always good to ask
  - what are user incentives
  - how can i manipulate timing to gain an unfair advantage

### Audit findings #46

_Reference_
Hermez Finding 5

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Access control

_Description_

- Same account was used to update more frequent protocol parameyters and less frequenct ones
- this increased risk of compromise - where a single priveleged user had access to all protocol parameters

_Recommendation_

- `Least common mechanism` rule of audit -> limit overlap of as many common functions as possible - one point of failure should not bring down entire protocol
- In long term, recommended to design access control document carefully

_Lessons_
Access control is about active risk management - anything that can reduce risk by improving access control is a good security recommendatin

### Audit findings #47

_Reference_
Hermez Finding 6

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Data validation

_Description_

- One-step change for critical operations -> that are irreversible and permanent
- For eg, setter for whitehat group address sets the address to provider argument ->if address is incorrect, new address can take on functionality of that role, and prevent any further changes, leaving it open to use by anyone who controlled that address
- If new address is one without a available private key, it would lock access to that role forever

_Recommendation_

- Use a 2 step procedure for all such critical updates to prevent irrecoverable mistakes

_Lessons_

- Huge, impactful changes in one step should always be a red flag - a good audit recommendation would be to make it 2 steps

### Audit findings #48

_Reference_
Hermez Finding 12

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Configuration frontrunning

_Description_

- due to delegate call proxy contract pattern - these contracts could not be initialized using `constructor`
- and had `initializer` functions - which could be frontrun by an attacker
- allowing attackers to initialize contract with malicious values that favor contractor -> and can be used to immediately drain contract

_Recommendation_

- use a factory pattern that could prevent front running of initialization (only the factory contract can initialize)
- or ensure atomically deploying and initializing scripts

### Audit findings #49

_Reference_
Uniswap V3 finding 1

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Data validation

_Description_

- Missing validation of owner argument in `constructor` and `setOwner` function could permanently lock the owner role if zero address or incorrect address was used
- would have forced an expensive redeployment of factory contract followed by re-addition of pairs and liquidity
- led to a loss of reputation and concurrent use of 2 versions of uniswap

_Recommendation_
-> designate `owner == msg.sender`
-> make changes a 2 step process -> permanent changes
-> if ownership could be set to zero address (whose private keys are not with anyone), implement a `renounceOwnership` function that clearly separates this action

_Lesson_

- Again big, impactful changes should have correct validations
- and `zero address` case has to be separately handled to prevent accidental use

### Audit findings #50

_Reference_
Uniswap V3 finding 5

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Data validation

_Description_

- Incorrect comparison allowed for swap to succeed even if no tokens were paired
- allowed exploiteer to drain all tokens from any pool at no cost
- `require()` check used >= instead of <= operator

_Recommendation_

- change >= to <=

_Lesson_
Even large protocols can make silly errors - nothing to be assumed based on credibility of protocol

### Audit findings #51

_Reference_
Uniswap V3 finding 6

_Auditor_
Trail of Bits

_Severity_
High

_Issue_

- `Swap` function had an unbounded loop

_Description_

- attacker could exploit by forcing loop to go through too many operations and cause a DOS attack

_Recommendation_

- bound loops and document bounds

_Lessons_

- calls within loops - goes back to our earlier lesson - any loops in ethereum can be potential landmies
- easy DOS attack vectors when loops can be manipulated to run out of gas

### Audit findings #52

_Reference_
Uniswap V3 finding 7

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Timing and access control

_Description_

- frontrun on uniswap v3 pool initialize function allowed attacker to set an unfair price and drain assets from first deposits
- there were no access controls on initialize function -> anyone could call it on a deployed pool
- initializing pool with incorrect price allowed an attacker to generate profits from initial LP deposits

_Recommendation_

- move price operations from `initialize` to constructor or
- adding access controls to initialize or
- documentation warns users about incorrect initialization

### Audit findings #53

_Reference_
Uniswap V3 finding 8

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Application logic

_Description_

- Swapping on a tick with zero liquidity enabled user to adjust price of one way of tokens in any direction
- attacker could set an arbitary price at pool initialization
- attacker could set an arbitary price if LPs withdrew all liquidity for short time
- total control of price by attacker

_Recommendation_

- this design implication can lead to pools ending up in unexpected states
- warn users of potential risks

### Audit findings #54

_Reference_
Uniswap V3 finding 9

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Data validation

_Description_

- Failed transfers can be overlooked due to lack of contract existence check
- transferHelper `safeTransfer` performed a low level call without confirming contract existence
- if tokens were not deloyed or destroyed, `safeTransfer` would return success even if no transfer had actually executed

_Recommendation_

- Check for contract existence
- Avoid low level calls

_Lessons_

- Whenever low level calls -> first check you make is to evaluate if contract exists -> what happends if it doesn't exist and return value is true -> implicarions of a true value is critical -> if it changes some balances-> then it is vulnerable

### Audit findings #55

_Reference_
DFX Finding 10

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Undefined behavior

_Description_

- LHS of check had assignment and RHS of check used same variable
- Above check doesn't make any sense
- this check constutes an undefined behavior
- behavior of that code was not specified and could change in future versions of solidity

_Recommendation_

- rewrite statement -> cannot assign and reuse inside the same check
- avoid underfines usage

### Audit findings #56

_Reference_
DFX Finding 12

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Data validation

_Description_

- some functions returned raw values instead of numeraire values - missed conversion
- interchanging raw and numeraire values can result in unwanted results and may lead to loss of funds

_Recommendation_

- keep values consistent -> return numeraire values instead of raw values
- use unit tests and fuzzing to identify and prevent such errors

### Audit findings #57

_Reference_
DFX Finding 13

_Auditor_
Trail of Bits

_Severity_
Medium

_Issue_
Data validation

_Description_

- Invalid assumption - intrinsically assumed that 1 USDC = 1 USD (peg always holds)
- didn't use usdc/usd oracle provided by chainlink
- could result in exchange errors at times of deviation

_Recommendation_

- avoid hardcoding with a oracle result
- external dependencies need to properly reflect internal assumptions

_Lesson_

- Whenever there are stable coins used -> always ask, how is price computed, what frequency -> what happens if oracles throw out incorrect prices -> ask how oracle is getting its price

### Audit findings #58

_Reference_
DFX Finding 1

_Auditor_
Trail of Bits

_Severity_
Undetermined

_Issue_
Deprecated Oracle usage

_Description_

- Using a deprecated version of chainlink oracle
- deprectaed API used functions that were not present in latest oracle
- worst case scenario, API stops being updated -protocol will incure losses because of stale price feed

_Recommendation_

- Use latest stable version of dependencies

### Audit findings #59

_Reference_
0x protocol finding 3

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Data validation

_Description_

- `Cancelled orders` function could cancel future orders if called with very large values such as `max(uint256) -1`

_Recommendation_

- document this behavior and let users know
- or disallow cancellation of future orders

### Audit findings #59

_Reference_
0x protocol finding 13

_Auditor_
Trail of Bits

_Severity_
High

_Issue_
Specification mismatch

_Description_

- Logic implemented and spec sheet had different values
- spec sheet had 2-week timelock - implementation had 0 timelock
- either spec was outdated or this was a serious flaw

_Recommendation_

- Sync spec & code and update spec sheet to reflect latest implemenation

_Lesson_

- First natural place to look for is spec sheet -> a comparison of spec with implementation will give us a lot of insights
