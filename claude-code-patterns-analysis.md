# Claude Code Patterns Analysis

**Date**: 2025-11-15
**Purpose**: Synthesize official Claude Code patterns with user's existing framework

---

## Key Findings from Claude Code Documentation

### 1. **Sub-agents vs Skills** (Critical Distinction!)

| Aspect | Sub-agents | Skills |
|--------|-----------|--------|
| **Invocation** | Explicit (user/agent calls them) | Automatic (Claude decides when to use) |
| **Storage** | `.claude/agents/` | `.claude/skills/` |
| **Context** | Separate context window | Progressive disclosure |
| **Use Case** | Complex multi-step tasks | Single focused capabilities |
| **Example** | "Code reviewer agent" | "PDF form filling skill" |

**Implication**: User's current agents could be split into:
- **Agents**: Rudolf (navigation), Cupid (orchestration), Comet (documentation)
- **Skills**: Vixen (geocoding), Prancer (data validation), specific refactoring patterns

---

### 2. **Official Directory Structure**

```
.claude/
├── agents/              # Sub-agent definitions
├── skills/              # Model-invoked capabilities
├── commands/            # Custom slash commands
├── output-styles/       # Custom communication modes
├── settings.json        # Hooks configuration
└── .mcp.json           # External tool integrations
```

**User's current structure**:
```
docs/
├── agents/
│   ├── templates/       # Agent definitions
│   ├── AI_AUGMENTED_WORKFLOW.md
│   └── SESSION_STATE.md
├── decisions/           # ADRs
└── guides/              # Human documentation
```

**Recommendation**: Hybrid approach
- Use `.claude/` for Claude Code native features (agents, skills, hooks)
- Keep `docs/` for human-facing docs and workflow philosophy
- Bridge the two with clear references

---

### 3. **Hooks for Automation** (New Capability!)

**9 Available Hook Events**:
- `PreToolUse` - Before tool calls (can block)
- `PostToolUse` - After tool calls
- `UserPromptSubmit` - Before processing prompts
- `Notification` - When notifications sent
- `Stop` - When Claude finishes responding
- `SubagentStop` - When subagent completes
- `PreCompact` - Before context compaction
- `SessionStart` - Session initialization
- `SessionEnd` - Session termination

**Potential use cases for software engineering**:
- Auto-format code after Edit/Write (PostToolUse hook)
- Log all Bash commands for audit (PostToolUse hook)
- Update SESSION_STATE.md after significant work (Stop hook)
- Validate code standards before commits (PreToolUse hook blocking)
- Auto-generate ADRs for architectural decisions (Stop hook)

---

### 4. **Agent Architecture Patterns**

**YAML Frontmatter** (matches user's pattern!):
```yaml
---
name: agent-name
description: What it does and when to use it
tools: Read, Grep, Glob, Bash
model: sonnet | haiku | opus | inherit
---
```

**Best Practices from Claude Code**:
- Single-responsibility design ✅ (user already does this)
- Minimal tool permissions (user doesn't restrict tools currently)
- Detailed prompts with examples ✅ (user does this)
- Version control via git ✅ (user does this)
- Context isolation (user doesn't leverage this explicitly)

---

### 5. **Plugins for Distribution**

**Plugin structure**:
```
my-plugin/
├── .claude-plugin/plugin.json
├── agents/              # Bundled agents
├── skills/              # Bundled skills
├── commands/            # Bundled slash commands
├── hooks/               # Bundled hook configs
└── .mcp.json           # External integrations
```

**Opportunity**: Package user's agent framework as distributable plugins:
- `software-engineering-agents` plugin
- `ml-workflow-agents` plugin
- `documentation-agents` plugin

---

### 6. **Output Styles** (Communication Modes)

**Built-in**: Default, Explanatory, Learning

**Custom styles** via markdown + YAML in `.claude/output-styles/`:
```yaml
---
name: code-review-mode
description: Detailed code review with security focus
keep-coding-instructions: true
---

# Custom Instructions

When in code review mode:
- Check for security vulnerabilities (OWASP Top 10)
- Validate code style consistency
- Suggest performance optimizations
- Use PASS/REVIEW/FAIL framework
```

**Potential styles for software engineering**:
- `planning-mode` - Architecture planning, ADR generation
- `review-mode` - Code review, security analysis
- `refactoring-mode` - Code improvement suggestions
- `debugging-mode` - Root cause analysis
- `documentation-mode` - Generate docs, update SESSION_STATE

---

### 7. **MCP (Model Context Protocol)**

External tool integration for:
- Issue trackers (Linear, Jira, GitHub Issues)
- Databases (PostgreSQL, MongoDB)
- APIs (Stripe, Slack, Notion)
- Design tools (Figma)
- Infrastructure (Vercel, Netlify, AWS)

**Relevance**: Could integrate with user's existing systems:
- Supabase for SANTA project (via MCP)
- GitHub for issue tracking
- Notion for documentation

---

## Gap Analysis: User's Patterns vs Claude Code

### What User Has (Not in Claude Code)

✅ **SESSION_STATE.md** - Running project logbook
- **Value**: Context recovery, session continuity
- **Recommendation**: Keep this! It's a unique innovation

✅ **AI_AUGMENTED_WORKFLOW.md** - Philosophy & principles
- **Value**: Defines how AI should behave
- **Recommendation**: Keep as meta-documentation

✅ **PASS/REVIEW/FAIL Framework** - Decision criteria
- **Value**: Structured quality gates
- **Recommendation**: Integrate into agents and skills

✅ **ADRs (Architecture Decision Records)**
- **Value**: Decision documentation with context
- **Recommendation**: Automate with hooks (Stop hook → suggest ADR creation)

✅ **Progressive Disclosure** - Load context as needed
- **Value**: Token efficiency
- **Recommendation**: Both user and Claude Code have this

✅ **Agent Orchestration** - Delegation patterns (Cupid → Vixen → Prancer → Donner)
- **Value**: Complex workflows
- **Recommendation**: Formalize as reusable pattern

### What Claude Code Has (User Doesn't)

❌ **Skills** (model-invoked) - User has agents but not auto-invoked skills
- **Gap**: No automatic capability discovery
- **Recommendation**: Extract single-purpose patterns as skills

❌ **Hooks** - Event-driven automation
- **Gap**: No automated workflows (formatting, logging, validation)
- **Recommendation**: Add hooks for common tasks

❌ **Output Styles** - Communication modes
- **Gap**: No mode switching (planning vs debugging vs review)
- **Recommendation**: Create custom output styles

❌ **Plugins** - Distributable bundles
- **Gap**: No packaging for reuse across projects
- **Recommendation**: Package as plugins

❌ **Tool Restrictions** - Minimal permissions per agent
- **Gap**: All agents have access to all tools
- **Recommendation**: Apply principle of least privilege

❌ **MCP Integration** - External tools
- **Gap**: No standardized external integrations
- **Recommendation**: Add for databases, APIs, issue trackers

---

## Recommended Hybrid Architecture

### Directory Structure

```
project/
├── .claude/                           # Claude Code native
│   ├── agents/                        # Sub-agents (explicit invocation)
│   │   ├── rudolf-navigator.md
│   │   ├── code-reviewer.md
│   │   └── deployment-assistant.md
│   ├── skills/                        # Skills (auto-invoked)
│   │   ├── refactor-extract-function.md
│   │   ├── security-scan.md
│   │   └── test-generator.md
│   ├── output-styles/                 # Communication modes
│   │   ├── planning-mode.md
│   │   ├── review-mode.md
│   │   └── debugging-mode.md
│   ├── commands/                      # Custom slash commands
│   │   ├── status.md                  # /status → read SESSION_STATE
│   │   └── adr.md                     # /adr → create ADR
│   ├── settings.json                  # Hooks configuration
│   └── .mcp.json                      # External integrations
│
├── docs/                              # Human-facing (user's innovation)
│   ├── SESSION_STATE.md               # Running logbook
│   ├── AI_AUGMENTED_WORKFLOW.md       # Philosophy
│   ├── decisions/                     # ADRs
│   │   └── YYYY-MM-DD-title.md
│   └── guides/                        # User guides
│
└── sandbox/                           # Git-ignored experiments
```

### Agent Classification

**Sub-agents (Explicit Invocation)**:
- **Rudolf** - Navigation, session orientation
- **Cupid** - Orchestration, multi-step workflows
- **Code Reviewer** - Quality & security analysis
- **Debugger** - Root cause analysis
- **Deployment Assistant** - CI/CD, infrastructure

**Skills (Auto-Invoked)**:
- **Refactoring Patterns** - Extract function, inline variable, etc.
- **Security Scanning** - OWASP checks, dependency audit
- **Test Generation** - Unit tests, integration tests
- **Documentation Generation** - JSDoc, README updates
- **Data Validation** - Schema checks, type validation

**Output Styles (Communication Modes)**:
- **Planning Mode** - Architecture design, ADR generation
- **Review Mode** - Code review with PASS/REVIEW/FAIL
- **Debugging Mode** - Root cause analysis
- **Refactoring Mode** - Code improvement suggestions
- **Documentation Mode** - Generate/update docs

### Hooks for Automation

**Code Quality**:
- `PostToolUse(Edit|Write)` → Auto-format (Prettier, ESLint)
- `PreToolUse(Write)` → Validate doesn't overwrite protected files

**Documentation**:
- `Stop` → Suggest SESSION_STATE.md update
- `SubagentStop` → Suggest ADR if architectural decision made

**Logging**:
- `PostToolUse(Bash)` → Log command with description
- `UserPromptSubmit` → Track session activity

**Validation**:
- `PreToolUse(Bash:git commit)` → Validate commit message format
- `PreToolUse(Write:.env)` → Block (security)

---

## Next Steps

1. **Validate Alignment**: Confirm this hybrid approach matches user's vision
2. **Create Meta-Templates**:
   - Agent template (aligned with Claude Code + user's patterns)
   - Skill template
   - Output style template
   - Hook configuration template
3. **Define Software Engineering Taxonomy**:
   - What agents are needed?
   - What skills are needed?
   - What hooks are useful?
4. **Build Generator Tools**: Scripts to create new agents/skills from templates
5. **Package as Plugin**: Distribute as `software-engineering-agents` plugin

---

## Key Insights

1. **Claude Code provides infrastructure** (agents, skills, hooks, plugins)
2. **User provides workflow innovations** (SESSION_STATE, ADRs, PASS/REVIEW/FAIL, orchestration)
3. **Combining both creates powerful framework** for AI-augmented development
4. **Skills are the missing piece** - user has agents but not auto-invoked capabilities
5. **Hooks enable automation** - user can automate documentation, validation, formatting
6. **Output styles enable mode switching** - planning vs debugging vs review

---

## Questions for User

1. Do you want to adopt `.claude/` directory structure or keep `docs/agents/`?
2. Should we distinguish agents (explicit) from skills (auto-invoked)?
3. Which hooks would be most valuable for your workflow?
4. Do you want to package this as a distributable plugin?
5. Are there other external resources to review before we start building?
