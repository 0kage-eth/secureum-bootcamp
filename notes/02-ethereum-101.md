# ETHEREUM 101

[Video](https://www.youtube.com/watch?v=44qhIBMGMoM)

## Intro

- Ethereum is a blockchain that allows smart contracts and decentralized apps
- Turing complete language
- State can be read and written
- State → rules → State’ (new state)
- Global commodity - a database that is accessible to everyone to read/write
- Open source protocol & code
- Stores state & syncs the state across all nodes
- $ETH is native currency

### Properties

- Permissionless - anyone can read or write to the chain (vs Android/iOS centralized)
- High availability - always running, 24*7*365
- High transparency and neutrality
- Censorship resistant
- Low counterparty risk
- $ETH is currency, store of value, commodity → all at the same time

### BTC vs ETH

- BTC has limited scripting vs ETH
- BTC is not turing complete → ETH can have any amount of complexity
- BTC runs on UTXO transactions

---

## Components

- **Transaction**: Contains sender, recepient, amount, data
- **State Machine**: sends instructions to EVM compiler → referred to as byte code
- **Data structures**: used to store and handle different types of data
- **Modified Merkle Patricia trees**: handles state in blockchain
- **Consensus algorithm**: every node has to agree on to create a block (POS Eth 2.0 has serenity consensus)
- Protocol is implemented in Ethereum client → geth, openethereum, nethermind, erigon
- Nodes run ethereum client

_Halting Problem - Turing Completeness_

- Turing complete languages have a halting problem
- don't know upfront if a particular input given to a particular program will make it halt or end up in a infinite recursive loop
- In the context of smart contracts - we cannot predict ahead of time it will take to run whether it will stop ever
- Way Ethereum handles this is by constraining resources - by concept of Gas
- Smart contract is a bunch of instructions - each instruction needs some gas - portioning gas to perform specific operation is called _metering_
