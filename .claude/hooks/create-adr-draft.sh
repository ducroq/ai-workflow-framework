#!/bin/bash
# Hook: SubagentStop - Create ADR draft when architectural decisions are detected
# This hook analyzes agent output for decisions and creates decision records

AGENT_NAME="$1"
AGENT_OUTPUT="$2"

# Check if docs/decisions/ directory exists
if [[ ! -d "docs/decisions" ]]; then
  exit 0  # Auto-docs not initialized yet
fi

# Keywords that indicate a decision was made
DECISION_KEYWORDS="chose|decided|selected|going with|using|adopting"

# Check if agent output contains decision indicators
if echo "$AGENT_OUTPUT" | grep -qiE "$DECISION_KEYWORDS"; then
  echo "🎯 Decision detected in $AGENT_NAME output"
  echo "   Creating ADR draft..."

  # TODO: Invoke auto-docs-maintainer agent to:
  # 1. Extract decision from agent output
  # 2. Identify context and consequences
  # 3. Create ADR draft with date stamp
  # 4. Notify developer for review
fi

exit 0
