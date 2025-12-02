# Conductor FAQ

**Frequently Asked Questions about Conductor**

---

## General Questions

### What is Conductor?

Conductor is a production-ready framework for creating, managing, and deploying specialized AI agents for Claude Code. It provides:

- **Specialized agents** for complex multi-step tasks (code review, debugging, ML workflows)
- **Auto-invoked skills** for focused capabilities (refactoring, testing)
- **Metaskills** that create and test new agents (self-improving framework)
- **Hooks** for automation (formatting, documentation)
- **MCP integrations** for external tools (GitHub, databases, APIs)

Think of it as an orchestration layer for AI-augmented workflows across software engineering, ML, data science, DevOps, and security.

### Why "Conductor"?

A conductor orchestrates multiple musicians (agents) to create harmonious output (high-quality software). The name reflects how the framework coordinates specialized agents, skills, and automation to accomplish complex cognitive tasks.

### Who should use Conductor?

**Ideal for**:
- Software engineers wanting systematic code review and refactoring
- ML engineers running batch labeling and dataset QA
- Data scientists performing exploratory analysis
- DevOps teams troubleshooting deployments
- Security teams conducting audits
- Teams wanting to codify best practices across projects

**Not ideal for**:
- One-off simple tasks (just use Claude directly)
- Non-technical users unfamiliar with command line
- Projects not using Claude Code

### Is Conductor free?

Yes! Conductor is MIT-licensed open-source software. You pay only for Claude API usage (same as using Claude Code without Conductor).

**Cost**: Same Claude API costs, but potentially *lower* overall costs due to:
- More focused agents (less trial-and-error)
- Progressive disclosure (load only needed context)
- Reusable patterns (don't re-explain best practices each session)

---

## Comparison Questions

### Conductor vs. Custom Prompts

| Aspect | Custom Prompts | Conductor |
|--------|----------------|-----------|
| **Reusability** | Copy-paste between sessions | Framework-level reuse across all projects |
| **Consistency** | Varies by memory | Enforced structure (YAML frontmatter, templates) |
| **Specialization** | Generic instructions | Domain-specific expertise (OWASP Top 10, etc.) |
| **Testing** | Manual trial-and-error | Pressure-tested metaskills |
| **Extension** | Write new prompts manually | Metaskills generate agents in minutes |
| **Automation** | External tools needed | Built-in hooks |
| **Learning Curve** | Low | Medium |
| **Maintenance** | Manual updates | Versioned in git |

**Use Custom Prompts when**: One-off task, experimenting, simple request

**Use Conductor when**: Recurring workflows, team collaboration, maintaining quality standards

### Conductor vs. Anthropic's Claude Projects

| Aspect | Claude Projects | Conductor |
|--------|-----------------|-----------|
| **Purpose** | Project-specific context | Framework for reusable workflows |
| **Scope** | Single project | All projects |
| **Agents** | General-purpose Claude | Specialized domain agents |
| **Structure** | Freeform | Standardized templates |
| **Automation** | Manual | Hooks for formatting, documentation |
| **Testing** | Manual | agent-tester pressure testing |
| **Extension** | N/A | Metaskills create new agents |

**Relationship**: Conductor *enhances* Claude Projects by providing specialized agents you can invoke within any project.

### Conductor vs. LangChain/AutoGPT

| Aspect | LangChain/AutoGPT | Conductor |
|--------|-------------------|-----------|
| **Integration** | External framework | Native Claude Code plugin |
| **Complexity** | High (Python code, servers) | Medium (Markdown agents, shell scripts) |
| **Setup** | Complex (dependencies, APIs) | Simple (copy .claude directory) |
| **Language** | Python/JavaScript | Markdown + Bash |
| **Episodic Memory** | External databases | SESSION_STATE.md (local file) |
| **Agent Creation** | Code + debugging | Metaskills (ask Claude to create) |
| **Tool Calling** | Custom integrations | Built-in Claude Code tools + MCP |

**Use LangChain/AutoGPT when**: Building custom LLM apps, need Python ecosystem

**Use Conductor when**: Working in Claude Code, want simple setup, prefer Markdown over code

### Conductor vs. GitHub Copilot

| Aspect | GitHub Copilot | Conductor |
|--------|----------------|-----------|
| **Focus** | Code completion | Multi-step workflows |
| **Interaction** | Inline suggestions | Conversational agents |
| **Scope** | Single file | Entire project/codebase |
| **Workflow** | Write → suggest | Request → analyze → recommend |
| **Quality Framework** | None | PASS/REVIEW/FAIL decisions |
| **Domains** | Code only | Code, ML, data science, DevOps, security |
| **Memory** | None | SESSION_STATE.md |

**Relationship**: Complementary tools - Use Copilot for code completion, Conductor for code review, debugging, refactoring, etc.

---

## Technical Questions

### How do agents differ from skills?

| Aspect | Agent | Skill |
|--------|-------|-------|
| **Invocation** | Explicit (user requests) | Automatic (Claude detects need) |
| **Scope** | Complex, multi-step | Focused, single capability |
| **Example** | code-reviewer, debugger | refactor-extract-function |
| **Length** | 500+ words | 200-400 words |
| **Mandatory** | Optional | Can be mandatory |

**Example**:

**Agent** (explicit invocation):
```
You: "Review this code for security issues"
Claude: [Launches code-reviewer agent]
```

**Skill** (automatic invocation):
```
You: "This function is getting too long"
Claude: [Automatically invokes refactor-extract-function skill]
```

### What are metaskills?

**Metaskills** are agents that create, test, and improve other agents - making the framework self-improving.

**Three metaskills**:

1. **agent-creator**: Generates new agents from requirements
   ```
   You: "Create an agent for database migration validation"
   Claude: [Generates complete agent specification]
   ```

2. **skill-creator**: Generates new skills
   ```
   You: "Create a skill for generating TypeScript interfaces from JSON"
   Claude: [Generates auto-invoked skill]
   ```

3. **agent-tester**: Pressure-tests agents under realistic constraints
   ```
   You: "Test the code-reviewer agent under time pressure"
   Claude: [Runs pressure scenarios, returns test report]
   ```

**Why important**: Extend framework without manual template editing. Generate production-ready agents in minutes.

### What is the PASS/REVIEW/FAIL framework?

**Three-tier decision framework** used by all agents:

✅ **PASS**: Criteria met, approve/proceed/accept
⚠️ **REVIEW**: Minor issues, needs attention before approval
❌ **FAIL**: Critical issues, block until resolved

**Example** (code-reviewer):

| Finding | Decision |
|---------|----------|
| No security issues, tests pass, documented | ✅ PASS → Approve PR |
| Medium complexity, missing some edge case tests | ⚠️ REVIEW → Fix before merge |
| SQL injection vulnerability | ❌ FAIL → Block deployment |

**Why three tiers?** Binary PASS/FAIL insufficient - need to distinguish critical vs. minor issues.

### How do hooks work?

**Hooks** execute shell scripts in response to events:

**Example**: auto-format.sh runs after code edits

```
1. You: "Edit this Python file"
2. Claude: [Uses Edit tool]
3. PostToolUse event fires
4. auto-format.sh script runs
5. Black formatter applies formatting
6. Output: "✓ Formatted with Black: file.py"
```

**9 available events**: PreToolUse, PostToolUse, Start, Stop, SubagentStart, SubagentStop, UserPromptSubmit, Error, TokenLimit

**Benefits**: Automates repetitive tasks without manual intervention.

### What is MCP?

**MCP (Model Context Protocol)** allows Claude to interact with external tools and APIs.

**Conductor includes 5 pre-configured MCPs**:

| MCP | Purpose | Tools |
|-----|---------|-------|
| GitHub | Issues, PRs, repos | list-issues, create-issue, get-pr |
| Supabase | Database queries | query-table, insert-row, update-row |
| Figma | Design files | get-file, get-components |
| Linear | Project management | list-issues, create-issue |
| Slack | Notifications | send-message, list-channels |

**Example usage**:
```
You: "List open issues in myorg/myrepo"
Claude: [Uses GitHub MCP to fetch issues from API]
```

**Setup**: Set environment variables for authentication
```bash
export GITHUB_TOKEN=your_token
export SUPABASE_KEY=your_key
```

### How does Conductor handle context/memory?

**Three mechanisms**:

1. **SESSION_STATE.md** (episodic memory)
   - Running project logbook
   - Tracks current status, accomplishments, next steps
   - Updated manually or via hook reminder
   - Claude reads to recover context after breaks

2. **Agent specifications** (semantic memory)
   - Domain expertise encoded in agent definitions
   - Reusable across all sessions/projects
   - Examples: OWASP Top 10 (code-reviewer), statistical methods (dataset-qa)

3. **Progressive disclosure** (contextual memory)
   - Load broad context first (SESSION_STATE, agent spec)
   - Navigate to specific components as needed
   - Minimize token usage (10k vs. 100k+ for full codebase)

**No external databases required** - all memory is local files.

---

## Usage Questions

### How do I create a new agent?

**Method 1** (recommended): Use agent-creator metaskill

```
You: "Create an agent for [your use case]"

Example: "Create an agent for API documentation validation"

Claude: [Launches agent-creator]
        [Researches best practices]
        [Generates complete agent specification]
        [Tests with agent-tester]
        [Saves to appropriate domain directory]
```

**Method 2**: Manual creation

```bash
# Copy template
cp .claude/AGENT-TEMPLATE.md .claude/agents/your-domain/your-agent.md

# Edit file (fill YAML frontmatter, role, responsibilities, examples, etc.)
# Test with agent-tester
```

See `DEVELOPER_GUIDE.md` for detailed instructions.

### How do I create a new skill?

**Method 1** (recommended): Use skill-creator metaskill

```
You: "Create a skill for [focused task]"

Example: "Create a skill for converting inline styles to CSS classes"

Claude: [Launches skill-creator]
        [Defines triggers and process]
        [Generates before/after examples]
        [Saves to domain directory]
```

**Method 2**: Manual creation

```bash
cp .claude/SKILL-TEMPLATE.md .claude/skills/your-domain/your-skill.md
# Edit with triggers, steps, examples
```

### When should I use an agent vs. a skill?

**Use Agent when**:
- Complex, multi-step task
- Requires domain expertise
- User explicitly requests it
- Examples: code review, debugging, deployment troubleshooting

**Use Skill when**:
- Focused, well-defined transformation
- Should happen automatically when pattern detected
- Single responsibility
- Examples: extract function, format code, generate tests

**Rule of thumb**: If you want Claude to automatically do it when applicable, make it a skill. If you want to explicitly invoke it, make it an agent.

### Can I use Conductor with my existing Claude Code projects?

**Yes!** Conductor enhances Claude Code, doesn't replace it.

**Installation**:
```bash
# Copy to Claude plugins directory
cp -r .claude ~/.claude/
```

**Usage in any project**:
```
cd my-project/
# Conductor agents are now available

You: "Review this code"
Claude: [Launches code-reviewer agent from Conductor]
```

**SESSION_STATE.md per project**:
```bash
# Copy template to your project
cp ~/.claude/plugins/conductor/docs/SESSION_STATE.md ./docs/
```

### How do I customize agents for my team?

**Option 1**: Extend existing agents

```
You: "Customize code-reviewer to check for our team's naming conventions"

Claude: [Reads existing code-reviewer agent]
        [Adds team-specific rules]
        [Saves to .claude/agents/software-engineering/code-reviewer-team.md]
```

**Option 2**: Fork Conductor

```bash
git clone https://github.com/your-org/conductor.git
cd conductor

# Add team-specific agents
# Update .claude-plugin/plugin.json

# Distribute to team
```

**Option 3**: Create extension plugin

```json
// conductor-extensions-mycompany/plugin.json
{
  "name": "conductor-extensions-mycompany",
  "dependencies": {
    "conductor": "^1.0.0"
  },
  "components": {
    "agents": ["agents/custom/team-code-reviewer.md"]
  }
}
```

### What if an agent gives wrong advice?

**Agents are not infallible** - they're sophisticated prompts, not magic.

**Steps**:

1. **Use PASS/REVIEW/FAIL framework** - Treat REVIEW/FAIL outputs as suggestions, not commands

2. **Pressure-test with agent-tester** - Identifies weaknesses

3. **Improve agent specification**:
   ```
   You: "The code-reviewer missed this SQL injection. Update it to catch this pattern"

   Claude: [Reads agent specification]
           [Adds example of the missed pattern]
           [Tests with agent-tester]
           [Saves updated agent]
   ```

4. **Report issues** - Submit GitHub issue with:
   - Agent name
   - Input provided
   - Incorrect output
   - Expected output

**Remember**: Agents encode best practices, but you're the final decision-maker.

---

## Troubleshooting

### "Claude doesn't recognize my agent"

**Possible causes**:

1. **Agent not in correct location**
   ```bash
   # Should be:
   .claude/agents/{domain}/{agent-name}.md

   # Not:
   agents/{agent-name}.md  # Wrong!
   ```

2. **Invalid YAML frontmatter**
   ```yaml
   ---
   name: my-agent  # Must be lowercase-with-hyphens
   description: "..."  # Must have description
   ---
   ```

3. **Claude Code not restarted** after adding agent
   ```
   # Restart Claude Code to reload agents
   ```

**Fix**:
```bash
# Verify structure
ls .claude/agents/your-domain/

# Check YAML syntax
head -20 .claude/agents/your-domain/your-agent.md

# Restart Claude Code
```

### "Skills don't auto-invoke"

**Possible causes**:

1. **Triggers too vague**
   ```yaml
   # Too vague:
   triggers:
     - "Any code"

   # Specific:
   triggers:
     - Method > 30 lines with repeated code
   ```

2. **when_mandatory not set**
   ```yaml
   when_mandatory: false  # Skill is optional

   # Change to:
   when_mandatory: true  # Skill MUST be used
   ```

3. **Exclusion criteria prevents invocation**
   ```markdown
   ## When NOT to Use
   - Method < 15 lines  ← Your method is 12 lines, skill doesn't trigger
   ```

**Fix**:
- Make triggers more specific
- Review exclusion criteria
- Test with explicit invocation first
  ```
  You: "Use refactor-extract-function skill on this code"
  ```

### "Hooks don't run"

**Possible causes**:

1. **Hook not executable**
   ```bash
   chmod +x .claude/hooks/your-hook.sh
   ```

2. **Matcher doesn't match event**
   ```json
   {
     "matcher": "Edit",  // Only Edit, not Write
     "command": "bash .claude/hooks/auto-format.sh {{file_path}}"
   }

   // Change to:
   {
     "matcher": "Edit|Write",  // Both Edit and Write
     "command": "..."
   }
   ```

3. **Hook script has errors**
   ```bash
   # Test hook independently
   bash .claude/hooks/your-hook.sh test-file.py
   ```

**Fix**:
- Verify permissions (`chmod +x`)
- Check matcher in `.claude/settings.json`
- Test script independently
- Review script output for errors

### "MCP authentication failed"

**Possible causes**:

1. **Environment variable not set**
   ```bash
   echo $GITHUB_TOKEN  # Should output token

   # If empty:
   export GITHUB_TOKEN=your_token_here
   ```

2. **Token expired**
   ```
   # Regenerate token at provider
   # GitHub: https://github.com/settings/tokens
   ```

3. **Wrong permissions/scopes**
   ```
   # GitHub token needs: repo, read:org scopes
   # Regenerate with correct scopes
   ```

**Fix**:
```bash
# Set environment variable
export GITHUB_TOKEN=your_token

# Verify
echo $GITHUB_TOKEN

# Make permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export GITHUB_TOKEN=your_token' >> ~/.bashrc
```

### "How do I see what agents are available?"

**Option 1**: Check TAXONOMY.md

```bash
cat ~/.claude/plugins/conductor/docs/TAXONOMY.md
```

**Option 2**: List agent files

```bash
find .claude/agents -name "*.md" -type f
```

**Option 3**: Read README

Conductor README.md lists all production-ready agents by domain.

---

## Performance Questions

### Does Conductor increase token usage?

**Short answer**: Minimally, often *decreases* overall tokens.

**Token costs per agent invocation**:
- Agent specification: ~500-800 tokens (one-time load per conversation)
- Example workflows: ~0 additional tokens (already in conversation context)

**Token savings**:
- **Reusable patterns**: Don't re-explain OWASP Top 10 every code review
- **Progressive disclosure**: Load only needed code (10k vs. 100k+ for full codebase)
- **Focused agents**: Less trial-and-error, more direct solutions

**Net result**: ~500-800 tokens for agent load, often saves 5,000-10,000+ tokens by avoiding repetitive explanations and trial-and-error.

### How fast is agent creation with metaskills?

**agent-creator timing**:
- Simple agent: ~2-3 minutes
- Complex agent: ~5-10 minutes

**Compared to manual**:
- Manual creation: 30-60 minutes (research, write examples, test)

**Speedup**: 6-20x faster with metaskills

### Can I use Conductor offline?

**Mostly yes**, with caveats:

**Works offline**:
- ✅ Agent specifications (local Markdown files)
- ✅ Skills (local files)
- ✅ Hooks (local shell scripts)
- ✅ SESSION_STATE.md (local file)

**Requires internet**:
- ❌ Claude API (Conductor needs Claude Code, which needs internet)
- ❌ MCP integrations (GitHub, Supabase, etc. require API access)

**Offline usage**: Can browse agent specs, edit hooks, plan workflows - but need internet to actually invoke agents via Claude.

---

## Integration Questions

### Can I use Conductor with GitHub Actions?

**Yes!** Example workflow:

```yaml
# .github/workflows/code-review.yml
name: Code Review

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Conductor
        run: |
          git clone https://github.com/your-org/conductor.git
          cp -r conductor/.claude .

      - name: Run Code Review
        run: |
          # Invoke code-reviewer agent via Claude Code CLI
          claude-code "Review this PR for security issues" \
            --agent code-reviewer \
            --output review.md

      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: review
            });
```

**Benefits**:
- Automated code review on every PR
- Consistent quality standards
- Catches security issues before merge

### Can I integrate Conductor with VS Code?

**Not directly** - Conductor is a Claude Code plugin.

**Workaround**:
1. Use Claude Code for agent-based workflows (code review, debugging)
2. Use VS Code for editing
3. Use Claude Code API (if available) to invoke agents from VS Code

**Future**: VS Code extension planned for Conductor v2.0

### Can I use Conductor with other LLMs (GPT-4, Gemini)?

**No** - Conductor is specifically designed for Claude Code.

**Why**: Relies on Claude Code's agent system, tool use, and MCP integrations.

**Alternative**: Adapt agent specifications to LangChain/AutoGPT for other LLMs (requires significant refactoring).

---

## Auto-Documentation Questions

### How does auto-documentation work?

**Magic answer**: Hooks detect events (code edits, decisions, session end) and automatically update docs.

**Technical answer**:
1. **PostToolUse Hook**: Detects code changes → updates component docs
2. **Stop Hook**: Session ends → updates CURRENT_TASK with progress
3. **SubagentStop Hook**: Detects decisions → creates ADR drafts
4. **SessionStart Hook**: New session → loads context summary

**Zero manual work** - docs stay fresh automatically!

### Do I need to use auto-docs?

**No, it's optional** - but highly recommended!

**Without auto-docs**: You still get all 13 agents, skills, hooks, and templates
**With auto-docs**: You also get living documentation that maintains itself

**Setup time**: < 2 minutes
**Benefit**: Hours saved on documentation + instant context recovery

**Try it**: `"Bootstrap auto-docs for [your project description]"`

### Will auto-docs mess up my existing documentation?

**No** - bootstrap asks before overwriting anything.

**If you have existing docs**:
1. Bootstrap creates new structure alongside existing docs
2. You manually migrate valuable content
3. Archive old docs to `docs/archive/`

**Best practice**: Use auto-docs for high-level overview (PROJECT_OVERVIEW, CURRENT_TASK), keep technical details in your existing docs, link between them.

### How do I customize what gets auto-documented?

**Edit hooks** in `.claude/hooks/`:
- `update-component-docs.sh` - Control which files trigger component doc updates
- `create-adr-draft.sh` - Adjust what counts as a "decision"
- `update-current-task.sh` - Control progress tracking sensitivity

**Edit templates** in `.claude/templates/docs/`:
- Customize doc structure and sections
- Add domain-specific fields
- Change formatting preferences

### Can I disable auto-docs after enabling it?

**Yes!** Three options:

1. **Disable hooks** - Comment out hooks in `.claude/settings.json`
2. **Keep docs, stop updates** - Docs become static (manual updates)
3. **Full removal** - Delete `docs/` directory and hook configs

**Note**: Disabling is easy but you'll lose the automatic updates (and probably miss them!)

### Does auto-docs work for team projects?

**Yes!** But consider:

**Solo developer**: Perfect - context continuity across sessions
**Small team (2-5)**: Great - shared context, everyone sees current state
**Large team (6+)**: May need adjustment - lots of concurrent changes

**Team tips**:
- Use git hooks to sync docs before/after commits
- Review ADR drafts as team before finalizing
- Use OPEN_QUESTIONS for team discussion items

### How much does auto-docs cost (tokens)?

**Minimal** - progressive disclosure keeps token usage low:

**Session start context**: ~1-2k tokens (reads overview docs only)
**Component doc update**: ~500-1k tokens (single file analysis)
**ADR creation**: ~1-2k tokens (decision extraction)

**Total per day**: ~5-10k tokens for active development
**Comparison**: Manual context gathering often uses 20-50k tokens!

**Auto-docs actually saves tokens** through smart context management.

---

## Contributing Questions

### How can I contribute new agents?

**Steps**:

1. **Create agent** using agent-creator metaskill or manually

2. **Test thoroughly** with agent-tester

3. **Update TAXONOMY.md** with agent description

4. **Submit Pull Request**:
   - Title: "Add [agent-name] agent"
   - Description: Use case, testing results, example usage
   - Files: Agent file + TAXONOMY.md update

5. **Maintainers review** and merge

See `CONTRIBUTING.md` for detailed guidelines.

### How do I report bugs?

**GitHub Issues**: https://github.com/your-org/conductor/issues/new

**Include**:
1. **Agent/skill name** (if applicable)
2. **Input provided** (code, data, request)
3. **Expected output**
4. **Actual output**
5. **Conductor version**
6. **Claude Code version**

**Example**:
```
Title: code-reviewer misses SQL injection in f-string

Agent: code-reviewer
Version: Conductor 1.2.0

Input:
query = f"SELECT * FROM users WHERE id={user_id}"

Expected: FAIL with SQL injection warning
Actual: PASS (missed vulnerability)
```

### Can I create commercial extensions?

**Yes!** Conductor is MIT-licensed.

**You can**:
- Create commercial plugins based on Conductor
- Sell domain-specific agent packs
- Offer Conductor consulting/training
- Fork and customize for clients

**You must**:
- Include MIT license notice
- Not claim Conductor endorsement (unless partnered)

**Example commercial extensions**:
- "Conductor Extensions for Healthcare" (HIPAA compliance agents)
- "Conductor Extensions for Finance" (SOX, PCI-DSS agents)
- "Conductor Extensions for E-commerce" (A/B testing, conversion optimization agents)

---

## Roadmap Questions

### What's planned for Conductor v2.0?

**Planned features**:

1. **Agent composition** - Chain agents into workflows
   ```yaml
   workflow: code-review-and-deploy
   steps:
     - agent: code-reviewer
     - agent: security-auditor
     - agent: deployment-assistant
   ```

2. **Context caching** - Reuse agent specs across sessions (0 tokens for cached)

3. **Performance metrics** - Track agent usage, quality, false positives/negatives

4. **Visual workflow builder** - Diagram agent interactions

5. **Output styles** - planning-mode, review-mode, debugging-mode

6. **VS Code extension** - Invoke Conductor agents from VS Code

7. **Agent marketplace** - Discover and install community agents

**Timeline**: Q2-Q3 2025

### Will Conductor support local LLMs?

**Not planned** - Conductor is designed for Claude Code.

**Reasoning**:
- Claude Code agent system is proprietary
- Local LLMs lack tool use consistency
- MCP integrations specific to Claude

**Alternative**: Fork Conductor and adapt for LangChain + local LLMs (community contribution welcome).

---

**Version**: 1.0.0
**Last Updated**: 2025-11-15
**License**: MIT
