#!/bin/bash
# Hook: SessionStart - Load and summarize context at session start
# This hook provides developers with immediate context about where they left off
# Enhanced with CLAUDE.md living documentation auto-loading

# Check if auto-docs are initialized
if [[ ! -f "docs/CURRENT_TASK.md" ]] && [[ ! -f "docs/PROJECT_OVERVIEW.md" ]]; then
  exit 0  # Auto-docs not initialized yet
fi

echo "📖 Loading project context..."

# Load CURRENT_TASK.md
if [[ -f "docs/CURRENT_TASK.md" ]]; then
  echo ""
  echo "Current Task:"
  CURRENT_TASK=$(head -n 10 "docs/CURRENT_TASK.md" | tail -n +3)
  echo "$CURRENT_TASK"
fi

# Check for active features with CLAUDE.md
ACTIVE_FEATURES=$(find docs/features -name "CLAUDE.md" 2>/dev/null | wc -l)
if [[ $ACTIVE_FEATURES -gt 0 ]]; then
  echo ""
  echo "📚 Active Features with Knowledge Base: $ACTIVE_FEATURES"

  # Find most recently updated feature
  RECENT_FEATURE=$(find docs/features -name "STATUS.md" -type f -exec ls -t {} + 2>/dev/null | head -1)
  if [[ -n "$RECENT_FEATURE" ]]; then
    FEATURE_DIR=$(dirname "$RECENT_FEATURE")
    FEATURE_NAME=$(basename "$FEATURE_DIR")

    echo "   📍 Most Recent: $FEATURE_NAME"

    # Load relevant CLAUDE.md sections if exists
    CLAUDE_MD="$FEATURE_DIR/CLAUDE.md"
    if [[ -f "$CLAUDE_MD" ]]; then
      # Extract current development status
      echo ""
      echo "💡 Recent Context from CLAUDE.md:"

      # Get Implementation Journey section if exists
      if grep -q "## Implementation Journey" "$CLAUDE_MD"; then
        echo "   - Implementation iterations tracked"
      fi

      # Get Problem-Solution Pairs count
      PROBLEMS=$(grep -c "^### Problem:" "$CLAUDE_MD" 2>/dev/null | head -1 || echo "0")
      if [[ $PROBLEMS -gt 0 ]]; then
        echo "   - $PROBLEMS problem-solution pairs documented"
      fi

      # Get Failed Approaches count
      FAILED=$(grep -c "^### Tried:" "$CLAUDE_MD" 2>/dev/null | head -1 || echo "0")
      if [[ $FAILED -gt 0 ]]; then
        echo "   - $FAILED failed approaches documented (avoid these!)"
      fi

      # Get Successful Patterns count
      PATTERNS=$(grep -c "^### Working Pattern:" "$CLAUDE_MD" 2>/dev/null | head -1 || echo "0")
      if [[ $PATTERNS -gt 0 ]]; then
        echo "   - $PATTERNS successful patterns identified"
      fi

      # Get Architectural Decisions count
      ADRS=$(grep -c "^### Decision" "$CLAUDE_MD" 2>/dev/null | head -1 || echo "0")
      if [[ $ADRS -gt 0 ]]; then
        echo "   - $ADRS architectural decisions recorded"
      fi
    fi

    # Show current stage from STATUS.md
    if [[ -f "$RECENT_FEATURE" ]]; then
      STAGE=$(grep "Current Stage" "$RECENT_FEATURE" | head -1)
      if [[ -n "$STAGE" ]]; then
        echo ""
        echo "   $STAGE"
      fi
    fi
  fi
fi

# Check for critical open questions
if [[ -f "docs/OPEN_QUESTIONS.md" ]]; then
  CRITICAL=$(grep -A 1 "## Critical" "docs/OPEN_QUESTIONS.md" | grep -c "^\-" 2>/dev/null | head -1 || echo "0")
  if [[ $CRITICAL -gt 0 ]]; then
    echo ""
    echo "⚠️  $CRITICAL critical question(s) need attention"
  fi
fi

# Check for blockers in active features
BLOCKERS=0
for STATUS in $(find docs/features -name "STATUS.md" -type f 2>/dev/null); do
  BLOCKER_COUNT=$(grep -A 5 "## Current Blockers" "$STATUS" | grep -c "^\|" 2>/dev/null | head -1 || echo "0")
  if [[ $BLOCKER_COUNT -gt 1 ]]; then  # More than just header row
    BLOCKERS=$((BLOCKERS + BLOCKER_COUNT - 1))
  fi
done

if [[ $BLOCKERS -gt 0 ]]; then
  echo ""
  echo "🚫 $BLOCKERS active blocker(s) across features"
fi

# Suggest next actions based on current state
echo ""
echo "🎯 Next Actions:"

# Check if we're in a feature directory
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  if [[ "$BRANCH" =~ feature/ ]] || [[ "$BRANCH" =~ f[0-9]+ ]]; then
    echo "   - Continue work on feature branch: $BRANCH"

    # Suggest appropriate slash command based on stage
    if [[ -f "$RECENT_FEATURE" ]]; then
      STAGE_LINE=$(grep "Current Stage" "$RECENT_FEATURE" | head -1)

      if [[ "$STAGE_LINE" =~ Planning|planning ]]; then
        echo "   - Run /architect to design technical architecture"
      elif [[ "$STAGE_LINE" =~ Architecture|architecture ]]; then
        echo "   - Run /test-first to create comprehensive tests"
      elif [[ "$STAGE_LINE" =~ Testing|test ]]; then
        echo "   - Run /implement to make tests pass"
      elif [[ "$STAGE_LINE" =~ Implementation|implement ]]; then
        echo "   - Run /qa-check for quality assurance review"
      elif [[ "$STAGE_LINE" =~ QA|qa ]]; then
        echo "   - Run /document to create user documentation"
      fi
    fi
  fi
fi

# Show recent git activity
RECENT_COMMITS=$(git log --oneline -3 2>/dev/null)
if [[ -n "$RECENT_COMMITS" ]]; then
  echo ""
  echo "📝 Recent Commits:"
  echo "$RECENT_COMMITS" | sed 's/^/   /'
fi

exit 0
