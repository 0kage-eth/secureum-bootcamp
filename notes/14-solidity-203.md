# SOLIDITY 202

[Video](https://www.youtube.com/watch?v=C0zBhTgppLQ)

## Summary

Discuss ERC721 and Access Control

### Checks

**Zero Address Check**

- `require(address(msg.sender) != address(0))`, zero address
- zero address is where all 20bytes are 0s
- Private key for zero address is unknown - solidity gives a special treatment to zero address
- If ether or token is transferred to zero address, it is equivalent to burning
- setting access control rules with zero address will not work - because private key of zero address is unknown
- Zero address should be treated with extra care from security perspective - zero address checks should be actively checked for address parameters -> specifically for those that are user supplied

**tx.origin**

- second category of checks relate to transaction origin
- recall that ethereum has 2 type of accounts - EOA and contract
- transactions (msgs originated offchain) can ONLY be originated from EOA accounts
- So `tx.origin` should always refer to EOA accounts that originated a txn
- Checking if `msg.sender == tx.origin` is an effective way to check if sender is a contract OR a EOA (this has some nuances -> but when you encounter this in smart contracts, look at it carefully from security perspective)

**arithmetic checks**

- overflows or underflows
- if value exceeds max of that data type, then there is automatic wrapping -> if `value > max(type)`, overflow wraps to the left -> value goes to the minimum of that type. if `value < min(type)` undeflow wraps to the right -> values goes to maximum of that type

- Changes in balances due to overflows or underflows have resulted in critical vulnerabilities
- For solc < 0.8.0, developers used `SafeMath` -> after 0.8.0, implemented by default for integer types
- can be overriden by developer by using `unchecked` block

###Open Zeppelin libraries

- OZ is leader in space - not only in building libraries but in smart contract security as well
- Over 40 libraries

**ERC20 token standard**

| Name              |                           Signature                           |                                                                                                       Description |
| ----------------- | :-----------------------------------------------------------: | ----------------------------------------------------------------------------------------------------------------: |
| name              |                           `name()`                            |                                                                                                     Name of ERC20 |
| symbol            |                          `symbol()`                           |                                                                                                   Symbol of ERC20 |
| decimals          |                         `decimals()`                          |                                                                                           Decimals of ERC20 token |
| totalSupply       |                        `totalSupply()`                        |                                                                                     Max supply (virtual function) |
| balanceOf         |                     `balanceOf(address)`                      |                                                                             Gives balance of a particular address |
| transfer          |            `transfer(address to, uint256 amount)`             |                                                              Transfers tokens from current address to beneficiary |
| allowance         |          `allowance(address owner, address spender)`          |                                                  Gets the amount of tokens approved by owner for spender to spend |
| approve           |          `approve(address spender, uint256 amount)`           |                                                                Approve spender to spend specific number of tokens |
| approve           |   `transferFrom(address from, address to, uint256 amount)`    | Transfers tokens from from address and puts them in to address (assume `from` has given caller approval to spend) |
| increaseAllowance |   `increaseAllowance(address spender, uint256 addedValue)`    |                                                            Increases existing approval to spender by `addedValue` |
| decreaseAllowance | `decreaseAllowance(address spender, uint256 subtractedValue)` |                                                       Decreases existing approval to spender by `subtractedValue` |

- Various extensions, presets and utilities to these standards

_SafeERC20_

- Once such utility is `SafeERC20` implementation - `transfer`, `transferFrom`, `approve`, `increaseAllowance` and `decreaseAllowance` functions expected to return `bool` value in a simple `ERC20` -> this has resulted in vulnerabilities
- `SafeERC20` implementation reverts on failures of above functions -> implements wrappers for above functions

_TokenTimelock_

- `TokenTimelock` is another utility -> implements a token holder contract where a certain address is marked as token beneficiary address -> and tokens are only released to `token beneficiary` after a specific time has elapsed

- Application for this is token vesting for founders/investors etc -only after some time will tokens be sent to beneficiary

- a `release()` function -> that sends tokens to beneficiary, if `block.timestamp > releaseTime`

**ERC721 token standard**
[ERC 721 contract source code](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol)

- Non fungible token standard (NFT standard)
- Every token is distinguishable from the other unlike ERC20
- Every token has a tokenId
- `SafeTransferFrom` transfers nft token ids from one address to other -reverts on error. Does multiple checks to ensure that it is a safe transfer
- Just like ERC20 has notion of spender, ERC721 has concept of Operator
- `Approval` - checks if owner is giving approval, only one address will have approval at a time, and after transfer, any approver designated by transferor will be automatically removed. **Approving a zero address, removes all previous approvals**

- Various extensions/presets/utils for ERC721

**ERC777 token standard**
[ERC777 token contract source code](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC777/ERC777.sol)

- Similar to ERC20 standaard, in the sense that it applies to a fungible token
- Key features of ERC777 - Hooks -> functions that are called automatically when tokens are sent and tokens are received
- Allows contract to control which tokens are being sent and which are received
- Allows users to approve and transferFrom in one shot - better experience for users (otherwise, it happens in 2 legs)
- Also prevents tokens from being stuck in contract using hooks feature - how??
- sets decimals to 18, operators are special accounts that can transfer tokens on behalf of others
- Implements `send()` function - if a address is not aware of ERC 777 contract, then function prevents tokens sent to this contract
- **ERC1155 token standard**
  [ERC1155 contract source code](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol)
- Single contract can implement multiple tokens - some can be fungibles like ERC20 and non fungibles ERC721
- Single contract makes it user friendly and gas efficient
- provides 2 functions `balanceOfBatch()` and `safeBatchTransferFrom()` that allow querying of balance of multiple tokens in the same transaction

**Ownable**
[Ownable contract source code](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol)

- basic access control -> contract can have an owner
- default owner is address that deployed contract
- allows contracts to implement access control where only special addresses can execute some functions
- made possible by `onlyOwner()` modifier
- possible to transfer ownership using `transferOwnership()` function

**Access Control**
[Access control contract source code](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol)

- #role based access control - more generic version of Ownable Contract
-
