# SECURITY PITFALLS 203

[Video](https://www.youtube.com/watch?v=pXoEIjHupXk)

## Summary

Advanced security pitfalls, we will look at 100 more vulnerabilities (contd..)..

### V24 - Modifiers

_Background_

- Modifiers implement access control and data validation
- Things to keep in mind ->

  - are there missing modifiers?
  - are there incorrect modifiers?
  - is the order of modifiers correct?

- Modifiers affect both control and data -> `control` because they can authorize and revert, `data` -> do different type of data checks -> so they affect data flow as well

_Risk_

- Some modifiers might be missing OR
- Modifiers called in wrong order
- Incorrect modifiers are used that can effect control flow

_Mitigation_

- Check all modifier `control` and `data` flow
- Check each function's modifiers and also evaluate the order of calling

---

### V25 - Function returns

_Background_

- Smart contracts deploy functions that return explicit values
- For all such functions, every path of control flow should return some value -> there should be no path that does NOT return value
- Also, call sites where such functions are called have to use the return value

_Risk_

- control flow inside returns functions leads to a path that returns nothing -> could create security risks because dev is expecting a return value
- call sites don't use return value and hence miss out on potential key information regarding function calculation

_Mitigation_

- all paths of return value function should return a value
- return value at call sites has to be used

---

### V26 - Function timeliness

_Background_

- Timeliness refers to when a function can be called
- External functions that are public/external visibility can be called at any time
- Based on their access restrictions -> can be called by anyone
- External functions should not make any assumptions on when functions will be called & what state
- They have to be assumed to be called at anytime
- Functions should be robust to identify what state the system is currently in & what functions are expected to be called
- For eg. proxy upgradeable contracts, initialization should be done at the time of deployment ONLY - they should be called only once and should not be able to initialize again -> initialize function needs to know that the function is already initialized and cannot be initialized again

_Risk_

- Function call should not assume ideal conditions for calling - it should be robust enough to handle calls by external callers at any time

_Mitigation_

- Function calls should handle any function state -> different state variable scenarios should be evaluated to understand how function behaves in that state scenario

---

### V27 - Function repetitiveness

_Background_

- Refers to how many times a function is called
- Again a external function can be called any number of times & no assumptions are to be made on function call #
- Assumption on number of calls will introduce security vulnerability -> as exploiters can launch loop attacks to breach any preset limit
- State transitions should not make assumptions on number of times a function is called - instead, it should handle state transitions based on calls
- For eg. in upgradeable proxy contracts, initialization function should only be called once - any further calls need to be congnizant of the fact that initialization is already done and should not allow to reinitialize

_Risk_

- Any function that changes behavior based on number of calls is open for exploitation because external callers can trigger a function any number of times programatically

_Mitigation_

- function should not make any assumptions on number of calls & be prepared for any number of calls

- in cases where state transition depends on the number of times a function is called, logic needs to be carefully analyzed on how the call frequency and # of calls impacts the function logic

---

### V27 - Function order

_Background_

- Along with timeliness and frequency, order of functions also matters
- No pre-assumptions are to be made by devs that A will be called only after B, specially when A and B are external functions
- exploiters can and will try to call B before/after A -> state transitions need to be handled regardless of the order of calling

_Risk_

- When functions make assumption on call order and believe that B will be called after A is completed

_Mitigation_

- State transitions need to be checked for different order flows
- order should be assumed arbitary and state transition logic should be robust to handle any order

---

### V28 - Function input assumptions

_Background_

- Function inputs, if external functions, can be anything -> logic should not assume that only 'happy case' inputs will be entered by users
- Inputs should be properly handled and malicious inputs should be flagged as invalid and function should revert in that case

_Risk_

- assumptions on validity can always lead to security risks

_Mitigation_

- fuction input validation checks should be robust to handle any user inputs

---

### V29 - Conditionals

_Background_

- Code does not go in a straight line
- conditionals affect control flow - based on specific conditions, path A or path B is chosen by function logic
- `if/else/for/while/do/return` are all conditionals that change control flow
- conditionals have `predicates & expressions`, `variables & operators` that determine this flow

_Risk_

- Incorrect conditionals can alter the flow & cause serious security issues

_Mitigation_

- All expressions have to be thorughly checked for completeness and accuracy
- For eg. if A || B is used instead of A && B, what should not go through will go through if one of A or B is true
- each expression within conditional can be exploited to obtain a desired value that will execute a particular flow - so every expression, operator, variable has to be broken down to analyze any vulnerabilities

---

### V30 - Access control spec

_Background_

- Access control deals with access/actions/actors
- Who can access/What can they access/How much / When, are basically assigned by access control
- Trust & threat model and assumptions should be clearly specified upfront -> this should goven access control rules
- Spec -> Implement -> Enforce -> Evaluate

_Risk_

- Any missing access control or incorrect access can create security implications
- All 4 parameters - how/much/when/what can be exploited when it comes to access

_Mitigation_

- Make sure no missing actors/assets/flows or conditions

---

### V31 - Access control modifiers

_Background_

- Modifiers are how access control is enforced in smart contract
- modifiers allow access logic to be isolated - so that it need not be implemented over and over - can be used as a block and that block can be called in any function

- modifiers not only improve modularity of code but also auditability
- 2 shools of thought
  - 1 - modifiers are good because they implement all logic in one place
  - 2 - modifiers are not good because function and modifier logic is at 2 different places & auditor/dev has to scroll away from function logic to check modifier definitions - and this can cause omissions sometimes

_Risk_

- incorrect implementation
  - roles & priveleges wrongly assigned

_Mitigation_

- Check if all roles have access as per specifications document
- check how roles are assigned/revoked - and who can assign these roles
- check if roles are added -> who can add the roles & what process
- check which functions are mapped to which roles & if it follows spec sheet

---

### V32 - Incorrect use of modifiers

_Background_

- Its not sufficient to have right access controls, equally important to check if those access controls are used properly

_Risk_

- Missing modifiers in critical functions

_Mitigation_

- for each external function in contract
  - Which modifiers are used
  - Why are they used
  - How are they being used
  - What checks are being assumed to be done in modifiers & what is the significance of those checks
  - When are these modifiers used

---

### V33 - Access control changes

_Background_

- access control is not static - and access control changes can happen
- changes can impact assets/actors and actions -> change can include malicious actors adding new roles or existing players adding a wrong role for a wrong operation etc

_Risk_

- Wrong change to a wrong function could result in an exploit
- could lead to loss or lock of funds

_Mitigation_

- validations on who can make changes
- make it a 2-step process to make access control changes
- log changes to ensure transparency

---

### V34 - Code comments

_Background_

- comments are documentation added by developer to improve auditability and readability
- comments should be inline with the code - includes natspec and isolated comments
- should be detailed where necessary and relevant to the code block
- any updates or changes should be accompanied with code comments
- any to dos should also be addressed
- commented code and stale comments should be reviewed, and if not relevant, removed to keep code clear and concise

_Risk_
NA

_Mitigation_
NA

---

### V35 - Testing

_Background_

- Testing is fundamental for high security
- Testing should be dynamic and run before any update is introduced to ensure old logic does not break
- tests include unit test/ integration test/ functional test/ regression test
- test coverage across entire code base should be very high -> specially mutable functions that can change state

- Different types of tests

  - `Smoke testing` - indicates at high level if functionality works or not
  - `Stress testing` - validates extreme scenarios and inegrity of code in highly unusual scenarios
  - `Performance testing` - validates the responsiveness of the application & the response time of each call to contract
  - `Security testing` - checks overall code security

- Testnet vs Mainnet

  - Ethereum offers testnet environments such as goerli/sepolia to test smart contracts
  - other protocols also provide addresses to interact with their contracts on these test networks
  - helps improve the logic and control flow in a controlled environment

- Any code or parameterization used for testnet should be removed for mainnet - this includes any testnet addresses or hard coded wallet addresses - deploying such contracts on mainnet before removing testnet parameers could lead to unexpected errors - as such addresses might not exist on mainnet or might point to some other contract\

_Risk_
NA

_Mitigation_
NA

---

### V36 - Unused

_Background_

- unused constructs may impact security
- unused imports, contracts, functions, variables, events, returns are all part of unused constructs
- can be accessed by malicious actors for exploit
- Removing reduce gas cost and improve auditability/maintainability
- Unused constructs may be indicative of missing logic & assumptions - we need to be careful to analyze before any decision to remove code

_Risk_

- Unused constructs may be indicative of missing logic & assumptions

_Mitigation_

- Analyze unused constructs -> best is to remove them once you are convinced they don't correspond to missing logic

---

### V36 - Redundant constructs

_Background_

- Redundant is similar to unused - some constructs that are redundant because the check is already done elsewhere
- Another reason for redundancy is simply that they are not relevant anymore
- Such redundant code or comments could be confusing and removed for readability and auditability

_Risk_
Same as above.

_Mitigation_
Same as above.

---

### V36 - Handling ETH transfers

_Background_

- ETH can be transfered into an account provided that address is of `payable` type

_Risk_

- Balances are not accounted for properly, funds get locked or funds get drained

_Mitigation_

- Contracts handling deposit/withdraw and transfer should take of
- `msg.value` is being used appropriately - its a global variable and if used multiple times (inside loops), can potentially lead to drain of funds - `msg.value` transfer should be done only once
- `payable` addresses are being sent eth
- any `balances` that are being tracked in the contract takes into account all the ways in which `ether` can be transferred into the account
  - for eg. ether via self destruct
  - ether via low level calls
- logic that does `withdraw` and `transfer` does so correctly - including adjusting for account balances
- transfers should be reentrancy safe
- funds should not be accidentally locked in a contract
- functions handling ether should be checked carefully for access control / input validations and error handling

---

### V37 - Token handling

_Background_

- Token handling contracts should ensure deposit/withdraw and transfer functions are properly handled
- Note tokens can be of many times - ERC20/ ERC721/ ERC777 etc - contract functions handling token transfers need to take into account specific token standard uniqueness - all error checks and validations should correspond to that
- Account for any deflationary/inflationary aspects of these tokens
- Whether they are rebasing or expanding money supply
- Differentiate between trusted internal tokens and untrusted external tokens
- Different tokens have peculiarities
  - decimals
  - fungibility
  - support for hooks
  - whitelists

_Risk_
All of them could lead to following risks - reentrancy attacks - mismatched accounting - locking of tokens - wrong access controls - lack of input validation - lack of error handling

_Mitigation_

- Token transfers are the most vulnerable aspects of Web3 - because they include real money transfers
- All functions involving token transfers should be reviewed extensively for mitigating above risks

---

### V37 - Actors and Trust

_Background_

- Ideally protocols should be fully decentralized with no centralized actors having special permissions to manipulate txns
- concept of `trust` is very tricky with protocols - some amount fo centralization is inevitable for teams controlling the protocol code
- but a progressive goal should be to decentralize ownership and control
- End goal is to get to 0 trust system where noone needs to be trusted to use system

- As we learnt in guarded launches -> initial control is high -> slowly actors/assets and actions could move to decntralized contract based implementation
- All centralized actors and their roles should be clearly specified in the `trust and threat` model and implemented accordingly

_Risk_

- Centralized players can take unilateral actions at any time and lock fund transfers

_Mitigation_

- Understanding access control rules & key plans to decentralize actors/actions and assets
- Role based access should be clearly specified and exhaustive - no surprises should be present in access
- governance contracts and timelocks is another way of increasing decentralization
