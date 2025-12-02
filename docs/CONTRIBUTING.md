# Contributing to Conductor

Thank you for your interest in contributing to Conductor! This document provides guidelines for contributing agents, skills, hooks, documentation, and bug fixes.

---

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How to Contribute](#how-to-contribute)
3. [Contributing Agents](#contributing-agents)
4. [Contributing Skills](#contributing-skills)
5. [Contributing Hooks](#contributing-hooks)
6. [Contributing Documentation](#contributing-documentation)
7. [Reporting Bugs](#reporting-bugs)
8. [Suggesting Features](#suggesting-features)
9. [Development Setup](#development-setup)
10. [Pull Request Process](#pull-request-process)
11. [Style Guide](#style-guide)

---

## Code of Conduct

### Our Pledge

We pledge to make participation in Conductor a harassment-free experience for everyone, regardless of:
- Experience level
- Gender identity and expression
- Sexual orientation
- Disability
- Personal appearance
- Body size
- Race, ethnicity, nationality
- Age
- Religion

### Our Standards

**Positive behavior includes**:
- Using welcoming and inclusive language
- Respecting differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what's best for the community
- Showing empathy towards others

**Unacceptable behavior includes**:
- Trolling, insulting/derogatory comments, personal attacks
- Public or private harassment
- Publishing others' private information
- Other conduct inappropriate in a professional setting

### Enforcement

Violations may be reported to project maintainers. All complaints will be reviewed and investigated promptly and fairly.

---

## How to Contribute

### Ways to Contribute

1. **New Agents** - Add specialized agents for new domains or use cases
2. **New Skills** - Create auto-invoked capabilities for common tasks
3. **New Hooks** - Automate workflows with event-driven scripts
4. **Documentation** - Improve guides, examples, tutorials
5. **Bug Reports** - Identify and report issues
6. **Bug Fixes** - Fix reported issues
7. **Feature Requests** - Suggest new capabilities

### Contribution Workflow

```
1. Fork repository
2. Create feature branch (git checkout -b feature/new-agent)
3. Make changes
4. Test thoroughly
5. Commit with descriptive message
6. Push to fork
7. Submit Pull Request
8. Address review feedback
9. Merge when approved
```

---

## Contributing Agents

### Before Creating an Agent

**Check if agent already exists**:
```bash
# Search existing agents
grep -r "your use case" .claude/agents/

# Check TAXONOMY.md
cat docs/TAXONOMY.md
```

**Check if similar agent exists** that could be extended instead of creating new one.

### Creating a New Agent

#### Method 1: Use agent-creator Metaskill (Recommended)

```
You: "Create an agent for [specific use case]"

Example: "Create an agent for Kubernetes manifest validation"

Claude: [Launches agent-creator]
        [Generates comprehensive agent specification]
        [Tests with agent-tester]
        [Saves to appropriate domain]
```

**Review generated agent** and customize if needed.

#### Method 2: Manual Creation

See `DEVELOPER_GUIDE.md` for detailed instructions.

### Agent Quality Checklist

Before submitting, ensure your agent has:

- [ ] **Valid YAML frontmatter** with all required fields
  - `name` (lowercase-with-hyphens)
  - `description` (with "Use when" triggers)
  - `examples` (3+ concrete examples)
  - `domain`
  - `tools` (minimal permissions)
  - `model` (sonnet/opus/haiku)
  - `when_mandatory` (true/false)

- [ ] **Clear role statement** - "I [verb] [task] by [method]"

- [ ] **Specific responsibilities** (3-5 items, not generic)

- [ ] **Domain expertise** section with actual frameworks/standards

- [ ] **PASS/REVIEW/FAIL criteria** (measurable, not subjective)

- [ ] **3+ detailed examples** with realistic code/data

- [ ] **Persuasion framework** (authority, commitment, social proof, consistency)

- [ ] **Anti-patterns section** - What NOT to do

- [ ] **Pressure-tested** with agent-tester (all scenarios pass)

- [ ] **Documentation updated** (TAXONOMY.md)

### Testing Your Agent

**Requirement**: All agents must pass pressure testing before submission.

```
You: "Test the [agent-name] agent under pressure"

Claude: [Launches agent-tester]
        [Runs 4 pressure scenarios]
        [Returns test report]
```

**Required scenarios**:
1. Time pressure (production outage, tight deadline)
2. Authority pressure (senior developer approved)
3. Sunk cost (user invested significant time)
4. Incomplete information (missing requirements)

**Expected**: Agent maintains quality standards in all scenarios (doesn't skip checks, defer to authority, or rush).

### Agent Submission Template

```markdown
## Description

[Brief description of agent's purpose]

## Use Case

[Specific scenario this agent addresses]

## Domain

[Primary domain: software-engineering, ml-workflow, data-science, devops, security, meta]

## Testing Results

**agent-tester results**:
- Time pressure scenario: ✅ PASS
- Authority pressure scenario: ✅ PASS
- Sunk cost scenario: ✅ PASS
- Incomplete info scenario: ✅ PASS

## Example Usage

```
You: "[Example request]"

Claude: [Launches agent]
        [Shows analysis]
        [Returns PASS/REVIEW/FAIL decision]
```

## Related Agents

[Any agents this integrates with or delegates to]
```

---

## Contributing Skills

### Before Creating a Skill

**Ensure skill is**:
- Focused on single capability (not multi-purpose)
- Auto-invocable (has clear triggers)
- Repeatable (same input → same output)
- Beneficial (provides measurable improvement)

**Check existing skills**:
```bash
find .claude/skills -name "*.md"
```

### Creating a New Skill

#### Method 1: Use skill-creator Metaskill (Recommended)

```
You: "Create a skill for [specific focused task]"

Example: "Create a skill for generating API documentation from code"

Claude: [Launches skill-creator]
        [Defines triggers and process]
        [Generates before/after examples]
        [Saves to domain directory]
```

#### Method 2: Manual Creation

See `DEVELOPER_GUIDE.md` for detailed instructions.

### Skill Quality Checklist

- [ ] **Valid YAML frontmatter** with all fields

- [ ] **Precise triggers** - When to auto-invoke (not vague like "any code")

- [ ] **Exclusion criteria** - When NOT to use

- [ ] **Step-by-step process** (detailed, not high-level)

- [ ] **3+ before/after examples** showing transformations

- [ ] **Quality checks** - How to verify success

- [ ] **Common pitfalls** section

- [ ] **Tested** - Skill auto-invokes when triggers met

- [ ] **`when_mandatory` appropriately set**:
  - `true` for critical/security checks
  - `false` for optional improvements

### Skill Submission Template

```markdown
## Description

[What this skill does]

## Triggers

[Specific conditions when skill should auto-invoke]

## Benefits

[Why this skill improves code/workflow]

## Testing

**Manual test**:
```
You: "[Request that matches triggers]"
Claude: [Skill automatically activates]
```

**Result**: [Describe transformation]

## Examples

[Link to before/after examples in skill file]
```

---

## Contributing Hooks

### Before Creating a Hook

**Ensure hook**:
- Solves real automation need
- Doesn't block unnecessarily
- Has clear trigger event
- Provides actionable feedback

**Review existing hooks**:
```bash
ls .claude/hooks/
cat .claude/settings.json
```

### Creating a New Hook

#### Step 1: Create Shell Script

```bash
# .claude/hooks/your-hook.sh
#!/bin/bash

# Get hook parameters
PARAM1="$1"
PARAM2="$2"

# Exit early if not applicable
if [[ ! "$PARAM1" =~ pattern ]]; then
  exit 0
fi

# Perform automation
# ...

# Provide feedback
echo "✓ Action completed"
```

#### Step 2: Make Executable

```bash
chmod +x .claude/hooks/your-hook.sh
```

#### Step 3: Register in settings.json

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "pattern",
        "command": "bash .claude/hooks/your-hook.sh \"{{param1}}\" \"{{param2}}\""
      }
    ]
  }
}
```

#### Step 4: Test Independently

```bash
# Test hook script directly
bash .claude/hooks/your-hook.sh test-value
```

### Hook Quality Checklist

- [ ] **Script is executable** (`chmod +x`)

- [ ] **Exit early** if hook doesn't apply

- [ ] **Provides feedback** (echo what happened)

- [ ] **Doesn't block** unless critical failure

- [ ] **Handles errors gracefully** (doesn't crash Claude)

- [ ] **Fast execution** (< 1 second for most operations)

- [ ] **Documented** - Comments explain what hook does

- [ ] **Tested independently** before integration

### Hook Submission Template

```markdown
## Description

[What this hook automates]

## Trigger Event

[When hook runs: PostToolUse, Stop, SubagentStop, etc.]

## Use Case

[Problem this hook solves]

## Configuration

```json
{
  "hooks": {
    "EventName": [...]
  }
}
```

## Testing

**Test command**:
```bash
bash .claude/hooks/your-hook.sh test-params
```

**Expected output**:
```
[Show what hook outputs]
```
```

---

## Contributing Documentation

### Types of Documentation Contributions

1. **Guides** - How-to tutorials for specific tasks
2. **Examples** - Real-world usage scenarios
3. **Explanations** - Conceptual documentation (architecture, design)
4. **Reference** - API docs, agent catalogs, configuration options
5. **Improvements** - Fix typos, clarify confusing sections, add diagrams

### Documentation Style Guide

**Writing style**:
- Use active voice ("Create an agent" not "An agent is created")
- Be concise (prefer short sentences and paragraphs)
- Include concrete examples (not just abstract concepts)
- Use code blocks for commands, file paths, code samples
- Use bullet lists for steps or options

**Formatting**:
- Use H1 (`#`) for title only
- Use H2 (`##`) for main sections
- Use H3 (`###`) for subsections
- Use **bold** for emphasis (not *italic*)
- Use `code` for file names, commands, variables

**Examples**:
- Always include before/after examples for transformations
- Use realistic data (not foo/bar unless teaching example)
- Show full context (not just snippets)

### Documentation Checklist

- [ ] **Spell-checked** (no typos)

- [ ] **Technically accurate** (tested all commands/examples)

- [ ] **Clear structure** (headings, sections, TOC if long)

- [ ] **Code blocks** have language hints (```python, ```bash, etc.)

- [ ] **Links work** (both internal and external)

- [ ] **Consistent formatting** with existing docs

- [ ] **Examples tested** (commands work, code runs)

---

## Reporting Bugs

### Before Reporting

**Check if bug already reported**:
- Search GitHub Issues: https://github.com/your-org/conductor/issues

**Try to reproduce**:
- Does it happen consistently?
- Can you identify trigger/steps?

### Bug Report Template

```markdown
**Agent/Skill/Hook**: [Name of component]

**Conductor Version**: 1.0.0

**Claude Code Version**: [Your version]

**Description**: [Clear description of bug]

**Steps to Reproduce**:
1. [First step]
2. [Second step]
3. [...]

**Expected Behavior**: [What should happen]

**Actual Behavior**: [What actually happens]

**Example Input**: [Code, data, or request that triggers bug]

```
[paste example]
```

**Example Output**: [Incorrect output]

```
[paste output]
```

**Additional Context**: [Screenshots, logs, relevant config]
```

### Bug Severity Labels

**Critical** (blocking):
- Security vulnerabilities
- Data loss/corruption
- Complete feature failure

**High** (important):
- Major functionality broken
- Incorrect results in common scenarios
- Performance degradation

**Medium** (affects some users):
- Edge case failures
- Usability issues
- Non-critical errors

**Low** (nice to fix):
- Cosmetic issues
- Rare edge cases
- Minor inconsistencies

---

## Suggesting Features

### Feature Request Template

```markdown
**Feature**: [Short feature name]

**Problem**: [What problem does this solve?]

**Proposed Solution**: [How would this work?]

**Alternatives Considered**: [Other approaches you considered]

**Use Case**: [Specific scenario where this is valuable]

**Example Usage**:

```
You: "[Example request]"
Claude: [How feature would work]
```

**Impact**: [Who benefits? How much?]

**Implementation Complexity**: [Your estimate: Low/Medium/High]
```

### Feature Evaluation Criteria

Features are evaluated on:

1. **Value** - How many users benefit?
2. **Alignment** - Fits Conductor's mission (reusable AI-augmented workflows)?
3. **Complexity** - Implementation cost vs. benefit
4. **Maintenance** - Ongoing maintenance burden
5. **Breaking Changes** - Affects existing users?

---

## Development Setup

### Prerequisites

- Git
- Claude Code (latest version)
- Text editor (VS Code, Vim, etc.)
- Bash (for hooks)

### Fork and Clone

```bash
# Fork on GitHub (click Fork button)

# Clone your fork
git clone https://github.com/your-username/conductor.git
cd conductor

# Add upstream remote
git remote add upstream https://github.com/your-org/conductor.git
```

### Create Feature Branch

```bash
# Update main branch
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/your-feature-name

# Examples:
# feature/add-k8s-agent
# fix/code-reviewer-sql-injection
# docs/improve-quickstart
```

### Install Conductor Locally

```bash
# Copy to Claude plugins
cp -r .claude ~/.claude/

# Make hooks executable
chmod +x .claude/hooks/*.sh

# Restart Claude Code
```

### Make Changes

```bash
# Create new agent
You: "Create an agent for [use case]"

# Test agent
You: "Test the [agent-name] agent"

# Update documentation
vim docs/TAXONOMY.md

# Commit changes
git add .
git commit -m "Add [agent-name] agent for [use case]"
```

### Test Changes

**For agents**:
```
You: "Test the [agent-name] agent under pressure"
# All scenarios must pass
```

**For skills**:
```
You: "[Request matching skill triggers]"
# Verify skill auto-invokes
```

**For hooks**:
```bash
bash .claude/hooks/your-hook.sh test-params
# Verify expected output
```

**For documentation**:
- Spell-check
- Test all code examples
- Verify links work

### Push Changes

```bash
git push origin feature/your-feature-name
```

---

## Pull Request Process

### Before Submitting PR

**Checklist**:
- [ ] Code tested (agents pass agent-tester, skills auto-invoke, hooks work)
- [ ] Documentation updated (TAXONOMY.md, README.md if needed)
- [ ] Commits have descriptive messages
- [ ] Changes follow style guide
- [ ] No merge conflicts with main branch

### PR Title Format

**Good examples**:
- `Add Kubernetes manifest validator agent`
- `Fix code-reviewer SQL injection detection`
- `Improve GETTING_STARTED.md with Docker example`
- `Add generate-openapi-spec skill`

**Bad examples**:
- `Update` (too vague)
- `Fix bug` (which bug?)
- `Agent` (what agent?)

### PR Description Template

```markdown
## Description

[Clear description of what this PR does]

## Type of Change

- [ ] New agent
- [ ] New skill
- [ ] New hook
- [ ] Bug fix
- [ ] Documentation
- [ ] Other: [describe]

## Related Issue

Fixes #[issue number]

## Testing

[How was this tested?]

**For agents**:
- agent-tester results: [PASS/FAIL for each scenario]

**For skills**:
- Auto-invocation test: [description]

**For hooks**:
- Manual test: [command and output]

## Screenshots / Examples

[If applicable, add screenshots or example outputs]

## Checklist

- [ ] Tested thoroughly
- [ ] Documentation updated
- [ ] Follows style guide
- [ ] Commits have descriptive messages
- [ ] No merge conflicts
```

### Review Process

1. **Automated checks run** (linting, validation)
2. **Maintainer reviews** code and tests
3. **Feedback provided** if changes needed
4. **Author addresses feedback**
5. **Maintainer approves** when ready
6. **Merged** to main branch

**Timeline**: Most PRs reviewed within 48 hours.

### After Merge

```bash
# Update your fork
git checkout main
git pull upstream main

# Delete feature branch
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

---

## Style Guide

### Agent Style

**YAML Frontmatter**:
- `name`: lowercase-with-hyphens
- `description`: Include "Use when:" section with 3 triggers
- `examples`: 3-4 concrete examples (not generic)
- `domain`: Choose from existing domains or propose new
- `tools`: Minimal permissions (only what's needed)
- `model`: sonnet (default), opus (complex reasoning), haiku (simple tasks)

**Markdown Content**:
- **Role**: Single sentence, active voice
- **Responsibilities**: 3-5 specific items (not "everything related to X")
- **Domain Expertise**: Actual frameworks/standards (not "best practices")
- **PASS/REVIEW/FAIL**: Measurable criteria with actions
- **Examples**: 500-1000 words total, realistic scenarios

### Skill Style

**YAML Frontmatter**:
- Similar to agents, plus:
- `when_mandatory`: Default false unless critical

**Markdown Content**:
- **Triggers**: Specific conditions (not "any code")
- **Process**: Step-by-step with inputs/outputs
- **Examples**: Before/after transformations (3+ examples)

### Hook Style

**Shell Scripts**:
- Shebang: `#!/bin/bash`
- Exit early if not applicable
- Provide feedback with `echo`
- Don't block unless critical

**Comments**:
- Explain what hook does
- Document parameters
- Note side effects

### Documentation Style

**Structure**:
- H1 for title only
- H2 for main sections
- H3 for subsections
- TOC for docs > 500 words

**Writing**:
- Active voice
- Short sentences
- Concrete examples
- Code blocks with language hints

**Formatting**:
- **Bold** for emphasis
- `code` for file names, commands, variables
- > blockquotes for important notes
- Lists for steps or options

---

## Community

### Communication Channels

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: Questions, general discussion
- **Pull Requests**: Code contributions

### Recognition

Contributors are recognized in:
- Contributor list (README.md)
- Release notes for their contributions
- GitHub contributor badge

### License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## Questions?

- **General questions**: GitHub Discussions
- **Bug reports**: GitHub Issues
- **Documentation**: See `docs/` directory

Thank you for contributing to Conductor!

---

**Version**: 1.2.0
**Last Updated**: 2025-11-15
**License**: MIT
