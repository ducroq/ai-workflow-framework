# MCP Integration Guide

**Purpose**: Configure Model Context Protocol integrations for external tools and APIs

---

## What is MCP?

MCP (Model Context Protocol) allows Claude Code to interact with external tools, databases, and APIs. The framework includes preconfigured integrations for common services.

---

## Configured MCPs

### 1. GitHub (`github`)

**Purpose**: Issue tracking, pull requests, repository management

**Tools Available**:
- `list-issues` - List issues in a repository
- `create-issue` - Create new issue
- `get-pull-request` - Get PR details
- `create-pull-request` - Create new PR
- `list-repositories` - List repositories

**Setup**:
1. Generate GitHub Personal Access Token: https://github.com/settings/tokens
2. Add to environment:
   ```bash
   export GITHUB_TOKEN=ghp_your_token_here
   ```

**Usage**:
```
You: "List open issues in myorg/myrepo"
Claude: [Uses MCP to fetch issues from GitHub API]

You: "Create an issue for the bug we just found"
Claude: [Uses MCP to create issue with details]
```

---

### 2. Supabase (`supabase`)

**Purpose**: Database operations (PostgreSQL + PostGIS)

**Tools Available**:
- `query-table` - SELECT queries
- `insert-row` - INSERT data
- `update-row` - UPDATE data
- `delete-row` - DELETE data

**Setup**:
1. Get Supabase project URL and API key from dashboard
2. Add to environment:
   ```bash
   export SUPABASE_URL=https://yourproject.supabase.co
   export SUPABASE_KEY=your_api_key_here
   ```
3. Update `.claude/.mcp.json` with your project URL

**Usage**:
```
You: "Query all companies in the database"
Claude: [Uses MCP to run SELECT * FROM companies]

You: "Add a new company to the database"
Claude: [Uses MCP to INSERT INTO companies]
```

---

### 3. Figma (`figma`)

**Purpose**: Access design files, components, comments

**Tools Available**:
- `get-file` - Get design file
- `get-components` - List components
- `get-comments` - Get file comments

**Setup**:
1. Generate Figma Personal Access Token: https://www.figma.com/developers/api#access-tokens
2. Add to environment:
   ```bash
   export FIGMA_TOKEN=your_token_here
   ```

**Usage**:
```
You: "What components are in this Figma file?"
Claude: [Uses MCP to fetch components from Figma API]
```

---

### 4. Linear (`linear`)

**Purpose**: Issue tracking and project management

**Tools Available**:
- `list-issues` - List issues
- `create-issue` - Create issue
- `update-issue` - Update issue
- `list-projects` - List projects

**Setup**:
1. Get Linear API key from settings
2. Add to environment:
   ```bash
   export LINEAR_API_KEY=lin_api_your_key_here
   ```

**Usage**:
```
You: "List all bugs in the current sprint"
Claude: [Uses MCP to query Linear issues]
```

---

### 5. Slack (`slack`)

**Purpose**: Send notifications and messages

**Tools Available**:
- `send-message` - Send message to channel
- `list-channels` - List channels
- `get-messages` - Get channel messages

**Setup**:
1. Create Slack app and get bot token
2. Add to environment:
   ```bash
   export SLACK_BOT_TOKEN=xoxb-your-token-here
   ```

**Usage**:
```
You: "Notify the team about this deployment"
Claude: [Uses MCP to send Slack message]
```

---

## MCP Design Principles

From Jesse Vincent's blog post "MCPs are not like other APIs":

### 1. Flexibility Over Rigidity
- Accept multiple input formats
- Don't enforce strict parameter validation
- Allow both CSS and XPath selectors (not just one)

### 2. Progressive Disclosure
- Provide basic info upfront
- Detailed documentation available when needed
- Don't overload initial context

### 3. Recovery-Focused
- Return partial results over hard failures
- Graceful degradation when possible
- Guide toward solutions in error messages

### 4. Human-Readable Errors
- Explain what went wrong
- Suggest how to fix it
- Don't just return error codes

### 5. Simplicity Wins
- Single dispatcher tool can outperform multi-tool APIs
- Practical utility > architectural purity
- Token efficiency matters (947 tokens vs 13,678)

---

## Adding New MCPs

### Example: Notion Integration

1. Create MCP configuration in `.claude/.mcp.json`:

```json
{
  "mcpServers": {
    "notion": {
      "transport": "http",
      "url": "https://api.notion.com/v1",
      "description": "Notion database and page operations",
      "tools": [
        "query-database",
        "create-page",
        "update-page"
      ],
      "authentication": {
        "type": "token",
        "envVar": "NOTION_API_KEY"
      }
    }
  }
}
```

2. Set environment variable:
```bash
export NOTION_API_KEY=secret_your_key_here
```

3. Use in Claude:
```
You: "Add this to my Notion database"
Claude: [Uses MCP to create page in Notion]
```

---

## Security Best Practices

### Never Hardcode Tokens
❌ Bad:
```json
{
  "authentication": {
    "token": "ghp_actual_token_here"  // NEVER DO THIS
  }
}
```

✅ Good:
```json
{
  "authentication": {
    "type": "token",
    "envVar": "GITHUB_TOKEN"  // Reference environment variable
  }
}
```

### Use Read-Only Tokens When Possible
- GitHub: Fine-grained tokens with minimum scopes
- Supabase: Read-only API keys for analysis
- Slack: Bot tokens with minimal permissions

### Audit MCP Usage
- Review which MCPs are being invoked
- Monitor API usage and costs
- Revoke unused tokens

### Third-Party MCPs
⚠️ Warning from Claude Code docs:
> "Use third party MCP servers at your own risk - Anthropic has not verified the correctness or security of all these servers."

Only use MCPs from trusted sources.

---

## Troubleshooting

### "MCP not found"
- Check `.claude/.mcp.json` syntax
- Verify MCP name matches exactly
- Ensure file is in correct location

### "Authentication failed"
- Check environment variable is set:
  ```bash
  echo $GITHUB_TOKEN
  ```
- Verify token has correct permissions
- Check token hasn't expired

### "MCP timeout"
- Check API endpoint is accessible
- Verify network connectivity
- Increase timeout in config:
  ```json
  {
    "config": {
      "defaultTimeout": 60000  // 60 seconds
    }
  }
  ```

---

## Cost Optimization

### Use MCPs Wisely
- MCP calls consume tokens (request + response)
- Cache responses when possible
- Use progressive disclosure (don't fetch everything upfront)

### Example Comparison
**Inefficient**:
```
Fetch all 10,000 GitHub issues → 500,000 tokens
```

**Efficient**:
```
Fetch last 10 issues → 5,000 tokens
If needed, fetch more → 5,000 tokens/request
```

---

## Related Documentation

- `.claude/.mcp.json` - MCP configuration
- Claude Code MCP docs: https://code.claude.com/docs/en/mcp
- Jesse's blog: https://blog.fsck.com/2025/10/19/mcps-are-not-like-other-apis/

---

**Last Updated**: 2025-11-15
**Version**: 1.0
