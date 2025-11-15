#!/bin/bash
# Sync Conductor framework to global Claude Code directory

SOURCE_DIR="/c/local_dev/conductor/.claude"
DEST_DIR="/c/Users/scbry/.claude"

echo "🔄 Syncing Conductor framework to Claude Code..."

# Copy agents
echo "  📋 Syncing agents..."
cp -r "$SOURCE_DIR/agents/"* "$DEST_DIR/agents/" 2>/dev/null || echo "    No agents to sync"

# Copy skills
echo "  ⚡ Syncing skills..."
cp -r "$SOURCE_DIR/skills/"* "$DEST_DIR/skills/" 2>/dev/null || echo "    No skills to sync"

# Copy hooks
echo "  🪝 Syncing hooks..."
cp -r "$SOURCE_DIR/hooks/"* "$DEST_DIR/hooks/" 2>/dev/null || echo "    No hooks to sync"

# Copy templates
echo "  📄 Syncing templates..."
cp -r "$SOURCE_DIR/templates" "$DEST_DIR/" 2>/dev/null || echo "    No templates to sync"

# Copy template files
echo "  📋 Syncing templates..."
cp "$SOURCE_DIR/AGENT-TEMPLATE.md" "$DEST_DIR/" 2>/dev/null || echo "    No agent template to sync"
cp "$SOURCE_DIR/SKILL-TEMPLATE.md" "$DEST_DIR/" 2>/dev/null || echo "    No skill template to sync"

# Update version info
VERSION=$(grep '"version"' .claude-plugin/plugin.json | head -1 | sed 's/.*"version": "\(.*\)".*/\1/')
echo ""
echo "✅ Conductor framework synced! (version $VERSION)"
echo ""
echo "⚠️  Restart Claude Code to see changes"
