# ETHEREUM 103

## Summary

In this session, we dive deeper into signatures, Blocks & Block Headers, EVM

[Video](https://www.youtube.com/watch?v=ltvTIr4K63s)

## ECDSA Signature

ECDSA signatures have 3 purposes

- _Authorization_: authorize transactions to spend ether or approve spend for another contract
- _Non repudiation_: once authorization is given, cannot be denied later that authorization was not given
- _Integrity_: transaction data cannot be modified by anyone after transaction is signed

---

### Contract creation

- Transaction can result in a contract creation
- Contract creation txn is sent to a 0 address (all bits are 0) - special address on ethereum
- `data` of this contract creation transaction contains contract bytecode
- Can also contain ether amount in ‘value’ field → in this case, new contract that gets created will have ether balance

---

### Message v/s transaction

- Using interchangeably but there is a difference between 2
- **Transaction originates offchain and it targets an account/entity onchain**
- **Message originates onchain and it targets an account/entity onchain**
- Transaction is originated by EOA acccount where a user signs a message and sends it onchain; msg could transfer eth or trigger contract code
- Message could be triggered by a EOA transaction and destination could be a EOA or contract
- Message could also be triggered by an EVM contract `CALL` opcode. When a contract triggers another contract

---

### Blocks & Blockchain

- Transactions are grouped together → creates a block → blocks are linked together → creates a blockchain
- Every block has a hash that links to previous block
- if any single block is changed, all subsequent blocks change
- blocks are ordered and txns within blocks are also ordered -maintains immutability and integrity of blockchains

---

### Node

- Ethereum node is just a protocol that implements ethereum specification
- communicates with other nodes - peer-to-peer
- ethereum client → specific implementation of ethereum node
- geth, openethereum, erigon, nethermind are all ethereum clients
- txns are sent to ethereum node → these are then broadcasted peer to peer to all nodes → consensus is arrived at a bunch of txns grouped into a block→ once consensus is reached, block sits on chain

---

### Validators

- Entities running ethereum nodes
- they receive txns → validate → execute → combine and propose a block
- if block gets added, validator is rewarded with eth → block reward

---

### Block Gas Limit

- total gas spent by all txns added to a block
- caps # of txns that can be included in a block
- **block size is NOT fixed by # of transactions but by the gas used by all txns**
- block gas limit is set by miners → (in PoW model, set by miners by voting), this was 15 million per block

---

### GHOST

- When multiple valid blocks are mined at same time (old PoW ), one block needs to be chosen as winner
- Done by GHOST protocol - greedy, heaviest observed subtree protocol

---

### Consensus

- Nakamoto consensus is used for figuring winner block
- POW to POS transition → currently block proposer is selected at random. (More study on this needed...)

---

### Ethereum State

- Mapping of address to the state contained within it
- Implemented as modified `merkle-patricia` tree - binary tree
- Merkle tree is a binary tree that is composed of a set of nodes, leaf nodes contain data are right at the bottom - all intermediate nodes contain combined hash of two child nodes

[Merkle Patricia Tree reference 1](https://medium.com/codechain/modified-merkle-patricia-trie-how-ethereum-saves-a-state-e6d7555078dd)

[Merkle Patricia Tree reference 2](https://ethereum.stackexchange.com/questions/6415/eli5-how-does-a-merkle-patricia-trie-tree-work)

---

### Block Header

- Each block contains header and txns and ommers header (uncle block header)
- Uncle block refers to orphan blocks that have lost in a competitive consensus race (2 blocks mined at same time, but one is chosen as winner, other becomes uncle)
- Block header contains -> parent hash, ommer hash, beneficiary, state root, txn root, receipt root, logs bloom, difficulty number, gas limit, gas used, extra data, timestamp, mix hash, nonce

Below is illustration I found on [ethereum stack exchange article](https://ethereum.stackexchange.com/questions/268/ethereum-block-architecture)

![Block header illustration](../images/Block-Header-Illustration.png)

Also, below is the ethereum block structure from same stack exchange article

![Ethereum block structure](../images/Eth%20Block%20structure.jpeg)

**State root**

- This is critical to how ethereum state is captured within blockchain
- its a 256 bit modified merkle patricia tree
- leaves of the state root (bottom most nodes of binary tree) contain key-value pairs.
- keys are ethereum addresses and value represents state of the account. Recall that each account has a nonce, balance, code hash, storage root.

**Transaction root**

- leaves (bottom most nodes of binary tree) represent txns
- all intermediate ndes again contain combined hash of 2 child nodes
- root represents txn root

**Transaction receipt root**

- txn receipts are side effects of capturing a txn on a blockchain
- Txn receipt is a tuple with 4 items
  - `cumulative gas used` - total gas used until this particular txn has happened
  - `logs`- events emitted by transactions
  - `bloom filter` - contains all indexed fields from logs generated by executing transactions
  - txn status code - what really happened with txn

**Transaction gas**

- gas is sent to validator for running and validating txns
- refund is when maxGasLimit > actual gas used. In such cases, excess gas is refunded back to user

---

### Ethereum Virtual Machine

- Execution component of ethereum blockchain
- Run time environment → all smart contracts are run here
- quasi turing complete → turing complete but with gas bounded computation
- EVM runs on low-level, stack based machine code
- code consists of series of bytes (bytecode)
- One byte → one operation
- Opcodes are simple → each of them is a single byte → and executes one operation

**EVM architecture**

- EVM follows a stack based architecture
- 4 components
  - Stack
  - Volatile memory (non persistent data)
  - Non-Volatile storage (persistent data)
  - Call data
- Word size - 256 bits → chosen to facilitate keccak256

**Stack**

- has 1024 elements - each element is 256 bits in length
- has access to top 16 elements → anything beyond is inaccessible
- Stack operations
  - `PUSH` - Push to the top of stack
  - `POP` - Pop from the top of stack
  - `SWAP` - Swap positions in stack
  - `DUP` - Duplicate word
