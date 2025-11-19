#!/bin/bash
# Hook: PostCommit - Sync progress tracking with git commits
# Updates CLAUDE.md and STATUS.md based on committed changes

echo "📊 Syncing progress with commit..."

# Get commit message and changed files
COMMIT_MSG=$(git log -1 --pretty=%B)
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD)

# Function to detect feature from changed files
detect_feature_from_commit() {
  # Check if any feature docs were modified
  local feature_doc=$(echo "$CHANGED_FILES" | grep -E "docs/features/[^/]+" | head -1)
  if [[ -n "$feature_doc" ]]; then
    echo "$feature_doc" | sed -E 's|docs/features/([^/]+)/.*|\1|'
    return 0
  fi

  # Check commit message for feature ID
  if [[ "$COMMIT_MSG" =~ (F[0-9]{3}) ]]; then
    local feature_id="${BASH_REMATCH[1]}"
    local feature_dir=$(find docs/features -type d -name "${feature_id}*" | head -1)
    if [[ -n "$feature_dir" ]]; then
      basename "$feature_dir"
      return 0
    fi
  fi

  # Check current branch
  local branch=$(git branch --show-current 2>/dev/null)
  if [[ "$branch" =~ (F[0-9]+) ]]; then
    local feature_id="${BASH_REMATCH[1]}"
    local feature_dir=$(find docs/features -type d -name "${feature_id}*" | head -1)
    if [[ -n "$feature_dir" ]]; then
      basename "$feature_dir"
      return 0
    fi
  fi

  return 1
}

FEATURE_NAME=$(detect_feature_from_commit)
if [[ -z "$FEATURE_NAME" ]]; then
  # No feature context
  exit 0
fi

FEATURE_DIR="docs/features/$FEATURE_NAME"
STATUS_FILE="$FEATURE_DIR/STATUS.md"
CLAUDE_FILE="$FEATURE_DIR/CLAUDE.md"

if [[ ! -d "$FEATURE_DIR" ]]; then
  exit 0
fi

# Analyze what was committed
SRC_FILES=$(echo "$CHANGED_FILES" | grep -E "src/|lib/" | wc -l)
TEST_FILES=$(echo "$CHANGED_FILES" | grep -E "test|spec|__tests__" | wc -l)
DOC_FILES=$(echo "$CHANGED_FILES" | grep -E "\.md$|docs/" | wc -l)

# Update STATUS.md metrics
if [[ -f "$STATUS_FILE" ]] && [[ $SRC_FILES -gt 0 || $TEST_FILES -gt 0 ]]; then
  # Count lines changed
  STATS=$(git diff HEAD~1 HEAD --numstat | awk '{added+=$1; removed+=$2} END {print added, removed}')
  LINES_ADDED=$(echo "$STATS" | awk '{print $1}')
  LINES_REMOVED=$(echo "$STATS" | awk '{print $2}')

  # Update metrics in STATUS.md
  if grep -q "## Metrics" "$STATUS_FILE"; then
    # Update Files Modified count
    TOTAL_FILES=$(echo "$CHANGED_FILES" | wc -l)

    if grep -q "Files Modified" "$STATUS_FILE"; then
      # Increment existing count
      CURRENT=$(grep "Files Modified" "$STATUS_FILE" | grep -oE "[0-9]+" | head -1)
      NEW_COUNT=$((CURRENT + TOTAL_FILES))
      if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "s/Files Modified.*$/Files Modified**: $NEW_COUNT/" "$STATUS_FILE"
      else
        sed -i "s/Files Modified.*$/Files Modified**: $NEW_COUNT/" "$STATUS_FILE"
      fi
    fi

    # Update Lines Added
    if grep -q "Lines Added" "$STATUS_FILE"; then
      CURRENT=$(grep "Lines Added" "$STATUS_FILE" | grep -oE "[0-9]+" | head -1)
      NEW_COUNT=$((CURRENT + LINES_ADDED))
      if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "s/Lines Added.*$/Lines Added**: $NEW_COUNT/" "$STATUS_FILE"
      else
        sed -i "s/Lines Added.*$/Lines Added**: $NEW_COUNT/" "$STATUS_FILE"
      fi
    fi

    # Update Lines Removed
    if grep -q "Lines Removed" "$STATUS_FILE"; then
      CURRENT=$(grep "Lines Removed" "$STATUS_FILE" | grep -oE "[0-9]+" | head -1)
      NEW_COUNT=$((CURRENT + LINES_REMOVED))
      if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "s/Lines Removed.*$/Lines Removed**: $NEW_COUNT/" "$STATUS_FILE"
      else
        sed -i "s/Lines Removed.*$/Lines Removed**: $NEW_COUNT/" "$STATUS_FILE"
      fi
    fi
  fi
fi

# Update CLAUDE.md with commit summary
if [[ -f "$CLAUDE_FILE" ]] && [[ $SRC_FILES -gt 0 || $TEST_FILES -gt 0 ]]; then
  # Determine what type of work was done
  WORK_TYPE=""
  if [[ $TEST_FILES -gt 0 ]] && [[ $SRC_FILES -eq 0 ]]; then
    WORK_TYPE="Tests"
  elif [[ $SRC_FILES -gt 0 ]] && [[ $TEST_FILES -eq 0 ]]; then
    WORK_TYPE="Implementation"
  elif [[ $SRC_FILES -gt 0 ]] && [[ $TEST_FILES -gt 0 ]]; then
    WORK_TYPE="Implementation + Tests"
  fi

  if [[ -n "$WORK_TYPE" ]] && grep -q "## Implementation Journey" "$CLAUDE_FILE"; then
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
    COMMIT_SHORT=$(git log -1 --pretty=%h)

    # Extract first line of commit message
    FIRST_LINE=$(echo "$COMMIT_MSG" | head -1)

    NOTE="
**Commit $COMMIT_SHORT** ($TIMESTAMP): $WORK_TYPE
- $FIRST_LINE
- Files changed: $SRC_FILES src, $TEST_FILES tests
"

    # Find Implementation Journey section and append
    if grep -q "### Iteration Tracking" "$CLAUDE_FILE"; then
      # Insert after "### Iteration Tracking"
      LINE_NUM=$(grep -n "### Iteration Tracking" "$CLAUDE_FILE" | head -1 | cut -d: -f1)
      if [[ -n "$LINE_NUM" ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
          sed -i "" "${LINE_NUM}a\\
$NOTE" "$CLAUDE_FILE"
        else
          sed -i "${LINE_NUM}a\\
$NOTE" "$CLAUDE_FILE"
        fi
      fi
    fi
  fi
fi

# Detect if tests were run and update test count
if echo "$COMMIT_MSG" | grep -qE "test.*pass|tests.*passing|all tests pass"; then
  if [[ -f "$STATUS_FILE" ]] && grep -q "## Metrics" "$STATUS_FILE"; then
    # Extract test count from commit message
    TEST_COUNT=$(echo "$COMMIT_MSG" | grep -oE "[0-9]+.*test" | grep -oE "^[0-9]+" | head -1)

    if [[ -n "$TEST_COUNT" ]]; then
      if grep -q "Tests Passing" "$STATUS_FILE"; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
          sed -i "" "s/Tests Passing.*$/Tests Passing**: $TEST_COUNT/" "$STATUS_FILE"
        else
          sed -i "s/Tests Passing.*$/Tests Passing**: $TEST_COUNT/" "$STATUS_FILE"
        fi
      fi
    fi
  fi
fi

echo "   ✅ Progress synced for $FEATURE_NAME"

exit 0
