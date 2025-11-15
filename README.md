# Conductor

<p align="center">
  <strong>Orchestrate AI-augmented workflows with specialized agents, skills, and automation</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.1.0-blue" alt="Version 1.1.0">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
  <img src="https://img.shields.io/badge/Claude%20Code-required-orange" alt="Claude Code Required">
  <img src="https://img.shields.io/badge/agents-13-purple" alt="13 Agents">
  <img src="https://img.shields.io/badge/auto--docs-enabled-red" alt="Auto-docs Enabled">
</p>

**Version**: 1.1.0
**Date**: 2025-11-15
**License**: MIT

---

## What is Conductor?

**Conductor** is a production-ready framework for zero-friction AI-augmented development. It provides specialized agents, auto-documentation, and automation hooks that make AI-assisted coding feel effortless.

**Purpose**: Reusable agent infrastructure + automatic living documentation for software engineering, ML workflows, data science, DevOps, security, and beyond.

**Core Innovation**: Your documentation updates automatically as you code. Resume work instantly with full context. Zero manual overhead.

---

## Overview

This framework provides a complete system for creating, managing, and using specialized AI agents and skills across multiple domains (software engineering, ML workflows, testing, etc.).

**Key Features**:
- **🔥 Auto-Documentation System** - Living docs that update automatically (zero manual work!)
- **🤖 Specialized Agents** - 13+ agents for code review, debugging, ML workflows, security, etc.
- **⚡ Automation Hooks** - Trigger updates on code changes, decisions, session events
- **📚 Progressive Disclosure** - Smart context loading (never overwhelm Claude's context window)
- **🎯 Meta-Agents** - Agents that create and test other agents (self-improving framework)
- **✅ PASS/REVIEW/FAIL Framework** - Consistent decision-making across all agents
- **🔄 Session Continuity** - Resume work instantly with full context recovery

---

## Quick Start

### 1. Directory Structure

```
.claude/
├── agents/                      # Specialized agents (explicit invocation)
│   ├── software-engineering/
│   │   └── code-reviewer.md     ✅ READY
│   ├── ml-workflow/
│   │   └── oracle-calibration.md ✅ READY
│   ├── testing/
│   ├── collaboration/
│   └── meta/                    # Agents that create agents
│       ├── agent-creator.md     ✅ READY
│       ├── skill-creator.md     ✅ READY
│       └── agent-tester.md      ✅ READY
│
├── skills/                      # Auto-invoked capabilities
│   ├── software-engineering/
│   │   └── refactor-extract-function.md ✅ READY
│   └── ml-workflow/
│
├── AGENT-TEMPLATE.md            ✅ READY
├── SKILL-TEMPLATE.md            ✅ READY
│
├── hooks/                       # Automation hooks
│   ├── update-component-docs.sh      ✅ READY
│   ├── update-current-task.sh        ✅ READY
│   ├── create-adr-draft.sh           ✅ READY
│   └── session-start-context.sh      ✅ READY
│
└── templates/docs/              # Auto-doc templates
    ├── PROJECT_OVERVIEW.md
    ├── CURRENT_TASK.md
    ├── OPEN_QUESTIONS.md
    └── ... (full doc system)

docs/
├── PROJECT_OVERVIEW.md          # Auto-maintained project status
├── CURRENT_TASK.md              # Auto-tracked current work
├── OPEN_QUESTIONS.md            # Living question log
├── ROADMAP.md                   # Auto-updated work planning
├── AUTO_DOCS_GUIDE.md           # Complete auto-docs guide
├── TAXONOMY.md                  # Complete catalog of agents
├── HOOKS_GUIDE.md               # Hook documentation
├── components/                  # Auto-maintained component docs
└── decisions/                   # Auto-created decision records
```

### 2. Initialize Auto-Documentation (New Projects)

**The magic feature**: Your docs update automatically as you code!

```bash
# In your project, say to Claude:
"Bootstrap auto-docs for my e-commerce platform with React and Node.js"

# Claude creates:
# ✅ Complete docs structure (PROJECT_OVERVIEW, CURRENT_TASK, etc.)
# ✅ Automation hooks (updates on code changes, decisions, commits)
# ✅ Component documentation templates
# ✅ Architecture Decision Records (ADRs)

# From now on:
# - Docs stay fresh automatically
# - Context loads instantly at session start
# - Zero manual documentation work!
```

**What you get**:
- **Automatic updates** when you edit code → component docs refresh
- **Progress tracking** when session ends → CURRENT_TASK updates
- **Decision records** when architectural choices made → ADRs created
- **Context loading** when session starts → instant resumption

See: [AUTO_DOCS_GUIDE.md](docs/AUTO_DOCS_GUIDE.md) for complete guide.

### 3. Using Existing Agents

**Invoke code-reviewer**:
```
You: "Review this authentication logic for security vulnerabilities"

Claude: [Reads .claude/agents/software-engineering/code-reviewer.md]
Claude: [Performs systematic security review using OWASP Top 10]
Claude: [Returns PASS/REVIEW/FAIL with specific findings]
```

**Invoke oracle-calibration**:
```
You: "Calibrate the LLM for sentiment scoring before labeling 10k articles"

Claude: [Reads .claude/agents/ml-workflow/oracle-calibration.md]
Claude: [Samples 200 articles, runs calibration, analyzes distributions]
Claude: [Provides PASS/REVIEW/FAIL recommendation with cost estimates]
```

### 3. Using Skills (Auto-Invoked)

**Skills activate automatically** when Claude detects applicable scenarios:

```
You: "This function is 50 lines long and hard to read"

Claude: [Automatically invokes refactor-extract-function skill]
Claude: [Identifies code blocks to extract]
Claude: [Performs extraction with before/after examples]
```

**Note**: Skills are marked `when_mandatory: true` - Claude MUST use them when applicable.

### 4. Creating New Agents

**Use agent-creator metaskill**:

```
You: "Create an agent for database migration validation"

Claude: [Reads .claude/agents/meta/agent-creator.md]
Claude: [Reads AGENT-TEMPLATE.md]
Claude: [Researches database migration best practices]
Claude: [Fills template with comprehensive content]
Claude: [Saves to .claude/agents/software-engineering/database-migration-validator.md]
Claude: [Invokes agent-tester to pressure-test the new agent]
Claude: "✅ Agent created and tested. Ready for use."
```

### 5. Creating New Skills

**Use skill-creator metaskill**:

```
You: "Create a skill for generating Jest unit tests"

Claude: [Reads .claude/agents/meta/skill-creator.md]
Claude: [Reads SKILL-TEMPLATE.md]
Claude: [Defines triggers, process steps, examples]
Claude: [Saves to .claude/skills/software-engineering/test-generator-jest.md]
Claude: "✅ Skill created. Will auto-invoke when new functions are created."
```

### 6. Pressure Testing Agents

**Use agent-tester metaskill**:

```
You: "Pressure-test the code-reviewer agent under time pressure"

Claude: [Reads .claude/agents/meta/agent-tester.md]
Claude: [Simulates production outage scenario]
Claude: [Tests if agent maintains security checks despite urgency]
Claude: [Generates test report with PASS/REVIEW/FAIL]
```

---

## Framework Components

### Agents (Explicit Invocation)

**Software Engineering**:
- ✅ **code-reviewer** - Security, quality, performance review
- 🔄 **debugger** - Systematic root cause analysis (to be generated)
- 🔄 **refactoring-guide** - Code improvement strategies (to be generated)
- 🔄 **deployment-assistant** - CI/CD, deployment management (to be generated)
- 🔄 **architecture-advisor** - System design patterns (to be generated)

**ML Workflow**:
- ✅ **oracle-calibration** - Validate LLM labeling quality
- 🔄 **dataset-qa** - Dataset quality assurance (to be generated)
- 🔄 **model-evaluator** - Model performance assessment (to be generated)
- 🔄 **training-advisor** - Training strategy guidance (to be generated)

**Meta** (Self-Improvement):
- ✅ **agent-creator** - Creates new agents
- ✅ **skill-creator** - Creates new skills
- ✅ **agent-tester** - Pressure-tests agents

### Skills (Auto-Invoked)

**Software Engineering**:
- ✅ **refactor-extract-function** - Extract code into functions
- 🔄 **refactor-inline-variable** - Inline unnecessary variables (to be generated)
- 🔄 **security-scan-sql-injection** - Detect SQL injection (to be generated)
- 🔄 **security-scan-xss** - Detect XSS vulnerabilities (to be generated)
- 🔄 **test-generator-jest** - Generate Jest tests (to be generated)
- 🔄 **api-design-rest** - REST API patterns (to be generated)

**ML Workflow**:
- 🔄 **validate-dataset-schema** - Schema validation (to be generated)
- 🔄 **train-model-regression** - Regression training (to be generated)

---

## Key Concepts

### 1. Agents vs Skills

| Aspect | Agents | Skills |
|--------|--------|--------|
| **Invocation** | Explicit (user asks) | Automatic (Claude decides) |
| **Scope** | Complex multi-step tasks | Focused single capabilities |
| **Example** | "Review this PR for security" | "Extract this function" |
| **Storage** | `.claude/agents/{domain}/` | `.claude/skills/{domain}/` |

### 2. Mandatory Skills

When a skill exists for a task, **Claude MUST use it**:

```yaml
when_mandatory: true  # Enforces usage when applicable
```

**Philosophy**: Skills codify best practices. Once created, they become mandatory to ensure consistency.

### 3. PASS/REVIEW/FAIL Framework

All agents use this decision framework:

- ✅ **PASS**: Criteria met, proceed
- ⚠️ **REVIEW**: Concerns but not blocking
- ❌ **FAIL**: Critical issues, block

**Example** (code-reviewer):
- PASS: No critical security issues
- REVIEW: Medium security concerns
- FAIL: SQL injection vulnerability detected

### 4. Persuasion Framework

All agents implement Cialdini's principles:

1. **Authority**: "I am the designated security reviewer"
2. **Commitment**: "By requesting review, you've committed to addressing issues"
3. **Social Proof**: "Top engineering teams use systematic code review"
4. **Consistency**: "Every code change undergoes rigorous review"

**Purpose**: Ensures agents actually follow best practices under pressure (not just acknowledge them).

### 5. Pressure Testing

**agent-tester** validates agents under realistic constraints:

- **Time Pressure**: Production outages, tight deadlines
- **Sunk Cost**: User invested significant time in approach
- **Authority**: Senior developer approved the code
- **Incomplete Info**: Missing requirements

**Philosophy**: Agents must maintain standards even when users resist.

### 6. Progressive Disclosure

Load context only when needed:

1. **Start broad**: Read SESSION_STATE.md, agent spec
2. **Navigate**: Find relevant domain/component
3. **Load specific**: Read only necessary code/data
4. **Total**: 10k tokens vs 100k+ for full codebase

---

## Agent Structure

Every agent includes:

```yaml
---
name: agent-name
description: >
  Brief description.
  Use when:
  - Scenario 1
  - Scenario 2
  - Scenario 3
examples:
  - "Concrete example 1"
  - "Concrete example 2"
  - "Concrete example 3"
domain: software-engineering | ml-workflow | testing | collaboration | meta
tools: Read, Write, Bash, Grep, Glob  # Minimal permissions
model: sonnet | haiku | opus
when_mandatory: true | false
---

# Agent Name

## Role
[Brief identity statement]

## Core Responsibilities
1. [Primary]
2. [Secondary]
3. [Tertiary]

## Domain Expertise
[Specific knowledge areas]

## Integration Philosophy
[How it fits into workflows, when to delegate]

## Best Practices
- [Practice 1]
- [Practice 2]

## Constraints
- [Limitation 1]
- [Limitation 2]

## Success Metrics
[Measurable outcomes]

## Decision Criteria

### ✅ PASS
[Conditions]
**Action**: [What to do]

### ⚠️ REVIEW
[Conditions]
**Action**: [What to do]

### ❌ FAIL
[Conditions]
**Action**: [What to do]

## Delegation Patterns
[Which agents/skills to invoke]

## Detailed Examples
[3+ concrete scenarios with code/data]

## Persuasion Framework
[Authority, Commitment, Social Proof, Consistency]

## Anti-Patterns to Avoid
[Common mistakes]

## Related Agents/Skills
[Coordination points]
```

---

## Skill Structure

Every skill includes:

```yaml
---
name: skill-name
description: >
  What it does.
  Use when:
  - Trigger 1
  - Trigger 2
examples:
  - "Example 1"
  - "Example 2"
domain: software-engineering | ml-workflow | testing
allowed-tools: Read  # Minimal permissions
when_mandatory: true
---

# Skill Name

## What This Skill Does
[Clear description]

## When to Use This Skill
[Detailed triggers]

## When NOT to Use This Skill
[Exclusions]

## Prerequisites
- [Requirement 1]
- [Requirement 2]

## Step-by-Step Process
### Step 1: [Name]
**Input**: [What you need]
**Output**: [What you produce]
**Validation**: [How to verify]

[Repeat for each step]

## Quality Checks
- ✅ [Check 1]
- ✅ [Check 2]

## Common Pitfalls
- ❌ [Pitfall 1]: [How to avoid]
- ❌ [Pitfall 2]: [How to avoid]

## Examples
### Example 1: [Scenario]
**Before**:
```language
[code before]
```

**After**:
```language
[code after]
```

**Explanation**: [Why this improves code]

[Repeat for 3+ examples]

## Success Criteria
[Measurable outcomes]

## Related Skills/Agents
[Coordination points]
```

---

## Workflow Examples

### Example 1: Code Review Workflow

```
1. User: "Review this PR for security issues"

2. Claude:
   - Invokes code-reviewer agent
   - Reads PR files
   - Automatically invokes security-scan-sql-injection skill (if SQL code present)
   - Automatically invokes refactor-extract-function skill (if long methods found)
   - Returns comprehensive review with PASS/REVIEW/FAIL

3. If FAIL:
   - User fixes issues
   - Requests re-review
   - Claude re-invokes code-reviewer

4. If PASS:
   - User merges PR
```

### Example 2: ML Pipeline Workflow

```
1. User: "I want to train a sentiment analysis model"

2. Claude:
   - Suggests: "First, let's calibrate the LLM for labeling"
   - Invokes oracle-calibration agent
   - Runs calibration on 200-sample dataset
   - Returns PASS/REVIEW/FAIL with cost estimates

3. If PASS:
   - User: "Proceed with full batch labeling"
   - Claude: Runs batch labeling (10k samples)
   - After labeling: Invokes dataset-qa agent
   - Validates dataset quality

4. If dataset-qa PASS:
   - User: "Train the model"
   - Claude: Invokes training-advisor agent
   - Recommends hyperparameters, strategy
```

### Example 3: Creating New Capabilities

```
1. User: "I need an agent for API versioning strategy"

2. Claude:
   - Invokes agent-creator metaskill
   - Reads AGENT-TEMPLATE.md
   - Researches API versioning best practices
   - Generates comprehensive agent spec
   - Saves to .claude/agents/software-engineering/api-versioning-advisor.md
   - Invokes agent-tester to pressure-test

3. agent-tester:
   - Tests under time pressure
   - Tests with user resistance
   - Returns PASS/REVIEW/FAIL

4. If PASS:
   - Agent is production-ready
   - User can now invoke it
```

---

## Extending the Framework

### Adding New Domains

1. Create directory: `.claude/agents/{new-domain}/`
2. Create directory: `.claude/skills/{new-domain}/`
3. Update `docs/TAXONOMY.md` with new domain
4. Use agent-creator to generate domain-specific agents
5. Use skill-creator to generate domain-specific skills

**Example Domains**:
- `data-science` (analysis, visualization)
- `devops` (infrastructure, monitoring)
- `security` (pentesting, compliance)
- `documentation` (technical writing)

### Migrating Existing Custom Agents

**If you have existing agent specifications**:
1. Read your existing agent definition
2. Use agent-creator to convert to Conductor format
3. Save to appropriate domain directory
4. Test with agent-tester to validate quality

**Benefits of migration**:
- Consistent YAML frontmatter structure
- PASS/REVIEW/FAIL decision framework
- Pressure-tested under realistic constraints
- Integration with Conductor's hook and MCP systems

---

## Best Practices

### For Users

1. **Start with metaskills**: Use agent-creator/skill-creator to generate new capabilities
2. **Pressure-test before deployment**: Always run agent-tester on new agents
3. **Keep SESSION_STATE.md updated**: Document progress for context recovery
4. **Use progressive disclosure**: Don't load entire codebase, navigate incrementally
5. **Trust mandatory skills**: If a skill exists, let Claude use it automatically

### For Agent Creators

1. **Include 3-4 concrete examples**: Generic examples reduce usability
2. **Define clear triggers**: "When to use" AND "When NOT to use"
3. **Make decision criteria testable**: Use measurable conditions, not subjective
4. **Implement persuasion framework**: Authority, commitment, social proof, consistency
5. **Document anti-patterns**: Explicitly call out what NOT to do
6. **Minimize tool permissions**: Grant only necessary tools (principle of least privilege)

### For Skill Creators

1. **Single responsibility**: One capability per skill (not multi-function)
2. **Detailed process steps**: Claude needs step-by-step instructions
3. **Before/after code examples**: Show concrete transformations
4. **Quality checks**: Define measurable success criteria
5. **Mark as mandatory**: Set `when_mandatory: true` for established patterns

---

## Roadmap

### ✅ Phase 1 (COMPLETE)
- Directory structure
- Meta-templates
- Metaskills (agent-creator, skill-creator, agent-tester)
- Core SW agents (code-reviewer)
- Core SW skills (refactor-extract-function)
- Core ML agents (oracle-calibration)
- Taxonomy
- Documentation
- Test report

### 🔄 Phase 2 (COMPLETED)
- Generated additional agents (debugger, refactoring-guide, dataset-qa)
- Created SESSION_STATE.md template
- Added hooks configuration (auto-format, session-state reminders, ADR suggestions)
- Created comprehensive hook documentation

### ✅ Phase 3 (COMPLETED)
- Additional domains (data-science, devops, security agents added)
- MCP integrations for external tools (GitHub, Supabase, Figma, Linear, Slack)
- Plugin packaging for distribution (.claude-plugin/plugin.json)

### 📋 Phase 4 (FUTURE)
- Output styles (planning-mode, review-mode, debugging-mode)
- Episodic memory enhancements (vector search, auto-archive)
- Context caching for agent definitions
- Visual workflow builder
- Agent composition and chaining
- Performance metrics tracking

---

## Troubleshooting

### "Claude isn't using my skill"
- Check `when_mandatory: true` is set
- Verify triggers are specific enough
- Ensure skill is in correct domain directory
- Try explicit invocation first to test

### "Agent gives inconsistent results"
- Run agent-tester to identify pressure points
- Check if persuasion framework is implemented
- Verify decision criteria are measurable
- Add more concrete examples to agent spec

### "I don't know which agent to use"
- Check `docs/TAXONOMY.md` for all available agents
- Read agent descriptions and examples
- Start with meta agents if creating new capabilities

---

## Acknowledgments

**Conductor builds upon insights from**:
- **Claude Code official documentation** - Agents, skills, hooks, and MCP patterns
- **Contains Studio** - Domain-based organization and multi-department structure
- **Superpowers by Jesse Vincent** - Mandatory skills, pressure testing, metaskills concepts
- **Cialdini's Influence** - Persuasion framework principles

**Key Innovations in Conductor**:
- **Self-improving framework** - Metaskills that create and test other agents
- **Persuasion-informed design** - Ensures agents maintain standards under pressure
- **Unified decision framework** - PASS/REVIEW/FAIL across all domains
- **Multi-domain from day one** - Scalable architecture supporting diverse cognitive tasks
- **Comprehensive automation** - Hooks for formatting, documentation, and decision tracking

---

## License

MIT License - See LICENSE file

---

## Support

**Issues**: Create GitHub issue
**Questions**: See `docs/` for detailed guides
**Contributing**: Use agent-creator to propose new agents, submit PR

---

**Last Updated**: 2025-11-15
**Version**: 1.0
**Status**: ✅ Production Ready
