# SECURITY PITFALLS 204

[Video](https://www.youtube.com/watch?v=IVbEIbIpWUY&t=5s)

## Summary

Advanced security pitfalls, we will look at 100 more vulnerabilities (contd..)..

### V55 - Trust

_Background_

- trust minimization or zero trust is aspirational goal of crypto
- trusting assets, actors and actions can be compromised and malicious actors can take advantage of trust
- never trust blindly -> trust but verify

_Risk_
NA

_Mitigation_
NA

### V56 - gas

_Background_

- Block gas limit is total gas that can be used in 1 block
- transaction limit to a block is decided by block gas limit
- each operation on chain needs gas - to protect turing completeness of solidity -> gas is used as commodity to power trsnactions onchain
- Gas consumption is what makings ethereum computations bounded

_Risk_

- Loops or external calls can create `out of gas` exception causing locked funds

_Mitigation_
Gas consumption of each trasnaction should be evaluated - and any gas guzzlers should be made gas efficient to prevent out of gas exception

---

### V56 - dependency

_Background_

- Dependency on external assets/actors or actions or contracts such as oracles/liquidators/tokens/relayers can create trust, availability and correctness assumptions
- Specially something like oracles -> if there is a hack that causes price to dramatically collapse -> catching such dependencies on time & quarantining its impact is extremely challenging -> creates a lot of security risk

_Risk_

- Blowup of dependency contracts can create huge security risks

_Mitigation_

- Dependencies should be well documented and evaluated for such security implications

---

### V57 - constant

_Background_

- assuming some constants would not change for lifetime can sometimes create security issues
- For eg. external contract addresses, some roles, permissions -> if changed, can create a lot of challenges to logic

_Risk_

NA

_Mitigation_

- if and when constants change for whatever reason, such changes should be documented and contracts setters should correspondingly be updated

---

### V57 - freshness

_Background_

- Freshness relates to working with the latest state of an external contract or some value that keeps changing (eg. nonce of account)
- Freshness assumes availability and trust that external source of data is continuously active

_Risk_

- Any risk of availability creates freshness issue & this can have serious security implications
- Best example is an oracle that continuously feeds prices to variety of exchanges and defi platforms - if the latest state of oracle is not really the latest, then such platforms are exposed to serious loss events

_Mitigation_

- Security implications of freshness need to be clearly understood and documented
- Redundancies that can track lack of freshness (for eg. picking prices from multiple oracles and comparing prices between them)

---

### V58 - scarcity

_Background_

- Refers to assumption that something is available in limited quantities
- If that trust of scarcity is broken - severe security issues can happen

_Risk_

- Incorrect assumptions on scarcity can lead to logic errors that are built based on that assumption
- for eg. flash loans/flash mints can impact any calculation that implicitly assumes scarcity (for eg. if a governance voting is based on outstanding tokens at a snapshot - someone can take a flashloan at the exact time and pass whatever vote because he holds the max % of tokens at that moment)
- sybil attacks are another example - airdrops assume 1 user from 1 account - if 1 user spins up 100's of accounts - scarcity assumption is violated and all airdrops can go to the exploiter with 100s of accounts

_Mitigation_

- Evaluate if there is any scarcity or abundance assumption that could cause exploits

---

### V59 - incentive

_Background_

- Incentives, misaligned or non-existent, can cause security issues
- airdrops, liquidation fees, liquidity provider fees, token farm yield, are examples of incentives
- Similarly lack of incentives to cause denial of service or griefing also lead to security issues
- Incentives or lack of - can lead to expected behavior not being triggered or unexpected behavior being triggered

_Risk_

NA

_Mitigation_

NA

---

### V60 - clarity

_Background_

- Clarity comes from

  - specifications document
  - documentation
  - clearly defined UI/UX
  - Error/incident reports
  - logging and audits

- Lack of clarity leads to incorrect assumptions and possible errors

_Risk_

NA

_Mitigation_

NA

---

### V60 - cloning

_Background_

- copying code from library, contracts or other protocols is referred to as cloning
- assumptions, bug fixes from cloned code might be ignored over time - errors or incorrect assumptions can contaminate logic of current contract
- there have been security vulnerabilities because of incorrect cloning in the past

_Risk_

NA

_Mitigation_

NA

---

### V60 - Logic

_Background_

- Bugs specific to business or application logic cannot be identified unless we have know how business functions
- these errors are what create the most hacks - and this is most tricky as well
- A requirement and specification sheet and protocol conceptual documentation with list of possible assumptions is a good place to start to analyze business specific vulnerabilities
- Lack of rules/tools means that we have to infer the constraints from the code - this is not very effective
- these are the hardest class of bvulnerabilities -> and require a sound understanding of protocol

**Principle 1 - Least Privelege**

- Was first formulated by Saltzer & Schroeder 1975
- Every contract or program should be operated by user with least amount of privelege possible
- Any users accessing 'X` should ideally be having permissions only to do X. Not Y, Z, A, B -> more the priveleges to that user, more the potential damage that can be caused
- When granting roles, user should be granted the least role sufficient to do the job (s)he is intending to do
- Privelege should be need based

**Principle 2 - Separation of priveleges**

- Critical priveleges should be separated across multiple actors, who are mutually adversarial (preferably)
- lesser amount of diversification of priveleges leads to higher amount of risk
- Good example - Multi Sig vs EOA
- Multi-sig should preferably be among mutually distrusting participants -> ensures no single point of failure

**Principle 3 - Least common mechanism**

- Shall minimize the amount of common mechanism that is shared by more than one user and depended on by all users
- ensure least number of scurity critical modules or paths as required are shared amongst different actors of code so that impact from any vulnerability or compromise of shared components is limited to smallest possible subset
- Common points of failure are minimized

**Principle 4 - Fail safe defaults**

- base access based on permission rather than exclusion - so its a sign-in rather than opt-out
- permissions are initialized to default values that deny access by default
- these permissions can be diluted and be made more inclusive and permissive with time
- this is the concept of guarded launch we discussed earlier
- fail safe defaults could apply to visibility, permissions, assets, actors, actions
- pros and cons for this approach - werb3 is open system - while this might apply for web2, it doesn't fit into the ethos of web3

**Principle 5 - Complete Mediation**

- every action or control path needs to have an access checkpoint
- there should be no control path that can be used freely by any participant
- this means - missing auth flows, missing modifier checks etc

**Principle 6 - Economy of Mechanism**

- Keep the design as simple and small as possible
- ensure contreacts or functions are not overly complex and large
- this reduces readability, maintainability or even auditability
- KISS - Keep it simple stupid
- More complex - less secure

**Principle 7 - Open design**

- design should not be secret
- especially true for web 3 space
- permissionless participation improves code security
- gated and obfuscated code has more chance of failure
- design and code of smart contracts should be available to all by default

**Principle 8 - Psychological acceptability**

- System UI should encourage good behavior and encourage users to apply protection mechanisms
- ease of UI/UX
- Interfaces have to be designed so that users can use them with minimal risk
- Design and user interface should be easy and intuitive

**Principle 9 - Work factor**

- compare the cost of circumventing mechanism with resources of attacker
- this is extremely relevant for smart contracts and web3
- Since contracts manage billions of dollars - hackers will dedicate greatest amount of resources possible (intellectural, social and financial capital) rto support such systems
- cost of circumventing is not very high but rewards are huge - high risk/reward -> extremely skewed
- factor in the highest levels of threat

**Principle 10 - Compromise recording**

- Mechanisms that reliably report compromise of information can be used in place of elaborate mechanisms that completely prevent loss
- achieving bug-free code is theoretically and practically impossible
- one should strive to reduce attack surface as much as possible
- anticipate residual risk to exist in the system
- monitor, detect and fix errors rather than waiting to ship best code
- ensure smart contract and operational infrastructure can be monitored and analyzed at all times
- For eg. token transfers, large mints, burns, huge deposits, withdrawals can be tracked in real-time by logging events
