# SOLIDITY 205

[Video](https://www.youtube.com/watch?v=0kx8M4u5980)

## Summary

More OZ contracts

### More OZ Contracts

**PaymentSplitter**

- Split ether payments over a group of acconts
- Sender who sends ETH to this contract need not know about this splitting - so its sender agnostic
- Splitting can be equal or abitary manner
- Done by assigning a # of shares for each account
- And that account can proportionally claim ether balance based on shares
- Follows Pull Payment model instead of push - so beneficiary needs to claim funds rather than this contract pushing payments

**TimeLockController**

- Time lock controller allows contract to set time delayed operations
- Operations that have to be executed after a time window
- Enforces timelock - onlyOwner operations
- governance implementation after voting is a good example
- Operations include - schedule / delay / execute / cancel / batch
- we can query if operation is pending/done/ready/updateDelay (change time when operation gets executed)

**ERC2771 Context**

- Variant of `context` library
- There is a growing interest in making it possible for Ethereum contracts to accept calls from externally owned accounts that do not have ETH to pay for gas.
- Solutions that allow for third parties to pay for gas costs are called meta transactions.
- meta transactions for ERC 2771 context are transactions that have been authorized by a Transaction Signer and relayed by an untrusted third party that pays for the gas (the Gas Relay)
- How does it work

  - Tx sender signas a transaction and sends to a gas relay contract
  - gas relay contract verifies signature offchain & pays gas to the txn and sends to trust forwarder
  - trust forwarder verifies txn and signature and forwards txn to the recepient - client address is appended to the end of call data -> which is sent to the recepient address
  - `_msgSender()` checks msg.sender and extracts client address
  - `isTrustedForwarder(address forwarder)` checks is forwarder is trusted
  - If the msg.sender is not a trusted forwarder (or if the msg.data is shorter than 20 bytes), then return the original msg.sender as it is.

- Recepient contract only accepts txns from Trust Forwarder -> whose responsible for verifying signature from a gas relay contract

**Minimal Forwarder**

- Basic implementation of trust forwarder
- checks nonce & signature checks before forwarding to recepient address
- `verify(req,signature)` - verifies, `execute(req,signature)` -> executes

**Proxy**

- At a high level, there are 2 contracts - proxy contract and implementation contract
- Proxy contract implements a `delegateCall` on the implementation contract
- Proxy call receives calls from user and further calls the implementation contract
- **Proxy contract holds contract state, implementation contract holds contract logic**
- Calling a delegate call implements logic on implementation contract with the state of proxy contract
- Has to be done carefully - can lead to a variety of security issues
- Provides a `_fallback()` function that forwards call to an `_implementation()`
- Provides a `_delegate(address implementation)` function that specifies the implementation contract
- `_beforeFallback()` that provides a hook that gets called before `fallback` forward to implementation
- `implementation()` gets implementation address
- `fallback()` or `receive()` delegates call to implementation address -> if `call data` is empty, `receive` gets executed

**ERC1967 Upgradeable Proxy**

- Implements upgreadable proxies
- its upgradeable because implmentation contract can be changed/updated
- Address of implementation contract is stored in storage of porxy contract -> specific storage location is specified by EIP -> so that it does not conflict with layout of implementation contract that sits behind the proxy
  -address of logic can be specified as part of constructor `constructor(address _logic, bytes _data)`
- address of new implementation can be provided by `_upgradeTo(address newImplementation)`
- upgradable proxy is implemented very commonly - from security perspective, check if there is a storage conflict

**Transparent Upgradeable Proxy**

- Upgradeable only by admin to prevent any attacks from Selector Clash
- Selector clash if when a function selector clashes between proxy and implementation contract
- This contract avoids selector clashes by implementing followin
  - all non-admin function calls gets implemented within implementation contract (even if there is a clash)
  - all admin function calls get implemented in the proxy contract -> no admin call gets forwrded to implementation -> allows for a clean separation of admin and non-admin roles
  - `admin` can upgrade implementation contract or address

**ProxyAdmin**

- Proxy Admin library is used to specify admin for upgradeableproxy contract
- `getProxyAdmin` `getProxyImplementation` gives admin and implementation address
- `changeProxyAdmin` changes admin of proxy contract
- `upgrade(proxy, implementation)` upgrades implementation
- `upgradeAndCall()` upgrades implementation and makes a call to that implementation

**BeaconProxy**

- Implements a proxy where implementation address is obtained from another contract `UpgradeableBeacon`
  - Address of a beacon contract is stored in proxy storage at a slot -> `uint256(keccak256('eip1967.proxy.beacon'))-1` so that it doesn’t conflict with the storage layout of the implementation behind the proxy.
  - constructor is used to initialize proxy with beacon contract
  - `_beacon()` gets beacon contract address
  - `implementation()` Returns the current implementation address of the associated beacon.

**UpgradeableBeacon**

- This contract is used in conjunction with one or more instances of BeaconProxy to determine implementation address which is where all function calls are delegated
- An owner is able to change the implementation the beacon points to -> thus upgrading proxies that use this beacon
- `upgradeTo(newImplementation)` -> upgrades beacon to new implementation
- `implementation()` - returns current implementation address
- Owner is one who deployed this contrct
- So you can have a bunch of beacons - each beacon can keep flipping multiple implementation contracts (wonderful design)

**Clones**

- Implements minmimal proxy contracts as specified by EIP 1167
- all implementation contracts are clones ofo a specific byte code
- Calls are delegated to a known fixed address
- Deployment of implemntation contracts can be done by Create/Create2
- `clone(implementation)` -clones implementation and returns instance of clone
- `cloneDeterministic(implementation,salt)` -> clones implementation using `create2` and returns instance of cline

**Initializable**

- Initializable is used for contracts to interact with proxy contracts
- As we know -> proxy has state and implementation has logic and proxy forwards non-admin calls to implementation
- If there are some initializations that are needed for implementation contract -> such initializations should NOT be done in constructor of inmplementation -> because they would modify the state of proxy contract
- to get around this problem of initializations, we use initializable
- All initialization should be moved to a new contract -> this initialization is expected to be called by `proxy` contracts
- This concept of not using constructor for initialization is not only applicable for implementation contracts but to all base contracts that it derives from
- This initialization should happen only ONCe and immediately after implementation contract is deployed using factory contract
- `initializable` library hs `initializer` modifier that allows initialization only once -> should be immediate after deployment
- **This aspect of initialization only ONCE and immediately after implementation contracts are deployed is very critical from security perspective- there have been multiple vulnerabilities reported because this is not followed**

**Dappsys DSProxy**

- Dappsys team at DappHub - these libraries are an alternative to open zeppelin
- Implements DSProxy -> again, a proxy and implementation contract
- User can send contract `byteCode` and `callData` -> proxy contract can create contract using `byteCode` and immediately call a function using `callData`
- Associated librariers `DSFactory` and `DSCache` that help increation of proxy contract

**Dappsys DSMath**

- Again alternative to OZ
- Equivalent of SafeMath
- overflow/underflow checks
- operations (add sub mul min max)
- fixed point math - wad type -18 decimals, ray type - 27 decimals

**Dappsys DSAuth**

- Authorization pattern completely separate from application logic
- auth modifier - isAuthorized() -> checks if `msg.sender == owner` or `msg.sender == contract` itself
- checks if msg.sender has authority

**Dappsys Guard**

- DS Gaurd implements an access control list (ACL)
- It is a `mapping (bytes32 => mapping (bytes32 => mapping (bytes32 => bool))) acl`
- `canCall` function returns a `bool` of whether a calling address has access to a specific address in destination address
- `function canCall(address src, address dst, bytes4 sig)` -> source, destination and function signature
- `[src][dest][sig] => bool`
- When used as DSAuth -> `src` refers to msg.sender, `dst` refers to contract and `sig` refers to function

**Dappsys Roles**

- Role based access control (RBAC)
- `canCall()` -> boolean
- user -> function @ Address
- Root users -> can access all functions at an address
- Public capabilities - roles applicable to all users
- Role capabilities - role specific capabilities

---

### Token Contracts

**WETH**

- Wrapped Ether
- Ether is not ERC-20 standard
- For devs to deal with 2 logic flows - one for ether and other for ERC20 would be inconvenient - instead, what is generally done is `WETH` wrapper is created around Ether that is a ERC20 token
- Wrapping converts Ether -> ERC-20 equivalent (Wrapped Ether)
- `WETH9` contract -> 1:1 wrapper with ETH-WETH peg
- `WETH10` contract -> gas efficienct & supports flash loans as per EIP-3156 standard

**Uniswap V2**

- AMM - x\*y = k (Constant Product Market Maker)
- Uni allows Liquidity Providers to create pools & token pairs
- Whenever LPs provide token pairs, new tokens called LP tokens are minted
- LP tokens reprsent the share of a given user in pool
- Uni also provides support for on-chain oracles
- Price oracles are used to give price of a given token against another on chain
- In Uni V2, every token pair measures price at beginning of each block - so TWAP is time weighted price since previous block

**Uniswap V3**

- concentrated liquidity -> LPs can provide liquidity across specific price range
- introduces capital efficiency
- flexible fees (V2 had constant 0.3% fees)
- Advance TWAP support (cumulative sum trapped in one value -> is now stored in an array)
- Allows users to query TWAP at any instant over last 9 days

ChainLink

- most widely used price oracles
- price data is taken from multiple offchain providers and put onchain by Chainlink network
- AggregatorV3Interface - provdies prices for different assets
