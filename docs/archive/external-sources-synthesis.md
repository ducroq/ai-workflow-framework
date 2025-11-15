# External Sources Synthesis

**Date**: 2025-11-15
**Sources**: Contains Studio, Superpowers, Jesse Vincent's blog posts

---

## Key Insights from External Sources

### 1. **Contains Studio Agents** (8-Department Organization)

**Organization Pattern**:
```
agents/
├── engineering/        (7 agents) - implementation, testing, deployment
├── design/            (5 agents) - UI/UX, branding, visual
├── marketing/         (7 agents) - platform-specific growth
├── product/           (3 agents) - research, prioritization
├── project-management/(3 agents) - shipping, tracking
├── studio-operations/ (5 agents) - analytics, compliance
├── testing/           (5 agents) - QA, optimization
└── bonus/             (2 agents) - morale, humor
```

**Agent Structure**:
```yaml
name: unique-identifier
description: When to use + 3-4 detailed examples  # Critical!
color: visual-identifier
tools: accessible-resources
```

**System Prompt** (500+ words):
- Role definition
- Core responsibilities
- Domain expertise
- Studio integration philosophy
- Best practices
- Constraints
- Success metrics

**Key Innovation**: **Description includes 3-4 concrete examples** of when to use the agent

---

### 2. **Superpowers** (Jesse Vincent's Skills Library)

**Core Philosophy**:
> "Skills are mandatory when they exist"

**Architecture**:
- SessionStart hook loads foundational skills
- Automatic discovery and activation
- 5 domains: Testing, Debugging, Collaboration, Development, Meta
- Slash commands: `/superpowers:brainstorm`, `/write-plan`, `/execute-plan`

**Design Principles**:
1. Test-driven development FIRST
2. Systematic processes over intuition
3. Complexity reduction
4. Evidence-based validation
5. Domain-level problem solving

**Key Innovation**: **Metaskills** - skills that create/test other skills

---

### 3. **Jesse Vincent's Blog Insights**

#### A. Skills Design (2025-10-16)

**Critical Distinction**:
- "What does this skill do?" ≠ "When should Claude use this skill?"
- **Explicit usage guidance > capability descriptions**

**Implementation Patterns**:
- Skills can invoke other skills (composite skills)
- Test-driven approach prevents Claude from rationalizing non-compliance
- **Skill creation metaskills** enable self-improvement

**Challenge**: Reliable automatic activation is still hard

#### B. Superpowers Evolution (2025-10-12)

**Major Lesson**:
> "External tools become obsolete when the platform adopts their core functionality natively"

- The hardest part: Getting Claude to use skills autonomously
- Claude's native support may solve this
- AI capabilities evolve rapidly

#### C. Original Superpowers Philosophy (2025-10-09)

**Behavioral Enforcement**:
- **Pressure testing**: Validate skills under realistic scenarios (production outages, time constraints, sunk costs)
- Agents must comply, not just acknowledge

**Persuasion-Informed Design** (Cialdini's principles):
1. **Authority**: "This skill is mandatory"
2. **Commitment**: "You agreed to follow this skill"
3. **Social proof**: "Other agents successfully use this"

**Self-Improvement**:
- Agents read skills (markdown)
- Agents write new skills
- Recursive improvement loop

#### D. Episodic Memory (2025-10-23)

**Components**:
1. **Auto-archive**: Preserve conversation logs (beyond 1-month default)
2. **Vector search**: SQLite with semantic retrieval
3. **MCP tool + subagent**: Query past conversations

**What It Preserves** (that docs/code don't):
- Reasoning behind decisions
- Trade-offs discussed
- Rejected alternatives
- Attempted approaches

**User's SESSION_STATE.md is a form of episodic memory!**

#### E. MCP Design Principles (2025-10-19)

**Traditional API Design ≠ MCP Design**

**For LLMs, prefer**:
1. **Flexibility over rigidity**: Accept multiple input formats (CSS + XPath, not just CSS)
2. **Progressive disclosure**: "Tell Claude how to get more info when needed"
3. **Recovery-focused**: Graceful degradation > fail-fast
4. **Human-readable errors**: Guide toward recovery, not dead ends
5. **Practical utility > architectural purity**: Single dispatcher tool can outperform multi-tool

**Example**: `superpowers-chrome` MCP
- Single `use_browser` tool with flexible actions
- Auto-initialization
- 947 tokens vs 13,678 for Playwright
- "Unhinged" design beats "proper" architecture

---

## Synthesis: What to Incorporate

### 1. **Organization by Domain** (from Contains Studio)

**Recommendation**:
```
.claude/
├── agents/
│   ├── software-engineering/
│   │   ├── code-reviewer.md
│   │   ├── debugger.md
│   │   └── deployment-assistant.md
│   ├── ml-workflow/
│   │   ├── oracle-calibration.md
│   │   ├── dataset-qa.md
│   │   └── model-evaluator.md
│   ├── testing/
│   ├── collaboration/
│   └── meta/                    # Agents that create agents
├── skills/
│   ├── software-engineering/
│   │   ├── refactor-extract-function.md
│   │   ├── security-scan-owasp.md
│   │   └── test-generator-jest.md
│   ├── ml-workflow/
│   └── testing/
```

**Benefits**:
- Clear domain boundaries
- Easy to navigate
- Scales to many agents/skills
- Supports multi-domain vision

---

### 2. **YAML Frontmatter** (Enhanced)

```yaml
---
name: code-reviewer
description: >
  Reviews code for quality, security, and maintainability.
  Use when:
  - Pull request created
  - Before merging to main
  - After significant refactoring
  - Security-sensitive code changes
examples:
  - "Review this authentication logic for security vulnerabilities"
  - "Check this database query for SQL injection"
  - "Validate error handling in this API endpoint"
domain: software-engineering
tools: Read, Grep, Glob  # Minimal permissions
model: sonnet
color: blue  # Optional: for UI
when_mandatory: true  # Like superpowers: use when applicable
---
```

**Key additions**:
- **description**: What + When (from Contains Studio)
- **examples**: 3-4 concrete use cases (from Contains Studio)
- **domain**: Organization
- **when_mandatory**: Enforce usage (from Superpowers)

---

### 3. **System Prompt Structure** (500+ words, from Contains Studio)

```markdown
# Agent Name

## Role
[Brief identity statement]

## Core Responsibilities
1. [Primary task]
2. [Secondary task]
3. [Tertiary task]

## Domain Expertise
[Specific knowledge areas]

## Integration Philosophy
[How this agent fits into workflows]

## Best Practices
- [Practice 1]
- [Practice 2]
- [Practice 3]

## Constraints
- [Limitation 1]
- [Limitation 2]

## Success Metrics
[How to measure success]

## Decision Criteria
- ✅ PASS: [Conditions]
- ⚠️ REVIEW: [Conditions]
- ❌ FAIL: [Conditions]

## Examples
[Detailed scenarios]
```

---

### 4. **Mandatory Skills** (from Superpowers)

When a skill exists for a task, **Claude MUST use it**.

**Implementation**:
- SessionStart hook: Load skill index
- System prompt: "Skills are mandatory when applicable"
- Skill frontmatter: `when_mandatory: true`

**Example**:
- Skill: `refactor-extract-function.md` exists
- User: "This function is too long, help me clean it up"
- Claude: **MUST** use the extraction skill (can't freehand it)

---

### 5. **Metaskills** (Self-Improvement)

**Agents that create agents**:

```
.claude/
├── agents/
│   └── meta/
│       ├── agent-creator.md      # Creates new agents
│       ├── skill-creator.md      # Creates new skills
│       ├── agent-tester.md       # Pressure-tests agents
│       └── agent-refiner.md      # Improves existing agents
```

**Workflow**:
1. User: "Create an agent for database migration validation"
2. Claude invokes `agent-creator.md`
3. Agent-creator uses template to generate new agent
4. Claude invokes `agent-tester.md` to pressure-test it
5. Agent saved to `.claude/agents/database/`

---

### 6. **Pressure Testing** (from Superpowers)

**Validate agents comply under realistic constraints**:
- Production outage scenarios
- Time pressure
- Sunk cost bias (user already wrote bad code)
- Conflicting requirements

**Agent-tester metaskill**:
```markdown
Test this agent under:
1. User insists on skipping tests (time pressure)
2. Code already written, wants quick review (sunk cost)
3. Production bug, need immediate fix (outage scenario)

Agent must STILL follow best practices, not rationalize shortcuts.
```

---

### 7. **Episodic Memory** (Enhanced SESSION_STATE.md)

**Current**: User has SESSION_STATE.md (manual updates)

**Enhancement**:
- **Auto-archive**: Hook saves conversations automatically
- **Vector search**: Semantic search over past sessions
- **MCP integration**: Query tool for "what did we discuss about X?"

**Location**: Keep in root or `docs/SESSION_STATE.md` (both Claude and humans read it)

**Complementary files**:
- `.claude/memory/` - Vector DB for semantic search
- `.claude/hooks/session-end.sh` - Auto-update SESSION_STATE

---

### 8. **Persuasion-Informed Design** (Cialdini's Principles)

**Build into agent prompts**:

1. **Authority**: "As the designated [role], you are the authority on [domain]"
2. **Commitment**: "You committed to following this skill when you started"
3. **Social proof**: "Other agents successfully use this pattern"
4. **Consistency**: "You followed this approach in the last 3 sessions"
5. **Scarcity**: "This is your only chance to catch this bug before production"

**Example in code-reviewer.md**:
```markdown
## Authority
You are the designated security reviewer. Users trust your expertise.

## Commitment
By invoking you, the user committed to addressing security issues you find.

## Social Proof
Top engineering teams use systematic code review. You embody this practice.
```

---

### 9. **MCP Design Principles**

When creating MCPs for external tools:

1. **Flexible inputs**: Accept multiple formats
2. **Progressive disclosure**: Basic info upfront, details on demand
3. **Recovery-focused**: Return partial results over hard failures
4. **Human-readable errors**: Guide toward solutions
5. **Simplicity**: Single dispatcher > multiple specialized tools

---

## Comparison: User's Patterns vs External Sources

| Pattern | User Has | External Has | Recommendation |
|---------|----------|--------------|----------------|
| Domain organization | ❌ Flat structure | ✅ Department-based | **Adopt domain structure** |
| Examples in description | ❌ | ✅ Contains Studio | **Add 3-4 examples** |
| Mandatory skills | ❌ | ✅ Superpowers | **Add when_mandatory flag** |
| Metaskills | ❌ | ✅ Superpowers | **Create meta/ domain** |
| Pressure testing | ❌ | ✅ Superpowers | **Add agent-tester metaskill** |
| Episodic memory | ✅ SESSION_STATE (manual) | ✅ Superpowers (auto) | **Enhance with auto-archive** |
| Persuasion principles | ❌ | ✅ Superpowers | **Add to agent prompts** |
| PASS/REVIEW/FAIL | ✅ User innovation | ❌ | **Keep this!** |
| AI_AUGMENTED_WORKFLOW.md | ✅ User innovation | ❌ | **Keep this!** |
| ADRs | ✅ User innovation | ❌ | **Keep this!** |
| Agent orchestration | ✅ User innovation | ❌ | **Keep this!** |

---

## Final Recommended Structure

```
project/
├── .claude/
│   ├── agents/
│   │   ├── software-engineering/
│   │   │   ├── code-reviewer.md
│   │   │   ├── debugger.md
│   │   │   ├── deployment-assistant.md
│   │   │   └── refactoring-guide.md
│   │   ├── ml-workflow/
│   │   │   ├── oracle-calibration.md
│   │   │   ├── dataset-qa.md
│   │   │   └── model-evaluator.md
│   │   ├── testing/
│   │   │   └── test-strategy-advisor.md
│   │   ├── collaboration/
│   │   │   ├── code-review-coordinator.md
│   │   │   └── planning-facilitator.md
│   │   └── meta/                    # Self-improvement
│   │       ├── agent-creator.md
│   │       ├── skill-creator.md
│   │       ├── agent-tester.md
│   │       └── agent-refiner.md
│   │
│   ├── skills/
│   │   ├── software-engineering/
│   │   │   ├── refactor-extract-function.md
│   │   │   ├── refactor-inline-variable.md
│   │   │   ├── security-scan-owasp.md
│   │   │   ├── test-generator-jest.md
│   │   │   └── api-design-rest.md
│   │   ├── ml-workflow/
│   │   │   ├── train-model-regression.md
│   │   │   └── validate-dataset-qa.md
│   │   └── testing/
│   │       ├── tdd-red-green-refactor.md
│   │       └── integration-test-strategy.md
│   │
│   ├── settings.json                # Hooks configuration
│   ├── .mcp.json                    # External tool integrations
│   └── memory/                      # Episodic memory (auto-archived)
│
├── docs/
│   ├── SESSION_STATE.md             # Running logbook (Claude + humans)
│   ├── AI_AUGMENTED_WORKFLOW.md     # Philosophy
│   ├── decisions/                   # ADRs
│   │   ├── ADR-TEMPLATE.md
│   │   └── YYYY-MM-DD-title.md
│   └── guides/                      # Human guides
│
└── sandbox/                         # Git-ignored experiments
```

---

## Answers to User's Questions

### 1. **SESSION_STATE.md location**

**Answer**: Root (`docs/SESSION_STATE.md`) because:
- ✅ Claude reads it (episodic memory)
- ✅ Humans read it (project documentation)
- ✅ Git-tracked (team collaboration)
- ✅ Easy to reference from agents

**Enhancement**: Add auto-archiving via SessionEnd hook

---

### 4. **Multi-domain structure**

**Answer**: **Domain-based subfolders** (not flat, not YAML tags)

**Reasons**:
- ✅ Contains Studio uses this (proven pattern)
- ✅ Scales to many agents (100+ agents across domains)
- ✅ Clear navigation (`agents/software-engineering/` vs `agents/ml-workflow/`)
- ✅ Domain-specific conventions
- ✅ Easy to expand to new domains

**Alternative considered**: Flat with YAML domain tags
- ❌ Harder to navigate with 100+ agents
- ❌ No clear domain boundaries
- ❌ Mixing concerns in same directory

---

## Next Steps

1. ✅ **Confirmed**: Use `.claude/` structure
2. ✅ **Confirmed**: Split agents vs skills
3. ✅ **Confirmed**: Domain-based organization
4. ⏳ **Next**: Define software engineering + ML taxonomy
5. ⏳ **Next**: Create meta-templates
6. ⏳ **Next**: Build metaskills (agent-creator, skill-creator)

---

## Key Innovations to Preserve

**From user's work**:
- SESSION_STATE.md as episodic memory
- AI_AUGMENTED_WORKFLOW.md as philosophy
- PASS/REVIEW/FAIL decision framework
- Agent orchestration patterns (Cupid → Vixen → Prancer → Donner)
- ADRs for architectural decisions

**From external sources**:
- Domain-based organization (Contains Studio)
- 3-4 examples in descriptions (Contains Studio)
- Mandatory skills (Superpowers)
- Metaskills for self-improvement (Superpowers)
- Pressure testing (Superpowers)
- Persuasion-informed design (Superpowers)
- MCP design principles (Jesse's blog)

**Combining both = Powerful, scalable, multi-domain AI-augmented workflow framework**
