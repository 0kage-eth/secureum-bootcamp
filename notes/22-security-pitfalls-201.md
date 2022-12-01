# SECURITY PITFALLS 305

[Video](https://www.youtube.com/watch?v=vyWLO5Dlg50)

## Summary

Advanced security pitfalls, we will look at 100 more vulnerabilities..

### V1 - no return value for transfer/transferFrom

_Background_

- ERC20 `transfer` and `transferFrom` should return boolean value -> giving status of transfer
- Not all token standards adhere to this specification and may not return boolean values
- If they don't return bool, call fails

_Risk_
No risk as such - just failure of contract call

_Mitigation_

- Ensure ERC20 standard implementation has a 'bool' return for `transfer` and `transferFrom`
- if custom implementation, you should not assume that functions return bool unless verified
- Use OZ contract

---

### V2 - optional name, symbol and decimal

_Background_

- ERC20 has fields - name, symbol and decimal
- Anyone creating a token may choose to skip thesee fieldds
- Any user calling a ERC20 should not assume that these fields exist

_Risk_

- Call might fail if we try to access name, symbol and decimal (which are optional)

_Mitigation_

- Verify if name, symbol and decimal fields exist before using them
- Do not assume their presence

--

### V3 - decimals

_Background_

- ERC20 has decimals -> typically 18 digits in precision
- decimals are represented as uint8 - sufficient for number upto 18
- custom contracts might be using a uint256 instead of uint8 for decimals
- best practice is to check the type of decimals -> if its uint256 -> make sure value <=255

_Risk_
NA

_Mitigation_
NA

--

### V4 - approve

_Background_

- `approve` is susceptible to front-running (already discussed this)
- `approve` does not check earlier approval given to a spender
- as a result, when a owner tries to decrease approval, sender can watch mempool txns
- frontrun the owner, spend earlier approved tokens, and then once new approval happens, spender can again spend new tokens

_Risk_

- Double spending during course of decreasing approval for a spender

_Mitigation_

- Use `increaseAllowance` or `decreaseAllowance` functions to change approval amounts for a spender

--

### V5 - ERC777 hooks

_Background_

- hooks get called before key actions are initiated - send, transfers, burn, mint, operatorTransfer etc
- recall also that ERC777 has concept of operators - who are approved addresses that can perform actions
- its a callback function that gets executed before actual action gets initiated

_Risk_

- Reentrancy attacks using hooks -> if hooks make external calls, then there is a possibility to create reentrancy attacks

_Mitigation_

- Best practice is to check for hooks having external calls
- if there are, analyze reentrancy risks

--

### V6 - Token Deflation

_Background_

- Tokens charge a fee to transfer tokens frrom one address to another
- This fee is later used to burn the corresponding amount of tokens creating a deflationary effect
- if such fee is charged, then the amount received by beneficiary < amount sent by the sender
- Total amount of tokens across all users would reduce over time if such fee is charged

_Risks_

- Contracts are not aware of deflationary fees of tokens & make assumptions on the token transfers leading to wrong logic

_Mitigation_

- Smart contract applications interacting with ERC20 tokens should be aware of any deflationary fees
- In general, ERC20 implementations should avoid such deflationary fees
- If yes, they should know the accounting methods of token contract and take that into account in their calculation

--

### V7 - Token Inflation

_Background_

- ERC20 tokens can also have an opposite effect called token inflation
- New tokens are minted into existence over time -> token generates interest for holders and this interest is then shared back to the holders
- increases the amount of tokens held by all users over time
- in this case received tokens > sent tokens

_Risk_

- Smart contract application is not aware of ERC20 token interest -> such additional tokens might be trapped inside the token contract without being realized

_Mitigation_

- In general, ERC20 implementations should avoid such inflationary interest
- If they are offering interest, contracts should know the accounting methods and incorporate that interest in calculations

--

### V7 - Token complexity

_Background_

- high complexity of tokens is a security risk
- Well defined spec and simple contract implementing something like ERC20 specs should be preferred
- More the complexity - greater is likelihood of bugs

_Risk_
NA

_Mitigation_
Avoid high complexity as chances of severe bugs increases

--

### V8 - Token functions

_Background_

- 'Separation of functions' refers to a particular contract only doing specific functions
- For eg. a ERC20 contract should only be concerned about token issuance and supply -> it should not have functions related to other tokens etc
- Having complex implementations that bundle all functionality in a single contract increases security risk

_Risk_
NA

_Mitigation_

- Recommend a clear separation of functions across contracts. ERC20 should strictly deal with functions specific to that token

--

### V9 - Single ERC20 address

_Background_

- ERC20 address should have all balances under a single address
- Single address creates a single entry point and improves transparency

_Risk_

- Multiple addresses that deploy same ERC have multiple balances & must be avoided - since they have multiple entry points, fungibility of tokens and their accountng becomes complex and creates unnecessary risks

_Mitigation_
Only single address for a given token

--

### V10 - ERC20 token contracts upgradeability

_Background_

- While upgradeability is great in general, for ERC20 token contract upgradeability is a strict NO NO
- Any change in token supply or functions can erode trust in the token and should be avoided
- Token functions in the contract are meant to be super simple -and don't need upgradeability at the level of token functions
- Also because these tokens follow specific ERC20 standards - which everyone has agreed to - adding upgradeability doesn't make sense

_Risk_
NA

_Mitigation_
NA

### V10 - Token Minting

_Background_

- Token minting -> process where new tokens are created
- Capabilities of owner to create new tokens should be carefully analyzed
- Malicious owner can print infinite tokens and dilute everybody
- all contracts that are housing these tokens will be impacted -> price impact could lead to liquiddations etc

_Risk_

- Understand who owns minting functionality -> who can mint and how much
- Abuse minting -> creates infinite tokens & dilutes everyones value to 0

_Mitigation_

- Always review `mint` functionality -> owner capabilities related to minting

### V11 - Token Pause

_Background_

- Pausable contracts are used in guarded launch cinditions
- Some specific accounts can pause and unpause a contract - incase of ERC20, this spplies to mint/burn/send/transfer et
- Malicious actors can pause contracts and trap funds

_Risk_

- Malicious attack on pause functionality can block users from accessing funds or buying -> stalls token velocity -> leading to huge implications

_Mitigation_

- If a `pausable` contract is used, always check who all has authority to pause -> access controls around pause functionality

---

### V12 - Token Blacklist

_Backgound_

- blacklist was implemented to prevent access for certain accounts
- this notion of blacklist for token contracts is problematic
- Someone has to maintain the blacklist ->adding or removing addresses to that list -> those owners could be malicious
- Centralizing power of token flow in a few hands by creating such a blacklisting option

_Risk_
Malicious actors can take control of blacklist functionality and trap user funds by adding any address to blacklist arbitarily

_Mitigation_

- Blacklist in token contracts should be strictly avoided
- As auditors, you need to be aware of risks & if any code inside ERC20 implementation allows for blacklisting

---

### V12 - ERC20 team

_Backgound_

- Team behind ERC20 maybe publicly known - who team is, their past projects etc and how they are connected within community
- Or the team could be anonymous - we don't know who, what background etc
- 2 schools of thought - anonymous teams are risky from security perspective - we don't know reputation
- this school of thought attaches greater risk to anonymous schemes - pump and dump tokens with no legal liabilities
- so anonymous teams will be subject to greated security scrutiny

- Other school of thought is that anonymity should not matter to security as long as all code is open source
- Project should be evaluated independently of who the members are
- Privacy and anonymity are strong aspirational virtues of Web3

_Risk_

- Legal and team risks are high for anonymous teams

_Mitigation_
NA
Depending on your school of thought, anonymous is a good or bad thing

---

### V13 - Ownership

_Backgound_

- Who owns the token and how many tokens they own
- In scenarios where very few own a lot, such scenarios can lead to token governance manipulation
- larger the dispersion of tokens across users -> better is the security for token

_Risk_

- Minority might bring key governance changes to tokens based on their large ownership
- influence price, liquidity and governance of tokens

_Mitigation_

- More of awareness issue

---

### V13 - Token Supply

_Backgound_

- Max amount of tokens in circulation is token supply
- Risk is when supply is low and concentrated among few owners

_Risk_

Price, liquidity and governance manipulation in a low supply environment

_Mitigation_

- Be aware of current supply, max supply and emission schedule to avoid risk of price manipulations

---

### V14 - Token listing

_Backgound_

- ERC20 tokens maybe listed at various places - could be centralized or decentralized exchanges
- DEX are expected to be more resilient against failures
- CEX can have issues of liquidity/volatility/ scams etc

_Risk_

Tokens listed in very few exchanges - price and supply can be manipulated by few

_Mitigation_

Have awareness on token listings and supply across exchanges and other centralized players

---

### V15 - Token Balance

_Backgound_

- Assumptions on token balances have security risks
- assumptions in smart contracts such as `balance < supply` breaks down when supply changes
- such assumptions can be broken down by whales who can bring in large supply OR by flash loan borrowers
- flash loans - where loan has to be paid back within the transaction - can borrow a huge number of tokens as part of flash loan - ownership never changes because loan is paid back in smae txn - flash loans can change supply by a huge amount for a fraction of time and manipulate any smart contract logic with above condition

_Risk_

- Exploit logic limits on balance by manipulating supply to the contract

\_Mitigation

- Check balance logic & see if the logic can fail when large tokens are transferred into the contract

---
