# AUDIT TECHNIQUES AND TOOLS 105

[Video](https://www.youtube.com/watch?v=dgITqd3mkDk&list=PLYORQHvGMg-VWUdk3AollB0IYVF0az5Tw&index=1)

## Summary

We discuss audit process in detail..

### Audit Process Steps

_Step 1: Read Docs_

- Very less projects have specifications at audit stage
- specification is technical and project goals, why and what about the project
- actual implementation is functional manifestation of these goals (documentation)
- specification - why, documentation - how
- documentation - readme files/ github repo
- good specifications - helps in increasing audit quality -> auditors don't need to infer specifications from documentation
- inference is a waste of time/effort of auditors
- identifying threats to assets/actors/actions from just documentation is a tedious and complex task
- inference can be done by tools like Surya (need to check this)
- time saved here could be spent by auditors for deeper manual analysis

_Step 2: fast tools_

- slither,maru and other tools are useful for detecting common pitfalls
- detect missing best practices
- implement control flow and data flow analysis on smart contracts
- they are prone to false positives and false negatives - be careful not to rely only on fast tools

_step 3: Manual analysis_

- most important step to find business logic vulnerabilities (often most important and serious bugs are found here)
- automatic tools cannot help much with business logic
- application constraints and business logic - more of science - need to know what to look for/how and what could go wrong
- inference of constraints is tough until there is good experience in the space

_step 4: slow & deep tools_

- slow tools run a deep analysis
- echidna, manticore
- more prep/expertise needed to run these tools
- output also is much richer -and takes a deeper diver into the smart contracts
- manticore, mythX, echidna, harvey, scribble are some examples (need to use all of them..and work with all of them)
- evaluating false positives are challenging but true positives from these tools are pretty significant - even best manual analysis sometimes can't catch errors the way these deep tools do

_step 5: discuss with auditors_

- brainstorming with other auditors helps in removing some blindspots
- `given enough eyeballs are bugs are shallow` - is a very important truth and hence need to discuss with others
- multiple auditors on a single project
- audit firms encourage group discussions
- group discussions might bias auditors to focus only on specific topics
- hybrid approach - once goals are decided, go on your own - once you have your findings, go in for a discussion - wont be hijacked by others thinking

_step 6: discuss with project team_

- have an open communication channel is important
- clarify assumptions and specifications
- discuss interim findings
- findings also can be shared on private repo
- other view is to talk to project team as late as possible - potentially to avoid being led by team to only think in certain ways

_step 7: audit report_

- report is a tangible output and has to be written with a lot of care
- all aspects of audit including scope, coverage, timeline, team, efforts, summaries, tools, techniques, findings, exploit scenarios, fixes are part of the report
- short term and long term recommendations
- executive summary gives an overview of audit, critical findings and suggested fixes - overall assessment of risks at a high level
- bulk of report focuses on fidings of audit, severity, impact, likelihood of attack and talking about exploit scenarios
- also can address subjective aspects of code quality -> coding, conventions, coverage
- audit report should be articulate and actionable

_step 8: deliver report_

- first time project team will have full access to assessment
- auditors and team agree on findings and security
- team reviews and responds with counter points
- depending on mutual agreement and consent of project team, audit report might be kept private or public

_step 9: evaluate fixes_

- final stage of the audit
- findings should be accepted/acknowledged or denied
- fixes may be different from what is recommended
- fixes need to be reviewe once completed
- some findings maybe contested as not being relevant by project team
- Usually very quick - outside scope of audit but most audit firms accomodate to help out project

- Specifics of the above steps may change from audit to audit and across firms

### Manual Review - Deep Dive

- Most critical component
- May have different approaches - they may start with access control, may track asset flows, may track control flows or data flows
- May have different focus - may infer constraints, may look at dependencies, evaluate assumptions, evaluate checklists

Lets look at approaches

_Access control_ - Starting with access control is very helpful - its a fundamental security primitive - which actor has access to which actions and which assets - priveleged roles typically have control over critical configuration (Admins / role based) - visibility of functions also controls access - modifiers capture the role based access rules - starting with access control & checking if they are applied correctly, consistently and completely is a first starting point

_Asset flow_

- one can look at an alternate approach of tracking asset flow
- one could start with assets - erc20/erc721 tokens
- exploits almoost always target assets -> so it makes sense to target asset flows -> how assets can come into and go out of the contract
- what conditions need to be met for asset flows to happen -> more so outflows
- questions of who/where/why/what type/how much -> are usually good questions to ask regarding asset flows

_Control flow_

- Tracking control flow, ie execution order, is another way of checking smart contracts
- key critical functions - and the order in which they are called
- call graph showing which functions call which other functions in which order is a great tool to understand control flow
- intra procedural flow -> conditionals or loops that dicate functional flow within a function
- inter procedural flows -> how activity happens between functions

_Data flow_

- analyze data across and within smart contracts
- variables and constants used as argument values for function calls
- track function arguments and corresponding return values
- intra function data flow tracks data within a function & data on storage/stack/memory and calldata
- intra and inter flow help track global and local changes to state variables
- data flows where control flows -> both together will help in understanding key functions of smart contracts

Now other areas to focus while running manual analysis are:

_Infer constraints_

- program constraints - rules / properties that should be followed by the program
- solidity/evm level constraints
- application constraints are rules implicit to business logic of application - may not be clear without a clear specification sheet - need to be inferred from documentation in that case
- Maximal occurence of a particular logic -> we can infer a constraint from this occurence -> and if this occurence is missing in a few paths, then we ask ourself - why is the constraint not seen in this path -> without knowing business logic also, we can take up this approach

_Understanding dependencies_

- reliance on other contracts, protocols, oracles or libraries creates dependencies
- explicit dependencies are captured in import statements
- Use of OZ projects reduces risks of external dependencies - time tested contracts
- composability is a reality in web3, especially defi - interacting with other stable coins, borrowing/lending platforms and exchanges means that we have to be careful how data (and control shifting) is coming in and going from our smart contracts to these protocols
- assumptions on functinality and correctness of these dependencies needs to be reviewed

_Assumptions_

- a meta level approach is to evaluate assumptions - many security vulnerabilities result from incorrect assumptions
- Some assumptions are
  - only admins can call some functions
  - functions will be called in a certain order
  - parameters can have only specific values
  - balances are always in sync with transfers
  - addresses will never be zero value
  - function calls will always be successful - checking for return values is not required
  - actions would be performed by external parties based on economic incentives (liquidatiosn)
  - all participants will be rational and try to maximize profits
  - availability of data (for eg. bid ask prices will always be available)
  - asset values (assets cannot go down by x% in y minutes etc)

_Checklist_

- Last approach for manual analysis would be to review checklists
- this is the one we will use in our bootcamp
- checklists are lists of items that can provide a systematic approach to audit
- made popular by checklist manifestor - atul gawande
- smart contracts managing multiple assets, multiple actors, multiple txn types - and managing billions of dollars
- easy to overlook some things or get something wrong - easy to make incorrect assumptions
- checklists increase retention and recall
- checklists help in going through pitfalls and best practices in smart contracts, one-by-one
- no missed checks - there is a seemingly large number of checks we have to make - its very easy to skip through a few checks as an auditor without such checklists

_Exploit scenarios_

- Presenting proof-of-concept exploit scenarios could be part of certain audits
- Past exploits using malicious contracts could be used as therotical concept to demonstrate attacks using code and written descriptions is a very useful way of demonstrating vulnerabilities
- codified exploits should be kept private on a testnet -> and should be responsibly disclosed to project team
- should be realistic and relatable - clear sequence of events that could lead to vulnerabilities with a demonstrable path to exploitation

_Likelihood & impact_

- likelihood is probability of exploit - high difficulty = low likelihood and vice versa
- Impact is magnitude of losses if there is an exploit
- severity = likelihood \* impact
- High likelihood - if exploit can be done manually, with a few txns, and with few resources - likelihood of that exploit is deemed high
- Medium likelihood - exploits that need deep knowledge of system, priveleged access, large resources or multiple edge conditions to hold true are evaluated as medium likelihood
- Low likelihood - exploits that need minor collusion, chain forks or insider collusion considered low likelihood (much harder conditions to perform this exploit)
- High imapct - any loss or locking up of funds is high impact
- Medium impact - no loss of funds but disrupt function of platform
- low impact - anything else

- Some classifications of likelihood and impact are contentious and debated between audit teams and project teams
- this typically happens when audit teams press for higher impact & project teams tend to downplay them
