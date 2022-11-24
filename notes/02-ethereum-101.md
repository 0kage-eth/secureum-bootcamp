# ETHEREUM 101

## Summary

In this session, we discuss basics of ethereum, web 2.0 vs web 3.0, decentralization, $ETH and cryptography basics

[Video](https://www.youtube.com/watch?v=44qhIBMGMoM)

### Intro

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
- Transaction triggering a smart contract has to specify gas upfront → depending what we want to execute → more complex instructions = more gas
- Once gas is exhausted → execution stops
- Gas bounds the resources that anyone has to run on blockchain → without resources, blockchain halts → prevents infinite loops and blockchain attacks

--

## Ether

- Units of gas are consumed for running transactions
- Price of gas is measured in _ether_
- Gas price depends on supply and demand
- if more contracts need access to blockchain compute/storage, price increases and vice versa
- If gas units are exhausted, then transaction is reverted
- 18 decimals
- smallest unit is _wei_ (1 ether = 10^18 wei)
- 10^3 wei = 1 babbage
- 10^6 wei = 1 lovelace (names of famous cryptographers)

--

## Dapps

- Decentralized applications - built on decentralized infrastructure
- Web frontend running on peer to peer infrastructure (IPFS)
- Web app interacts with a smart contract on Ethereum blockchain

--

## Web 2.0 vs Web 3.0

- Web 2.0 → Client-Server architecture
- Centrally managed, freemium, ad-biz models
- Web 3.0 → P2P compute, storage, network
- Web 3.0 decentralized, incentivized participation

--

- Talks about ethereum triad (need to research more on this...)
  - compute - ethereum
  - storage - swarm
  - network - whisper/waku

--

## Decentralization

- Talks about 3 levels of decentralization
  - _Architectural_: Physical hardware, who runs the nodes
  - _Political_: Individuals or institutions who control that hardware & staking. Are they independent or a group
  - _Logical_: data structures that are used to build smart contracts - is it one monolith or can it be broken down

## Cryptography

- Public key cryptography is assymetric. Private key cryptography is symmetric (what does this mean?)
- Private key → can generate public key but not vice versa
- In ethereum, digital signatures are used extensively
- Digital signature algorithm used by ETH (same as BTC) is ECDSA. _Elliptic Curve Digital Signature Algorithm_
- Elliptic curve cryptography is an approach to public key cryptography
- In ethereum, particular elliptic curve that is used is **SECP-256K1**
- Private Key - secret 256 bit key - its a random number → used to derive a public key → Public key is used to derive address of ethereum account/address
