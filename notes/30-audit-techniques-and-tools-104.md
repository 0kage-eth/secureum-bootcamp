# AUDIT TECHNIQUES AND TOOLS 104

[Video](https://www.youtube.com/watch?v=jZ81ebDJVe0&list=PLYORQHvGMg-VWUdk3AollB0IYVF0az5Tw&index=2)

## Summary

We discuss audit tools in greater detail. continuing previous view topic on Mythx and audit tools...

### MythX

_Privacy_

- privacy guarantee for contract code sent using API's
- TLS encryption
- code is sent to secure server & not shared with others
- results of analysis private and only accessible to sender

_Performance_

- performance is an issue as good analysis with a deep review takes a lot of time
- comes in 3 configurable scans

  - quick - 5 mins
  - standard - 30 mins
  - deep - 90 mins

- Comes with CLI
- Library - JS/TS intergrations
- PythX - python library
- VScode extension

### Scribble

- Another verification tool from consensys diligence
- translates high level specifications into solidity code
- annotations made onscrible are converted to concrete assertions

### Fuzzing as a service

- project can submit their code along with scribble specifications
- contracts are run using `Harvey`

### karl

- monitor ethereum blockchain for newly deployed smart contracts
- can be done in real time
- checks using Mythril engine
- Can be used to report vulnerabilities on newly deployed contracts

### theo

- exploitation tool
- for reconaissance, exploiting, front/backrunning

### visual auditor

- VS code extension
- security aware syntax for solidity/vyper language
- modifiers/visibility/unused states/ developer notes in comments/ constructor fallback/ inheritance etc
- code reporting and augmentation

### Surya

- visualization tool by consensys
- call graph and inheritance graph
- integrated with visual auditor

### SWC registry

- smart contract weakness classification
- claasification of security issues
- compare & improve tools
- maintained by consensys diligence

### securify

- developed by chainsecurity
- static analysis tool
- supports 38+ vulnerabilities

### verX

- efficient symbolic checking engine
- temporal safety -> reachability

### SmartCheck

- Developed by SmartDec
- Static Analyzer
- converts solidity code into XML specification

### K-framework

- Model of EVM - K-EVM
- Verification framework - runtime verification
- framework for building tools

### Certora Prover

- symbolic checker

### HEVM

- EVM implementation nby DappHub
- Made for testing and debugging
- helps run unit/property tests

- Best wat is to install and experiment

### Capture the Flag contests

- Hack dummy contracts with vulnerabilities
  - Capture the Ether
  - Ethernaut
  - Damn Vulnerable Defi
  - Paradigm CTF

### Summary

- Security tools help humans automate part of testing
- Catch generic EVM/solidity based vulberabilities
- Automate tasks - cheap, fast and scaleable
- Susceptible to false positives
- Helpful to atleast clear some common pitfalls

### Audit Process

Generalizing an audit process can be thought of in terms of 10 steps

_Step 1_
Read specs and documentation to understand protocol/requirements/dependencies etc

_Step 2_
Run fast automated tools - such as slither (static analyzers) to investigate for common security pitfalls and missing best practices

_Step 3_
Manual analysis of code to analyze business logic

_Step 4_
Slow/deep tools (fuzzers/symbolic checkers) to get a deeper understanding of any hidden vulnerabilities

_Step 5_
Discuss findings with other auditors to identify dfalse positives or missing analysis.

_Step 6_
convery status to project team. Can clarify with project team to understand knowledge gaps

_Step 7_
Iterate the above steps

_Step 8_
Write report

_Step 9_
Deliver report

_Step 10_
Evaluate fixes
