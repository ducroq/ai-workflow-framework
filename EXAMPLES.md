# Conductor Usage Examples

**Real-world scenarios demonstrating Conductor's agents, skills, hooks, and MCP integrations**

---

## Table of Contents

1. [Software Engineering](#software-engineering)
2. [ML Workflow](#ml-workflow)
3. [Data Science](#data-science)
4. [DevOps](#devops)
5. [Security](#security)
6. [Cross-Domain Workflows](#cross-domain-workflows)
7. [Framework Extension](#framework-extension)

---

## Software Engineering

### Example 1: Pre-Deployment Code Review

**Scenario**: Review authentication changes before deploying to production

**Workflow**:

```
You: "Review this authentication code before we deploy"

```python
# auth.py
def login(username, password):
    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    result = db.execute(query)
    if result:
        token = generate_token(username)
        return {"token": token}
    return {"error": "Invalid credentials"}
```

Claude: [Launches code-reviewer agent]

**Agent Analysis**:

```markdown
## Code Review: auth.py

### CRITICAL SECURITY ISSUES

❌ **SQL Injection Vulnerability** (CWE-89)
**Location**: Line 2
**Issue**: Unparameterized SQL query with user input
**Current Code**:
```python
query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
```

**Fix**:
```python
query = "SELECT * FROM users WHERE username=%s AND password=%s"
result = db.execute(query, (username, password))
```

❌ **Plain Text Password Storage**
**Location**: Line 2
**Issue**: Passwords should never be stored or compared in plain text
**Fix**:
```python
# On registration:
hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

# On login:
query = "SELECT password_hash FROM users WHERE username=%s"
result = db.execute(query, (username,))
if result and bcrypt.checkpw(password.encode('utf-8'), result[0]):
    # Valid password
```

### Decision: ❌ FAIL

**Action**: BLOCK deployment immediately. Fix critical security vulnerabilities.

**Estimated Fix Time**: 30 minutes
**Risk if Deployed**: Account compromise, data breach, SQL injection attacks
```

**Hooks Triggered**:
- ✓ auto-format.sh (would format fixed code)
- 💡 suggest-adr.sh (detects authentication pattern decision)

**Outcome**: Security vulnerabilities caught before production deployment

---

### Example 2: Refactoring Legacy God Class

**Scenario**: Break apart 2000-line controller class

**Workflow**:

```
You: "This UserController is 2000 lines and does everything. Help me refactor it"

Claude: [Launches refactoring-guide agent]
```

**Agent Analysis**:

```markdown
## Refactoring Analysis: UserController

### Current Issues

1. **God Class Anti-Pattern** (2,043 lines)
   - User management (registration, login, profile)
   - Email notifications
   - Analytics tracking
   - Payment processing
   - File uploads

2. **Multiple Responsibilities** (violates SRP)

3. **Hard to Test** (requires mocking 15+ dependencies)

### Recommended Strategy: Extract Classes

#### Phase 1: Extract UserAuthService
**Lines**: 1-350
**Responsibility**: Authentication (login, logout, token management)
**Dependencies**: Database, TokenManager

```python
class UserAuthService:
    def __init__(self, db, token_manager):
        self.db = db
        self.token_manager = token_manager

    def login(self, username, password):
        # Authentication logic here
        pass

    def logout(self, token):
        pass

    def refresh_token(self, refresh_token):
        pass
```

#### Phase 2: Extract UserProfileService
**Lines**: 351-680
**Responsibility**: Profile management (get, update, delete)
**Dependencies**: Database, FileStorage

#### Phase 3: Extract UserNotificationService
**Lines**: 681-950
**Responsibility**: Email notifications
**Dependencies**: EmailClient, TemplateEngine

#### Phase 4: Extract UserAnalyticsService
**Lines**: 951-1500
**Responsibility**: Analytics tracking
**Dependencies**: AnalyticsClient

#### Phase 5: Create UserFacade
**Purpose**: Maintain backward compatibility
**Pattern**: Facade pattern delegating to services

```python
class UserController:
    """Facade maintaining backward compatibility"""

    def __init__(self):
        self.auth = UserAuthService(db, token_manager)
        self.profile = UserProfileService(db, storage)
        self.notifications = UserNotificationService(email, templates)
        self.analytics = UserAnalyticsService(analytics_client)

    def login(self, username, password):
        return self.auth.login(username, password)

    def get_profile(self, user_id):
        return self.profile.get(user_id)
```

### Implementation Plan

**Week 1**: Extract UserAuthService
- Create new class
- Move authentication logic
- Update tests
- Deploy behind feature flag

**Week 2**: Extract UserProfileService
- Repeat pattern
- Ensure no regression

**Week 3**: Extract remaining services

**Week 4**: Create facade, update all callers

### Decision: ⚠️ REVIEW

**Recommendation**: Proceed with incremental extraction
**Risk**: Moderate (requires careful testing at each phase)
**Benefit**: 5 focused classes (200-400 lines each) vs. 1 monolith
```

**Skills Auto-Invoked**:
- refactor-extract-function (for long methods within controller)

**Outcome**: Clear refactoring roadmap with incremental steps

---

### Example 3: Debugging Intermittent API Timeouts

**Scenario**: Production API returns 500 errors intermittently

**Workflow**:

```
You: "Production API is timing out randomly. Users report it works sometimes, fails other times. No consistent pattern in logs"

Claude: [Launches debugger agent]
```

**Agent Analysis**:

```markdown
## Root Cause Analysis: Intermittent API Timeouts

### Symptoms

- Random 500 errors (15% of requests)
- No consistent pattern (time of day, specific users, payload size)
- Some requests succeed, others timeout (same endpoint, same payload)
- Error rate higher during peak traffic

### Hypotheses (Ranked by Likelihood)

#### Hypothesis 1: Race Condition in Concurrent Requests (HIGH)

**Theory**: Shared state modification without synchronization

**Test Plan**:
1. Add logging around shared state access
2. Reproduce with concurrent requests
3. Check for interleaved operations

**Test**:
```python
# Add logging
import threading

def process_request(request_id):
    logger.info(f"[{request_id}] Thread ID: {threading.get_ident()}")
    logger.info(f"[{request_id}] Accessing shared cache")
    # ... existing code
```

**Result**: ✅ CONFIRMED
```
Thread 1234: Accessing shared cache (key='user:123')
Thread 5678: Accessing shared cache (key='user:123')  # Concurrent!
Thread 1234: Writing to cache
Thread 5678: Writing to cache  # Overwrites Thread 1234's write
Thread 1234: Reading from cache  # Gets Thread 5678's data - WRONG!
→ NoneType error → 500 response
```

#### Root Cause: Missing Thread Synchronization

**Problematic Code**:
```python
# Shared cache without locking
cache = {}

def get_user_data(user_id):
    if user_id not in cache:
        data = fetch_from_database(user_id)
        cache[user_id] = data  # Race condition here!
    return cache[user_id]
```

**Fix**:
```python
import threading

cache = {}
cache_lock = threading.Lock()

def get_user_data(user_id):
    with cache_lock:  # Synchronize access
        if user_id not in cache:
            data = fetch_from_database(user_id)
            cache[user_id] = data
        return cache[user_id]
```

### Verification

**Before Fix**:
- 100 concurrent requests → 15 errors (15% failure rate)

**After Fix**:
- 100 concurrent requests → 0 errors (0% failure rate)

### Decision: ✅ PASS (Fix Verified)

**Deployment**: Deploy fix to production
**Monitoring**: Track error rate for 24 hours
**Expected**: 500 errors drop to near-zero
```

**Outcome**: Root cause identified and fixed in < 1 hour

---

## ML Workflow

### Example 4: LLM Labeling Quality Validation

**Scenario**: Using Claude to label 10,000 articles for sentiment, need to validate quality before batch processing

**Workflow**:

```
You: "I want to use Claude to label 10k articles for sentiment (positive, neutral, negative). Let's validate the approach first"

Claude: [Launches oracle-calibration agent]

Claude: "I'll calibrate with a 200-article sample before the full batch. This validates the labeling quality and estimates costs."

[Agent runs calibration]
```

**Agent Analysis**:

```markdown
## Oracle Calibration Report: Sentiment Labeling

### Calibration Sample: 200 articles

### Results by Dimension

| Dimension | Mean | Std Dev | Min | Max | Range Coverage | Status |
|-----------|------|---------|-----|-----|----------------|--------|
| sentiment | 0.0  | 2.1     | -3  | +3  | 7/7 values     | ✅ PASS |

### Distribution Analysis

**Sentiment Distribution**:
- Very Negative (-3): 12% (24 articles)
- Negative (-2): 18% (36 articles)
- Slightly Negative (-1): 15% (30 articles)
- Neutral (0): 20% (40 articles)
- Slightly Positive (+1): 16% (32 articles)
- Positive (+2): 12% (24 articles)
- Very Positive (+3): 7% (14 articles)

**Assessment**: ✅ Good distribution across full range

### Sample Validation

**Example 1: Very Negative (-3)**
> "This product is a complete disaster. Broke within a week, customer service was rude and unhelpful. Worst purchase ever."

**Label**: -3 (Very Negative)
**Confidence**: High ✅

**Example 2: Neutral (0)**
> "The product arrived on time. It works as advertised. Nothing particularly special about it."

**Label**: 0 (Neutral)
**Confidence**: High ✅

**Example 3: Very Positive (+3)**
> "Absolutely love this! Best purchase I've made all year. Exceeded all expectations. Highly recommend to everyone!"

**Label**: +3 (Very Positive)
**Confidence**: High ✅

### Cost Estimate

**Calibration Cost**: $2.50 (200 articles × $0.0125/article)

**Full Batch Cost**: $125 (10,000 articles × $0.0125/article)

**Variance**: ✅ Good (std dev = 2.1, indicating meaningful distinctions)

### Decision: ✅ PASS

**Recommendation**: Proceed with full batch labeling

**Confidence**: High - Calibration shows:
- Full range coverage
- Reasonable distribution
- Consistent labeling
- Good variance (not all neutral)

**Next Step**: Run batch labeling on 10,000 articles
```

**Delegation**:
- After batch labeling: Automatically invoke dataset-qa agent to validate final dataset

**Outcome**: Validated LLM labeling quality before spending $125 on batch processing

---

### Example 5: Dataset Quality Assurance Before Training

**Scenario**: 10k labeled articles ready for model training, need QA check

**Workflow**:

```
You: "I have 10k labeled articles. Can we verify quality before training?"

Claude: [Launches dataset-qa agent]
```

**Agent Analysis**:

```markdown
## Dataset QA Report

### Dataset: sentiment_articles_10k.jsonl

### 1. Completeness Check

✅ All 10,000 samples have required fields:
- `article_text`: 10,000/10,000 (100%)
- `sentiment_score`: 10,000/10,000 (100%)
- `confidence`: 10,000/10,000 (100%)

### 2. Score Validity

✅ All scores in valid range [-3, +3]:
- Valid: 10,000/10,000 (100%)
- Invalid: 0

### 3. Variance Check

✅ Sufficient variance (not all neutral):

| Score | Count | Percentage |
|-------|-------|------------|
| -3    | 612   | 6.1%       |
| -2    | 1,805 | 18.1%      |
| -1    | 1,523 | 15.2%      |
| 0     | 1,998 | 20.0%      |
| +1    | 1,601 | 16.0%      |
| +2    | 1,203 | 12.0%      |
| +3    | 1,258 | 12.6%      |

**Standard Deviation**: 2.03 ✅ (target: > 1.0)

### 4. Duplicate Detection

❌ Found 23 duplicate articles (0.23%)

**Example Duplicates**:
```json
{
  "article_id_1": 4523,
  "article_id_2": 8901,
  "text": "This product exceeded my expectations..."
}
```

**Recommendation**: Remove duplicates before training

### 5. Parse Error Check

✅ All 10,000 samples are valid JSON

### 6. Confidence Distribution

⚠️ Low confidence on 145 samples (1.45%)

**Examples of low confidence labels** (confidence < 0.6):
```
Article 3421: "It's okay I guess..."
Label: 0 (Neutral)
Confidence: 0.52
→ Recommendation: Review manually or exclude
```

### Decision: ⚠️ REVIEW

**Issues to Address**:
1. ❌ Remove 23 duplicate articles
2. ⚠️ Review or exclude 145 low-confidence samples

**After Fixes**:
- Final dataset: 9,832 samples (removed 168)
- Expected quality: High

**Recommendation**:
1. Run deduplication script
2. Exclude low-confidence samples
3. Proceed with training on 9,832 samples
```

**Outcome**: Dataset quality issues identified before expensive model training

---

## Data Science

### Example 6: Exploratory Data Analysis

**Scenario**: New customer dataset, need to understand patterns before analysis

**Workflow**:

```
You: "I have a customer dataset (customers.csv). What patterns should I investigate?"

Claude: [Launches data-analyzer agent]
```

**Agent Analysis**:

```markdown
## Exploratory Data Analysis: customers.csv

### Dataset Overview

- **Rows**: 50,000 customers
- **Columns**: 12 features
- **Missing Data**: 3 columns have nulls

### Key Patterns Identified

#### 1. Revenue Distribution (Highly Skewed)

**Finding**: Top 1% of customers generate 45% of revenue

```
Percentile | Revenue
-----------|----------
99th       | $50,000+
95th       | $12,000
90th       | $5,000
50th       | $850
```

**Recommendation**: Segment analysis (whale customers vs. typical)

#### 2. Churn Correlation

**Strong churn predictors**:
1. Support tickets > 5 in last month (75% churn rate)
2. Days since last login > 30 (62% churn rate)
3. Feature usage < 10% (58% churn rate)

**Visualization Recommendation**:
```python
import seaborn as sns

# Churn by support tickets
sns.boxplot(x='churned', y='support_tickets', data=df)
plt.title('Support Tickets vs. Churn')
```

#### 3. Geographic Clustering

**Finding**: 80% of customers in 3 regions
- West Coast: 45%
- Northeast: 25%
- Texas: 10%

**Recommendation**: Regional marketing strategies

### Missing Data Analysis

| Column | Missing % | Recommendation |
|--------|-----------|----------------|
| phone  | 12%       | Optional field, OK |
| industry | 23%    | Impute with "Unknown" |
| company_size | 31% | ⚠️ Critical for segmentation - investigate |

### Recommended Next Steps

1. **Segmentation Analysis**
   - Create whale/typical customer segments
   - Analyze behavior differences

2. **Churn Prediction Model**
   - Features: support_tickets, days_since_login, feature_usage
   - Target: churned (binary)
   - Model: Logistic regression baseline

3. **Regional Analysis**
   - Compare conversion rates by region
   - Identify high-value regions

4. **Missing Data Strategy**
   - Contact sales team about company_size data
   - Consider excluding incomplete records (31% loss)

### Decision: ✅ PASS

**Recommendation**: Proceed with segmentation and churn model

**Priority**: Address company_size missing data (31% is significant)
```

**Hooks Triggered**:
- 📊 Auto-generated visualization notebook

**Outcome**: Clear analytical roadmap with concrete next steps

---

## DevOps

### Example 7: Deployment Failure Diagnosis

**Scenario**: Kubernetes deployment failed, pods crashing

**Workflow**:

```
You: "Production deployment failed. Pods are crash-looping. Here's the log:

Error: Failed to pull image 'myapp:v2.1.0': rpc error: code = Unknown desc = Error response from daemon: manifest for myapp:v2.1.0 not found"

Claude: [Launches deployment-troubleshooter agent]
```

**Agent Analysis**:

```markdown
## Deployment Failure Analysis

### Error Classification

**Type**: Image Pull Error
**Severity**: Critical (Production Down)
**Impact**: All pods failing to start

### Root Cause: Image Not Found

**Error**: `manifest for myapp:v2.1.0 not found`

**Likely Causes**:
1. ✅ Image was never pushed to registry
2. ❌ Wrong registry URL
3. ❌ Authentication issue
4. ❌ Tag doesn't exist

### Diagnosis Steps

#### Step 1: Check Registry for Image

```bash
# Check Docker Hub (or your registry)
docker pull myapp:v2.1.0
```

**Result**: `Error: manifest unknown: manifest unknown`

**Conclusion**: ✅ Image doesn't exist in registry

#### Step 2: Check CI/CD Build Logs

**Finding**: Build succeeded but push failed

```
Step 10/10 : RUN npm run build
Successfully built 9a8f7e3d2c1b
Successfully tagged myapp:v2.1.0

Pushing to registry...
Error: unauthorized: authentication required
```

**Root Cause**: Registry authentication expired in CI/CD

### Fix

#### Immediate (Rollback to Last Working Version)

```bash
# Rollback deployment
kubectl rollout undo deployment/myapp

# Verify pods running
kubectl get pods
```

**Expected**: Pods return to v2.0.3 (last working version)

#### Permanent (Fix Registry Auth + Rebuild)

```bash
# 1. Update CI/CD registry credentials
# GitHub Actions:
# Settings → Secrets → DOCKER_PASSWORD (update)

# 2. Re-trigger build for v2.1.0
git tag -f v2.1.0
git push -f origin v2.1.0

# 3. Verify image pushed
docker pull myapp:v2.1.0  # Should succeed now

# 4. Re-deploy
kubectl rollout restart deployment/myapp
```

### Prevention

**Add to CI/CD Pipeline**:
```yaml
# .github/workflows/deploy.yml
- name: Verify Image Pushed
  run: |
    docker pull myapp:${{ github.ref_name }}
    if [ $? -ne 0 ]; then
      echo "Image push failed!"
      exit 1
    fi
```

### Decision: ✅ PASS (Fix Identified)

**Action Plan**:
1. ✅ Immediate: Rollback to v2.0.3 (restore service)
2. ⏳ Fix: Update registry credentials
3. ⏳ Rebuild: Re-tag and push v2.1.0
4. ⏳ Deploy: Restart deployment
5. 📋 Prevent: Add image verification to CI/CD

**Estimated Downtime**: 5 minutes (rollback) + 15 minutes (rebuild/deploy) = 20 minutes total
```

**Outcome**: Production restored in 5 minutes, permanent fix deployed in 20 minutes

---

## Security

### Example 8: Pre-Release Security Audit

**Scenario**: New API version ready, need security clearance before public release

**Workflow**:

```
You: "Audit this new API endpoint before we release it publicly"

```python
# api/v2/payments.py
@app.route('/api/v2/payment/process', methods=['POST'])
def process_payment():
    amount = request.json.get('amount')
    card_number = request.json.get('card_number')
    user_id = request.json.get('user_id')

    # Charge card
    result = stripe.charge(
        amount=amount,
        source=card_number,
        metadata={'user_id': user_id}
    )

    # Log transaction
    log_file = open(f'/var/log/payments_{user_id}.log', 'a')
    log_file.write(f'{amount},{card_number},{result}\n')
    log_file.close()

    return jsonify(result)
```

Claude: [Launches security-auditor agent]
```

**Agent Analysis**:

```markdown
## Security Audit: Payment API Endpoint

### CRITICAL VULNERABILITIES

#### 1. ❌ No Input Validation (CWE-20)

**Issue**: Accepts any `amount` without validation

**Attack Scenario**:
```json
POST /api/v2/payment/process
{
  "amount": -1000,  // Negative amount!
  "card_number": "...",
  "user_id": 123
}
```

**Impact**: Attacker credits their account instead of charging

**Fix**:
```python
amount = request.json.get('amount')
if not isinstance(amount, (int, float)) or amount <= 0:
    return jsonify({'error': 'Invalid amount'}), 400
if amount > 10000:  # Max transaction limit
    return jsonify({'error': 'Amount exceeds limit'}), 400
```

#### 2. ❌ Logging Sensitive Data (PCI-DSS Violation)

**Issue**: Logs credit card numbers to file

**Regulation**: PCI-DSS explicitly forbids logging full card numbers

**Current Code**:
```python
log_file.write(f'{amount},{card_number},{result}\n')  # ❌ Logs card_number
```

**Fix**:
```python
# Log only last 4 digits
masked_card = 'XXXX-XXXX-XXXX-' + card_number[-4:]
log_file.write(f'{amount},{masked_card},{result}\n')
```

#### 3. ❌ Path Traversal Vulnerability (CWE-22)

**Issue**: User-controlled `user_id` in file path

**Attack Scenario**:
```json
POST /api/v2/payment/process
{
  "user_id": "../../../etc/passwd",
  ...
}
```

**Result**: Writes payment data to `/var/log/payments_../../../etc/passwd.log` (could overwrite system files)

**Fix**:
```python
import os

# Sanitize user_id
if not str(user_id).isdigit():
    return jsonify({'error': 'Invalid user ID'}), 400

# Use safe path construction
log_dir = '/var/log/payments'
log_path = os.path.join(log_dir, f'{user_id}.log')

# Verify path is within expected directory
if not os.path.abspath(log_path).startswith(os.path.abspath(log_dir)):
    return jsonify({'error': 'Invalid path'}), 400
```

#### 4. ❌ No Authentication Check

**Issue**: Endpoint doesn't verify user authentication

**Attack**: Anyone can charge any card for any user

**Fix**:
```python
from functools import wraps

def require_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token or not verify_token(token):
            return jsonify({'error': 'Unauthorized'}), 401
        return f(*args, **kwargs)
    return decorated

@app.route('/api/v2/payment/process', methods=['POST'])
@require_auth  # Add authentication requirement
def process_payment():
    ...
```

#### 5. ❌ No Rate Limiting

**Issue**: No protection against brute-force attacks

**Attack**: Try thousands of card numbers rapidly

**Fix**:
```python
from flask_limiter import Limiter

limiter = Limiter(app, key_func=lambda: request.remote_addr)

@app.route('/api/v2/payment/process', methods=['POST'])
@limiter.limit("10 per minute")  # Max 10 payment attempts/minute
def process_payment():
    ...
```

### Decision: ❌ FAIL

**Action**: BLOCK PUBLIC RELEASE

**Critical Issues**: 5 high-severity vulnerabilities
1. No input validation (negative amounts, excessive amounts)
2. PCI-DSS violation (logging full card numbers)
3. Path traversal (arbitrary file write)
4. No authentication (unauthorized payments)
5. No rate limiting (brute-force card testing)

**Recommended Fix Order**:
1. **Immediate**: Add authentication (blocks unauthorized access)
2. **Immediate**: Fix PCI-DSS violation (regulatory requirement)
3. **Before Release**: Input validation
4. **Before Release**: Path traversal fix
5. **Before Release**: Rate limiting

**Estimated Fix Time**: 4-6 hours
**Re-Audit**: Required after fixes implemented
```

**Outcome**: Critical vulnerabilities caught before public release, preventing potential security breach

---

## Cross-Domain Workflows

### Example 9: End-to-End Feature Development

**Scenario**: Build and deploy new "password reset" feature

**Full Workflow** (multiple agents):

```
=== Step 1: Code Implementation ===

You: "Implement password reset functionality"

Claude: [Writes implementation]

=== Step 2: Code Review ===

Claude: [Automatically invokes code-reviewer agent]

Finding: ✅ PASS (implementation follows best practices)

=== Step 3: Security Audit ===

Claude: [Delegates to security-auditor agent]

Finding: ⚠️ REVIEW
- Add rate limiting to prevent abuse
- Token expiration should be 1 hour (currently 24 hours)

Claude: [Applies fixes]

=== Step 4: Re-Review ===

Claude: [Re-invokes security-auditor]

Finding: ✅ PASS (issues resolved)

=== Step 5: Testing ===

You: "Add tests for password reset"

Claude: [Writes tests]
Skill: test-generator-jest auto-invokes

=== Step 6: Documentation ===

Hook: suggest-adr.sh detects authentication decision
Output: "📋 Consider creating ADR for password reset token expiration decision"

You: "Create ADR for token expiration"

Claude: [Creates docs/decisions/0005-password-reset-token-expiration.md]

=== Step 7: Deployment ===

You: "Deploy to staging"

Claude: [Deploys]
Claude: [Invokes deployment-troubleshooter to verify]

Finding: ✅ PASS (deployment successful, health checks passing)

=== Step 8: Session State Update ===

Hook: suggest-session-state-update.sh (after conversation ends)
Output: "💡 Consider updating SESSION_STATE.md (last updated 3 hours ago)"

You: "Update session state"

Claude: [Updates docs/SESSION_STATE.md with password reset feature completion]
```

**Agents Used**: 3 (code-reviewer, security-auditor, deployment-troubleshooter)
**Skills Used**: 1 (test-generator-jest)
**Hooks Triggered**: 3 (auto-format, suggest-adr, suggest-session-state-update)
**Outcome**: Feature implemented, reviewed, tested, documented, and deployed with full quality checks

---

## Framework Extension

### Example 10: Creating Custom Domain for Your Team

**Scenario**: Startup building fintech app, needs domain-specific agents

**Workflow**:

```
You: "Create a domain for fintech compliance with agents for:
- PCI-DSS compliance checking
- GDPR data handling validation
- Financial transaction auditing"

Claude: [Launches agent-creator metaskill]

=== Agent 1: PCI-DSS Compliance Checker ===

Claude: "Creating pci-dss-compliance-checker agent..."

[Generates comprehensive agent]

Saved to: .claude/agents/fintech-compliance/pci-dss-checker.md

Key Features:
- Checks for credit card data in logs (violation)
- Validates encryption at rest/transit
- Ensures access controls on cardholder data
- Audits third-party integrations
- PASS/REVIEW/FAIL framework

=== Agent 2: GDPR Validator ===

Claude: "Creating gdpr-validator agent..."

Saved to: .claude/agents/fintech-compliance/gdpr-validator.md

Key Features:
- Checks data retention policies
- Validates consent mechanisms
- Ensures right-to-deletion implementation
- Audits data exports (portability)
- Checks for data minimization

=== Agent 3: Transaction Auditor ===

Claude: "Creating transaction-auditor agent..."

Saved to: .claude/agents/fintech-compliance/transaction-auditor.md

Key Features:
- Validates transaction logging (immutable audit trail)
- Checks for suspicious patterns
- Ensures regulatory reporting compliance
- Monitors for money laundering indicators
- Validates reconciliation processes

=== Testing All Agents ===

Claude: [Launches agent-tester for each agent]

Results:
- pci-dss-checker: ✅ PASS (maintains standards under pressure)
- gdpr-validator: ✅ PASS
- transaction-auditor: ✅ PASS

=== Documentation ===

Claude: [Updates docs/TAXONOMY.md]

```markdown
## fintech-compliance

### Agents
- **pci-dss-checker**: Validates PCI-DSS compliance (card data handling, encryption, access controls)
- **gdpr-validator**: Ensures GDPR compliance (consent, retention, right-to-deletion)
- **transaction-auditor**: Audits financial transactions for regulatory compliance
```

=== Usage Example ===

You: "Review this payment processing code for compliance"

Claude: [Launches pci-dss-checker agent]

Finding: ❌ FAIL
- Credit card numbers logged in plain text
- Missing encryption at rest
- No access controls on cardholder data environment

You: [Fixes issues]

Claude: [Re-reviews]

Finding: ✅ PASS (compliant with PCI-DSS requirements)
```

**Time to Create Domain**: < 15 minutes
**Agents Generated**: 3 production-ready agents
**Testing**: All agents pressure-tested
**Outcome**: Complete fintech compliance domain ready for team use

---

## Key Takeaways

### Across All Examples

1. **Agents maintain standards** even under pressure (security, time constraints)
2. **Skills auto-invoke** when patterns detected (refactoring, testing)
3. **Hooks automate** repetitive tasks (formatting, documentation)
4. **Metaskills enable** rapid framework extension (new domains in minutes)
5. **PASS/REVIEW/FAIL** provides consistent decision framework
6. **Cross-domain workflows** combine multiple agents seamlessly

### Common Patterns

- **Code Review**: code-reviewer → security-auditor → deployment-troubleshooter
- **ML Pipeline**: oracle-calibration → dataset-qa → training-advisor
- **Feature Development**: code-reviewer → security-auditor → ADR creation
- **Incident Response**: debugger → deployment-troubleshooter → root cause analysis

---

**Version**: 1.0.0
**Last Updated**: 2025-11-15
**License**: MIT
