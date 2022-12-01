# SECURITY PITFALLS 302

[Video](https://www.youtube.com/watch?v=fgXuHaZDenU)

## Summary

List of all security vulnerabilities continued..

### V19 - Transaction order dependence (TOD)

_Background_

- Recall that pending txns are sent to mempool from which miners/validators pick txns
- Gas price decides which txns are picked and order of those txns in the mempool
- Order in which txns are stacked in a proposed block matters
- Leads to phenomena of front-running or back-running
- front-running is when my txn is placed before another txn that I want to exploit
- back-running is when my txn is placed after another txn that I want to exploit
- by submitting txns with appropriate gas fee, we can either front or backrun & lead to what is known as sandwich attacks

_Risks_

- Assumptions made on specific txn ordering by miners can create risks
- When we assume A gets executed after B, we incorporate logic that might not be valid if order is flipped

_Mitigation_

- If there is a logic that is sensitive to order of execution, then remove that sensitivity from logic or handle appropriately
- Don't make any implicit assumptions on transaction order - because this could be used to exploit the txns when an exploiter cleverly manipulates the gas fee

---

### V20 - Front running of ERC20 approve()

_Background_

- ERC20 approve allows `owner` to approve `spender` to spend a specific amount of tokens
- `spender` has freedom to transfer or spend tokens in anyway once approval is given
- frontrunning of this transaction can lead to exploits
- let's see how -> say O(owner) approves S(spender) 100E (ERC20) tokens
- Now O wants to reduce approval limit to 50 and sends a txn
- Say S is malicious & monitoring the mempool for any txns from O
- S sees the pending approval change initiated by O and sends a `transfer` of 100 tokens with a higher gas price
- Miner orders O txn before S txn allowing O to frontrun S and spend the 100 txns
- Once O approval txn got executed, S can again frontrun O and spend an additional 50 txns
- So instead of allowing S to spend 50 tokens, O has allowed S to now use 150 tokens

_Risk_

- By assuming an implicit order of txns, I have exposed myself to exploit using `approve`
- front running by others has created a material loss to me

_Mitigation_

- One option is to reduce approval to 0 and set desired value afterwards
- Other option is to use _increaseAllowance()_ and _decreaseAllowance()_ instead of using `approve`
- In previous attack scenario, _decreaseAllowance()_ will revert because allowance to spender will be < subtractedValue (since exploiter has used up all earlier tokens)
- Although this still doesn't prevent 100 tokens to be used by attacker, it prevents the additional 50 tokens to be lost by the owner

---

### V21 - ecrecover

_Background_

- ecrecover is used to verify if signed messaged hash is actually sent by an owner
- takes in a message hash & signature in the form of `(v,r,s)` -> byte1/byte32/byte32 variables
- note that we mentioned signature malleability -> lower order s & higher order s gives the same address

_Risk_

- elliptic cover signature has 3 components `v,r,s`
- ecrecover -> 2 combinations of `(v,r,s)` lead to the same decoded address- called signature malleability
- If an attacker has access to (v,r,s) => they can create another combination without knowing private key
- This leads to Replay Attacks

_Mitigation_

- To check if `s` component is in lower range and not in higher range and `v` = 27 or 28
- Use OZ ECDSA to make this check
- use `tryRecover(bytes32 hash, bytes signature)` function of OZ ECDSA - that makes necessary checks to prevent higher order `s`

---

### V22 - ERC20 transfer

_Background_

- ERC20 specification says that `transfer()` function returns a boolean value
- Token contract might not adhere to above standard & might not return a boolean value
- This was ok until 0.4.22 version but recent compilers will revert in such scenarios

_Risk_

- Custom ERC20 implementation that does not adhere to ERC20 standards for `transfer()` function

_Mitigation_

- Always recommended to use OZ `SafeERC20` that reverts if transfer does not go through
- use `using SafeERC20 for IERC20` for wrapping ERC20 inteface with SafeERC20 wrapper

---

### V23 - OwnerOf()

_Background_

- `ownerOf(tokenId)` function of ERC721 standard should return the address of owner
- However contracts that did not adhere to this standard and were returning boolean value
- this was ok until solc version 0.4.22 but now they explicitly revert

_Risk_

- Custom ERC721 implementation does not adhere to ERC721 standards for `ownerOf` implementation

_Mitigation_

- Use OZ ERC721 contract

---

### V24 - Contract balance

_Background_

- Smart contract constructors can be created to begin with specific ether balance
- `payable` functions inside a contract can receive ether
- These are 2 ways in which contract balance can change & a developer can track balance changes
- However these are not the only 2 ways in which contract balances can change
  - `Coinbase Tx` - these are beneficiary addresses specified in blockheaders that receive block rewards. This coinbase address can point to a smart contract address & hence can directly get ether as block rewards if that block is included on chain
  - `selfDestruct` - when a txn gets self destructed, target address can get ether from that contract. A contract address given as target address can get the ether- and this receipt of ether DOES NOT trigger `receive` fallback

_Risk_

- Explicit logic that tracks balances with actual ether in contract & locks certain key functions if there is a mismatch can be locked forever by sending ether directly without triggering any fallbacks
- While dev thinks he has accounted for all entry points from which ether can come in, there are still ways in which ether can be sent to the contract
- Strict modifier checks that check for balance match will fail & hence certain critical functionaly can get locked for users

_Mitigation_

- All assumptions and checks related to balance of account need to be carefully analyzed to check if some exploits can happen

---

### V25 - Fallback vs receive

_Background_

- `fallback` and `receive` are fallbacks that are triggered whenever
  - ether is transfereed into this contract
  - low level `call` is made
- there are similarities and differences between these 2 functions
- When only ether transfer happens and `calldata` is empty - `receive` is triggered
- When no ether transfer happens - `fallback` is triggered
- When ether transfer happens with `calldata` - fallback is triggered

_Risk_

- fallback logic is defined in `fallback` function but actually `receive` function gets triggered or vice versa

_Mitigation_

- both fallback triggers and the logic implemented in them needs to be carefully examined
- which logic gets triggered when & its implications needs to be analyzed

---

### V26 - Strict equalities

_Background_

- Strict equalities refer to `==` or `!=` operators
- Considered dangerous from a security perspective compared to less strict comparisons (`<=` or `>=`)

_Risk_

- Strict equalities on ether or token balances can fail because of precision or decimal mismatches
- This can lead to critical logic loopholes

_Mitigation_

- Shift to less strict equalities where possible
- And make sure precisions and token decimals are taken into account when using strict equalities

---

### V27 - Locked Ether

_Background_

- Locked Ether refers to condition where ether can be sent to a contract but there is no way in which ether can be withdrawn from address
- Account can receive ether via `payable` functions
- But a way to withdraw ether from contract is missing, ie no `withdraw()` function exists

_Risks_

- Contracts with `payable` functions but with no `withdraw` functions are one way streets that lead to locked ether

_Mitigation_

- Remove `payable` functions so that users don't accidentally deposit eth into the functions (if not needed)
- Add `withdraw` functions so that users have a way of taking ETH out of contract (if protocol intends to have withdrawals)
- Simple usecases are easily fixed but complex usecases where some logic or externalities can change state to a particular value where ether gets locked are much more difficult to catch - be on a lookout for conditions that lock withdrawals

---

### V27 - Txn origin

_Background_

- `tx.origin` gives the original sender who initiated the transaction
- in many cases when we are looking at composable txns, `msg.sender` could be a contract caller but `tx.origin` refers to the EOA that triggered the chain of transactions, including the calling contract (msg.sender)

_Risk_

- If this tx.origin is used for authorization -> can be abused by attackers launching replay attacks by coming in between user and smart contract
- This is sometimes called Man in the Middle Attack (MITM attack)
- MITM attack happens when authorization is based on `tx.origin` instead of `msg.sender`
- A malicious contract can be called by original user (`tx.origin`) which inturn can trigger the actual contract
- Refer to [medium article](https://medium.com/coinmonks/solidity-tx-origin-attacks-58211ad95514) for an analysis of this type of attack

_Mitigation_

- Always use `msg.sender` over `tx.origin` -> if `tx.origin` is used, ask yourself, why is this necessary and think if this opens up a MITM attack

---

### V28 - Contract vs EOA

_Background_

- A txn can be sent from a contract account or an external owned account
- Two checks for this
  - first is code size -> code size for external owned account == 0
  - second is msg.sender == tx.origin
- Both have pros & cons

_Risk_

- code.size == 0 -> a contract account within a constructor also satisfies this condition -> because when constructor is being initialized, byteCode is not yet assigned to that account

_Mitigation_

- Analyze the risks in making the check and security implications of verifying EOA vs contract account

---

### V29 - Delete Mapping

_Background_

- If there is a `struct` inside a contract that contains a mapping -> `delete` on struct does NOT delete the mapping
- deleting `mapping` is O(n) task where all keys need to be individually deleted because solidity does not know the keys

_Risk_

- deleting `struct` that contains a mapping element does not eliminate `mapping` -> so any logic on mapping data will continue to yield unexpected results
- unintended consequences if dev assumed `mapping` also got deleted

_Mitigation_

- Use alternatives - consider using `lock` instead of `delete` - lock the data structure to prevent anyone from using mapping from that data structure
- Or make sure you keep all keys of mapping in an array and delete the mapping by running a loop

---

### V30 - Tautology and contradiction

_Background_

- Tautology is something that is always true
- Contradiction is something that is always false
- `uint x` and `x >= 0` => is a tautology => always greater than 0

_Risk_

- Presence of tautology or contradiction indicates flawed logic or mistaken assumptions by developer
- Or these could be redundant checks

_Mitigation_

- Whether it is tautology or contradiction or redundant checks -> presence of them indicates a possibility that dev has erred in his interpretation of logic
- Need to be flagged

---

### V31 - Boolean constants & boolean equality

_Background_

- Boolean constants are constants TRUE (1) or FALSE (0)
- Use in conditions `if(x == true)` => x already evaluates to a `true` or `false` => this check is redundant
- Instead, use directly if(x)

_Risk_

- This is not a risk in itself but an indicator of potential vulnerabilities in rest of code base
- Seeing boolean conditions is a flag that dev is not focused on optimization and might not have a strong grasp of solidity

_Mitigation_

- No specific mitigation here - just that additional care needs to be taken to review rest of codebase

---

### V32 - State modification in pure/view

_Background_

- `Pure` and `view` functions cannot write to state
- Any state changes inside these functions leads to a revert from solc >= 0.5.0
- From this version, compiler started using `STATICCALL` opcode -> = reverts on any state change

_Risk_

- No specific risk out here -> just contract reverts when state changes happen in `pure` and `view`

_Mitigation_

- Check function mutability and make sure state changes are not happening in `view` and `pure` functions

---

### V33 - Return values

_Background_

- Low level functions such as `send/call/delegateCall` do not revert -instead they give a boolean value
- If a txn couldn't go through, developer would not know unless the function return values are explicitly handled

_Risk_

- If return values of low level calls are properly not handled, there could be security risks because these calls don't revert the transaction

_Mitigation_

- Check return values and handle `success` and `failure` cases explicitly

---

### V34 - Account Existence check via low level calls

_Background_

- low level calls `call/delegateCall/staticCall` -> these functions return `true` even IF account does not exist at the address
- `true` is mileading in this case and could lead to risks

_Risk_

- A return of `true` when low level function interacts with an account at an address that does not exist could make dev think

  - account and call function exists
  - function executed successfully

- Interpreting either of the above could impact the follow-on logic that can be exploited

_Mitigation_

- Check existence of contract BEFORE making low level calls -> don't use the return value of low level call as a proof that the contract exists or that function call was successful

---

### V34 - Shadowing built in variables

_Background_

- Shadowing of built-in solidity variables - `now`, `assert` was allowed in previous versions
- Built-in variables could be shadowed by other variables/functions or modifiers and could be overwritten

Risk

- Shadowing could lead to dangerous overides

Mitigation

- Shadowing is disallowed in later versions of complier

### V35 - Shadowing state variables

_Background_

- Derived contracts could have same variables as base contract state variables
- This again leads to confusion & unexpected behavior
- End up using wrong variables or cause a mixup
- Solidity henceforth does not allow for shadowing of variables in base contracts
