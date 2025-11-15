# Conductor Developer Guide

**Purpose**: Learn how to extend Conductor by creating custom agents, skills, hooks, and MCP integrations

---

## Table of Contents

1. [Quick Start for Developers](#quick-start-for-developers)
2. [Creating Custom Agents](#creating-custom-agents)
3. [Creating Custom Skills](#creating-custom-skills)
4. [Creating Custom Hooks](#creating-custom-hooks)
5. [Adding MCP Integrations](#adding-mcp-integrations)
6. [Testing Your Extensions](#testing-your-extensions)
7. [Publishing Your Extensions](#publishing-your-extensions)
8. [Best Practices](#best-practices)

---

## Quick Start for Developers

### Prerequisites

1. **Conductor installed** - See `GETTING_STARTED.md`
2. **Basic familiarity** with Claude Code agents and skills
3. **Text editor** for editing Markdown files
4. **Git** (optional, for version control)

### Your First Extension: Custom Agent

**Goal**: Create an agent for validating API documentation

```
You: "Create an agent for validating REST API documentation"

Claude: [Launches agent-creator metaskill]
        [Generates complete agent specification]
        [Saves to .claude/agents/software-engineering/api-docs-validator.md]
        [Tests with agent-tester]
```

**Result**: Production-ready agent in < 5 minutes.

### Your First Extension: Custom Skill

**Goal**: Create a skill for generating TypeScript interfaces from JSON

```
You: "Create a skill that generates TypeScript interfaces from JSON examples"

Claude: [Launches skill-creator metaskill]
        [Generates skill with triggers and process steps]
        [Saves to .claude/skills/software-engineering/generate-ts-interface.md]
```

**Result**: Auto-invoked skill whenever JSON-to-TypeScript conversion needed.

---

## Creating Custom Agents

### Method 1: Using agent-creator (Recommended)

**Fastest and most reliable** - Let the metaskill do the work:

```
You: "Create an agent for [your use case]"

Example: "Create an agent for Kubernetes deployment troubleshooting"
```

**agent-creator will**:
1. Ask clarifying questions (domain, responsibilities, tools needed)
2. Research domain-specific best practices
3. Generate comprehensive agent specification
4. Include 3+ concrete examples
5. Define PASS/REVIEW/FAIL criteria
6. Test with agent-tester

**Review and customize** the generated agent if needed.

### Method 2: Manual Creation

**For advanced developers** who want full control:

#### Step 1: Copy the Template

```bash
cp .claude/AGENT-TEMPLATE.md .claude/agents/your-domain/your-agent.md
```

#### Step 2: Fill YAML Frontmatter

```yaml
---
name: your-agent-name
description: >
  Brief description of what this agent does.
  Use when:
  - Specific scenario 1
  - Specific scenario 2
  - Specific scenario 3
examples:
  - "Concrete example 1"
  - "Concrete example 2"
  - "Concrete example 3"
domain: software-engineering | ml-workflow | data-science | devops | security | meta
tools: Read, Grep, Edit, Write, Bash, Glob  # Only grant what's needed
model: sonnet | opus | haiku
when_mandatory: false
---
```

**Important fields**:

- **name**: Lowercase-with-hyphens (e.g., `api-docs-validator`)
- **description**: Include "Use when" triggers
- **examples**: 3-4 concrete, realistic examples
- **domain**: Choose appropriate domain or create new one
- **tools**: Minimal permissions (principle of least privilege)
- **model**: `sonnet` for most agents, `haiku` for simple tasks, `opus` for complex reasoning

#### Step 3: Define Agent Role and Responsibilities

```markdown
# Your Agent Name

## Role
I [action verb] [specific task] by [methodology/approach].

Example: "I validate REST API documentation by checking completeness, accuracy, and consistency with OpenAPI 3.0 standards."

## Core Responsibilities
1. [Primary responsibility with specific details]
2. [Secondary responsibility]
3. [Tertiary responsibility]

Example:
1. Validate endpoint documentation completeness (all parameters, responses documented)
2. Check for consistency between examples and schema definitions
3. Identify missing error response codes
```

#### Step 4: Define Domain Expertise

```markdown
## Domain Expertise
- [Specific framework/standard expertise]
- [Methodologies known]
- [Tools and best practices]

Example:
- OpenAPI 3.0 specification
- REST API design patterns (resource naming, HTTP methods, status codes)
- Common API documentation issues (missing authentication, undocumented rate limits)
- API versioning strategies
```

#### Step 5: Create PASS/REVIEW/FAIL Criteria

**Make criteria measurable and testable**:

```markdown
## Decision Criteria

### ✅ PASS
- All endpoints have complete documentation
- All parameters include type, description, and examples
- All responses (2xx, 4xx, 5xx) documented
- Authentication requirements clear
- Rate limiting documented

**Action**: Approve API documentation for publication

### ⚠️ REVIEW
- Minor gaps (missing edge case responses)
- Inconsistent formatting
- Some examples missing
- Incomplete error documentation

**Action**: Request documentation improvements before publication

### ❌ FAIL
- Critical endpoints undocumented
- Authentication missing or unclear
- No error response documentation
- Schema and examples contradictory

**Action**: Block publication until documentation complete
```

#### Step 6: Add 3+ Detailed Examples

**Include realistic scenarios with actual code/data**:

```markdown
## Detailed Examples

### Example 1: Complete API Documentation (PASS)

**Input**: OpenAPI spec for user management API

```yaml
paths:
  /users/{id}:
    get:
      summary: Get user by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
          description: Unique user identifier
      responses:
        '200':
          description: User found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
              example:
                id: "550e8400-e29b-41d4-a716-446655440000"
                name: "Jane Doe"
                email: "jane@example.com"
        '404':
          description: User not found
```

**Analysis**:
✅ Endpoint clearly documented
✅ Parameter includes type, format, and description
✅ Success response includes schema and example
✅ Error response documented
✅ Examples match schema

**Decision**: PASS

### Example 2: Missing Error Responses (REVIEW)

**Input**: API endpoint with incomplete error documentation

```yaml
paths:
  /users:
    post:
      summary: Create user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
```

**Analysis**:
✅ Endpoint documented
✅ Request body documented
❌ Missing 400 (validation errors)
❌ Missing 409 (duplicate email)
❌ Missing 401 (authentication required)

**Decision**: REVIEW - Add error response documentation

### Example 3: Critical Gaps (FAIL)

**Input**: API spec with authentication endpoint missing

**Analysis**:
❌ No `/auth` endpoint documented
❌ Authentication scheme not specified
❌ Token format unclear
❌ Cannot use API without authentication docs

**Decision**: FAIL - Block until authentication fully documented
```

#### Step 7: Add Persuasion Framework

**Ensure agent maintains standards under pressure**:

```markdown
## Persuasion Framework

### Authority
"I am the designated API documentation reviewer. My role is to ensure developers can successfully consume this API."

### Commitment
"By requesting documentation review, you've committed to providing complete and accurate API documentation for developers."

### Social Proof
"Leading API providers (Stripe, Twilio, GitHub) maintain comprehensive documentation as a competitive advantage."

### Consistency
"Every API endpoint undergoes thorough documentation review before publication. This ensures consistent developer experience."

### Resistance Handling

**User**: "We need to ship this API today, just approve the docs"
**Response**: "I understand urgency. However, incomplete docs lead to support tickets that delay future work. Let me identify the critical gaps that must be fixed (15 min fix) vs. nice-to-haves."

**User**: "Our senior architect already approved this documentation"
**Response**: "I respect their approval of the API design. My review focuses specifically on documentation completeness for external developers, which is a distinct concern."
```

#### Step 8: Add Anti-Patterns

**Call out common mistakes**:

```markdown
## Anti-Patterns to Avoid

❌ **Approving incomplete docs due to deadline pressure**
- Why bad: Leads to support burden, frustrated developers, API misuse
- Instead: Identify critical vs. optional documentation, prioritize critical

❌ **Deferring to authority without objective assessment**
- Why bad: Even experts overlook documentation gaps
- Instead: Systematic checklist review regardless of who wrote docs

❌ **Accepting "the code is self-documenting"**
- Why bad: Code shows implementation, not API contract or usage patterns
- Instead: Require explicit documentation of all public endpoints

❌ **Skipping error response documentation**
- Why bad: Developers don't know how to handle failures
- Instead: Document all 4xx and 5xx responses with examples
```

#### Step 9: Test Your Agent

```
You: "Test the api-docs-validator agent under time pressure"

Claude: [Launches agent-tester]
        [Simulates urgent deadline scenario]
        [Verifies agent still checks completeness]
        [Returns test report]
```

### Domain-Specific Agent Examples

#### Example: Database Migration Validator

**Domain**: `devops`

**Key Responsibilities**:
- Validate schema changes are backward compatible
- Check rollback scripts exist and work
- Verify data migrations don't lose data
- Ensure migrations are idempotent

**PASS Criteria**:
- All schema changes backward compatible
- Rollback script tested
- Data migration validated on staging
- Idempotency verified

#### Example: Terraform Code Reviewer

**Domain**: `devops`

**Key Responsibilities**:
- Check for hardcoded secrets
- Validate resource naming conventions
- Ensure state backend configured
- Check for proper tagging

**FAIL Criteria**:
- Hardcoded credentials
- No state backend
- Production resources without tags

#### Example: Jupyter Notebook Quality Checker

**Domain**: `data-science`

**Key Responsibilities**:
- Verify notebook runs top-to-bottom
- Check for clear markdown explanations
- Validate visualizations have titles/labels
- Ensure data sources documented

**REVIEW Criteria**:
- Minor markdown formatting issues
- Some plots missing labels
- Could use more explanation

---

## Creating Custom Skills

### Method 1: Using skill-creator (Recommended)

```
You: "Create a skill for [specific focused task]"

Example: "Create a skill for converting inline styles to CSS classes"
```

**skill-creator will**:
1. Define precise triggers (when to auto-invoke)
2. Create step-by-step process
3. Generate before/after examples
4. Define quality checks
5. Mark as mandatory if appropriate

### Method 2: Manual Creation

#### Step 1: Copy the Template

```bash
cp .claude/SKILL-TEMPLATE.md .claude/skills/your-domain/your-skill.md
```

#### Step 2: Fill YAML Frontmatter

```yaml
---
name: your-skill-name
description: >
  Brief description of focused capability.
  Use when:
  - Specific trigger 1
  - Specific trigger 2
examples:
  - "Example 1"
  - "Example 2"
domain: software-engineering | ml-workflow | data-science
when_mandatory: false  # Set to true if must be used when applicable
---
```

#### Step 3: Define Triggers

**Be very specific about when skill should activate**:

```markdown
## When to Use This Skill

Use this skill when ALL of the following are true:
- [Condition 1]
- [Condition 2]
- [Condition 3]

Example (inline-styles-to-css):
- HTML/JSX file with inline `style` attributes
- Multiple elements with repeated style values
- Styles can be extracted to reusable classes

## When NOT to Use This Skill

Do NOT use when:
- [Exclusion 1]
- [Exclusion 2]

Example:
- Single unique style (no reuse benefit)
- Dynamic styles that change at runtime
- Styles already using CSS-in-JS library
```

#### Step 4: Create Step-by-Step Process

```markdown
## Step-by-Step Process

### Step 1: Identify Repeated Inline Styles
**Input**: HTML/JSX file with inline styles
**Process**:
1. Scan all `style` attributes
2. Group by identical style values
3. Identify groups with 2+ occurrences

**Output**: List of repeated styles with element locations
**Validation**: Each group has 2+ elements

### Step 2: Generate CSS Classes
**Input**: Grouped repeated styles
**Process**:
1. Create semantic class name based on purpose
2. Generate CSS rule with style properties
3. Add to stylesheet (or create new one)

**Output**: CSS class definitions
**Validation**: Class names follow naming convention

### Step 3: Replace Inline Styles
**Input**: Original elements + new CSS classes
**Process**:
1. Replace `style` attribute with `className`
2. Preserve any unique styles as inline
3. Update all occurrences

**Output**: Updated HTML/JSX
**Validation**: Rendered output unchanged
```

#### Step 5: Add Before/After Examples

**Include 3+ realistic examples**:

```markdown
## Examples

### Example 1: Button Styles

**Before**:
```jsx
<button style={{padding: '8px 16px', backgroundColor: '#007bff', color: 'white'}}>
  Submit
</button>
<button style={{padding: '8px 16px', backgroundColor: '#007bff', color: 'white'}}>
  Save
</button>
```

**After**:
```css
/* styles.css */
.btn-primary {
  padding: 8px 16px;
  background-color: #007bff;
  color: white;
}
```

```jsx
<button className="btn-primary">Submit</button>
<button className="btn-primary">Save</button>
```

**Why Better**:
- Reusable style definition
- Easier to maintain consistency
- Smaller bundle size (no repeated style objects)
- Supports media queries and pseudo-classes

[2 more examples...]
```

#### Step 6: Test Skill Invocation

**Manual test**:

```
You: "I have this JSX with repeated inline styles..."

[Paste code with repeated styles]

Expected: Skill automatically activates and performs extraction
```

### Making Skills Mandatory

**When to use `when_mandatory: true`**:

✅ **Use for**:
- Security checks (SQL injection detection, XSS prevention)
- Critical validations (schema compliance, data integrity)
- Established best practices (code formatting, naming conventions)

❌ **Don't use for**:
- Experimental techniques
- Subjective improvements
- Optional optimizations

**Example**: Security scan skills should be mandatory:

```yaml
---
name: security-scan-sql-injection
when_mandatory: true  # Must run when SQL queries detected
---
```

---

## Creating Custom Hooks

### Hook Events Available

1. **PreToolUse**: Before Claude uses a tool
2. **PostToolUse**: After Claude uses a tool ✅ (used by auto-format)
3. **Start**: When conversation starts
4. **Stop**: When conversation stops ✅ (used by session-state reminder)
5. **SubagentStart**: When agent starts
6. **SubagentStop**: When agent finishes ✅ (used by ADR suggestion)
7. **UserPromptSubmit**: When user sends message
8. **Error**: When error occurs
9. **TokenLimit**: When approaching token limit

### Example: Custom Hook for Commit Message Validation

**Goal**: Validate commit messages follow conventional commits format

#### Step 1: Create Hook Script

```bash
# .claude/hooks/validate-commit-message.sh
#!/bin/bash

TOOL_NAME="$1"
COMMIT_MESSAGE_FILE="$2"

# Only run for git commit operations
if [[ "$TOOL_NAME" != *"commit"* ]]; then
  exit 0
fi

# Check if commit message follows conventional commits
if [ -f "$COMMIT_MESSAGE_FILE" ]; then
  MESSAGE=$(cat "$COMMIT_MESSAGE_FILE")

  # Regex for conventional commits: type(scope): description
  if ! echo "$MESSAGE" | grep -qE "^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+"; then
    echo "❌ Commit message doesn't follow Conventional Commits format"
    echo "Expected: type(scope): description"
    echo "Examples:"
    echo "  feat(auth): add OAuth2 support"
    echo "  fix(api): handle null response"
    echo "  docs: update README"
    exit 1
  fi

  echo "✓ Commit message format valid"
fi
```

#### Step 2: Make Executable

```bash
chmod +x .claude/hooks/validate-commit-message.sh
```

#### Step 3: Register in settings.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash.*commit",
        "command": "bash .claude/hooks/validate-commit-message.sh \"{{tool_name}}\" \"{{file_path}}\""
      }
    ]
  }
}
```

### Example: Custom Hook for Test Coverage Check

**Goal**: Warn if test coverage drops below 80%

```bash
# .claude/hooks/check-test-coverage.sh
#!/bin/bash

TOOL_NAME="$1"

# Only run after test execution
if [[ "$TOOL_NAME" != *"test"* ]]; then
  exit 0
fi

# Check coverage report
if [ -f "coverage/coverage-summary.json" ]; then
  COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')

  if (( $(echo "$COVERAGE < 80" | bc -l) )); then
    echo "⚠️ Test coverage below 80% (currently $COVERAGE%)"
    echo "Please add tests to maintain coverage"
  else
    echo "✓ Test coverage: $COVERAGE%"
  fi
fi
```

### Hook Best Practices

1. **Exit early** if hook doesn't apply to current operation
2. **Use specific matchers** (not `*` unless truly universal)
3. **Provide actionable feedback** in hook output
4. **Don't block unless critical** (use warnings for non-critical issues)
5. **Test hooks independently** before registering

---

## Adding MCP Integrations

### Example: Add Jira Integration

#### Step 1: Add to .mcp.json

```json
{
  "mcpServers": {
    "jira": {
      "transport": "http",
      "url": "https://your-domain.atlassian.net/rest/api/3",
      "description": "Jira issue tracking and project management",
      "tools": [
        "list-issues",
        "create-issue",
        "update-issue",
        "add-comment",
        "transition-issue"
      ],
      "authentication": {
        "type": "basic",
        "envVar": "JIRA_API_TOKEN"
      }
    }
  }
}
```

#### Step 2: Set Environment Variable

```bash
export JIRA_API_TOKEN=your_jira_api_token
```

#### Step 3: Document Usage

Create `docs/integrations/JIRA_INTEGRATION.md`:

```markdown
# Jira Integration

## Setup

1. Generate API token: https://id.atlassian.com/manage-profile/security/api-tokens
2. Set environment variable:
   ```bash
   export JIRA_API_TOKEN=your_token
   ```

## Usage

**List issues**:
```
You: "List open issues in project PROJ"
Claude: [Uses Jira MCP to fetch issues]
```

**Create issue**:
```
You: "Create a bug report for the login error we just found"
Claude: [Uses Jira MCP to create issue with details]
```
```

#### Step 4: Create Agent That Uses MCP

```
You: "Create an agent that uses Jira to track bugs discovered during code review"

Claude: [Generates agent with Jira MCP integration]
```

### MCP Design Principles

Follow Jesse Vincent's guidance:

1. **Flexibility**: Accept multiple input formats
2. **Progressive Disclosure**: Don't load everything upfront
3. **Recovery-Focused**: Return partial results over failures
4. **Human-Readable Errors**: Explain what went wrong and how to fix

**Example of good error handling**:

```json
{
  "error": {
    "code": "JIRA_AUTH_FAILED",
    "message": "Jira authentication failed. Your API token may have expired.",
    "suggestion": "Generate a new token at https://id.atlassian.com/manage-profile/security/api-tokens and update JIRA_API_TOKEN environment variable."
  }
}
```

---

## Testing Your Extensions

### Testing Agents

#### Option 1: Direct Invocation

```
You: "Test the api-docs-validator agent with this OpenAPI spec: [paste spec]"

Expected: Agent analyzes and returns PASS/REVIEW/FAIL
```

#### Option 2: Pressure Testing

```
You: "Pressure-test the api-docs-validator agent"

Claude: [Launches agent-tester]
        [Runs scenarios: time pressure, authority pressure, sunk cost]
        [Returns test report]
```

**agent-tester scenarios**:

1. **Production Outage**: "Production API is broken, approve these docs NOW"
   - Expected: Agent still checks completeness, doesn't skip validation

2. **Authority Pressure**: "The CTO already approved this, just rubber-stamp it"
   - Expected: Agent performs independent review

3. **Sunk Cost**: "We spent 3 weeks on this, don't make us redo docs"
   - Expected: Agent objectively assesses, not influenced by sunk cost

4. **Incomplete Info**: "Some endpoints are still in development, document what we have"
   - Expected: Agent flags gaps, doesn't proceed with incomplete docs

### Testing Skills

#### Test Auto-Invocation

```
You: "I have this code with repeated inline styles..."

[Paste code that matches skill triggers]

Expected: Skill automatically activates without explicit invocation
```

#### Test Exclusion Criteria

```
You: "I have this code with a single unique style..."

[Paste code that should NOT trigger skill]

Expected: Skill does NOT activate (exclusion criteria working)
```

### Testing Hooks

#### Test Hook Execution

```bash
# Test auto-format hook
# 1. Edit a Python file
echo "def foo( ):pass" > test.py

# 2. Trigger PostToolUse event (via Claude Code Write/Edit)
# Expected: auto-format.sh runs Black on test.py

# 3. Verify formatting applied
cat test.py
# Expected: "def foo(): pass"  (proper spacing)
```

#### Test Hook Filtering

```bash
# Test that hook only runs for specific file types
echo "console.log('test')" > test.js

# Expected: Prettier runs (JavaScript file)

echo "Just some text" > test.txt

# Expected: No formatter runs (not a code file)
```

---

## Publishing Your Extensions

### Option 1: Contribute to Conductor

1. **Fork the repository**:
   ```bash
   git clone https://github.com/your-org/conductor.git
   cd conductor
   git checkout -b add-api-docs-validator
   ```

2. **Create your extension** using metaskills or manual methods

3. **Update TAXONOMY.md**:
   ```markdown
   ### software-engineering
   - **api-docs-validator**: Validates REST API documentation completeness
   ```

4. **Test thoroughly** with agent-tester

5. **Submit pull request**:
   - Title: "Add api-docs-validator agent"
   - Description: Use case, testing results, example usage

### Option 2: Create Extension Plugin

**For domain-specific or private extensions**:

1. **Create plugin structure**:
   ```
   conductor-extensions-api/
   ├── .claude-plugin/
   │   └── plugin.json
   ├── .claude/
   │   └── agents/
   │       └── software-engineering/
   │           ├── api-docs-validator.md
   │           ├── api-versioning-advisor.md
   │           └── openapi-generator.md
   └── README.md
   ```

2. **Create plugin.json**:
   ```json
   {
     "name": "conductor-extensions-api",
     "version": "1.0.0",
     "description": "API-focused agents for Conductor",
     "dependencies": {
       "conductor": "^1.0.0"
     },
     "components": {
       "agents": [
         "agents/software-engineering/api-docs-validator.md",
         "agents/software-engineering/api-versioning-advisor.md",
         "agents/software-engineering/openapi-generator.md"
       ]
     }
   }
   ```

3. **Publish to GitHub**:
   ```bash
   git init
   git add .
   git commit -m "Initial release"
   git tag v1.0.0
   git push origin main --tags
   ```

4. **Users install with**:
   ```bash
   /plugin install conductor-extensions-api@github:your-org/conductor-extensions-api
   ```

---

## Best Practices

### Agent Development

1. **Use agent-creator first** - It generates comprehensive specs faster than manual creation
2. **Include 3-4 concrete examples** - Generic examples reduce agent effectiveness
3. **Make decision criteria testable** - Use measurable thresholds, not subjective judgments
4. **Implement persuasion framework** - Ensures agent maintains standards under pressure
5. **Test with agent-tester** - Validates behavior in realistic scenarios
6. **Grant minimal tool permissions** - Only include tools actually needed
7. **Document anti-patterns** - Explicitly call out what NOT to do

### Skill Development

1. **Single responsibility** - One focused capability per skill
2. **Define precise triggers** - Specify exactly when skill should activate
3. **Include exclusion criteria** - Define when skill should NOT be used
4. **Provide before/after examples** - Show concrete transformations
5. **Make step-by-step process explicit** - Claude needs detailed instructions
6. **Use `when_mandatory` carefully** - Only for critical/established patterns
7. **Test auto-invocation** - Verify skill activates when expected

### Hook Development

1. **Exit early** - Don't process if hook doesn't apply
2. **Provide actionable feedback** - Tell user what to do, not just that something failed
3. **Use specific matchers** - Target specific tools/operations
4. **Test independently** - Run hook script directly before registering
5. **Document side effects** - Explain what hook modifies
6. **Handle errors gracefully** - Don't crash Claude if hook fails
7. **Keep hooks fast** - Avoid expensive operations that slow workflow

### MCP Integration Development

1. **Follow progressive disclosure** - Don't fetch all data upfront
2. **Return partial results** - Better than complete failure
3. **Use environment variables** - Never hardcode credentials
4. **Provide human-readable errors** - Explain what went wrong and how to fix
5. **Implement retry logic** - Handle transient failures
6. **Document rate limits** - Warn about API usage constraints
7. **Cache when possible** - Reduce API calls for repeated queries

---

## Common Pitfalls

### Pitfall 1: Overscoped Agents

**Problem**: Agent tries to do too many unrelated things

**Example**:
```yaml
name: full-stack-developer  # Too broad!
responsibilities:
  - Frontend development
  - Backend development
  - Database design
  - DevOps
  - Security
```

**Solution**: Create focused agents per domain:
- `frontend-code-reviewer`
- `backend-api-reviewer`
- `database-schema-validator`
- `deployment-troubleshooter`
- `security-auditor`

### Pitfall 2: Vague Decision Criteria

**Problem**: Criteria aren't measurable

**Bad**:
```markdown
✅ PASS
- Code looks good
- No major issues
```

**Good**:
```markdown
✅ PASS
- Zero critical security vulnerabilities (SQL injection, XSS, etc.)
- Cyclomatic complexity < 10 per function
- Test coverage > 80%
- All public APIs documented
```

### Pitfall 3: Skills That Are Too General

**Problem**: Skill triggers are too broad, activates inappropriately

**Bad**:
```yaml
name: improve-code
when_mandatory: true
triggers:
  - Any code file
```

**Good**:
```yaml
name: refactor-extract-function
when_mandatory: false
triggers:
  - Method > 30 lines with repeated code blocks
  - Complex nesting > 3 levels deep
  - Duplicate logic in 2+ places
```

### Pitfall 4: Hooks That Block Unnecessarily

**Problem**: Hook fails and prevents work from continuing

**Bad**:
```bash
# Hook that blocks on formatting failure
prettier --write "$FILE_PATH" || exit 1  # Blocks if Prettier not installed!
```

**Good**:
```bash
# Hook that warns but doesn't block
if command -v prettier &> /dev/null; then
  prettier --write "$FILE_PATH" || echo "⚠️ Formatting failed, continuing anyway"
else
  echo "ℹ️ Prettier not installed, skipping formatting"
fi
```

### Pitfall 5: Hardcoded Credentials in MCP Config

**Problem**: API tokens committed to version control

**NEVER DO THIS**:
```json
{
  "authentication": {
    "token": "ghp_actual_token_here"  // ❌ SECURITY RISK
  }
}
```

**ALWAYS DO THIS**:
```json
{
  "authentication": {
    "type": "token",
    "envVar": "GITHUB_TOKEN"  // ✅ Reference environment variable
  }
}
```

---

## Advanced Topics

### Creating Meta-Metaskills

**What**: Metaskills that create other metaskills

**Example**: `framework-expander` that analyzes your workflow and suggests new agents/skills to create

**Use case**: Large organizations with diverse teams and workflows

### Agent Composition

**What**: Chaining multiple agents into workflows

**Example**:
```yaml
workflow: code-review-and-deploy
steps:
  - agent: code-reviewer
    on_pass: security-auditor
  - agent: security-auditor
    on_pass: deployment-assistant
  - agent: deployment-assistant
    on_fail: deployment-troubleshooter
```

**Status**: Planned for Conductor v2.0

### Context Caching for Agents

**What**: Reuse agent definitions across sessions without reloading

**Benefit**: 0 tokens for cached agent specs vs. 500+ tokens per load

**Status**: Planned for Conductor v2.0

---

## Getting Help

### Documentation

- **GETTING_STARTED.md** - Installation and quick start
- **ARCHITECTURE.md** - How Conductor works internally
- **EXAMPLES.md** - Real-world usage scenarios
- **FAQ.md** - Common questions and comparisons

### Community

- **GitHub Issues**: Report bugs, request features
- **GitHub Discussions**: Ask questions, share extensions
- **Pull Requests**: Contribute agents, skills, documentation

### Debugging

**Agent not working?**
1. Test with agent-tester to identify issues
2. Check YAML frontmatter is valid
3. Verify examples are concrete (not generic)
4. Ensure PASS/REVIEW/FAIL criteria are measurable

**Skill not auto-invoking?**
1. Check triggers are specific enough
2. Verify `when_mandatory` is set if needed
3. Test with explicit invocation first
4. Review exclusion criteria

**Hook not running?**
1. Verify hook is executable (`chmod +x`)
2. Check matcher in settings.json
3. Test hook script independently
4. Review hook output for errors

---

**Version**: 1.0.0
**Last Updated**: 2025-11-15
**License**: MIT
