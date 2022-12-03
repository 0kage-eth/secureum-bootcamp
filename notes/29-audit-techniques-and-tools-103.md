# AUDIT TECHNIQUES AND TOOLS 103

[Video](https://www.youtube.com/watch?v=QmD2bJUe140&list=PLYORQHvGMg-VWUdk3AollB0IYVF0az5Tw&index=3)

## Summary

We discuss audit tools in greater detail. continuing previous view topic on Slither...

### Slither

_Slither ERC Conformance_

- ERC confromance tools - checks if contracts using custom ERC implementations are indeed compliant with ERC token standards (eg. ERC20, ERC721, ERC777, ERC165, ERC223, ERC1820)

- Check if functions are present, return correct type and visibility
- Events are present and correctly emitted inside each functions and if parameters rightly indexed
- All ERC checks are verified in one single tool

_Slither Prop_

- Property generation tool
- Generates code properties and invariants
- Can be tested with unit tests and echidna

_Slither New Detectors_

- Slither supports an extensible architecture that allows anyone to create new detectors
- Skeleton for such new implementation - arguments, help,impact, confidence, wiki
- placeholder for detect logic -`_detect()` - detect logic
- community can contribute new detectors - `exactly what i have to do on slither`

### Manticore

- Symbolic execution tool from trail of bits
- can execute code with symbolic inputs and can explore all possible states that can be reached
- It can generate inputs that can lead to crashes -> leading to error discovery
- Provides programmatic interface to its analysis engine

### Echidna

- Fuzzing tool that complements Slither and Manticore
- Haskell based language
- creates fuzzing campaigns to falsify user defined predicates or assertions
- generates inputs tailored to actual code
- has corpus collection of predefined fuzzing campaigns
- Supports mutations/coverage guidance for deeper bugs

_Echidna usage_

- execute test runner where it takes contract and a set of invariants as inputs
- for each invariant, it generates random call sequences and see if invariant holds
- if it finds a way to falsify invariant, prints the inputs that allowed that
- If it can't find examples of falsification, then we can consider contract safe w.r.t that invariant
- Invariants are solidity functions with names starting with `echidna_` - no arguments, return a boolean
- collecting / visualizing coverage

### Eth security box

- ToB has combined all 3 tools into a single security toolbox
- docker container package
- preinstalled and preconfigured
- makes it very handy
- toolbox has slither, echidna, manticore, rattle, ethno

### Ethersplay

- a binary ninja plugin by trail of bits
- disassemble a binary and display in various ways
- ethersplay extends this to evm bytecode
- displays contol flow graphs
- displays manticore coverage

### Pyevmasm

- also by ToB
- EVM assembler and disassembler
- command line utility for assembling and disassembling

### Rattle

- Security tool by trail of bits
- evm binary static analysis framework - designed to work with deployed smart contracts
- it takes evm byte code as input and generates control flow
- there is context sensitive and path sensitive analysis
- converts this control flow into SSA - single stacking assignment form (SSA form) with infinite registers (?? read more)
- evm is s stack based machine and there are many stack instructions in byte code
- rattle converts bytecode from stack machine to SSA - removes >60% of stack instructions (??)
- provides a user friendly interface for analyzing smart contract byte code

### EVM CFG builder

-security tool built by trail of bits

- Extracts Control flow Graph from EVM byte code
- Also outputs function names and signatures
- generates a DOT file that is used by ethersplay, manticore & other tools

### Crytic Compile

- by ToB
- smart contract compilcation library
- support truffle, brownie, hardhat
- used by slither/echidna/manticore

### solc-select

- security helper tool
- ToB
- helps us switch between different solidity compiler versions
- uses a wrapper around solidity compiler that picks the right version based on what is set

## Etheno

- ethereum testing swiss army knife
- again by ToB
- Analysis tool wrapper

### CONSENSYS TOOLS

_Mythx_

- security service provided by consensys diligence
- paid API based service
- combines maru + mythril and harvey
- mythx implements 46+ detectors, Maru is closes source, Mythril is open cosurce
- runs in the cloud

- first step for project to submit code via API (source code + contract byte code)
- second step is to activate full suite of analysis
- longer mythx runs, more security vulnerabilities it can detect
- precision of symbolic checker and fuzzy logic can better with more iterations
- fourth step is to receive analysis report - all vulnerabilities listed and their location in code

_Tools used_

- When person submits code over MythX API, it gets analyzed by variety of tools
- static analysis called maru
- symbolic analysis by mythril
- greybox fuzzing by harvey

- Coverage provided by MythX covers most of the issues found in SNX registry
- SaaS platform - premise is SaaS approach is better
  - higher performance than running sec tools locally
  - three tools together - better coverage
  - continuous improvements by consensys for latest tools
