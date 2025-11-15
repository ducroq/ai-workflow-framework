#!/bin/bash
# Hook: SessionStart - Load and summarize context at session start
# This hook provides developers with immediate context about where they left off

# Check if auto-docs are initialized
if [[ ! -f "docs/CURRENT_TASK.md" ]] && [[ ! -f "docs/PROJECT_OVERVIEW.md" ]]; then
  exit 0  # Auto-docs not initialized yet
fi

echo "📖 Loading project context..."

# TODO: Invoke auto-docs-maintainer agent to:
# 1. Read CURRENT_TASK.md
# 2. Read OPEN_QUESTIONS.md (critical/important)
# 3. Read recent decisions (last 3)
# 4. Summarize: "Here's where we left off..."
# 5. Suggest next actions based on ROADMAP

# For now, show quick summary
if [[ -f "docs/CURRENT_TASK.md" ]]; then
  echo ""
  echo "Current Task:"
  head -n 5 "docs/CURRENT_TASK.md" | tail -n 3
fi

if [[ -f "docs/OPEN_QUESTIONS.md" ]]; then
  CRITICAL=$(grep -A 1 "## Critical" "docs/OPEN_QUESTIONS.md" | grep -c "^\-")
  if [[ $CRITICAL -gt 0 ]]; then
    echo ""
    echo "⚠️  $CRITICAL critical question(s) need attention"
  fi
fi

exit 0
