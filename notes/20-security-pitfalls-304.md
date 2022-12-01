# SECURITY PITFALLS 304

[Video](https://www.youtube.com/watch?v=byA3MLLiKMM&t=3s)

## Summary

List of all security vulnerabilities continued..

### V46 - Dirty Bits

_Background_

- Multiple types with size < 32 bytes
- Using such types may mean that higher order bits contain dirty values
- this could be because of previous writes to those bits that have not been cleared or zeroed out
- Such dirty bits do not affect variable operations as compiler knows the dirty bits and does not let them interfere in normal operations

_Risk_

- If variables with dirty bits are getting used and passed around as `msg.data` -> then that may cause malleability or non uniqueness

- Need to be aware of this risk -> when we are encoding variables < 32 bytes

_Mitigation_

N/A

---

### V47 - Incorrect shifts

_Background_

- Assembly -> there are 3 ways to shift -> shift left, shift right and shift arithmetic right
- `shl(x,y)`, `shr(x,y)` and `sar(x,y)` -> take 2 oerands x and y
- above shift `y` by `x` bits -> this can be confused to `x` shifted by `y` bits

_Risk_

- Wrongly interpreting shift operations could lead to completely different outcomes

_Mitigation_

- Analyze assembly for use of `shift` operations -> check if `x` and `y` operaands are properly used as intended

---

### V48 - Assembly usage

_Background_

- Yul is a low level assembly language for EVM
- Assembly -> does not use type safety of solidity
- Low level manipulation could be gas efficient but trade off is increased security risk
- Error-prone & semantics/readability of code is reduced

_Risk_

- Manipulating at low level could lead to unexpected errors

_Mitigation_

- Use of solidity is preferred from maintainability, auditability and readability perspective
- Auditors themselves may not be aware of Yul
- There could be parts of code written in assembly language - any code block written in Yul must be double checked by auditors

---

### V48 - RTLO

_Background_

- Right to Left Override
- Use of special unicode character (U+202E) allows use of right-to-left (RTL) characters inside a text that is normally rendered left-to-right(LTR)
- RTLO has been used in phishing attacks for years, where attackers inserted the RTLO character in the middle of filenames of attachments to try and deceive users into thinking the attachment is safe.
- For example, if we rename a malicious .exe file to: “Test\u202excod.exe” then on the one hand the system will treat it as an executable file, but on the other it will be displayed as “Testexe.docx”, which appears to be a legitimate docx file.

_Risk_

- Malicious actors can use the Right-To-Left-Override Unicode character to force RTL text rendering and confuse users as the real intent of a contract
  [Read this article on RTLO](https://coinsbench.com/the-new-language-but-the-old-mistake-33831bfce25e)
- This trick confuses users and auditors reading the code

_Mitigation_

- Change the solidity compiler version to ^0.7.6 to detect RTLO
- Reading code from Pastebin or block explorer without trying to copy and paste it to IDE or Code Editor which cannot guarantee the securement of smart contracts -> always check for IDE warnings of any unicode insertion
- Ensure absence of RTLO

---

### V48 - Constants

_Background_

- State variables whose values do not need to change over contract lifetime are declared `constant`
- saves gas because compiler replaces all places where state variable is used with constant value -> there are no SLOADS

_Risk_

- Expensive gas if what are supposed to be `constants` are not declared as such

_Mitigation_

- Identify variables that are not changing over lifetime of contract
- Make sure they are declared `constant`

---

### V48 - Variable Naming

_Background_

- Names of variables should be as distinct and unique as possible
- Name overlaps lead to wrong usage -> where one is accidentally used by dev instead of its similar cousin and this could lead to logic breakdowns

_Risk_

- Accidental wrong usage of seemingly similarly named variables

_Mitigation_

- Make variable names clearly unique and distinct

---

### V49 - Uninitialized state/local variables

_Background_

- Solidity, uninitialized state/local variables - default values are zero
- Address -> zero address, bool -> false, uint -> 0

_Risk_

- We have already noted that zero address can lead to inadvartent contract lock or burning of eth/tokens
- Default bool could lead conditionals to skip key control flows that were never intended by dev

_Mitigation_

- Initialization of values should be explicit as a best practice
- Assign reasonable values for this initialization -> so that dev is aware of these values and their impact on logic

---

### V50 - Uninitialized storage pointers

_Background_

- Local storage variables that are uninitialized can point to unexpected storage locations

_Risk_

- Can lead to devs unintentionally changing contract state leading to serious vulnerabilities

_Mitigation_

- > 0.5.0 disllows usage of such storage pointers

---

### V51 - Uninitialized function pointers

_Background_

- Was an error with uninitialized function pointers when used in constructors
- Causing unexpected behavior
- Present in 0.4.6 and since been fixed

_Risk_
NA

_Mitigation_
NA

---

### V52 - Number literals

_Background_

- Use long number literals
- too many digits -> dev might miss 1 zero or add an extra zero
- `eg uint 1_ether = 1000000000000000000`

_Risk_

- Long number literals can miss a digit or add a digit leading to different outputs

_Mitigation_

- Use the support in solidity for native units - `ether`, `gwei`, `wei`
- Same applies for time - use `days`, `months`, `hours` native support in solidity

---

### V52 - Enum out of range

_Background_

- If we had `enum` E with single member -> E(1) is out of range
- out of range enum provided unexpected behavior for solc < 0.4.5
- until fix, we had to check enums if enum is out of range -> not required now

_Risk_

- Out of range enums in old solc

_Mitigation_

- In any case, best is to use enum paramater instead of enum index

---

### V53 - Public functions

_Background_

- Public vs external -> public consumes more gas than external
- The above is because arguments of ppublic functions need to be copied from `calldata` to `memory`
- This copying produces more byte code for such functions -> and hence more gas
- for external functions, arguments of functions can be left in `calldata` component

_Risk_
NA

_Mitigation_

- No mitigation as such but best practice is, if functions are not called within the contract -> they should be made external visibility to save gas

---

### V54 - Dead code

_Background_

- Contract code that is unused or unreachable
- Could be indicative of programming error or missing logic

_Risk_

- Just a flag to possible sections of missing code or missing logic

_Mitigation_

- Check why the code is present in first place & what is its intention
- Clear opportunity to optimize -> reduce code size -> if not used, then remove dead code
- Affects readability, mantainability and auditability of code
- 3 scenarios possible below

  _Scenarios_

  1. dead code that has security checks - auditor might assume that dead code checks are being done but these checks are not actually happening - so reduce security

  2. devs know there is dead code and still place it - code inside that dead code is not tested because devs know it is dead - and that could lead to security vulnerabilities

  3. third scenario is when devs classify some code with actual utility as dead code - they might comment out that code thinking its not used - which might create security vulnerabilities

- If dead code -> decide whether to use it or delete it -> if using it, make sure the code is properly error checked, if not, make sure deleted code doesn't contain some key security checks that we might lose by deleting it

---

### V54 - Return values

_Background_

- Recall that functions can return a value
- this value is usually an output or latest state update or reflection of execution of that function and hence contains vital information from a security standpoint
- Often times, devs might choose to ignore the output of such a function and not run any security checks on outputs

_Risk_

- When critical function return values are not used from security standpoint. The output return values are ignored

_Mitigation_

- Return values could have some error codes that reflect the output status of function OR return values might give the laytest update to a state variable
- Ask why the return variable is not being used - it could be indicative of some missed error checks happening at call site
- If data is returned that is not used - could result in unexpected logic behavior
- And if that return value is not adding any value, consider removing the output from function signature

---

### V55 - Unused variables

_Background_

- State and local variables inside of contracts are unused at times
- This could be indicative of some logic loopholes or incomplete logic
- Or, it could be an opportunity to reduce bytecode/storage and make it more gas efficient

_Risk_

- Unused variables (specially state variables) could indicate missing logic

_Mitigation_

- Go through all state and local variables
- If unused, ask what was the purpose of that variable inside the contract
- If really uneccessary, remove and optimize for gas

---

### V56 - Redundant function statements

_Background_

- redundant statements are statements with no side effects or statements with side effects but are made redundant because other statements have same side effects

- redundant statements could be a case of missing logic or programming error (that made them redundant)
- present chance for optimization where we can make it more gas efficient by removing redundancies

_Risk_

- redundant statements usually mean some logic is missing or a potential programming error
- if redundant statements lead to certain checks - because they are redundant those checks never get executed -> leading to security vulnerabilities

_Mitigation_

- Determine if statements are redundant - determine their side effects - and if they really are redundant, just remove them and optimize
- Analyze side effects of statements before classifying anything as redundant

---

### V58 - Compiler Bug: Storage arrays

_Background_

- Some compiler specific errors were causing serious issues to smart contracts
- Older verions of solidity compilers that are now fixed
- Very specific to certain data structures - some errors are so deep & only come out when certain unique set of conditions are met
- These could be some complex data structures or very niche combinations of storage & logic that we might not encounter for long time

_Risk_

- Bug related to storage arrays of signed integers
- Usage was enabled by ABI encoder v2 that is now enabled by solidity by default
- arose when assigning an array of signed integers to a storage array of different type
- `Type[] = int[]` - assignment lead to data corruption
- compile present in `0.4.7-0.5.10` - fixed after - unlikely we will see smart contracts with this bug

_Mitigation_
NA

---

### V59 - Compiler Bug: Constructor Arguments

_Background_

- Related to constructor arguments with dynamic elements such as structs, dynamic arrays
- This was possible with abiEncoderV2
- but reverted with invalid code error
- fixed 0.5.9

_Risk_

- constructor failing

_Mitigation_
NA

---

### V60 - Compiler Bug: Storage Array elements

_Background_

- Again, storage arrays of struct/static arrays was possible to send using abiEncoderV2()
- there was a bug in reading storage arrays when they were directly encoded in external function OR using `abi.encode` primitive
- fixed in 0.5.10

_Risk_
NA

_Mitigation_
NA

---

### V61 - Compiler Bug: CallData Structs

_Background_

- Reading calldata `structs` that contained dynamically encoded but static sized data would result in incorrect values
- Corrected in 0.5.11

_Risk_
NA

_Mitigation_
NA
