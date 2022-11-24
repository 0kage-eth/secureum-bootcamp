# ETHEREUM 104

## Summary

In this session, we dive into EVM architecture, various opcodes and their gas computations

[Video](https://www.youtube.com/watch?v=MFoxW07ICKs)

### Memory

- Data in memory is volatile, ie not persistent outside of functions where it is called
- Linear → byte array. Addressable at byte level
- It is Zero initialized
- 3 instructions that operate on memory → MSTORE (stores 32 bytes)/ MLOAD (loads 32 bytes)/ MSTORE8 (stores 1 byte)

![EVM Memory](../images/EVM-Memory.png)

### Storage

- Storage is non-volative, ie persistent
- Storage is a key-value, key is name, value is storage value. Its a 256 bit -> 256 bit mapping
- Zero initialized
- Storage of each account is captured in storage root which is implemented as a Merkle Patricia tree.
- State root is a hash of storage root along with other fields, balance, nonce and codeHash. And state root has its own implementation of merkle patricia tree -> its a root hash of all storage roots across all ethereum accounts
- There are 2 instructions - SLOAD - loads a word from storage to stack /SSTORE - stores a word from stack and puts it into storage

### Call data

- Special place where data parameters for transactions & msg calls can be stored
- Read only
- Byte addressable
- EVM has 3 instructions that operate with calldata
  - `CALLDATASIZE` gives size of supplied call data
  - `CALLDATALOAD` - Loads call data supplied to stack
  - `CALLDATACOPY` - Copies call data to specific region in memory

### EVM Architecture

- Computer architecture is classified either as Von Neumann vs Harvard architecture
- This is decided by how code and data is handled within architecture
- Are they stored together or are they transported in buses together or separately. Are they cached etc (memory and pathways)
- Incase of EVM, EVM code is stored separately in virtual ROM & special instructions to access EVM code

**EVM Ordering**

-
