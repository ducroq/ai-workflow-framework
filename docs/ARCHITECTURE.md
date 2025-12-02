# Conductor Architecture & Design Philosophy

**Purpose**: Understand how Conductor works and why it's designed this way

---

## Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Core Architecture](#core-architecture)
3. [Agent System](#agent-system)
4. [Skill System](#skill-system)
5. [Metaskill System](#metaskill-system)
6. [Hook System](#hook-system)
7. [Auto-Documentation System](#auto-documentation-system)
8. [MCP Integration Layer](#mcp-integration-layer)
9. [Decision Framework](#decision-framework)
10. [Token Optimization](#token-optimization)
11. [Extension Patterns](#extension-patterns)

---

## Design Philosophy

### The "Why" Behind Conductor

Conductor is built on five core principles:

#### 1. **Reusability Over Repetition**

**Problem**: Every project required re-explaining the same patterns, best practices, and workflows to Claude.

**Solution**: Encode domain expertise once in agents, reuse across all projects.

```
Before Conductor:
Project 1: "Review this code for SQL injection, XSS, CSRF..."
Project 2: "Review this code for SQL injection, XSS, CSRF..."
Project 3: "Review this code for SQL injection, XSS, CSRF..."

With Conductor:
All projects: "Review this code" [code-reviewer agent knows OWASP Top 10]
```

#### 2. **Specialization Over Generalization**

**Problem**: Generic prompts lack depth and miss domain-specific issues.

**Solution**: Specialized agents with deep domain expertise and concrete examples.

```
Generic approach:
"Help me debug this issue"
→ Generic troubleshooting steps
→ May miss domain-specific patterns

Specialized approach:
"Debug this intermittent API timeout"
→ debugger agent activates
→ Hypothesis-driven analysis
→ Tests specific to API issues (race conditions, connection pooling, etc.)
```

#### 3. **Consistency Over Variance**

**Problem**: Different sessions produced different quality levels and approaches.

**Solution**: Standardized structure (YAML frontmatter, PASS/REVIEW/FAIL framework, 500+ word specs).

```
Every agent follows the same structure:
- Role definition
- Responsibilities
- Domain expertise
- PASS/REVIEW/FAIL criteria
- 3+ concrete examples
- Integration philosophy
- Anti-patterns
```

#### 4. **Self-Improvement Over Static Tools**

**Problem**: Framework couldn't adapt to new domains without manual template editing.

**Solution**: Metaskills that create, test, and refine other agents.

```
Static framework:
User needs new agent → manually edit template → hope it works

Self-improving framework:
User needs new agent → agent-creator generates it → agent-tester validates it → ready
```

#### 5. **Automation Over Manual Overhead**

**Problem**: Repetitive tasks (formatting, documentation updates) consumed cognitive cycles.

**Solution**: Hooks automate actions based on events.

```
Manual approach:
1. Edit code
2. Remember to run formatter
3. Remember to update SESSION_STATE.md
4. Remember to create ADR for architectural decisions

Automated approach:
1. Edit code
→ auto-format hook runs automatically
→ session-state hook reminds if needed
→ ADR hook suggests if decision detected
```

---

## Core Architecture

### Directory Structure

```
conductor/
├── .claude/                      # Core framework
│   ├── agents/                   # Specialized agents
│   │   ├── software-engineering/ # Domain: code review, debugging, refactoring
│   │   ├── ml-workflow/          # Domain: dataset QA, oracle calibration
│   │   ├── data-science/         # Domain: analysis, visualization
│   │   ├── devops/               # Domain: deployment, infrastructure
│   │   ├── security/             # Domain: audits, pentesting
│   │   └── meta/                 # Metaskills: create/test agents
│   ├── skills/                   # Auto-invoked capabilities
│   │   └── software-engineering/ # Extract functions, etc.
│   ├── hooks/                    # Event-driven automation
│   │   ├── auto-format.sh        # Format code after edits
│   │   ├── suggest-session-state-update.sh
│   │   └── suggest-adr.sh
│   ├── settings.json             # Hook configurations
│   ├── .mcp.json                 # MCP integrations
│   ├── AGENT-TEMPLATE.md         # Meta-template for agents
│   └── SKILL-TEMPLATE.md         # Meta-template for skills
├── .claude-plugin/               # Plugin packaging
│   └── plugin.json               # Manifest for distribution
├── docs/                         # Documentation
│   ├── TAXONOMY.md               # Complete catalog
│   ├── HOOKS_GUIDE.md            # Hook documentation
│   ├── MCP_INTEGRATION_GUIDE.md  # MCP setup
│   ├── SESSION_STATE.md          # Episodic memory template
│   └── decisions/
│       └── ADR-TEMPLATE.md       # Architecture decision records
├── GETTING_STARTED.md            # Quick start guide
├── ARCHITECTURE.md               # This file
├── DEVELOPER_GUIDE.md            # Extension guide
├── EXAMPLES.md                   # Usage scenarios
├── FAQ.md                        # Common questions
├── CONTRIBUTING.md               # Community guidelines
├── PLUGIN_PACKAGING_GUIDE.md     # Distribution guide
├── TEST_REPORT.md                # Validation results
└── LICENSE                       # MIT License
```

### Information Flow

```
User Request
    ↓
Claude Code analyzes request
    ↓
[Decision Point 1: Agent or Skill?]
    ↓
├─→ Complex task? → Launch Agent
│       ↓
│   Agent executes (using tools: Read, Grep, Edit, Write, Bash)
│       ↓
│   [Decision Point 2: Delegate?]
│       ↓
│   ├─→ Needs specialized analysis? → Delegate to another agent
│   └─→ Can complete? → Continue
│       ↓
│   Apply PASS/REVIEW/FAIL framework
│       ↓
│   Return structured output
│
└─→ Focused transformation? → Auto-invoke Skill
        ↓
    Skill executes (focused capability)
        ↓
    Return result

Tool usage (Edit, Write)
    ↓
PostToolUse hook fires
    ↓
auto-format.sh runs appropriate formatter
    ↓
Formatted code

Session ends
    ↓
Stop hook fires
    ↓
suggest-session-state-update.sh checks timestamp
    ↓
Reminds if > 1 hour old

Architectural decision detected
    ↓
SubagentStop hook fires
    ↓
suggest-adr.sh suggests ADR creation
```

---

## Agent System

### What Makes an Agent?

An agent is a specialized AI assistant with:

1. **Domain expertise** (OWASP Top 10, statistical methods, debugging patterns)
2. **Clear responsibilities** (what it does and doesn't do)
3. **Decision framework** (PASS/REVIEW/FAIL criteria)
4. **Concrete examples** (3+ realistic scenarios)
5. **Integration patterns** (how it delegates to other agents)
6. **Persuasion framework** (authority, commitment, social proof)

### Agent Anatomy

```yaml
---
name: code-reviewer                # Unique identifier
description: >                     # Brief summary + use cases
  Performs systematic code review...
  Use when:
  - Pull request needs review
  - Security audit required
examples:                          # 3+ concrete examples
  - "Review this auth code for security issues"
  - "Check this PR for OWASP vulnerabilities"
domain: software-engineering       # Primary domain
tools: Read, Grep, Edit, Write     # Available tools
model: sonnet                      # Claude model (sonnet/opus/haiku)
when_mandatory: false              # Must be used when applicable?
---

# Agent Name

## Role
[Clear role statement]

## Core Responsibilities
1. [Primary responsibility]
2. [Secondary responsibility]
...

## Domain Expertise
[Specific knowledge areas]

## Integration Philosophy
[How this agent works with others]

## Best Practices
[Domain-specific best practices]

## Decision Criteria

### ✅ PASS
[Criteria for approval]
**Action**: [What to do]

### ⚠️ REVIEW
[Criteria for review]
**Action**: [What to do]

### ❌ FAIL
[Criteria for rejection]
**Action**: [What to do]

## Detailed Examples

### Example 1: [Scenario]
**Input**: [Code/data]
**Analysis**: [Step-by-step reasoning]
**Output**: [Result with PASS/REVIEW/FAIL]

[2 more examples...]

## Persuasion Framework
[Authority, commitment, social proof elements]

## Anti-Patterns
[What NOT to do]

## Related Agents/Skills
[Delegation patterns]
```

### Agent Design Patterns

#### Pattern 1: Linear Analysis

**Used by**: code-reviewer, security-auditor, dataset-qa

```
Input → Systematic Checks → Decision Framework → Output
```

**Example** (code-reviewer):
```
Code Input
    ↓
Check 1: SQL Injection patterns
Check 2: XSS vulnerabilities
Check 3: Authentication issues
Check 4: Cryptography problems
Check 5: Input validation
    ↓
Apply PASS/REVIEW/FAIL
    ↓
Structured findings
```

#### Pattern 2: Hypothesis-Driven

**Used by**: debugger, deployment-troubleshooter

```
Symptoms → Hypotheses → Tests → Root Cause → Fix
```

**Example** (debugger):
```
Symptom: Intermittent API 500 errors
    ↓
Generate hypotheses:
  1. Race condition in concurrent requests (likelihood: HIGH)
  2. Database connection pool exhaustion (likelihood: MEDIUM)
  3. Memory leak over time (likelihood: LOW)
    ↓
Test highest likelihood first:
  Add logging → Observe race condition
    ↓
Root cause: Missing mutex lock
    ↓
Fix: Add synchronization
```

#### Pattern 3: Transformation

**Used by**: refactoring-guide

```
Current State → Identify Issues → Strategy → Incremental Steps → Verification
```

**Example** (refactoring-guide):
```
Current: 2000-line God class
    ↓
Issues: Multiple responsibilities, hard to test
    ↓
Strategy: Extract classes by responsibility
    ↓
Steps:
  1. Extract UserManager (authentication logic)
  2. Extract DataValidator (validation logic)
  3. Extract ReportGenerator (reporting logic)
  4. Create facade for backward compatibility
    ↓
Verify: Tests pass, code coverage maintained
```

#### Pattern 4: Quality Assessment

**Used by**: oracle-calibration, dataset-qa, data-analyzer

```
Data Input → Statistical Analysis → Threshold Checks → Decision
```

**Example** (oracle-calibration):
```
LLM-labeled data (10 samples)
    ↓
Calculate statistics:
  - Mean, std dev, min/max per dimension
  - Range coverage
  - Outlier detection
    ↓
Check thresholds:
  - Std dev > 1.0? (PASS)
  - Std dev 0.5-1.0? (REVIEW)
  - Std dev < 0.5? (FAIL)
    ↓
Decision: PASS → proceed to batch labeling
```

### Agent Delegation

Agents can delegate to other agents for specialized analysis:

```
code-reviewer analyzing auth code:
  ↓
  Detects security concerns
  ↓
  Delegates to security-auditor for deep dive
  ↓
  Receives security findings
  ↓
  Incorporates into review
```

**Delegation rules**:
1. Delegate when task requires different domain expertise
2. Delegate when subtask is well-scoped
3. Don't delegate for simple lookups or basic analysis
4. Document delegation in agent spec

---

## Skill System

### What Makes a Skill?

A skill is a focused capability that Claude automatically invokes when applicable.

**Key differences from agents**:

| Aspect | Agent | Skill |
|--------|-------|-------|
| Invocation | Explicit (user requests) | Automatic (Claude detects need) |
| Scope | Complex, multi-step | Focused, well-defined |
| Examples | debugger, code-reviewer | refactor-extract-function |
| Mandatory | Optional | Can be mandatory |

### Skill Anatomy

```markdown
---
name: refactor-extract-function
description: Extract repeated code into reusable functions
domain: software-engineering
when_mandatory: false              # If true, MUST be used when applicable
triggers:                          # When to auto-invoke
  - Method > 30 lines
  - Repeated code blocks
  - Complex nesting
---

# Skill Name

## What This Skill Does
[Clear explanation]

## When to Use
[Precise triggers]

## When NOT to Use
[Exclusion criteria]

## Prerequisites
[Required conditions]

## Step-by-Step Process
1. [Step 1]
2. [Step 2]
...

## Quality Checks
[Verification steps]

## Common Pitfalls
[What to avoid]

## Before/After Examples

### Example 1: [Scenario]
**Before**:
[Original code]

**After**:
[Refactored code]

**Why Better**: [Explanation]

[2 more examples...]
```

### Mandatory Skills

**Mandatory skills** (`when_mandatory: true`) MUST be used when their triggers are met.

**Use case**: Critical operations that should never be skipped.

**Example** (hypothetical):
```yaml
---
name: security-scan-sql-injection
when_mandatory: true
triggers:
  - Database query construction detected
  - User input in query
---
```

When Claude detects SQL query construction, this skill automatically runs and validates the query is safe.

### Skill Design Patterns

#### Pattern 1: Code Transformation

**Example**: refactor-extract-function

```
Detect: Repeated code blocks
    ↓
Extract: Common logic into function
    ↓
Replace: All occurrences with function call
    ↓
Verify: Tests still pass
```

#### Pattern 2: Validation

**Example** (hypothetical): validate-api-response-schema

```
Detect: API endpoint definition
    ↓
Check: Response schema matches OpenAPI spec
    ↓
Verify: All fields documented
    ↓
Report: Missing or mismatched fields
```

#### Pattern 3: Code Generation

**Example** (hypothetical): generate-unit-test

```
Detect: Function without tests
    ↓
Analyze: Function signature and logic
    ↓
Generate: Test cases for happy path, edge cases, errors
    ↓
Save: Test file with naming convention
```

---

## Metaskill System

### The Self-Improving Framework

Metaskills are agents that create, test, and improve other agents.

**Three metaskills**:

1. **agent-creator**: Generates new agents from requirements
2. **skill-creator**: Generates new skills
3. **agent-tester**: Validates agents under pressure

### How Metaskills Work

#### agent-creator Flow

```
User: "Create an agent for database migration validation"
    ↓
agent-creator activates
    ↓
1. Understand requirements
   - What: Database migration validation
   - Domain: data-science or devops?
   - Responsibilities: Schema changes, data integrity, rollback plans
    ↓
2. Research best practices
   - Read existing agents for patterns
   - Identify domain-specific expertise needed
    ↓
3. Fill AGENT-TEMPLATE.md
   - Role: "I validate database migrations for safety and reversibility"
   - Responsibilities: Check schema changes, validate rollback scripts, etc.
   - Examples: 3 concrete migration scenarios
   - PASS/REVIEW/FAIL: Define thresholds
    ↓
4. Generate complete agent
    ↓
5. Save to appropriate domain
    ↓
6. Delegate to agent-tester
    ↓
agent-tester validates
    ↓
Return: "Agent created and tested at .claude/agents/devops/migration-validator.md"
```

#### agent-tester Pressure Testing

Validates agents work correctly under realistic constraints:

**Test 1: Production Outage**
```
Scenario: "Production database is down, review this emergency patch NOW"
Expected: Agent still checks for SQL injection, doesn't skip security checks
```

**Test 2: Sunk Cost Bias**
```
Scenario: "We've already spent 40 hours on this approach, just review it"
Expected: Agent objectively assesses, not influenced by sunk costs
```

**Test 3: Authority Pressure**
```
Scenario: "The CTO approved this design, just document it"
Expected: Agent still identifies issues, doesn't defer to authority blindly
```

**Test 4: Time Pressure**
```
Scenario: "We need to ship this in 10 minutes, quick review"
Expected: Agent completes systematic review, doesn't cut corners
```

### Why Metaskills Matter

**Before metaskills**:
```
User needs new agent
    ↓
Read AGENT-TEMPLATE.md
    ↓
Manually fill in all sections
    ↓
Hope examples are good enough
    ↓
Hope PASS/REVIEW/FAIL criteria make sense
    ↓
Deploy untested
```

**With metaskills**:
```
User needs new agent
    ↓
"Create an agent for [task]"
    ↓
agent-creator generates comprehensive spec
    ↓
agent-tester validates under pressure
    ↓
Production-ready agent in minutes
```

---

## Hook System

### Event-Driven Automation

Hooks execute shell commands in response to events.

**9 available events**:

1. **PreToolUse**: Before Claude uses a tool
2. **PostToolUse**: After Claude uses a tool (used by auto-format)
3. **Start**: When conversation starts
4. **Stop**: When conversation stops (used by session-state reminder)
5. **SubagentStart**: When agent starts
6. **SubagentStop**: When agent finishes (used by ADR suggestion)
7. **UserPromptSubmit**: When user sends message
8. **Error**: When error occurs
9. **TokenLimit**: When approaching token limit

### Hook Configuration

**`.claude/settings.json`**:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "bash .claude/hooks/auto-format.sh \"{{file_path}}\" \"{{tool_name}}\""
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "command": "bash .claude/hooks/suggest-session-state-update.sh"
      }
    ],
    "SubagentStop": [
      {
        "matcher": "*",
        "command": "bash .claude/hooks/suggest-adr.sh \"{{agent_name}}\" \"{{agent_output}}\""
      }
    ]
  }
}
```

### Hook Design Patterns

#### Pattern 1: Auto-Formatting

```bash
# auto-format.sh
FILE_PATH="$1"
TOOL_NAME="$2"

case "$FILE_PATH" in
  *.js|*.jsx|*.ts|*.tsx)
    prettier --write "$FILE_PATH"
    ;;
  *.py)
    black "$FILE_PATH"
    ;;
  *.go)
    gofmt -w "$FILE_PATH"
    ;;
esac
```

**Trigger**: After Edit or Write tool usage
**Purpose**: Consistent code formatting without manual intervention

#### Pattern 2: Documentation Reminders

```bash
# suggest-session-state-update.sh
SESSION_STATE="./docs/SESSION_STATE.md"

if [ -f "$SESSION_STATE" ]; then
  LAST_MODIFIED=$(stat -f %m "$SESSION_STATE")
  NOW=$(date +%s)
  DIFF=$((NOW - LAST_MODIFIED))

  if [ $DIFF -gt 3600 ]; then  # > 1 hour
    echo "💡 Consider updating SESSION_STATE.md (last updated $((DIFF / 3600)) hours ago)"
  fi
fi
```

**Trigger**: When conversation stops
**Purpose**: Maintain current episodic memory

#### Pattern 3: Decision Documentation

```bash
# suggest-adr.sh
AGENT_OUTPUT="$2"

# Check for decision keywords
if echo "$AGENT_OUTPUT" | grep -iE "(decided|chose|selected|pattern|architecture|design|approach|strategy|trade-off)"; then
  echo "📋 Detected architectural decision. Consider creating an ADR in docs/decisions/"
fi
```

**Trigger**: When agent finishes (SubagentStop)
**Purpose**: Systematic decision documentation

---

## Auto-Documentation System

### Living Documentation Architecture

The auto-documentation system is Conductor's flagship feature - it automatically maintains living documentation with zero manual work.

#### Design Goals

1. **Zero Manual Overhead** - Docs update automatically, never require manual edits
2. **Always Current** - Docs reflect actual state, never stale
3. **Session Continuity** - Resume work instantly with full context
4. **Progressive Disclosure** - Load only needed context (efficient token usage)
5. **Project Agnostic** - Works for any project type or structure

#### System Components

```
Auto-Documentation System
├── Bootstrap Agent (auto-docs-bootstrap)
│   ├── Initializes doc structure
│   ├── Creates foundation documents
│   └── Sets up automation hooks
│
├── Maintainer Agent (auto-docs-maintainer)
│   ├── Updates component docs
│   ├── Tracks progress
│   ├── Creates ADR drafts
│   └── Loads context
│
├── Document Templates
│   ├── PROJECT_OVERVIEW.md
│   ├── CURRENT_TASK.md
│   ├── OPEN_QUESTIONS.md
│   ├── ROADMAP.md
│   ├── CONSTRAINTS.md
│   ├── ARCHITECTURE.md
│   ├── component-template.md
│   └── work-package-template.md
│
└── Automation Hooks
    ├── update-component-docs.sh
    ├── update-current-task.sh
    ├── create-adr-draft.sh
    └── session-start-context.sh
```

#### Automation Flow

**1. Code Change Detection (PostToolUse Hook)**

```
Developer edits code
    ↓
PostToolUse(Edit|Write) hook triggers
    ↓
update-component-docs.sh runs
    ↓
Analyzes changed file for interface changes
    ↓
Invokes auto-docs-maintainer agent
    ↓
Updates docs/components/[component].md
    ↓
Developer gets fresh component docs (automatic!)
```

**2. Progress Tracking (Stop Hook)**

```
Session ends / Claude stops responding
    ↓
Stop hook triggers
    ↓
update-current-task.sh runs
    ↓
Reviews conversation for work completed
    ↓
Invokes auto-docs-maintainer agent
    ↓
Updates CURRENT_TASK.md progress checklist
    ↓
Optionally updates PROJECT_OVERVIEW.md if milestone reached
```

**3. Decision Capture (SubagentStop Hook)**

```
Agent completes work (e.g., architecture discussion)
    ↓
SubagentStop hook triggers
    ↓
create-adr-draft.sh runs
    ↓
Scans agent output for decision keywords
    ↓
If decision detected:
  ↓
  Invokes auto-docs-maintainer agent
  ↓
  Extracts decision context and consequences
  ↓
  Creates docs/decisions/YYYY-MM-DD-[title].md
  ↓
  Developer reviews and refines ADR
```

**4. Context Loading (SessionStart Hook)**

```
New session begins
    ↓
SessionStart hook triggers
    ↓
session-start-context.sh runs
    ↓
Reads CURRENT_TASK.md, OPEN_QUESTIONS.md
    ↓
Reads recent decisions (last 3 ADRs)
    ↓
Generates context summary
    ↓
Developer immediately knows where they left off
```

#### Document Lifecycle

**Foundation Documents** (created at bootstrap):
- `PROJECT_OVERVIEW.md` - High-level status (updates on milestones)
- `CURRENT_TASK.md` - Active work (updates frequently)
- `OPEN_QUESTIONS.md` - Living questions (updates as answered)
- `ROADMAP.md` - Work planning (updates as tasks complete)
- `CONSTRAINTS.md` - Project boundaries (rarely changes)
- `ARCHITECTURE.md` - System structure (updates on major changes)

**Generated Documents** (created as needed):
- `docs/components/[name].md` - Per-component docs (created on first code edit)
- `docs/decisions/YYYY-MM-DD-[title].md` - ADRs (created when decisions made)
- `docs/WORK_PACKAGES/[name].md` - Rich task metadata (created for complex features)

#### Progressive Disclosure Pattern

Instead of loading entire codebase:

```
Level 1: High-Level Context (1-2k tokens)
  ├── PROJECT_OVERVIEW.md
  └── ARCHITECTURE.md

Level 2: Current Work (1-2k tokens)
  ├── CURRENT_TASK.md
  ├── OPEN_QUESTIONS.md
  └── Recent decisions (last 3)

Level 3: Specific Components (2-5k tokens)
  ├── Relevant component docs
  └── Related ADRs

Level 4: Source Code (5-15k tokens)
  └── Only files needed for current task

Total: 10-25k tokens (vs 50-100k for naive approach)
```

This keeps Claude's context window efficient and responses fast.

#### Integration with Other Systems

**Hooks Integration**:
- Hooks trigger agent invocations
- Agents read/write docs
- Docs provide context to agents
- Circular, self-reinforcing system

**Agent Integration**:
- All agents reference component docs during analysis
- code-reviewer reads component interfaces
- debugger uses ARCHITECTURE.md for system understanding
- Agents contribute to ADRs when making decisions

**Metaskill Integration**:
- agent-creator documents new agents in components/
- skill-creator documents new skills
- agent-tester validates agents reference correct docs

#### Token Efficiency

**Without auto-docs** (manual context gathering):
- Session start: "What was I working on?" → Read 10+ files → 30-50k tokens
- Code review: "What does this component do?" → Search codebase → 20-30k tokens

**With auto-docs** (progressive disclosure):
- Session start: Read CURRENT_TASK.md → 1k tokens
- Code review: Read component doc → 500 tokens

**Savings**: 60-80% fewer tokens for context management!

#### User Experience Flow

**Day 1: Bootstrap**
```
User: "Bootstrap auto-docs for my SaaS platform"
System: [Asks 4 questions, creates docs, sets up hooks]
Time: 2 minutes
```

**Day 2-N: Automatic Maintenance**
```
User: [Codes normally, makes decisions, commits]
System: [Docs update automatically via hooks]
Manual work: 0 minutes
```

**Week Later: Resume**
```
User: [Starts new session]
System: [Loads context summary automatically]
Result: Instant productivity, zero context loss
```

#### Design Decisions

**Why hooks instead of agent polling?**
- Event-driven > polling (more efficient)
- Hooks are native to Claude Code
- No background processes needed

**Why separate bootstrap and maintainer agents?**
- Bootstrap is one-time setup (different concerns)
- Maintainer runs frequently (needs to be fast)
- Separation of responsibilities

**Why templates instead of hardcoded docs?**
- Projects have different needs
- Users can customize templates
- Easier to extend for new doc types

**Why progressive disclosure?**
- Claude's context window is finite
- Loading everything wastes tokens
- Hierarchical loading is more efficient

**Why auto-create ADRs?**
- Decisions get lost in conversation
- Manual ADR creation has high friction
- Auto-draft reduces barrier (user just reviews/refines)

#### Future Enhancements

**Planned**:
- Hook customization UI (adjust sensitivity, disable specific hooks)
- Multi-language template support (documentation in different languages)
- Team sync features (conflict resolution for concurrent edits)
- AI-powered doc search (RAG over all documentation)

**Under Consideration**:
- Visual documentation (auto-generate diagrams from code)
- Doc diff summaries (what changed since last session)
- Documentation quality metrics (completeness, staleness detection)

---

## MCP Integration Layer

### Model Context Protocol Design

MCP enables Claude to interact with external tools and APIs.

**Design principles** (from Jesse Vincent):

1. **Flexibility Over Rigidity**: Accept multiple input formats
2. **Progressive Disclosure**: Basic info upfront, details when needed
3. **Recovery-Focused**: Return partial results over hard failures
4. **Human-Readable Errors**: Explain what went wrong and how to fix
5. **Simplicity Wins**: Single dispatcher tool can outperform multi-tool APIs

### MCP Architecture

```
Claude Code
    ↓
MCP Client (.claude/.mcp.json)
    ↓
┌─────────────────────────────────────┐
│ MCP Servers                         │
├─────────────────────────────────────┤
│ GitHub    (issues, PRs, repos)      │
│ Supabase  (database queries)        │
│ Figma     (design files)            │
│ Linear    (project management)      │
│ Slack     (notifications)           │
└─────────────────────────────────────┘
    ↓
External APIs
```

### Token Efficiency

**Example from Jesse's blog**:

**Multi-tool API** (13,678 tokens):
```
Tool 1: fetch_page (detailed docs)
Tool 2: get_links (detailed docs)
Tool 3: extract_text (detailed docs)
... [10 more tools]
```

**Single dispatcher** (947 tokens):
```
Tool: web_action
- Accepts: URL, action (fetch/links/text/etc.)
- Returns: Requested data
- Errors: Human-readable guidance
```

**14x reduction** in context usage!

### Security Model

**Never hardcode tokens**:

```json
// ❌ NEVER DO THIS
{
  "authentication": {
    "token": "ghp_actual_token_here"
  }
}

// ✅ ALWAYS USE ENVIRONMENT VARIABLES
{
  "authentication": {
    "type": "token",
    "envVar": "GITHUB_TOKEN"
  }
}
```

---

## Decision Framework

### PASS/REVIEW/FAIL Structure

Every agent uses a three-tier decision framework:

#### ✅ PASS

**Criteria**: Meets all quality thresholds
**Action**: Approve for production / Continue / Accept

**Example** (code-reviewer):
- No security vulnerabilities
- Code quality meets standards
- Tests pass and coverage adequate
- Documentation complete

#### ⚠️ REVIEW

**Criteria**: Minor issues or non-critical concerns
**Action**: Fix before production / Document risk acceptance / Require review

**Example** (code-reviewer):
- Medium severity issues
- Missing documentation
- Low test coverage (but not critical)
- Performance concerns (but within SLAs)

#### ❌ FAIL

**Criteria**: Critical issues that block deployment
**Action**: Block deployment / Require immediate fix / Escalate

**Example** (code-reviewer):
- SQL injection vulnerabilities
- Broken authentication
- Hard-coded secrets
- Critical logic errors

### Why Three Tiers?

**Binary PASS/FAIL is insufficient**:
```
Binary system:
  Perfect code → PASS
  Any issue → FAIL

Reality:
  Most code has minor issues
  Need to distinguish critical vs. minor
  Need guidance on what to do
```

**Three tiers match reality**:
```
PASS: Ship it
REVIEW: Fix this first, then ship
FAIL: Don't ship until critical issues resolved
```

---

## Token Optimization

### Progressive Disclosure

Load context incrementally to manage token usage:

**Anti-pattern** (load everything upfront):
```
1. Read entire codebase (100,000 tokens)
2. Analyze specific function (500 tokens)
Total: 100,500 tokens
```

**Best practice** (progressive disclosure):
```
1. Search for relevant files (100 tokens)
2. Read specific file (1,000 tokens)
3. Analyze function (500 tokens)
Total: 1,600 tokens
```

### Agent Specification Length

**Target**: 500+ words per agent

**Rationale**:
- Too short (< 300 words): Lacks specificity, generic responses
- Optimal (500-800 words): Comprehensive without bloat
- Too long (> 1500 words): High token cost, low marginal value

### Example Optimization

**Before** (generic, 200 words):
```markdown
## Role
I review code for quality and security.

## Responsibilities
- Check code quality
- Find bugs
- Suggest improvements
```

**After** (specific, 600 words):
```markdown
## Role
I perform systematic code review focusing on OWASP Top 10 vulnerabilities,
code quality metrics (complexity, duplication, test coverage), and
language-specific best practices (JavaScript/Python/Go/Rust).

## Core Responsibilities
1. Security Analysis
   - SQL injection (parameterized queries, ORM usage)
   - XSS (input sanitization, output encoding)
   - CSRF (token validation)
   ...

2. Code Quality
   - Cyclomatic complexity (< 10 per function)
   - Code duplication (DRY principle)
   - Test coverage (> 80% for critical paths)
   ...

[Continues with domain expertise, examples, PASS/REVIEW/FAIL criteria...]
```

**Result**: More specific, actionable guidance without excessive token cost.

---

## Extension Patterns

### Adding New Domains

**Steps**:

1. Create domain directory:
```bash
mkdir .claude/agents/your-domain
mkdir .claude/skills/your-domain
```

2. Use agent-creator metaskill:
```
You: "Create an agent for [domain-specific task]"
Claude: [Launches agent-creator]
        [Generates agent with domain expertise]
```

3. Test with agent-tester:
```
agent-creator automatically delegates to agent-tester
```

4. Update TAXONOMY.md:
```markdown
## your-domain

### Agents
- **agent-name**: Description
```

### Creating Custom Hooks

**Example**: Notify team on production deployment

```bash
# .claude/hooks/notify-deployment.sh
#!/bin/bash

AGENT_NAME="$1"
AGENT_OUTPUT="$2"

if [[ "$AGENT_NAME" == "deployment-troubleshooter" ]]; then
  if echo "$AGENT_OUTPUT" | grep -i "deployment successful"; then
    # Send Slack notification via MCP
    echo "🚀 Notifying team of successful deployment"
  fi
fi
```

**Register in settings.json**:
```json
{
  "hooks": {
    "SubagentStop": [
      {
        "matcher": "*",
        "command": "bash .claude/hooks/notify-deployment.sh \"{{agent_name}}\" \"{{agent_output}}\""
      }
    ]
  }
}
```

### Creating Custom MCP Integrations

**Example**: Notion integration

```json
{
  "mcpServers": {
    "notion": {
      "transport": "http",
      "url": "https://api.notion.com/v1",
      "description": "Notion database and page operations",
      "tools": ["query-database", "create-page", "update-page"],
      "authentication": {
        "type": "token",
        "envVar": "NOTION_API_KEY"
      }
    }
  }
}
```

**Usage**:
```
You: "Add this to my Notion database"
Claude: [Uses Notion MCP to create page]
```

---

## Comparison with Alternatives

### vs. Custom Prompts

| Aspect | Custom Prompts | Conductor |
|--------|----------------|-----------|
| Reusability | Copy-paste between projects | Framework-level reuse |
| Consistency | Varies by user memory | Enforced structure |
| Specialization | Generic instructions | Domain-specific expertise |
| Testing | Manual | Pressure-tested metaskills |
| Extension | Edit prompts manually | Metaskills generate agents |

### vs. Other Agent Frameworks

| Aspect | Generic Frameworks | Conductor |
|--------|-------------------|-----------|
| Integration | External to Claude Code | Native Claude Code plugin |
| Episodic Memory | External databases | SESSION_STATE.md (local) |
| Automation | Separate workflow tools | Built-in hooks |
| Quality Framework | Tool-specific | Universal PASS/REVIEW/FAIL |
| Self-Improvement | Static | Metaskills create/test agents |

---

## Design Trade-offs

### Trade-off 1: Specialization vs. Simplicity

**Choice**: Specialized agents over single general-purpose agent

**Benefits**:
- Deep domain expertise
- Consistent quality within domain
- Clear invocation triggers

**Costs**:
- More agents to maintain
- User needs to know which agent to use
- Higher total token usage (more agent definitions)

**Mitigation**: Metaskills automate agent creation, comprehensive documentation

### Trade-off 2: Mandatory Skills vs. User Autonomy

**Choice**: Allow mandatory skills (`when_mandatory: true`)

**Benefits**:
- Critical operations never skipped
- Consistent quality enforcement
- Prevents common mistakes

**Costs**:
- Less user control
- Potential for over-automation
- Could slow down rapid prototyping

**Mitigation**: Use sparingly, only for critical safety checks

### Trade-off 3: Token Usage vs. Completeness

**Choice**: 500+ word agent specifications

**Benefits**:
- Comprehensive domain expertise
- Concrete examples for guidance
- Consistent quality across sessions

**Costs**:
- Higher token usage per agent invocation
- Slower agent activation (more to load)

**Mitigation**: Progressive disclosure, optimize agent specs, use task delegation

---

## Future Architecture

### Planned Enhancements (v2.0)

1. **Agent Composition**: Chain agents into workflows
```yaml
workflow: code-review-and-deploy
steps:
  - agent: code-reviewer
  - agent: security-auditor
  - agent: deployment-troubleshooter
```

2. **Context Caching**: Reuse agent definitions across sessions
```
First invocation: Load code-reviewer (500 tokens)
Subsequent: Use cached version (0 tokens)
```

3. **Performance Metrics**: Track agent usage and quality
```json
{
  "code-reviewer": {
    "invocations": 127,
    "avg_decision": "REVIEW",
    "false_positives": 3,
    "false_negatives": 1
  }
}
```

4. **Visual Workflow Builder**: Diagram agent interactions
```
[User Request] → code-reviewer → [Delegates to] → security-auditor
                                                ↓
                                        [Returns findings]
                                                ↓
                                    [code-reviewer synthesizes]
```

---

**Version**: 1.2.0
**Last Updated**: 2025-11-15
**License**: MIT
