# Agent & Skill Taxonomy

**Purpose**: Define all agents and skills for software engineering and ML workflow domains

---

## Software Engineering Domain

### Agents (Explicit Invocation)

1. **code-reviewer** - Code quality, security, maintainability review
2. **debugger** - Systematic root cause analysis
3. **refactoring-guide** - Code improvement strategies
4. **deployment-assistant** - CI/CD, deployment, rollback management
5. **architecture-advisor** - System design, patterns, trade-offs

### Skills (Auto-Invoked)

1. **refactor-extract-function** - Extract code blocks into functions
2. **refactor-inline-variable** - Inline unnecessary variables
3. **security-scan-sql-injection** - Detect SQL injection vulnerabilities
4. **security-scan-xss** - Detect XSS vulnerabilities
5. **test-generator-jest** - Generate Jest unit tests
6. **api-design-rest** - REST API design patterns

---

## ML Workflow Domain

### Agents (Explicit Invocation)

1. **oracle-calibration** - Validate LLM labeling quality
2. **dataset-qa** - Quality assurance for training datasets
3. **model-evaluator** - Model performance assessment
4. **training-advisor** - Training strategy and hyperparameter guidance

### Skills (Auto-Invoked)

1. **validate-dataset-schema** - Check dataset format and completeness
2. **train-model-regression** - Multi-dimensional regression training
3. **evaluate-model-metrics** - Calculate and analyze evaluation metrics

---

## Testing Domain

### Agents (Explicit Invocation)

1. **test-strategy-advisor** - Test planning and strategy

### Skills (Auto-Invoked)

1. **tdd-red-green-refactor** - Test-driven development cycle

---

## Collaboration Domain

### Agents (Explicit Invocation)

1. **planning-facilitator** - Feature planning and breakdown
2. **code-review-coordinator** - Coordinate multi-agent code reviews

---

## Meta Domain

### Agents (Explicit Invocation)

1. **agent-creator** - Create new agents ✅ (operational)
2. **skill-creator** - Create new skills ✅ (operational)
3. **agent-tester** - Pressure-test agents ✅ (operational)
4. **auto-docs-bootstrap** - Initialize auto-documentation system ✅ (operational)
5. **auto-docs-maintainer** - Maintain living documentation (via hooks) ✅ (operational)
6. **agent-refiner** - Improve existing agents (planned)

---

## Feature Workflow Commands (Slash Commands)

**Purpose**: Persona-based TDD workflow for structured feature development

### Workflow Commands (Sequential Personas)

1. **feature-init** (`/feature-init`) - Product Manager: Gather requirements, create feature directory ✅
2. **architect** (`/architect`) - System Architect: Design architecture, create task breakdown ✅
3. **test-first** (`/test-first`) - Test Engineer: Write tests before implementation (TDD) ✅
4. **implement** (`/implement`) - Implementation Engineer: Minimal code to pass tests ✅
5. **qa-check** (`/qa-check`) - QA Engineer: Comprehensive quality review (PASS/REVIEW/FAIL) ✅
6. **document** (`/document`) - Documentation Writer: User/developer/ops documentation ✅

**Workflow**: `/feature-init` → `/architect` → `/test-first` → `/implement` → `/qa-check` → `/document`

**Benefits**:
- Structured TDD process with clear stages
- Context-efficient (use `/clear` between personas)
- Built-in quality review before deployment
- Comprehensive documentation as standard
- Plan mode for review before execution

**Documentation**: See [FEATURE_WORKFLOW_GUIDE.md](FEATURE_WORKFLOW_GUIDE.md) and [FEATURE_WORKFLOW_EXAMPLE.md](FEATURE_WORKFLOW_EXAMPLE.md)

---

## Priority Order for Implementation

**Phase 1 (Core - NOW)**:
- Software Engineering: code-reviewer, debugger, refactoring-guide
- Software Engineering Skills: refactor-extract-function, security-scan-sql-injection
- ML Workflow: oracle-calibration, dataset-qa

**Phase 2 (Extended)**:
- Software Engineering: deployment-assistant, architecture-advisor
- Software Engineering Skills: test-generator-jest, api-design-rest
- ML Workflow: model-evaluator, training-advisor

**Phase 3 (Advanced)**:
- Testing: test-strategy-advisor, tdd-red-green-refactor
- Collaboration: planning-facilitator, code-review-coordinator
- ML Skills: All remaining skills
