---
description: Load relevant CLAUDE.md sections for current work
---

You are in **Context Loading Mode**. Load and summarize relevant sections from CLAUDE.md for the user's current work.

## Your Task

1. **Detect Current Context**:
   - Check current git branch for feature ID
   - Check recent file modifications
   - Identify which feature the user is working on

2. **Load CLAUDE.md Sections**:
   - Read the CLAUDE.md file for the active feature
   - Identify most relevant sections based on:
     - Current development stage (from STATUS.md)
     - Recently modified files
     - User's current focus

3. **Summarize Relevant Information**:
   - **Architectural Decisions**: Key ADRs relevant to current work
   - **Implementation Journey**: Recent iterations and progress
   - **Problem-Solution Pairs**: Similar problems already solved
   - **Failed Approaches**: What to avoid
   - **Successful Patterns**: Proven solutions to reuse
   - **Blockers**: Current impediments

4. **Provide Actionable Context**:
   - Highlight learnings relevant to current task
   - Surface patterns that can be reused
   - Warn about failed approaches to avoid
   - Suggest next steps based on progress

## Output Format

```markdown
📚 Context Loaded: [Feature Name]

## Current Stage
[Stage from STATUS.md]

## Relevant Architectural Decisions
- **[Decision]**: [Summary and why it matters now]

## Recent Progress
- [Latest iteration notes]
- [Tests: X passing/failing]
- [Implementation status]

## Relevant Learnings
### Patterns to Reuse
- **[Pattern Name]**: [How to apply it]

### Problems Already Solved
- **[Problem]**: [Solution that worked]

### Approaches to Avoid
- **[Failed Approach]**: [Why it failed]

## Current Blockers
- [Blocker 1]
- [Blocker 2]

## Suggested Next Steps
1. [Action based on current stage]
2. [Action based on recent progress]
3. [Action based on blockers]
```

## Smart Filtering

Prioritize sections based on:
- **Current Stage**: If in testing, focus on test strategy and edge cases
- **Recent Files**: If editing storage.js, load storage-related learnings
- **Recency**: Prefer recent decisions and learnings over old ones
- **Relevance**: Score sections by keyword match with current work

## Example Usage

User says: "Continue working on dark mode toggle"

You:
1. Find F001-dark-mode-toggle feature
2. Read STATUS.md to see current stage
3. Read CLAUDE.md sections
4. Filter to most relevant information
5. Summarize actionable context

## Remember

The goal is to give the user **exactly the context they need** without overwhelming them with all of CLAUDE.md. Be selective and relevant.
