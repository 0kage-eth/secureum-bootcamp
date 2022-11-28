# SOLIDITY 104

[Video](https://www.youtube.com/watch?v=WgU7KKKomMk)

## Summary

Discuss data types arrays, mappings and struct, error handling and global variables

### Complex Data Types

**Arrays**

- Gas costs

  - `push` - constant gas
  - `pop` - depends on array size

- Array slices
  - can extract useful portion of a given array
  - `x[start:end]` gives an array slice that starts at `start` and goes to `end-1`
  - ofcourse `start < end` && `end < length`
  - **Solidity Only supports array slices for `calldata` arrays**

**Struct**

- User defined types
- Aggregate types - can have variables of multiple types
- Can be used inside `mappings` and `arrays`
- Can combine value and reference type variables
- **One exception - struct types CANNOT contain members of same struct type**

**Mapping types**

- Mapping types refer to `key-value` pairs
- `mapping(_key type => _value type)` maps a key of \_key type to value of \_value type
- key type can be any value type or even string/bytes. Cannot use `mapping` type as key
- value type can be of any type -> arrays, structs, mappings etc
- key data is NOT stored in a mapping -> only used to lookup value by taking a `keccak256` hash of key
- mappings don't have concept of `length` and no concept of key or value being `set` in mapping
- they can only have storage data location - ONLY allowed for state variables
- Cannot be used as parameters or return values of public/external contract functions
- Above is also true for structs containing a mapping
- **Cannot iterate over a mapping**

**delete**

- removes underlying storage
- on `delete a` -> initial value of that type is assigned to `a`
- frees up storage
- if applied on integer, value of that deleted variable = 0
- for dynamic arrays, length becomes 0 on deletion
- for static arrays, length is same but all elements set to initial value
- `delete a[x]` where a is an array, deletes the item on the x'th position of array a
- delete structs -> all elements except mappings, get set to initial values
- `delete` has NO effect on mappings -> for mapping, need to specify specific key to delete key value pair
- **If struct with a mapping -> resets all members except for mappings. Mappings need to be explicitly deleted by calling each key value pair**

  **implicit conversions**

- Automatically done by compiler
- Mo information lost
- uint8 -> uint16, int128->int256 etc
- Conversions that have problem -> signed integers converting to unsigned integers (compile throws out an error when such incompatible conversions are implicit)

**Explicity conversions**

- developer applied
- when we explicitly convert from higher order -> lower order, leads to cutoff of higher order bits in uint and lower order bits in byte type (dangerous)
- when we explicitly convert from lower order -> higher order, higher order gets padded if its integer type, lower order gets padded for bytes type

Eg. with uint

```
    uint32 y;
    uint16 x;

    // Case 1 - lower to higher
    uint32 p = uint32(x); // in this case, we are explicityly converting
    //16 bytes to 32 bytes

    // higher order bytes are padded to the left

    // Case 2 - higher to lower
    uint16 q = uint16(y) // in this case, we are explicitly converting
    // 32 bytes to 16 bytes

    // HIGHER ORDER GETS TRUNCATED -> *** extremely dangerours **
```

Eg. with bytes

```
    // case 1 - bytes16 to bytes32
    byte16 b16
    bytes b32
    bytes32 b32cast = bytes32(b16) // no problem -> pads 16 bytes to the right - LOWER ORDER gets padded
    bytes16 b116cast = bytes16(b32) // problem - truncates 16 bytes to the right -> LOWER ORDER GETS TRUNCATED
```

**Conversion Literals**

- Decimals/Hex can be implicitly converted to integer type if type is large enough to represent it without getting truncated
- Decimals cannot be converted to fixed size byte arrays
- **hexadecimals can be converted to byte arrays IF number of hex digits matches byte array EXACTLY**
- String literals and HEX string literals can be explicitly converted into fixed size byte arrays only if #of characters match exactly

**Ether units**

| Ether units | Value |
| ----------- | :---: |
| 1 wei       |   1   |
| 1 gwei      |  1e9  |
| 1 ether     | 1e18  |

**Time units**
| Time| Value |
| -------- | :------: |
| 1 seconds | 1 |
| 1 minutes | 60 |
| 1 hours | 3600 |
| 1 days | 24*3600 |
| 1 weeks | 24*3600\*7 |

- Above suffixes cannot be directly applied - but need to be applied with a multiplcation

```
    //For eg. 5 days
    uint256 time = 5 * 1 days;

    // 18 hours
    uint256 hours = 18 * 1 hour;
```

**Block & Txn Properties**

- Block properties accessible inside code

  - _Block Hash_ - hash of specified block
  - _ChainID_ - current ID of chain that EVM is executing on
  - _Number_ - block number
  - _Timestamp_ - block timestamp, # of seconds since UNIX epoch
  - _Coinbase_ - address of beneficiary (block rewards)
  - _Difficulty_ - related to proof of work
  - _GasLimit_ - `block.gaslimit` gas limit related to block
  - _value_ - `msg.value` - amount of eth sent as part of msg
  - _sender_ - `msg.sender` - address of sender of msg
  - _data_ - `msg.data` - calldata sent to this txn
  - _sig_ - `msg.sig` - function identifier or the first 4 bytes of call data representing function selector

  - _Gasprice_ - `tx.gasPrice` - gas price used in this transaction
  - _Gasleft_ - `tx.gasLeft` - gas left at the time of call
  - _Origin_ - `tx.origin` - original EOA that triggered the txn

  **Msg Sender & Value**

  - _value_ - `msg.value` - amount of value in wei sent to the txn
  - _sender_ - `msg.sender` - sender that initated this msg -could be EOA or contract
  - Every external call made changes the sender
  - Every external call can have a separate msg.value
  - A calls B, B calls C -> in context of B, msg.sender is A, in context of C, msg.sender is B
  - From security stanpoint, this is important - msg.sender/value might be incorrectly assumed by developers

**Randomness source**

- `block.timestamp` and `block.hash` are NOT good sources of randomness
- Miners can influence miners mining both the above parameters
- Only aspect of timestamp that is invariant is -> Timestamp(block) > Timestamp(block-1)
- timestamp of block will be anywhere between 2 canonical blocks in a blockchain (this again is guaranteed)
- **Do not reply on block.timestamp for randomness**

**blockhash**

- solidity allows us to get blockhash given a block number
- only gets the last 256 block hashes excluding current block are retrievable - anything beyond is 0
- **ABI encoding/decoding**

- `abi.encode()` and `abi.decode()` take arguments and encode/decode them
- `abi.encodeWithSelector()` encodes with function selector
- `abi.encodeWithSignature()` encodes with function signature
- `abi.encodePacked()` takes arguments and performs encoding in a packed fashion, ie removes all pading - for this reason, packed encoding can be ambiguous -> we might not be able to decode into individual elements if we run encodePacked

**error handling**

- critical aspect of security
- errors during program execution can result in vulnerabilities -> handling them properly is very important for good contracts

**Assert**

- first way of handling errors is using `assert` primitive

```
    // exits in a panic/revert
    assert(x > 0);
```

- Panic error reverts all state changes
- `Assert` is meant to be used for internal errors

**require**

- `require` is used to trigger errors in external components or any inputs
- can pass a optional, custom error message when error is triggered
- reverts all changes and exits if require fails

```
    require(owner == msg.sender, "owner not sender");
```

**revert**

- revert unconditionally aborts the execution and reverts with custom error
- revert can take optional string when it happens

```
    revert([string message]) // string message is optional
```

- `assert` is for internal errors - conditions that are meant to be true as programing invariants (for eg. division by 0, overflow/underflow)
- `require` is more for logic errors, input errors (external errors)

**Math & Crypto functions**

- Solidity supports `addmod()` and `mulmod()` functions
- supports keccak256 hashing `keccak256(bytes memory)`
- supports sha256 algorithm `sha256(bytes memory)`
- supports older hashing `ripemd160(bytes memory)`
- supports ecrecover, elliptic curve recover function -> taks `hash` of a message along with `(v,r,s)` signature components. Function `ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)` and recovers the address associated with public key -> used in smart contracts to verify signature (public address generates can be checked with msg.sender)

**ECRecover Malleability**

- Valid signature can be converted to a second valid signature without knowledge of private key - this is a key vulnerability that can be exploited by hackers to do a replay attack
- How signatures are used inside contract needs to be carefully examined -> to prevent scope of replay attacks
- Reason behind this malleability is how ECRE works -> `Sig -> (v, r, s)`, `s` value can be in lower order range or higher order range -> ie 2 values of `s` give same signature
- If contract needs unique signatures, current best practice is to use OpenZeppelin ECDSA wrapper (study more about this...) -> library forces `s` value to be in lower range -> so a single unique signature is enforced
