# SECURITY PITFALLS 202

[Video](https://www.youtube.com/watch?v=HqHo1jKUnmU)

## Summary

Advanced security pitfalls, we will look at 100 more vulnerabilities (contd..)..

### V16 - Token Flash Minting

_Backgound_

- Flash minting mints the new tokens handed to user
- Similar to flash loans, flash minting burns all tokens before the transaction ends
- If smart contracts are working with assumptions on balance/supply of tokens available -> then such flash mints can disrupt the logic -> ERC20 tokens supporting flash minting feature create serious risks for smart contract logic that make some assumptions on balances

_Risk_

- Tokens supporting flash mint can disrupt assumptions related to token balances/circulating supplies
- Can also create overflow errors

_Mitigation_

- Be aware of any flash mint features
- If available, evaluate any logic breakdowns because of this feature

---

### V17 - ERC1400 addresses

_Backgound_

- Introduces concept of permissioned addresses
- Introduced by polymath -> these are called security tokens
- These are ownership tokens in a financial security
- Such permissioned addresses can block transfers from some addresses or to some addresses

_Risk_

- Security perspective - if permissioned addresses are malicious or compromised -> can create token locks and DOS

_Mitigation_

- Be aware othat tokens are using ERC1400 standard

---

### V18 - ERC1400 forced transfers

_Backgound_

- trusted actors can perform unbounded transfers
- these are kind of forced transfers
- trusted actors can transfer whichever amount of funds to specific addresses

_Risk_

- Security perspective - again if these are controlled by malicious actors -unbounded transfers create major security risk

_Mitigation_

- Be aware othat tokens are using ERC1400 standard

---

### V19 - ERC1644 forced transfers

_Backgound_

- Similar to above, we have a controller who can perform arbitary txns of arbitary amounts

_Risk_

- Security perspective - again if these are controlled by malicious actors -unbounded transfers create major security risk

_Mitigation_

- Be aware othat tokens are using ERC1644 standard

---

### V20 - ERC621 total supply

_Backgound_

- Some trusted addresses have ability to change total supply
- This is after contract deployment
- this is via `increaseSupply` or `decreaseSupply`
- this is again dangerous - changing supply can dilute existing token holders

_Risk_
Same as above

_Mitigation_
Be aware of the token standard ERC 621

---

### V21 - ERC884 total supply

_Backgound_

- Introduces cancel and reisssue risk
- Some accounts called 'token implementers' can cancel addresses and move tokens from those canceled address to a new address
- introduces token holding risk to users -> if you are holdiong tokens and they are moved, you will end up with 0 balance

_Risk_
Same as above

_Mitigation_
Be aware of the token standard ERC 884

---

### V21 - ERC884 total supply

_Backgound_

- Also introduces whitelisted address
- token transfers are only allowed among whitelisted addresses
- again introdces token transfer risk -> user might want to transfer to an address but can't if its not whitelisted

_Risk_
Same as above

_Mitigation_
Be aware of the token standard ERC 884

---

### V22 - Guarded Launch

_Backgound_

- Framework used by most protocols
- Made popular by electric capital team
- when project is launched - some vulnerabilities are unknown and can only come out once protocol is accessible to world at large
- but exposing to the world increases risk of rugging
- guarded launch is where you are prepared for exploits and can take measures to limit the impact of such exploits
- There are several ways to conduct guarded launches

**1. Asset Limits**

- amount of assets at launch could be limited - over time, assets can be increased
- Rational is - at launch time, there is higher risk of exploit

**2. Asset types**

- guarded launch can be of asset types
- Some ERC20 contracts are well understood - the risks, collateral etc (for eg USDC)
- While some others carry more risk - Guarded launch also can whitelist assets - only specific assets can be traded with the platform
- By limiting assets, protocols can reduce attack vectors
- Limited assets to begin with - as project matures, add more assets to list

**3.User limits**

- only a few trusted users are whitelisted to use the application (maye for Beta testing)
- as the platform matures, can be opened to all eventually

**4.Usage limits**

- Upon launch, there can be txn limits on users in token/ether balances
- Limits on volumes from an address also possible
- Daily limits and rate limits are also possible
- Usage limits limits the exposure at any given time

**5.Composability limits**

- composability is another area where we can apply guarded launch approach
- compoasability is the idea that every application can interact with any other application
- we can combine multiple protocols in interesting ways that was never originally intended
- And this creates security risks - some combination of txn calls that increases security risks - unconstrained composability
- Guarded launch - we can place limits on composability - project can interact with only known set of protocols - with time, more protocols can be allowed to interact with core contracts of protocol

**6.Escrow**

- Another approach is to use escrow
- High value txns are not directly executed but sent to escrow - > there could be a timelock/governance controlling escrow behavior -> and txn could revert if the escrow txn looks suspicious
- Protocol can introduce escrow to begin with -> and can remove escrow as time goes along
- We are kind of adding an intermediate layer to handle security risks

**7.Circuit breaker**

- Most widely used guarded launch approach used by protocols
- Smart contracts allow users to pause certain functions or functionalities of that contract -> and unpause them once a security issue is detected and resolved
- Ofcourse, this is centralization but if it is transitionary & can help the platform overcome security risks -> its a good step
- authorized users can decide what triggers an emergency - we discussed this in OZ Pausable contracts section

**8.Emergency shutdown**

- Extreme version of circuit breaker
- simply pausing and unpausing will not help us recover -> something fundamentally has gone wrong and should be fixed at core logic level - emergency shutdown is the only option to prevent further loss of funds
- Emergency shutdown allows users to reclaim their assets upon shutdown
-

_Risk_
Security risks are high at the initial launch phase of protocol - Guarded launch approach helps us manage and mitigate those risks

_Mitigation_

Above methods, one or a combination of guarded launch approaches discussed above will help us mitigate the security risk in the initial phases of protocol launch

---

### V22 - Software Engineering Aspects of Application

_Backgound_

**Requirements**

- best practices need to be put in place in general application building
- not specific to web3 projects
- Design of any system starts with requirement scoping - target application purpose, target market, target users

**Specification document**

- Once requirements are gathered -> they are translated into a very specific document called `specifications document` - Why and the how are objectively answered in the specifications document
- Without a detailed specification - there is no baseline to refer to

**System documentation**

- documentation deals with actual implementation
- describes different system components that are built as per specifications document
- has to cover assets/actors/actions/trust/threat aspects of the protocol

To summarize design flow, `specify -> implement -> document -> evaluate`

_Risk_
NA

_Mitigation_

---

### V23 - software engg. aspects - invalid function parameters

_Background_

- Function parameters need a input validation
- Specially for public/external functions where users can specify inputs

_Risk_

- Inputs that allow users to exploit the contract need to be explicitly avoided by defining clear input validation checks

_Mitigation_

- Valid sanity/threshold checks are recommended
- Some examples
  - `Zero address` - can lock key functionality of contract or can mint/burn tokens unintentionally
  - `value = 0` - specially if that value can be used as divisor (divion by 0)
  - `caller != msg.sender` - some critical functions can only be accessed by deployer

---

### V23 - software engg. aspects - unused function return calls

_Background_

- Function calls returning a value being unused at call sites

_Risk_

- Skipping a return value at call site can have serious implication if that return value contains status of execution or latest value of state

_Mitigation_

- Why was the return value not used at call site?
- Is it redundant and contains no useful information?
- Are there any return value checks that are missed by developer?
- can there be an uncaught, invalid execution that can create problems at a later point (ie side effects of that txn captured by return value was missed)

---

### V23 - software engg. aspects - function visibility

_Background_

- Order of visibility -> public > external > internal > private
- Private has most restricted visibility and public has no restrictions on visibility to external users
- As a best practice of software engg, we have to follow strictest privelege - only give as much privelege to user as needed

_Risk_

- If a function that is supposed to be private is accidentally made external/public -> exposing that function to manipulation by external users -> and if that private function controls some sensitive data -> then we are creating needless security risks by this additional visibilty privelege

_Mitigation_

- We can reduce this risk by awarding strictest visibility to every function as per usage
