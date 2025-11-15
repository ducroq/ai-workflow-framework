# Getting Started with Conductor

**Welcome to Conductor** - a production-ready framework for AI-augmented workflows that helps you build, test, and deploy specialized AI agents for complex cognitive tasks.

---

## Quick Start (5 Minutes)

### 1. Install Conductor

```bash
# Clone the repository
git clone https://github.com/your-org/conductor.git
cd conductor

# Copy to Claude Code plugins directory
cp -r .claude ~/.claude/
cp -r .claude-plugin ~/.claude/plugins/conductor

# Make hooks executable (Unix/Mac)
chmod +x ~/.claude/hooks/*.sh
```

### 2. Verify Installation

Restart Claude Code and verify the agents are available:

```bash
# List available agents
ls ~/.claude/agents/*/

# You should see:
# - software-engineering/ (code-reviewer, debugger, refactoring-guide)
# - ml-workflow/ (oracle-calibration, dataset-qa)
# - data-science/ (data-analyzer)
# - devops/ (deployment-troubleshooter)
# - security/ (security-auditor)
# - meta/ (agent-creator, skill-creator, agent-tester)
```

### 3. Use Your First Agent

**Example: Code Review**

```
You: "Review this authentication code for security issues"
Claude: [Launches code-reviewer agent]
        [Checks for OWASP Top 10 vulnerabilities]
        [Returns findings with PASS/REVIEW/FAIL decision]
```

**Example: Create New Agent**

```
You: "Create an agent for validating API documentation"
Claude: [Launches agent-creator metaskill]
        [Generates specialized agent based on requirements]
        [Saves to appropriate domain directory]
```

### 4. Bootstrap Auto-Documentation (HIGHLY RECOMMENDED)

**The killer feature**: Living documentation that updates automatically!

```
You: "Bootstrap auto-docs for my task management app with React frontend and FastAPI backend"

Claude: [Launches auto-docs-bootstrap agent]
        [Asks about your project: vision, phase, constraints]
        [Creates complete documentation structure]
        [Sets up automation hooks]

You get:
✅ PROJECT_OVERVIEW.md - Auto-updated project status
✅ CURRENT_TASK.md - Real-time progress tracking
✅ OPEN_QUESTIONS.md - Living question log
✅ ROADMAP.md - Work planning
✅ docs/components/ - Auto-maintained component docs
✅ docs/decisions/ - Auto-created decision records

From now on, docs update automatically as you code!
```

**Try it now**: The setup takes < 2 minutes and saves hours of documentation work.

---

## What Just Happened?

When you installed Conductor, you got:

1. **🔥 Auto-Documentation System** - Living docs that update automatically (zero manual work!)
2. **13 Production-Ready Agents** for software engineering, ML, data science, DevOps, security, meta-operations
3. **Metaskills** that create and test new agents automatically (self-improving framework)
4. **Automation Hooks** that update docs on code changes, decisions, and session events
5. **Progressive Disclosure** - Smart context loading that never overwhelms Claude's context window
6. **MCP Integrations** for GitHub, databases, Figma, Linear, Slack (optional)
7. **Templates** for creating consistent agents, skills, and documentation

---

## Core Concepts (2 Minutes)

### Agents

**Agents** are specialized AI assistants for complex, multi-step tasks.

```
Structure: .claude/agents/{domain}/{agent-name}.md
Examples: code-reviewer, debugger, oracle-calibration
When: Complex tasks requiring domain expertise
```

**Using an agent:**
```
You: "Debug this intermittent API timeout issue"
Claude: [Automatically launches debugger agent]
        [Follows hypothesis-driven root cause analysis]
        [Tests hypotheses systematically]
```

### Skills

**Skills** are focused capabilities that Claude automatically uses when applicable.

```
Structure: .claude/skills/{domain}/{skill-name}.md
Examples: refactor-extract-function
When: Specific, well-defined transformations
```

**Using a skill (automatic):**
```
You: "This validation function is getting too long"
Claude: [Automatically invokes refactor-extract-function skill]
        [Extracts repeated validation logic]
        [Creates helper functions]
```

### Metaskills

**Metaskills** create and improve other agents (self-improving framework).

```
Available: agent-creator, skill-creator, agent-tester
Purpose: Extend framework without manual template editing
```

**Creating new agents:**
```
You: "Create an agent for database migration validation"
Claude: [Launches agent-creator]
        [Researches database migration best practices]
        [Generates complete agent with examples]
        [Tests with agent-tester]
```

### Hooks

**Hooks** automate actions based on events (after file edits, when stopping, etc.).

```
Available: auto-format, suggest-session-state-update, suggest-adr
Purpose: Automation without manual intervention
```

**Hooks in action:**
```
Claude: [Edits Python file]
Auto-format hook: ✓ Formatted with Black: file.py

Claude: [Finishes long session]
Session-state hook: 💡 Consider updating SESSION_STATE.md (last updated 2 hours ago)
```

---

## Common Workflows

### Workflow 1: Code Review

```
You: "Review this pull request for security and quality issues"

Claude uses:
1. code-reviewer agent (OWASP Top 10, best practices)
2. auto-format hook (consistent formatting)
3. suggest-adr hook (if architectural decisions detected)

Output:
- Security findings (SQL injection, XSS, etc.)
- Quality issues (complexity, duplication)
- PASS/REVIEW/FAIL decision
- Concrete fix recommendations
```

### Workflow 2: ML Dataset Quality Check

```
You: "Validate this dataset before training"

Claude uses:
1. dataset-qa agent (completeness, variance, duplicates)
2. oracle-calibration agent (if LLM-labeled data)

Output:
- Quality report with statistics
- Pass/fail thresholds
- Specific issues to fix
- Recommendation (proceed/fix/relabel)
```

### Workflow 3: Debug Production Issue

```
You: "Production API is returning 500 errors intermittently"

Claude uses:
1. debugger agent (hypothesis-driven analysis)
2. deployment-troubleshooter agent (if infrastructure-related)

Output:
- Symptom analysis
- Hypotheses ranked by likelihood
- Test plan for each hypothesis
- Root cause identification
- Fix implementation
```

### Workflow 4: Extend Framework

```
You: "Create an agent for validating database schemas"

Claude uses:
1. agent-creator metaskill (generates agent)
2. agent-tester metaskill (validates quality)

Output:
- Complete agent definition
- Domain-specific best practices
- 3+ concrete examples
- PASS/REVIEW/FAIL criteria
- Saved to .claude/agents/data-science/schema-validator.md
```

---

## Configuration (Optional)

### Step 1: Install Optional Formatters

Conductor's auto-format hook supports multiple languages:

```bash
# JavaScript/TypeScript
npm install -g prettier eslint

# Python
pip install black autopep8

# Go (included with Go installation)
# Rust (included with Rust installation)

# Java
# Download from https://github.com/google/google-java-format
```

### Step 2: Configure MCP Integrations

MCP (Model Context Protocol) enables Claude to interact with external tools.

**GitHub Integration:**
```bash
# 1. Generate token: https://github.com/settings/tokens
export GITHUB_TOKEN=ghp_your_token_here

# 2. Use in Claude
You: "List open issues in myorg/myrepo"
Claude: [Uses GitHub MCP to fetch issues]
```

**Supabase Integration:**
```bash
# 1. Get credentials from Supabase dashboard
export SUPABASE_URL=https://yourproject.supabase.co
export SUPABASE_KEY=your_api_key_here

# 2. Update .claude/.mcp.json with your project URL
# 3. Use in Claude
You: "Query all companies in the database"
Claude: [Uses Supabase MCP to run query]
```

**Other Integrations:**
- Figma: `export FIGMA_TOKEN=your_token`
- Linear: `export LINEAR_API_KEY=your_key`
- Slack: `export SLACK_BOT_TOKEN=xoxb_your_token`

See `docs/MCP_INTEGRATION_GUIDE.md` for complete setup instructions.

### Step 3: Initialize Session State

Copy the SESSION_STATE.md template to your project:

```bash
cp ~/.claude/plugins/conductor/docs/SESSION_STATE.md ./docs/
```

Edit with your project details. This file helps Claude recover context after breaks.

---

## Testing Your Installation

### Test 1: Agent Invocation

```
You: "Review this code for security issues: const query = `SELECT * FROM users WHERE id=${userId}`;"

Expected: code-reviewer agent identifies SQL injection vulnerability
```

### Test 2: Skill Auto-Invocation

```
You: "This function is too long and has repeated validation logic"

Expected: refactor-extract-function skill automatically activates
```

### Test 3: Hook Execution

```
You: "Create a Python file with unformatted code"

Expected: auto-format hook runs Black/autopep8 automatically
```

### Test 4: Metaskill Usage

```
You: "Create an agent for API performance testing"

Expected: agent-creator generates complete agent, agent-tester validates it
```

---

## Next Steps

### Learn More

- **Architecture**: Read `ARCHITECTURE.md` to understand design philosophy
- **Developer Guide**: Read `DEVELOPER_GUIDE.md` to create custom agents
- **Examples**: Read `EXAMPLES.md` for real-world usage scenarios
- **FAQ**: Read `FAQ.md` for common questions

### Extend Conductor

1. **Create domain-specific agents** using agent-creator metaskill
2. **Add new skills** for your most common tasks
3. **Configure hooks** for team-specific workflows
4. **Add MCP integrations** for your tools

### Join the Community

- **Report issues**: https://github.com/your-org/conductor/issues
- **Contribute agents**: Fork repo, create agents, submit PR
- **Share feedback**: What agents would be most valuable?

---

## Troubleshooting

### Agents Not Available

**Problem**: Claude doesn't recognize agent names

**Solution**:
```bash
# Verify .claude directory structure
ls -la ~/.claude/agents/

# Ensure correct permissions
chmod -R 755 ~/.claude/

# Restart Claude Code
```

### Hooks Not Running

**Problem**: auto-format hook doesn't execute

**Solution**:
```bash
# Make hooks executable
chmod +x ~/.claude/hooks/*.sh

# Verify settings.json exists
cat ~/.claude/settings.json

# Check formatter is installed
which prettier  # for JavaScript
which black     # for Python
```

### MCP Authentication Failed

**Problem**: "GitHub MCP authentication failed"

**Solution**:
```bash
# Verify environment variable is set
echo $GITHUB_TOKEN

# Check token hasn't expired
# Regenerate at https://github.com/settings/tokens

# Verify token has correct scopes (repo, read:org)
```

---

## Support

- **Documentation**: See `docs/` directory for comprehensive guides
- **Issues**: https://github.com/your-org/conductor/issues
- **Questions**: Create a discussion on GitHub

---

**Ready to dive deeper?** Continue to `ARCHITECTURE.md` to understand how Conductor works under the hood.

**Want to extend Conductor?** Jump to `DEVELOPER_GUIDE.md` to create your first custom agent.

**Need inspiration?** Check out `EXAMPLES.md` for real-world usage scenarios.

---

**Version**: 1.0.0
**Last Updated**: 2025-11-15
**License**: MIT
