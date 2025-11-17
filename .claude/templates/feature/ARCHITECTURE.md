# Architecture: [Feature Name]

**Feature ID**: F[XXX]
**Date**: YYYY-MM-DD
**Architect**: [Name]

---

## Overview

[High-level architectural approach for this feature]

## Design Decisions

### Decision 1: [Title]
- **Context**: [Why this decision was needed]
- **Decision**: [What was decided]
- **Alternatives Considered**: [Other options]
- **Rationale**: [Why this approach]
- **Consequences**: [Impact of this decision]

### Decision 2: [Title]
- **Context**:
- **Decision**:
- **Alternatives Considered**:
- **Rationale**:
- **Consequences**:

## System Components

### Component 1: [Name]
- **Purpose**: [What it does]
- **Location**: [File path or module]
- **Responsibilities**:
  - [Responsibility 1]
  - [Responsibility 2]
- **Dependencies**: [Other components it depends on]
- **Interfaces**: [Public API/methods]

### Component 2: [Name]
- **Purpose**:
- **Location**:
- **Responsibilities**:
- **Dependencies**:
- **Interfaces**:

## Data Flow

```
[User] --> [Component A] --> [Component B] --> [Database]
                |                   |
                v                   v
           [Service X]         [Service Y]
```

**Step-by-step**:
1. [Step 1 description]
2. [Step 2 description]
3. [Step 3 description]

## API Design

### Endpoint: [METHOD] /api/path
- **Purpose**: [What it does]
- **Request**:
  ```json
  {
    "field": "type"
  }
  ```
- **Response**:
  ```json
  {
    "field": "type"
  }
  ```
- **Error Cases**:
  - `400`: [When this happens]
  - `404`: [When this happens]
  - `500`: [When this happens]

## Database Schema

### Table: [table_name]
```sql
CREATE TABLE table_name (
  id SERIAL PRIMARY KEY,
  field1 VARCHAR(255) NOT NULL,
  field2 TIMESTAMP DEFAULT NOW(),
  INDEX idx_field1 (field1)
);
```

**Indexes**:
- `idx_field1`: [Purpose]

**Migrations**:
- [ ] Migration script created
- [ ] Rollback script created

## Security Considerations

- **Authentication**: [How users are authenticated]
- **Authorization**: [Who can access what]
- **Data Validation**: [Input validation strategy]
- **Encryption**: [What data is encrypted, how]
- **Rate Limiting**: [Rate limiting strategy]

## Performance Considerations

- **Caching**: [What is cached, where, TTL]
- **Database Queries**: [Optimization strategy]
- **Asset Loading**: [Lazy loading, bundling]
- **Expected Load**: [Users/requests per second]

## Testing Strategy

### Unit Tests
- [ ] [Component 1] unit tests
- [ ] [Component 2] unit tests
- [ ] [Utility function] tests

### Integration Tests
- [ ] [API endpoint 1] integration test
- [ ] [Database interaction] test
- [ ] [External service] integration test

### E2E Tests
- [ ] [User flow 1] E2E test
- [ ] [Critical path] E2E test

## Deployment Strategy

- **Feature Flags**: [Which flags to use]
- **Rollout Plan**: [Gradual rollout or full deployment]
- **Monitoring**: [What to monitor]
- **Rollback Plan**: [How to rollback if needed]

## Technical Debt

- [Known shortcut or compromise]
- [Future improvement needed]

## Related Documentation

- [Link to related ADR]
- [Link to related component doc]
- [Link to external reference]

## Open Questions

- [ ] [Question 1]
- [ ] [Question 2]
