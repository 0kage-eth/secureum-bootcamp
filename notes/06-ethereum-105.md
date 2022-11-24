# ETHEREUM 105

## Summary

In this session, we dive into Application Binary Interface (ABIs), Block Explorers

### Application Binary Interface

- ABIs are standard interfaces to interact with contracts
- Required for transactions triggered off-chain or for msg calls
- Interface functions are strongly typed - and known prior to compilation (static)
- Function signatures cannot change post compilation

**Function Selector**

- Specifies the exact function within destination contract code
- We do a `Keccak256(<fn signature>)` and take first 4 bytes

```
    function selector = bytes4(keccak256(<fn signature>))

    fn signature = "function name(param1_type, param2_type...)"
```

- Function signature takes function name, and parameter types
- Parameters are specified with ',' delimiter with no spaces

**Function arguments**

- function arguments also need to be encoded
- immediately follow the 4 bytes of function selector (start from 5th byte)

---

### Block Explorer

- Web portal - application that tracks all transactions and accounts
- Real-time onchain data - with blocks, gas consumed, transaction flows
- For contract accounts, we can check the historical txns, read/write functions (if verified)
- Etherscan is most popular. Etherchain, Ethplorer, Blockchair, Blockscout are other explorers

### Mainnet

- Main ethereum network
- Testnets - goerli, kovan, sepolia, rinkeby etc
- protocol developers can test on testnet
- testnets use test ETH
- faucets can give us test ETH

### EIP

- Ethereum Improvement Proposal
- Community members, researchers can put in EIP
- Well defined process
- EIPs can be on core, networking, interface on token standards (ERC20/721)
- Some Meta & Informational EIPs that address the governance/informational aspects

### ETH 2.0

- POS upgrade
- Scalability, Security and Sustainability
- Sharding
- Lower energy consumption

### Immutabile code

- What if code has a bug? - if its immutable, it cannot be changed?
- Big issue - as all code is shipped with bugs, vulnerabilities that might be discovered over time

**Redeployment**

- One way is for contract to be redeployed - but this is a huge problem for users if they wrongly link to old contract
- Another problem is that the prevailing state has to be exactly carried into new contract

**Proxy Pattern**

- Another way is to use proxies -> proxy points to an implementation contract
- Implementation contract can be changed/redeployed

**CREATE2**

- Final way is to use `CREATE2`
- This opcode allows updating a same contract inplace using same init code

### Web3

- permissionless, trust-minimized, censorship resistant network
- P2P
- Privacy and anonymity
- web2.0 principles and practices can be carried over
- From a security standpoint, there is a major shift

**Web2 vs Web3 languages**

- Web2 - JS, Rust, Go, Nim
- Web3 - Web2 + Smart contracts
- Smart contracts - Solidity / Vyper

**Onchain vs Offchain**

- Onchain - something running on blockchain
- Offchain - outside of blockchain - Web2, everything is offchain
- Web3 space - there is a mix of onchain and offchain
- Main difference in web3 is smart contracts - this is very new and unique from security perspective

**Open Source**

- Design approach in Web3 is open source and transparent
- Web 2 world, convention is to be proprietary products from licensing perspective
- Web 3, all are open source by default - this is very important for censorship resistance and permissionless
- Contracts are expected to be `Verified` - verified means, source code of contract is same one that was used to deploy the contract
- Txn and state is public - everything is transparent, all is real-time
- All transactions are on blockchain - all pending txns are in mempool
- No security by obscurity or obfuscation - everything is open, permissionless and real-time

**Unstoppable & Immutable**

- Dapps are decentralized
- Governance is also moving towards decentralization
- One entity should not have power to stop or change a contract code
- This centralization of Web2 should be eliminated in Web 3 (as per design)
- Any decisions regarding upgrading, changing, stopping or killing contract need to be decentralized
- This makes it really hard to fix vulnerabilities - in Web2, its very easy and happen almost on daily basis
- Progressive decentralization - this space is evolving.
- Best practices - have emergency functions such as withdrawals, kill switches etc - once space matures, then we can aim for real decentralization

**Psuedonimity and DAOs**

- Regulatory uncertainity in the space. Legal complications of being branded a 'security'
- Who is responsible for a crypto project is often a bit in the grey
- If team is psuedonymous, how do we know the project future?
- DAO - Decentralized Autonomous Organizations - stem from censorship resistance & minimize role of central parties
- Project aspires to work by voting based decisions on project implementation, treasury spending etc
- Slows down decision making - eg. handling a vulnerability could be an immediate need - DAO slows it down
- Security implications of DAO decision speed could be high

**Security Implications**

- Ethereum is itself 6-7 yrs old
- EVM architecture is very simple
- Gas semantics has no parallel to Web2 world
- Languages for smart contracts - solidity/vyper
- Developer toolchain - hardhat / truffle / brownie / openzeppelin are all 3-4 yrs old
- security tools - slither, mythX not more than 4-5 yrs. Evolution of these tools is not happening in a very coordinated way
- Different teams, different timelines

**Byzantine Threat Model**

- Web 2 - trusted insiders / untrusted outsiders
- Web 3 - Byzantine fault tolerance. Anyone including users could be abusers to the system
- We have arbitarily malicious players that are motivated to exploit mechanism design
- Adversaries can be anyone - developers, miners, validators - all of them could be adversaries
- This fundamental difference between Web2 vs Web 3 could make security a big challenge
- Web 3 is ultimate zero trust scenario - you can trust nobody - so security is all the more important

**Keys and Tokens**

- Password in Web 2 vs Keys in Web 3
- Web 3, keys are the fundamental primitive that govern everything
- Holding your keys is your responsibility - no third party that can reset your key (like password)
- End users have to take control of their assets
- Data vs tokens - in web2 data in various services/websites, personal data can be sold etc
- In web 3 world, tokens taken from private accounts, there is no recourse - damage is much bigger than just loss of data

**Composability**

- Composability is where protocols and code can interact with one another
- Building on top of each other in a permissionless way is expected to boost innovation
- composability without having gated, permissiones systems is aspirational goal of web3
- When true composability, there is a ton of dependencies, configurations
- This brings with it multiple attack vectors and vulnerabilities - making security even more critical
- Requires a deep knowledge of interacting, composable components - that is why security is a big and critical issue

**Timescales**

- Timescales have compressed in Ethereum development
- Lot of development is incentivized by tokenomics
- Open-source, economic incentives, composability have made growth explosive in the space
- Its truly permissionless and borderless where anyone can contribute
- In this focus on speed, security has taken a backseat
- As a result, a whole lot of vulnerabilities and exploits have happened

**Test-In-Prod**

- Real world failure models cannot be replicated in testnet
- Vulnerabilities get exposed only in mainnet - how attackers attack a platform in a permissionless, composable environment is difficult to predict

**Web3 Audits**

- Not yet matured
- Build -> Audit -> Launch is the formula - this is flawed
- Dev team & users put too much expectations on the audit
- Audit-as-a-silver-bullet - this perception needs to be fixed
- Lack of inhouse security expertise - lack of security mindset of developers
- Lot of demand of people who can develop as well understand the risks
- Approach to launch quickly makes people rely on external audits -> unreal expectations
- And these audits are also super expensive
- Demand >> Supply
- Demand for quality auditors and security experts
