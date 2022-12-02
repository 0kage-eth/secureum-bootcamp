# SECURITY PITFALLS 204

[Video](https://www.youtube.com/watch?v=IVbEIbIpWUY&t=5s)

## Summary

Advanced security pitfalls, we will look at 100 more vulnerabilities (contd..)..

### V38 - Priveleged Roles

_Background_

- Priveleged roles are usually admin-level roles that give special permission to certain addresses
- these include
  - deploy/ modify/ pause / shutdown / withdraw / whitelist
- should be controlled by multiple independent and mutually distrusting entities
- should not be controlled via single private keys - EOA is a single point of failure
- Such key actions should be via `MultiSigs` and not `EOAs`- multisig should be 5 of 7 or something like that
- eventually governed by a DAO or community
- Multisigs work on concept of privelege separation - few can be malicious but still cannot change without a majority

- Additionally when such priveleged roles are being changed, they should ideally be a 2-step process
- If a single step, if current admin accidentally changes admin to a zero/incorrect address -> key contract functions could get critically locked out
- only alternative then is to redeploy - which will not be easy and also, not feasible in some scenarios
- A better way would be - current admin will propose a new admin in 1 txn - that new admin should claim the role in 2nd txn - only when 2'nd step is complete will the admin be changed -> we eliminate risk of wrong address

_Risk_

- Single control of key privelege actions
- Single step txns to executed changes in priveleges

_Mitigation_

- Recommend a multi-sig with a quorum
- 2-step, propose and claim workflow to effect changes to privelege users

### V39 - Timelock

_Background_

- Critical parameters once changed can take some time to effect those changes
- Immediate changes are unfair to users - they need time to understand changes and exercise their right to exit the system if they don't like the proposed changes
- such changes could severely impact long term viability of projects - and hence users might want to exit if certain changes are made - eg. lower rewards, increase fees
- Once a change is approved - there will be a timewindow until that change is effected
- Time delayed changes is less surprise, more fair

_Risk_

- Breaking changes with immediate effect can create adverse scenarios for users

_Mitigation_

- Key changes with long term impact should have timelocks

### V40 - Explicit vs Implicit

_Background_

- Always as a security principle, favor explicit over implicit
- implicit assumptions on access, trust, actors, assets lead to security vulnerabilities
- even solidity has adopted explicit declarations of mutability, visibility, storage/memory etc
- recommended at application level - all requirements should be explicitly specified
- implicit assumptions, if any have to be explicitly documented

_Risk_
NA

_Mitigation_
NA

### V41 - Mis configurations

_Background_

- Misconfiguration of system parameters such as contracts, parameters, addresses and permissions
- contract addresses of external contracts can be used wrongly or can belong to another chain etc
- global protocol parameters may be specified wrongly
- permissions may be configured incorrectly
- config files and data for production and test versions should be marked separately and not allowed to mingle
- testing maybe done at lower levels of configuration parameters, lower levels of access rules etc for ease of testing - which such configuration is accidentally used for production environment, we might end up with lower security controls

_Risk_

- Configuration parameters might be wrongly set or they might correspond to parameters in testing environment or other chain

_Mitigation_

- Clear demarcation of config parameters
- Careful review of config file that houses all contract addresses, global parameters etc

### V42 - Lack of initialization

_Background_

- Lack of initialization or incorrect initialization can lead to security issues
- In addition, allowing external players to initialize can lead to malicious actors changing sensitive protocol parameters to manipulate
- This is true for parameters, addresses, permissions and roles

_Risk_

- default values (uninitialized ) or incorrect values can change control flows and lead to manipulation

_Mitigation_

- Best practice is to check if initialization is done and done correctly
- And more importantly, is there a chance for external users to reinitialize the contract
- If yes, then how and when and by whom (only authorized users or any)

---

### V43 - Lack/incorrect cleanup

_Background_

- Cleaning could be by using the `delete` keyword of solidity or simply re-initializing variables
- Cleanup of current storage provides gas refunds - so devs who write good code that cleans up unused data actually get rewarded in terms of gas refunds
- london upgrade has reduced gas refunds of SSTORE
- there are benefits besides security for cleaning

_Risk_

- Incorrect cleanup could lead to old data retained in a variable -> while dev might think that data is cleaned, old data might continue to be used. This can create logic incompatibilities and hence vulnerabilities

_Mitigation_

- Make sure cleaning of structs that contain dynamic mappings is correct
- Make sure any logic that depends on incorrect cleaning is double verified (eg. length of array)

---

### V44 - Data processing issues

_Background_

- Data processing issues could become security issues because malicious data gets into the code due to lack of oversignt in processing

_Risk_

- When handling larger data -> processing could be missing or incorrectly implemented

_Mitigation_
-All aspects of data processing including any encode/decode of data, use of encodePacked() should be reviewed

---

### V45 - Data validation

_Background_

- A subset of data processing above is data validation
- Validations could be on balances, addresses, time stamps etc

_Risk_

- Missed/incorrect validations are key risk here - some calculation that can cause an error or fallback to be triggered

_Mitigation_

- All data that is pulled into functions should be analyzed for edge cases as per the spec document
- Validations that prevent invalid states and inputs not just enhances security but also saves costly gas

---

### V45 - Numerical processes

_Background_

- Numerical issues could be

  - overflow/underflow
  - casting
  - ordering of operations
  - decimals etc

_Risk_

Numerical issues could lead to unexpected logic outputs and this can create vulnerabilities

_Mitigation_

Best practice is to use safe external librariers that are rigorously tested
OZ librariers are great base layer libraries available

---

### V46 - Accounting issues

_Background_

- Incorrect accounting of balances, states, permissions, rules, deposits, withdrawals, mints, burns could lead to serious vulnerabilities
- Other accounting variables include staking rewards, interest, fees, collateral, profit/loss etc

_Risk_

- Incorrect accounting of key state variables can lead to mismatches that can be exploited

_Mitigation_

- Account logic related to application such as states, transitions, balances should be carefully reviewed to make sure they are complete and accurate

---

### V47 - Auditing & Logging

_Background_

- Events emitted by application are called `logs`
- Auditing and logging is important for protocol transparency
- Note that security auditing is different from this audting/logging
- We already know that events can be emitted with indexed or non-indexed parameters
- events typically log
  - actions
  - states
  - actors
  - errors

_Risk_

- Incorrect or insufficient logging may lead to reduced offchain scanning capabilities
- Any exploit will take much longer to identify & by the time protocol responds, it might already be too late

_Mitigation_

- All key onchain events must be logged as a best practice
- And log should contain as much logging info that can help in doing a deep dive at a later date

---

### V48 - Cryptography

_Background_

- Incorrect cryptography is another risk
- cryptography is fundamental to ethereum blockchain - everything from keys to data storage is based on cryptographic hashes
- keys, accounts, hashes, signatures, randomness -> all are based on cryptography
- ECDSA and keccak-256 hashing is used across all txns signatures and data encoding
- Cryptogrpahy is fundamental to security

_Risk_
NA

_Mitigation_
NA

---

### V49 - Error reporting

_Background_

- Incorrect or insufficient reporting of errors or exceptions will cause exceptions to go unnoticed
- Any behaviour outside the norm should be reported, documented and handled - exception reporting is critical for long term security

_Risk_
NA

_Mitigation_
NA

---

### V50 - Denial of Service

_Background_

- Security is a triad - condifentiality, integrity and availability -> Denial os Service (DOS) attacks availability
- Preventing users from accessing a protocol by modifying system parameter of shared state leads to DOS

_Risk_

DOS leads to

- Locked funds
- lose profit
- tx inclusion
- griefing (refers to using one's own gas to conduct DOS attacks)

_Mitigation_

- Best practice is to recognize and minimize DoS attributes

---

### V51 - Timing issues

_Background_

- Timing issues or incorrectly using `block.timestamp` are another security risk
- Assuming that state would get updated at specifi time or user would initiate an action by a specific time could lead to potential logic traps
- Triggering of state transitions & dependency on external keepers to trigger certain txns (eg .liquidations) can create security risks

_Risk_

- Assumptions that a txn would be executed by a certain time can lead to logic traps
- Any logic that depends on timeliness of user actions should be robust enough to survive even when those actions haven't been performed

_Mitigation_

- Check for time sensitive logic and see if there are any assumptions related to timeliness of a particular action

---

### V52 - Ordering issues

_Background_

- Similar to timing issues, incorrect assumptions on ordering txns can lead to security issues
- for eg. users may access a liquidation function even if there is no borrowing against a user - if such function allows a liquidation action triggered on an address with no borrowing - it copuld lead to logic traps

- attackers can front-run/back-run user interactions
- front running is when attackers race to finish a transaction before a user
- back running is when attackers race to be right behind user transaction
- combination of both could lead to what is popularly known as sandwich ayyack

_Risk_

- Sandwich attacks or front/back running txns

_Mitigation_

- Identify key actions such as transfers, deposits, withdrawals and check if they can be abused by changing order

---

### V53 - Undefined behavior

_Background_

- Any behavior that is not defined explicitly in specification document is undefined behavior
- This behavior could be malicious or just an accident
- If undefined behavior is triggered maliciously -> it can cause security issues
- In some cases undefined behavior may not be a security concern - but nn

_Mitigation_

- All behavior is explicitly defined in document -> implemented and documented clearly

---

### V54 External interactions

_Background_

- Could be interactions with outside assets, actors or actions and hence external
- interacting with external contracts such as oracles, tokens and contracts forces system to trust that called contract
- This requires a validation of outputs that are sent by that external account
- Possible return values from such external interactions could have internal implications to smart contract logic
- Therefore -> when looking at security -> its important to also understand how malfunctioning of an external contract could cause internal security issues
- Unbounded Composability makes checking all possible scenarios extremely diffe
