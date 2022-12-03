# AUDIT TECHNIQUES AND TOOLS 101

[Video](https://www.youtube.com/watch?v=M0C7z3TE5Go&t=28s)

## Summary

Review tools available that help with web3 audit and discuss audit techniques

### Audit Basics

_What?_

- Audit is an external security assessment of product code base
- meant to report security vulnerabilities
- includes pitfalls & best practices and deeper application logic
- subjective insights into code quality
- scope, depth varies but generally cover above
- typically happens before contracts are deployed to mainnet

_Scope_

- scope restricted to on-chain smart contracts mostly
- sometimes includes off-chain components

_Goal_

- assess project code and alert of any vulnerabilities
- review documentation, code and check security posture
- reduce the attack surface and mitigate risk

_Non-goals_

- Audit is not a security warantee
- No promise of a bug free code post audit
- Best effort endeavour by trained security experts
- Even experts operating under constraints of time, understanding and resources
- Audited project != 0 vulnerabilities - its a best effort only!
- Most auditors are self learned

_Target_

- Project teams pay for services
- Paying client projects are a priority
- Audit teams are answerable to paying clients - not to users or investors (this is important to understand)

_Need for an audit_

- Projects do not have sufficient in-house security expertise
- Don't have time or spend effort to perform internal security assessment (given pace of this space)
- Rely on external experts who have worked in the security domain
- Demand for security is orders of magnitude higher than supply
- We are pretty early in this industry
- even if projects have internal expertise, given risk and value at stake, they want to get audited
- users and investors also expect that protocol is audited for smart contract risk

_Audit types_

- New vs repeat audits - neew audits for new projects just being launched. repeat audits are for existing projects that had existing audits but a repeat for maybe a new version
- Fix audit - auditing fixes made to prior audit
- Retainer audit - audit is constantly done to provide guidance in continuous manner on project updates
- Incident audit - audit to specifically investigate a particular exploit or significant event (root cause, vulnerability assessment and fixes)

_Timeline_

- time spent depends on type/scope/nature of audit and complexity
- may range from days (retainer audit) to weeks (for new or repeat audit)
- may require months for complex projects with lot of external dependencies
- subjective - criticality of the platform, size of protocol also matter
- auditors try to objectively quantify time based on - # of files, lines of code, external dependencies, oracles, complex math

_Number of Auditors_

- More than 1 auditor simultaneously
- Independent, supplementary, complimentary analysis
- More than 1 approach is generally preferred
- This prevents blindspots of individual auditors

_Cost_

- Time, nature and scope
- market demand and supply
- strength and reputation of audit firm
- starts from ~7000$ a week

_Pre-requisites_

- Clear scope of project to be assessed
- particular hash of a github repository (could be public or private)
- team behind project (could be anonymous) should be available on-call
- specifications of the project
- documentation and associated business logic
- trust and threat modules and specific areas of concern
- include all prior testing and reviews
- tools used from previous audits
- timeline, cost and effort
- engagement mode - preferred way of engaging
- point of contact on both sides

_Limitations_

1. Residual risk

   - audits are considered necessary
   - audits are definitely not sufficient
   - residual risk exists - risk gets reduced by audit but residual risk will continue to remain
   - risk is because of limited time and effort on audit, limited insights in project specification and implementation (lot of times there is no clear specification and documentation itself doubles up as specification)
   - risk could also come from limited platform expertise of auditors itself (in fast moving pace, auditors have to understand workings of different platforms) or of limited scope of audit where auditors are not looking at all aspects of projects
   - Or audits might nto have covered latest versions
   - residual risk could arise from significant project complexity

   For all above reasons, audits cannot and should not guarantee a vulnerability free code
   Such expectation is unreasonable and projecting it as such is dangerous

2. Not all audits are equal

   - audit from a widely reputed security firm is not the same as getting audit from someone else

3. Snapshot
   - audits provide snapshots over a particular point of time when audit was done (or maybe a few weeks)
   - smart contracts are continuously evolving - new features, new integations, new composability etc
   - contratcs need to optimize, fix bugs or vulnerabilities - this is sometimes done during or after an audit -> which kind of reduces effectiveness of audit because the changes introduced can create new bugs into the system
   - Reliable audits after every change is also impractical

_Reports_

- Deliverables include reports with vulnerabilities and risk assessment with recommendations
- Projects may publish such reports - audit teams might do so with permission of project
- scope/goals/effort/timelines/approach and tools used are documented in these reports
- findings/vulnerability classification/severity/exploits/fixes are also detailed in these reports
- classification and severity are as per firm's own rating and ranking
- Also include less critical notes - recommendations/best practices etc
- Overall audit report is a compregensive structured document
- final report and might have interim reports as well

_Classification_

- Can change from firm to firm
- Lets look at trail of bits classification
  - `Access control`: authorization of users, roles etc
  - `Auditing/Logging` - logging of events etc
  - `Authentication` - users in the context of application
  - `Configurations` - addresses, global variables etc
  - `Cryptography` - hashing, privacy and integrity of data
  - `Data exposure` - unintended exposure of sensitive information
  - `Data validation` - improper reliance on structure and values of data
  - `Denial of Service` - relating to causing system shutdown or failure
  - `Error reporting` - relating to error handling
  - `Patching` - relating to software updates, in our case smart contracts
  - `Sesison management` - identification of authemticated users
  - `Timing` - locking or order of operations

If none of the above match, then it fits in `undefined behavior`

_Difficulty_

- Difficulty here refers to likelihood of an attack - high difficulty = low likelihood
- this is a rough measure of how likely or difficult it is to uncover a vulnerability that can be exploited
- OWASP (Open Web Application Security Project) proposes 3 likelihood levels
  - Low
  - Medium
  - High
- OWASP doesn't apply so well with web3. Trail of Bits classified into 4 likelihood levels

  - `Low` - common security pitfall, knowledge exists about this vulnerability or missing best practice at solidity or evm level. This implies that it can be easily exploited

  - `Medium` - attackers need indepth knowledge of system to exploit this vulnerability and this maybe application specific related to business logic - not generic or solidity/evm related

  - `High` - attacker must have priveleged access to the system. they need to know extremely complex technical details of that system or discover some other weakness to exploit the system. Means one of the actors with priveleged access is malicious or compromised - might even know some insider details on design and implementation

  - `Undeterminate` - could not determine the difficulty during the audit. This can happen because the operational scope did not allow this to be determined.

  _Impact_

- As per OWASP, impact is based on magnitude of technical and business impact of the vulnerability

  - `High` - High impact is when there is a lock of funds due to any unauthorized action.
  - `Medium` - Affect application in a significant way but does not cause immediate loss of funds
  - `Low` - Everything else is low impact

- Nature of impact is a bit subjective - and is discussed a lot between project team and audit team
- Also carefully looked at by community at large when discussing high impact vulnerabilities

_Serverity_

- `Likelihood * impact` matrix -> we get a 3 by 3 matricx when we combine the above concepts of difficulty and impact
- `Likelihood (L) * impact (I) = Severity`
- `Low L * Low I = Informational Note`
- `Low L * Medium I = Low`
- `Low L * High I = High`
- `Medium L * Low I = Low`
- `Medium L * Medium I = Medium`
- `Medium L * High I = High`
- `High L * Low I = Medium`
- `High L * Medium I = High`
- `High L * High I = Critical`

- Trail of bits uses 5 severity levels instead of this OWAS recommendation

  - `informational` - issue does not produce immediate risk
  - `low` - low risk or risk not important as per customer
  - `medium` - exploitation would be bad for reputation
  - `high` - affects large number of users
  - `undetermined` - extent of risk was not determined during engagement

- Consensys has different severity classification

### Audit Checklist

- Trail of bits recommends a checklist for projects before getting ready for audit

  - test
  - review
  - document

- `Test`

  - enable and address every compiler warning
  - increase `unit` and `feature` test coverage

- `review`

  - perform an internal review to address common pitfalls and best practices

- `documentation`

  - what project does
  - who uses it
  - what drives it
  - functionality
  - add comments about intended behavior in the code
  - label and describe your tests and results (both positive and negative tests and results)
  - include past reviews and any bugs fund
  - steps to create build environment
  - external dependencies
  - build process including debugging and testing
  - deployment process and environment

  ### Analysis techniques

  - manual/automated analysis performed with tools with some level of manual assistance
  - eight broad categories

    - specification analysis (manual)
    - documentation analysis (manual)
    - testing (automated)
    - static analysis (automated)
    - Fuzzing (automated)
    - symbolic checking (automated)
    - formal verification (automated)
    - Analysis (manual)

    1. _Specification_

       - what is the project, why, design aspects
       - assets / actors / trust and threat models
       - assumptions made are necessary to list to identify any shortfall in assumptions
       - very few projects have detailed specifications at audit stage
       - at best they have documentation on what is implemented
       - auditors spend a lot of time inferring specification from documentation of process and implementation

    contd in next lesson..
