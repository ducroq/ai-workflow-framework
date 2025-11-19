# Feature Knowledge Base: [Feature Name]

**Feature ID**: F[XXX]
**Created**: [Date]
**Last Updated**: [Date]

---

## Purpose

This document captures implementation knowledge, decisions, and lessons learned during the development of this feature. It serves as a knowledge base for:
- Future developers working on similar features
- AI pair programming context
- Team learning and pattern sharing
- Troubleshooting and debugging

---

## Test Strategy

### Overall Approach
<!-- Document the testing strategy used -->
- **Test Coverage Plan**: [What was prioritized]
- **Test Framework**: [Jest, Pytest, etc.]
- **Test Types**: [Unit, Integration, E2E proportions]

### Mocking Decisions
<!-- What was mocked and why -->
- **[Dependency Name]**: [Why mocked, what was mocked]
- **[External Service]**: [Mocking approach and rationale]

### Non-Obvious Edge Cases
<!-- Edge cases discovered during testing -->
- **[Edge Case Description]**: [Why it matters, how it's tested]
- **[Boundary Condition]**: [Specific scenario and test coverage]

### Test Patterns Used
<!-- Testing patterns from the codebase -->
- **[Pattern Name]**: [When used, why it fits]
- **[Testing Approach]**: [How it aligns with project conventions]

### Testing Challenges
<!-- Challenges encountered and solutions -->
- **Challenge**: [What was difficult to test]
- **Solution**: [How it was addressed]
- **Lesson**: [Key insight for future testing]

---

## Implementation Journey

### Iteration Tracking

#### [Component Name]
- **Iteration 1**: [What was tried] - [Result]
- **Iteration 2**: [Adjustment made] - [Result]
- **Iteration 3**: [Final approach] - [Result]
- **Total**: X iterations, all tests passing ✅

#### [Another Component]
- **Iteration 1**: [Initial implementation] - [Result]
- **Iteration 2**: [Refinement] - [Result]
- **Total**: X iterations, all tests passing ✅

**Average Iterations**: [X.X] across all components

---

## Problem-Solution Pairs

### Problem: [Component] - [Issue Description]
**Context**: What was being implemented when the problem occurred

**Problem**: Specific technical challenge or blocker encountered

**Solution**: How the problem was resolved

**Iteration**: Solved on iteration #X

**Code Reference**: `file_path:line_number`

---

### Problem: [Another Problem]
**Context**: [When this happened]

**Problem**: [Detailed problem description]

**Solution**: [Resolution approach]

**Iteration**: Solved on iteration #X

**Code Reference**: `file_path:line_number`

---

## Failed Approaches

### Tried: [Approach Name]
**What I tried**: Specific implementation or architectural approach attempted

**Why it failed**:
- Test failures encountered
- Technical limitations discovered
- Performance/security issues identified

**What worked instead**: The successful alternative approach

**Lesson**: Key insight for avoiding this in the future

---

### Tried: [Another Failed Approach]
**What I tried**: [Description]

**Why it failed**: [Reasons]

**What worked instead**: [Successful approach]

**Lesson**: [Takeaway]

---

## Successful Patterns

### Working Pattern: [Pattern Name]
**Use case**: When to use this pattern in this codebase

**Implementation**:
```javascript
// Brief code example or pseudocode
```

**Tests covered**: Which acceptance criteria this pattern satisfied

**Rationale**: Why this pattern was chosen over alternatives

---

### Working Pattern: [Another Pattern]
**Use case**: [When applicable]

**Implementation**:
```javascript
// Example
```

**Tests covered**: [Test descriptions]

**Rationale**: [Why this approach]

---

## Architectural Decisions (ADRs)

### Decision: [Decision Title]
**Date**: [When decided]

**Context**: What was the situation requiring a decision?

**Decision**: What was decided?

**Alternatives Considered**:
1. [Alternative 1] - [Why not chosen]
2. [Alternative 2] - [Why not chosen]

**Rationale**: Why this decision was made

**Consequences**:
- ✅ Benefits: [Positive outcomes]
- ⚠️ Trade-offs: [Known limitations or costs]

**Status**: [Accepted / Superseded by [link]]

---

## Blockers & Resolutions

### Blocker: [Blocker Description]
**Encountered**: During [which phase]

**Impact**: What was blocked

**Root Cause**: Analysis of underlying issue

**Resolution**: How it was resolved

**Resolution Time**: [Duration]

**Resolved By**: [Person/Team or "Self-resolved"]

---

## Performance Notes

<!-- If performance was a requirement -->

### Performance Requirements
- **Requirement 1**: [Metric and target]
- **Requirement 2**: [Metric and target]

### Performance Results
- **Metric 1**: [Actual result vs target]
- **Metric 2**: [Actual result vs target]

### Optimization Applied
- **[Optimization]**: [Description and impact]
- **[Another Optimization]**: [Description and impact]

---

## Security Considerations

<!-- Security decisions and validations -->

### Security Requirements Addressed
- **Input Validation**: [Approach]
- **Authentication**: [How handled]
- **Authorization**: [How handled]
- **Data Protection**: [Measures taken]

### Security Testing
- **Tests Created**: [Count and coverage]
- **Vulnerabilities Prevented**: [OWASP categories addressed]

---

## Dependencies

### External Dependencies Added
- **[Package Name]**: [Version, why needed]
- **[Another Package]**: [Version, why needed]

### Internal Dependencies
- **[Component/Module]**: [How it's used]
- **[Another Component]**: [Integration points]

---

## Technical Debt

### Known Limitations
- **[Limitation 1]**: [Description, why it exists, future improvement]
- **[Limitation 2]**: [Description, why it exists, future improvement]

### Future Improvements
- **[Improvement 1]**: [What could be better, when to prioritize]
- **[Improvement 2]**: [Enhancement opportunity]

---

## Key Learnings

### What Went Well
1. [Success factor 1]
2. [Success factor 2]
3. [Success factor 3]

### What Could Be Improved
1. [Area for improvement 1]
2. [Area for improvement 2]
3. [Area for improvement 3]

### Recommendations for Similar Features
1. [Recommendation 1]
2. [Recommendation 2]
3. [Recommendation 3]

---

## References

### Related Features
- **[Feature F[XXX]]**: [Relationship or similarity]
- **[Feature F[XXX]]**: [Shared patterns or components]

### External Resources
- **[Documentation]**: [Link and relevance]
- **[Article/Tutorial]**: [Link and what was learned]

### Code Examples Referenced
- **[Codebase Example]**: `file_path:line_number` - [What was learned]

---

## Team Knowledge Sharing

### Reusable Components Created
- **[Component Name]**: `file_path` - [Purpose, when to reuse]
- **[Utility Function]**: `file_path` - [Purpose, when to reuse]

### Patterns to Replicate
- **[Pattern Name]**: [Description, where it can be applied]
- **[Approach]**: [Situation where this approach fits]

### Anti-Patterns to Avoid
- **[Anti-Pattern]**: [What doesn't work, why to avoid]
- **[Bad Approach]**: [Why it failed, better alternative]

---

**Note**: This document should be updated throughout the feature development lifecycle:
- **Planning Phase**: Document test strategy
- **Testing Phase**: Record test challenges and edge cases
- **Implementation Phase**: Track iterations, problems, solutions, and patterns
- **Review Phase**: Capture learnings and recommendations
