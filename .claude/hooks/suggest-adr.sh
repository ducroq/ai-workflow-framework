#!/bin/bash
# Suggest ADR creation when architectural decisions are made
# Triggered by SubagentStop event (when subagent completes)

AGENT_NAME="$1"
AGENT_OUTPUT="$2"

# Keywords that might indicate architectural decisions
DECISION_KEYWORDS="decided|chose|selected|pattern|architecture|design|approach|strategy|trade-off"

# Check if agent output contains decision keywords
if echo "$AGENT_OUTPUT" | grep -iE "$DECISION_KEYWORDS" > /dev/null; then
  echo ""
  echo "📋 This looks like an architectural decision."
  echo "   Consider creating an ADR (Architecture Decision Record):"
  echo "   1. Copy docs/decisions/ADR-TEMPLATE.md (if it exists)"
  echo "   2. Document: Context, Decision, Consequences, Alternatives"
  echo "   3. Save as: docs/decisions/YYYY-MM-DD-title.md"
  echo ""
fi

exit 0
