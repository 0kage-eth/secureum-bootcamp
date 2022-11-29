# SOLIDITY 204

[Video](https://www.youtube.com/watch?v=L_9Fk6HRwpU)

## Summary

We dicuss more Open eppelin contracts and their security implications

### OZ contracts

**Context**

- Gives current execution context when msg.sender and user is different
- Useful in cases where txn is working with meta txns - meta txns are where account sending txns is different from account user
- In such situations, relayer between contract and actual users needs to be clearly separated from user - and relayer context should be identified separately from relayer context
- `_msgSender()` and `_msgData()` are 2 functions that help us do separate relayers context and user context

**Counters**

- helps keep a counter
- increment & decrement counter
- eg. tracking mapping elements, token Ids for ERC721 etc
- `current()` gives us current value, `reset()` resets counter to 0
- `increment()` and `decrement()` increase and decrease counter by 1

**Create2**

- Note that `Create2` opcode helps us create a contract at a pre-specified address
- OZ library helps us use `Create2` functionality in easier and safer manner
- Recall - `Create` sends a txns to zero address with `data` that is contract bytecode
- Contract address created by `Create` is a function of deployer address and nonce of the deployer
- Incontrast `Create2` does not use the nonce. uses bytecode of new contract along with a `salt` to generate a new contract
- because we don't use nonce, address of newly deployed contract becomes determinstic
- `deploy(uint256 amount, bytes32 salt, bytes byteCode)` is used to deploy new contract using `create2` opcode
- amount above refers to amount of ether balance to be sent to contract at initialization
- if one only wants to compute address of the 'to be' deployed contract, we can call `computeAddress(bytes32 salt, bytes32 byteCodehash)`
- if we want to compute address from a different deployer address, we can do `computeAddress(bytes32 salt, bytes32 byteCodeHash, address deployer)`

**Multicall**

- Library allows multiple calls to be batched to create a single external call
- `multicall(bytes[] calldata data) -> bytes[]` -> basically send each msgcall in a bytes array
- result is also a bytes array that needs to be decoded to get outputs
- Receives and executes calls in a batch
- one tx, same block - less overhead, less gas

**String**

- String library allows basic string operations
- `toString(value)` -> converts uint256 to ASCII string decimal representation
- `toHexString(value)` -> converts uint256 to ASCII string hexadecimal representation
- `toHexString(value, length)` -> converts uint256 ti ASCII string hexadecimal representation with fixed length

**ECDSA**

- Uses ECDSA library to sign contracts
- ECDSA has 3 components `(v, r, s)`
- `(r,s)` are sign keys (32 bytes each), `v` is 1 byte
- `ecrecover` opcode we discussed earlier in [lesson 10](./10-solidity-104.md) is exposed to malleable signature attacks - meaning, 2 different combinations of (v.r.s) can lead to same signature - `recover(bytes32 hash, bytes signature)` -> prevents malleable signatures, keeps the `s` value in lower half order and restricts `v` to 27/28
- `recover` does not revert if signature is invalid or if signer is not able to be recovered - reverts a zero address instead (important from security implications)

**Merkle Proof**

- Library helps with merkle proof verification
- We discussed earlier - Merkle Trees have leaf nodes that contain states, and all other nodes are combination of the hashes of two children nodes
- `verify(proof, root, leaf) -> bool` -> verify function takes proof, root and leaf and returns true if leaf parameter can be proven to be part of tree with root node. Proof includes all sibling hashes on the branch from leaf to the root
- Each pair of leaves and each pair of pre-images are assumed to be sorted.

**SignatureChecker**

- Allows contracts to work with ECDSA signature and ERC 1271 signatures
- ECDSA allows signatures of EOA accounts
- ERC 1271 allows signatures of contract accounts
- Interesting for smart contract wallets that need to work with contract and EOA signatures
- ERC1271 signatures originate from smart contract wallets like Argent and Gnosis Safe.

**EIP 712**

- Supports hashing and signing of type structured data
- Contract implements a EIP 712 domain separator that is used as part of encoding scheme
- implementation of domain separator includes chain Id and address to prevent replay attacks

**Escrow**

- Escrow library allows account to hold funds to a designated payee until they withdraw
- Guarantees that all funds are handled by escrow rules and there is no need to check payable functions or transfers in ingeritance tree
- Ownable -> only owner can operate escrow
- `depositsOf(payee)` -> returns deposits against a specific payee
- `deposit(payee) onlyOwner` -> only owner can setup a deposit against a given payee
- `withdraw(payee)`-> payee can withdraw funds deposited

**Conditional Escrow**

- Derives from Escrow libarary
- Withdraw allowed only if a condition is met
- `withdrawalAllowed(address payee) → bool public` - returns a flag of whether withdrawal is allowed or not
- this is a function that will be implemented by derivated classes
- Its an abstract contract - withdrawalAllowed is not implemented

**Refund Escrow**

- Built on top of Conditional Escrow Library
- Allows holding funds for a beneficiary that are deposited by multiple depositors
- Has 3 states - active / refunding/ close
- `Active` state is where deposits are allowed by multiple depositors
- `Refunding` state is where deposits are refunded by multiple depositors
- `Closed` state in which beneficiary can make withdrawals

**ERC165**

- ERC 165 library helps us identify if a particular contract supports a particular interface
- Ethereum has no native concept of an interface - applications usually don't know whether they are making a correct call
- for unknown third party addresses that need to be interacted with, there may not be direct calls to them (ie ERC20 sent to such addresses can be locked forever) - in these cases, contract declaring its interface can be very helpful
- provides 2 functions
  - `_registerFunctionInterface(bytes4)` - register interface function
  - `supportsInteface(bytes4 interfaceId)` -> bool, if contract supports interface

**Math**

- supports basic math operations missing in solidity
- `max(a,b)`, `min(a,b)`, `average(a,b)` - > average rounded to 0

**SafeMath**

- discussed earlier for supporting overflow/underflow (not needed after 0.8.0)
- supports `add, sub, mul, div, mod` functions
- `using SafeMath for uint256` -> typical usage

**SignedSafeMath**

- Same safemath functionality but for signed integers
- `mod` operation for signed integer missing - does not make sense to have

**SafeCast**

- Recall that solidity allows for implicit casting of types and explicit casting
- Explicit is where dev can force cast one type to another
- Incase devs want to downcast -> `SafeCast` library allows downcasting in a safe manner
- Downcasting is when target type (one we want to cast into) has fewer bytes for storage than source type

**EnumerableMap**

- Recall that Mapping types cannot be enumerated for all keys and values they contain -> ie. you cannot get a list of key-value pairs in mapping by enumerating a list
- Enumerable Maps have following properties
  - Entries are added, removed, checked for existence in constant time (order of 1 O(1))
  - Entries are enumerated in O(n) - no guarantees on ordering
- EnumerableMaps allow us to enumerate a mapping
- Supported mapping type is `uint256 -> address`

**Enumerable Set**

- allows devs to use enumerated sets (??)
- added/removed - O(1)
- enumerated - O(n)
- only set types supported - bytes/address/uint256

**BitMaps**

- BitMaps library maps a uint256-> bool
- 256 different boolean values within the single uint256 type
- `get` -> boolean value for a bitmap index
- `setTo` -> sets boolean value at a given bitmap index
- `unset` -> sets bitmap value at index to 0

Why are bitmaps uses??? -> check
