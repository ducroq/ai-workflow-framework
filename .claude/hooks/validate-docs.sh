#!/bin/bash
# Hook: PreCommit - Validate CLAUDE.md and STATUS.md consistency
# Ensures living documentation stays synchronized with codebase changes

EXIT_CODE=0

echo "🔍 Validating documentation consistency..."

# Function to check if file has been modified in this commit
is_modified() {
  git diff --cached --name-only | grep -q "$1"
}

# Function to validate markdown structure
validate_markdown() {
  local file=$1
  local errors=0

  if [[ ! -f "$file" ]]; then
    return 0  # File doesn't exist, skip
  fi

  # Check for basic markdown structure
  if ! grep -q "^# " "$file"; then
    echo "   ❌ $file: Missing top-level heading"
    errors=$((errors + 1))
  fi

  # Check for proper section markers
  if ! grep -q "^## " "$file"; then
    echo "   ⚠️  $file: No section headings found (may be incomplete)"
  fi

  return $errors
}

# Function to validate CLAUDE.md structure
validate_claude_md() {
  local file=$1
  local errors=0

  if [[ ! -f "$file" ]]; then
    return 0
  fi

  echo "   Validating: $file"

  # Check required sections
  local required_sections=(
    "Purpose"
    "Test Strategy"
    "Implementation Journey"
    "Problem-Solution Pairs"
    "Failed Approaches"
    "Successful Patterns"
    "Architectural Decisions"
    "Key Learnings"
  )

  for section in "${required_sections[@]}"; do
    if ! grep -q "## $section" "$file"; then
      echo "      ⚠️  Missing section: ## $section"
    fi
  done

  # Validate markdown structure
  validate_markdown "$file"
  errors=$?

  return $errors
}

# Function to validate STATUS.md structure
validate_status_md() {
  local file=$1
  local errors=0

  if [[ ! -f "$file" ]]; then
    return 0
  fi

  echo "   Validating: $file"

  # Check required sections
  local required_sections=(
    "Quick Summary"
    "Current Progress"
    "Recent Activity"
    "Current Blockers"
    "Next Steps"
    "Metrics"
  )

  for section in "${required_sections[@]}"; do
    if ! grep -q "## $section" "$file"; then
      echo "      ❌ Missing required section: ## $section"
      errors=$((errors + 1))
    fi
  done

  # Check for Last Updated date
  if ! grep -q "Last Updated" "$file"; then
    echo "      ⚠️  Missing 'Last Updated' field"
  fi

  # Validate markdown structure
  validate_markdown "$file"
  local md_errors=$?
  errors=$((errors + md_errors))

  return $errors
}

# Function to check if STATUS.md reflects recent changes
validate_status_freshness() {
  local status_file=$1
  local feature_dir=$(dirname "$status_file")

  if [[ ! -f "$status_file" ]]; then
    return 0
  fi

  # Check if any files in feature directory were modified
  local modified_in_feature=$(git diff --cached --name-only | grep -c "^$feature_dir/" | head -1 || echo "0")

  if [[ $modified_in_feature -gt 0 ]]; then
    # Check if STATUS.md was also updated
    if ! is_modified "$status_file"; then
      echo "   ⚠️  Files modified in $feature_dir but STATUS.md not updated"
      echo "      Consider updating STATUS.md to reflect recent changes"
    else
      # Check if Last Updated date is today
      local today=$(date +%Y-%m-%d)
      if ! grep -q "Last Updated.*$today" "$status_file"; then
        echo "   ⚠️  STATUS.md modified but 'Last Updated' date not current"
        echo "      Expected: $today"
      fi
    fi
  fi
}

# Function to check for major changes requiring decision log
check_decision_log() {
  local claude_file=$1
  local feature_dir=$(dirname "$claude_file")

  # Check if architecture or implementation files changed
  local arch_changes=$(git diff --cached --name-only | grep -E "ARCHITECTURE.md|src/|tests/" | grep -c "^$feature_dir/" | head -1 || echo "0")

  if [[ $arch_changes -gt 0 ]]; then
    # Check if CLAUDE.md has recent decision entries
    if [[ -f "$claude_file" ]]; then
      local today=$(date +%Y-%m-%d)
      local yesterday=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d 2>/dev/null || echo "")

      if ! grep -q "Date.*$today" "$claude_file" && ! grep -q "Date.*$yesterday" "$claude_file"; then
        echo "   ⚠️  Significant changes in $feature_dir but no recent decisions logged"
        echo "      Consider documenting architectural decisions in CLAUDE.md"
      fi
    fi
  fi
}

# Validate all CLAUDE.md files in modified features
for CLAUDE_FILE in $(find docs/features -name "CLAUDE.md" -type f 2>/dev/null); do
  FEATURE_DIR=$(dirname "$CLAUDE_FILE")

  # Check if this feature has any modified files
  MODIFIED_COUNT=$(git diff --cached --name-only | grep -c "^$FEATURE_DIR/" | head -1 || echo "0")

  if [[ $MODIFIED_COUNT -gt 0 ]] || is_modified "$CLAUDE_FILE"; then
    validate_claude_md "$CLAUDE_FILE"
    ERRORS=$?
    if [[ $ERRORS -gt 0 ]]; then
      EXIT_CODE=1
    fi

    check_decision_log "$CLAUDE_FILE"
  fi
done

# Validate all STATUS.md files in modified features
for STATUS_FILE in $(find docs/features -name "STATUS.md" -type f 2>/dev/null); do
  FEATURE_DIR=$(dirname "$STATUS_FILE")

  # Check if this feature has any modified files
  MODIFIED_COUNT=$(git diff --cached --name-only | grep -c "^$FEATURE_DIR/" | head -1 || echo "0")

  if [[ $MODIFIED_COUNT -gt 0 ]] || is_modified "$STATUS_FILE"; then
    validate_status_md "$STATUS_FILE"
    ERRORS=$?
    if [[ $ERRORS -gt 0 ]]; then
      EXIT_CODE=1
    fi

    validate_status_freshness "$STATUS_FILE"
  fi
done

# Check if implementation files were added without corresponding tests
SRC_FILES=$(git diff --cached --name-only --diff-filter=A | grep -E "src/.*\.(js|ts|jsx|tsx|py)$" || echo "")
if [[ -n "$SRC_FILES" ]]; then
  for SRC_FILE in $SRC_FILES; do
    # Extract filename without extension
    BASENAME=$(basename "$SRC_FILE" | sed 's/\.[^.]*$//')

    # Check if corresponding test file exists or is being added
    TEST_EXISTS=0
    for TEST_PATTERN in "tests/**/*${BASENAME}*test*" "tests/**/*${BASENAME}*spec*" "__tests__/**/*${BASENAME}*"; do
      if git diff --cached --name-only | grep -qE "$TEST_PATTERN"; then
        TEST_EXISTS=1
        break
      fi
      if find . -path "./$TEST_PATTERN" -type f 2>/dev/null | grep -q .; then
        TEST_EXISTS=1
        break
      fi
    done

    if [[ $TEST_EXISTS -eq 0 ]]; then
      echo "   ⚠️  New implementation file without tests: $SRC_FILE"
      echo "      Consider adding tests following TDD workflow"
    fi
  done
fi

# Summary
if [[ $EXIT_CODE -eq 0 ]]; then
  echo "   ✅ Documentation validation passed"
else
  echo ""
  echo "   ❌ Documentation validation found errors"
  echo "   Please fix errors before committing"
fi

exit $EXIT_CODE
