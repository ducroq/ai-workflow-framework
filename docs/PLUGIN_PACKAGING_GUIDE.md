# Plugin Packaging Guide

**Purpose**: How to package and distribute the AI Workflow Framework as a Claude Code plugin

---

## Plugin Structure

The framework is packaged as a complete Claude Code plugin with all components:

```
ai-workflow-framework/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── .claude/
│   ├── agents/              # All agent definitions
│   ├── skills/              # All skill definitions
│   ├── hooks/               # Hook scripts
│   ├── settings.json        # Hook configurations
│   ├── .mcp.json            # MCP integrations
│   ├── AGENT-TEMPLATE.md    # Meta-template for agents
│   └── SKILL-TEMPLATE.md    # Meta-template for skills
├── docs/
│   ├── TAXONOMY.md
│   ├── HOOKS_GUIDE.md
│   ├── MCP_INTEGRATION_GUIDE.md
│   ├── SESSION_STATE.md
│   └── decisions/
│       └── ADR-TEMPLATE.md
├── README.md                # Complete usage guide
├── TEST_REPORT.md           # Validation results
└── LICENSE                  # MIT License
```

---

## Plugin Manifest (plugin.json)

Located at `.claude-plugin/plugin.json`:

```json
{
  "name": "ai-workflow-framework",
  "version": "1.0.0",
  "description": "Reusable AI-augmented workflow framework...",
  "author": "AI Workflow Framework Contributors",
  "license": "MIT",
  "components": {
    "agents": [...],
    "skills": [...],
    "hooks": [...],
    "templates": [...],
    "mcp": [...],
    "documentation": [...]
  }
}
```

### Key Fields

- **name**: Unique plugin identifier (lowercase-with-hyphens)
- **version**: Semantic versioning (MAJOR.MINOR.PATCH)
- **components**: Lists all included files
- **dependencies**: Optional formatters and tools
- **configuration**: Required environment variables

---

## Distribution Methods

### Method 1: GitHub Repository

**Recommended for open-source distribution**

1. Create GitHub repository:
   ```bash
   git init
   git add .
   git commit -m "Initial plugin release v1.0.0"
   git remote add origin https://github.com/your-org/ai-workflow-framework.git
   git push -u origin main
   ```

2. Create release tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. Users install with:
   ```bash
   /plugin install ai-workflow-framework@github:your-org/ai-workflow-framework
   ```

---

### Method 2: Plugin Marketplace

**Recommended for wide distribution**

1. Create marketplace manifest (`marketplace.json`):
   ```json
   {
     "name": "AI Workflow Framework Marketplace",
     "plugins": [
       {
         "name": "ai-workflow-framework",
         "version": "1.0.0",
         "url": "https://github.com/your-org/ai-workflow-framework.git",
         "description": "Complete AI-augmented workflow framework",
         "featured": true
       }
     ]
   }
   ```

2. Submit to Claude Code marketplace (process TBD)

3. Users install with:
   ```bash
   /plugin marketplace add https://your-marketplace-url/marketplace.json
   /plugin install ai-workflow-framework
   ```

---

### Method 3: Direct File Distribution

**For team/enterprise distribution**

1. Package as archive:
   ```bash
   tar -czf ai-workflow-framework-v1.0.0.tar.gz .claude .claude-plugin docs README.md
   ```

2. Distribute file to team

3. Users install by:
   ```bash
   mkdir -p ~/.claude/plugins/ai-workflow-framework
   tar -xzf ai-workflow-framework-v1.0.0.tar.gz -C ~/.claude/plugins/ai-workflow-framework
   ```

---

## Installation for Users

### Quick Install

```bash
# From marketplace (future)
/plugin install ai-workflow-framework

# From GitHub
/plugin install ai-workflow-framework@github:your-org/ai-workflow-framework

# From local directory
/plugin install /path/to/ai-workflow-framework
```

### Manual Install

1. Clone or download repository
2. Copy to Claude plugins directory:
   ```bash
   cp -r ai-workflow-framework ~/.claude/plugins/
   ```
3. Restart Claude Code
4. Plugin automatically loads

---

## Configuration After Install

### 1. Install Optional Formatters

```bash
# JavaScript/TypeScript
npm install -g prettier eslint

# Python
pip install black autopep8

# (Go and Rust formatters included with language installations)
```

### 2. Configure Environment Variables

Create `.env` or add to shell profile:

```bash
# GitHub integration
export GITHUB_TOKEN=ghp_your_token_here

# Supabase integration
export SUPABASE_URL=https://yourproject.supabase.co
export SUPABASE_KEY=your_api_key_here

# Other integrations (optional)
export FIGMA_TOKEN=your_token
export LINEAR_API_KEY=your_key
export SLACK_BOT_TOKEN=xoxb_your_token
```

### 3. Initialize SESSION_STATE

Copy template:
```bash
cp ~/.claude/plugins/ai-workflow-framework/docs/SESSION_STATE.md ./docs/
```

Edit with your project details.

---

## Versioning Strategy

### Semantic Versioning

- **MAJOR** (1.x.x): Breaking changes (API changes, removed agents)
- **MINOR** (x.1.x): New features (new agents, skills, hooks)
- **PATCH** (x.x.1): Bug fixes, documentation updates

### Changelog

Maintain `CHANGELOG.md`:

```markdown
# Changelog

## [1.0.0] - 2025-11-15

### Added
- Initial release
- 11 core agents (software-engineering, ml-workflow, data-science, devops, security, meta)
- 1 skill (refactor-extract-function)
- 3 hooks (auto-format, session-state-update, adr-suggestion)
- 5 MCP integrations (GitHub, Supabase, Figma, Linear, Slack)
- Complete documentation

## [1.1.0] - Future

### Added
- New agents: deployment-assistant, architecture-advisor
- New skills: security-scan-sql-injection, test-generator-jest
- Additional MCP integrations

### Changed
- Improved agent-tester pressure scenarios
- Enhanced documentation

### Fixed
- Bug fixes
```

---

## Plugin Updates

### For Plugin Developers

1. Make changes to agents/skills/hooks
2. Update version in `plugin.json`
3. Update `CHANGELOG.md`
4. Commit and tag:
   ```bash
   git add .
   git commit -m "Release v1.1.0"
   git tag v1.1.0
   git push origin main --tags
   ```

### For Users

```bash
# Update from marketplace
/plugin update ai-workflow-framework

# Update from GitHub
cd ~/.claude/plugins/ai-workflow-framework
git pull origin main
```

---

## Customization for Teams

### Fork and Customize

1. Fork repository:
   ```bash
   git clone https://github.com/your-org/ai-workflow-framework.git
   cd ai-workflow-framework
   ```

2. Add team-specific agents:
   ```bash
   # Use agent-creator metaskill
   # Create agents for team workflows
   ```

3. Update plugin.json with new components

4. Distribute to team

### Private Marketplace

Create team marketplace:

```json
{
  "name": "YourCompany Internal Plugins",
  "plugins": [
    {
      "name": "ai-workflow-framework",
      "version": "1.0.0-yourcompany",
      "url": "https://github.yourcompany.com/internal/ai-workflow-framework.git",
      "description": "Customized for YourCompany workflows",
      "private": true
    }
  ]
}
```

---

## Uninstallation

```bash
# Via plugin manager
/plugin uninstall ai-workflow-framework

# Manual
rm -rf ~/.claude/plugins/ai-workflow-framework
```

---

## Plugin Components Breakdown

### Agents (11 operational)
- **Software Engineering**: code-reviewer, debugger, refactoring-guide
- **ML Workflow**: oracle-calibration, dataset-qa
- **Data Science**: data-analyzer
- **DevOps**: deployment-troubleshooter
- **Security**: security-auditor
- **Meta**: agent-creator, skill-creator, agent-tester

### Skills (1 operational, more planned)
- **Software Engineering**: refactor-extract-function

### Hooks (3 operational)
- auto-format.sh (PostToolUse)
- suggest-session-state-update.sh (Stop)
- suggest-adr.sh (SubagentStop)

### MCPs (5 configured)
- GitHub (issues, PRs)
- Supabase (database)
- Figma (design files)
- Linear (project management)
- Slack (notifications)

### Meta-Templates (2)
- AGENT-TEMPLATE.md
- SKILL-TEMPLATE.md

---

## Support and Contributions

### Reporting Issues

```bash
# Create issue on GitHub
https://github.com/your-org/ai-workflow-framework/issues/new
```

### Contributing New Agents/Skills

1. Use metaskills to create new components:
   ```
   You: "Create an agent for database migration validation"
   Claude: [Uses agent-creator to generate agent]
   ```

2. Test with agent-tester

3. Submit pull request with new agent

4. Plugin maintainer reviews and merges

### Community Extensions

Create separate plugins that depend on this framework:

```json
{
  "name": "ai-workflow-extensions-react",
  "dependencies": {
    "ai-workflow-framework": "^1.0.0"
  },
  "components": {
    "agents": [
      "agents/react-component-reviewer.md",
      "agents/react-performance-advisor.md"
    ]
  }
}
```

---

## License

MIT License - See LICENSE file

Framework is open-source and free to use, modify, and distribute.

---

## Future Enhancements

### Planned Features
- **v1.1**: Additional agents (deployment-assistant, architecture-advisor, model-evaluator, training-advisor)
- **v1.2**: More skills (security-scan-*, test-generator-*, api-design-*)
- **v1.3**: Output styles (planning-mode, review-mode, debugging-mode)
- **v2.0**: Visual diagrams, CLI tool for agent generation, video tutorials

### Community Contributions Welcome
- New domain agents
- Language-specific skills
- Additional MCP integrations
- Documentation improvements
- Translations

---

**Last Updated**: 2025-11-15
**Version**: 1.2.0
**Status**: Ready for Distribution
