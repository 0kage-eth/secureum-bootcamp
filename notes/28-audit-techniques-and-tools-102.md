# AUDIT TECHNIQUES AND TOOLS 102

[Video](https://www.youtube.com/watch?v=QstpNY1IuqM&list=PLYORQHvGMg-VWUdk3AollB0IYVF0az5Tw&index=4)

## Summary

Review tools available that help with web3 audit and discuss audit techniques - continued..
We ended last lesson discussing analysis techniques...

### Analysis techniques (..contd)

2. _Documentation_

   - should discuss how the protocol design is implemented
   - Not the `why/what` that is part of specificatiosn -but the `how`
   - README files in github repo
   - individual contract description along with NATSPEC of contracts and functions
   - Understanding documentation before looking at code helps auditors save a lot of time. Helps understand
     - asset flow
     - main contracts
     - external dependencies
     - threats
     - risk mitigation measures
   - mismatches between documentation and code could indicate
     - stale documentation
     - software defects or potential vulnerabilities
   - given the critical role of documentation, project teams should focus a lot on this as this makes the whole audit process faster and more effective
   - With no documentation, auditors have to infer all the above by reading code - possibility of missing some key understanding or overlooking something is high in such cases

3. _testing_

- test if software generates expected outputs with chosen inputs
- projects in general have very little testing done at audit stage
- test coverage give a good indication of project maturity
- testing composobility on mainnet is not trivial
- reviewing unit/functional tests give auditors a good insight into edge cases and multiple assumptions
- auditors should expect a very high level of test coverage - must have in web3 especially when moving money
- `program testing can be used to show presence of bugs but NEVER the absence` - famous quote on testing
- smart contracts open to all managing billions of TVL -> testing is super critical

4. _static analysis_

- technique of analyzing program properties without executing a program
- this is contrast to software testing where program is run by executing inputs to generate a set of outputs
- static analysis can be performed on solidity code or EVM byte code
- usually a combination of control flow & data flow analysis
- Eg. `slither` - trail of bits and `maru` - consensys - both anaylyze intermediate representations derived from smart contracts

5. _fuzzing_

- automated software testing - that works by providing invalid, random inputs
- this is in contrast to regular testing where chosen and valid set of inputs are used for testing
- invalid data is sent & program is monitored for crashes/failing/built-in code assertions or memory leaks etc
- since anyone can interact with smart contracts, fuzzing is a useful tool since anyone can be expected to enter any random inputs to check how contract performs
- Eg. `echidna` - trail of bits and `harvey` = consensys diligence

6. _symbolic checking_

- Symbolic inputs to represent states and transitions
- Model checking and property checking -> whethere a state model meets a given specification (???? - not sure what this means)
- model of system & its specification are formulated in some precise mathematical language
- problem itself is formulated as a task in logic with a goal of solving the formula
- `Manticore` from trail of bits and `mythril` from consensys are 2 widely used checkers

7. _formal verification_

- prove or disprove correctness of a system using formal specifications and methods of math
- used to detect complex bugs that are hard to detect using simple automated tools
- used to test some specific / deep properties (not sure.. again, need to read up more on this)
- Some tools here are `Certora Prover` and `KEVM`

8. _manual analysis_

- complementary to automated analysis
- automated analysis is cheap & fast - only runs on generic solidity and evm bugs
- manual analysis is expensive - to test business and application logic and constraints
- human expertise in smart contract security is a rare and expensive skillset today
- slower, prone to error and inconsistent
- not determinstic & scaleable - but only way to evaluate business logic and constrains, complex relationships and composability effects
- Majority of serious vulnerabilities are detected using manual analysis

### Audit false positives

- false positives are incorrectly flagged vulnerabilities
- incorrect assumptions or analysis simplifications leads to false positives
- increases cost and effort of reviewing the impact of these false positives & to classify them as false positives
- decreases confidence in the earlier findings and any efficacy of any automated tools used earlier

### Audit false negatives

- there is also false negative - where an issue was flagged but deemed a false positive -> but it is indeed a vulnerability that gets exposed later
- true issues were not reported at all
- again some incorrect assumptions or lack of proper understanding of platform
- true negatives are findings that were analyzed and dismissed as they are not vulnerabilities

### Audit firms

- several teams with experience in smart contracts & ethereum and provide auditing services
- some have web2 origin -> some are pure web3
- few others which are super specialized in formal verification, privacy and cryptographic aspects
- atleast 30+ firms in the space
- major ones trail of bits, consensys diligence, sigma prime

### Security tools

- assists developers and auditors to discover potential vulnerabilities
- highlight code that falls into common pitfall patterns
- also suggests best practices for various smart contract coding practices
- None of these are able to replace manual analysis - in the sense they can't track complex logic pitfalls
- So at best, these tools are complementary to manual analysis

Tool categories

_Testing_
_Test Coverage_
_Linting_
_Static Analysis_
_Symbolic Checkers_
_Fuzzing_
_Formal verification_
_Visualization_
_Disassemblers_
_Monitoring_

_Static Analysis_

- Lets start with most widely used tool in the space - `Slither`
- Uses Solidity and Python 3 for analysis risk of smart contracts
- It is easy to use and free
- Preruns a suite of vulnerability detectors -> prints visual information and contract details
- Basically checks for EVM/Solidity pifalls
- Provides an API to easily write custom analysis
- implements 75+ detectors,custom analysis support using APIs and printers
- Enhances code comprehension and detects vulnerabilities

**Features**

- implements vulnerability detectors and contract information printers
- tends to have low rate of false positives
- runtime tends to have <1 sec/ contract
- Uses intermediate representation known as SLithIR - enables simple and high precision analysis
- Detects 75+ vulnerabilities using unique detectors
- can run on truffle/hardhat frameworks
- by default, slither runs all its detectors
- to run only selected detectors from its suite, there is a detect option to specify names of detectors to run
- to exclude some detectors, one has exclude option
- eg. of detectors are `reentrancy-eth` and `unprotected-upgrade`

_Slither Printer_

- allows printing different type of contract information
- helps in contract comprehension and gives visibility into contract details
- various print options include - control flow graph, call graph, summaries, inheritance
- summary of functions
- data dependence of variables
- modifiers
- dependencies of external contracts

These will quickly help in understanding contract structure - giving a quick feel of how contracts of the project are orgamized

_Slither Upgradeability_

- Many security challenges related to proxy based upgradeable contracts
- Lot of checks implemented by slither on proxy contracts
- Reviews contracts with `delegatecall` proxy pattern
- Checks if variables are properly defined, any missing, correct order, initialized? any reinitialization risks?
- checks for function Id collission and shadowing

_Slither code similarity detector_

- Can detect similar solidity functions
- uses ML to detect similar contracts
- uses pre-trained database of 60k verified etherscan contracts
- Can be used to detect vulnerabilities from earlier forks/copies

_Slither flat_

- Flattening tool to flatten code
- deploys 3 strategies
  - most derived - exporting most derived contracts
  - one file - exports all contracts in one file
  - local import - exports every contract in one separate file

_Slither format_

- Automatically generates patches or fixes for few of its detectors
- Patches are git compatible
- detectors for which auto patches available are - unused state, naming convention, solc version wrapper, external function, constant states etc
- Patches generated by this tool should be carefully reviewed before applying
