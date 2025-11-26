# Zero Tolerance Rules

**Version**: 1.0.0
**Enforcement**: Automated (Git hooks + CI/CD)
**Bypass**: NOT RECOMMENDED (`git commit --no-verify`)

---

## Rule Categories

| Category | Enforcement Level | Bypass Allowed |
|----------|-------------------|----------------|
| Line Limits | **BLOCK** | No |
| File Structure | **BLOCK** | No |
| ID Uniqueness | **BLOCK** | No |
| Update Requirements | **WARN** | Yes |
| Naming Conventions | **WARN** | Yes |

---

## 1. Line Limits (ZERO TOLERANCE)

**Enforcement**: Pre-commit hook + CI/CD
**Violation**: Commit blocked

### 1.1 Memory System Files

| File Type | Max Lines | Action on Exceed |
|-----------|-----------|------------------|
| `memory/NOW.md` | **150** | Split to timeline |
| `memory/FIND.md` | **100** | Remove outdated entries |
| `memory/decisions/INDEX.md` | **100** | Split by year |
| `memory/timeline/YYYY-Wnn.md` | **300** | Create next week |
| `memory/timeline/*-SUMMARY.md` | **200** | Create quarterly summary |
| `memory/decisions/DEC-*.md` | **300** | Split into related decisions |

### 1.2 Documentation Files

| File Type | Max Lines | Action on Exceed |
|-----------|-----------|------------------|
| `docs/*/README.md` | **100** | Move content to separate files |
| `docs/*/*.md` (content) | **300** | Split file |
| `CLAUDE.md` | **300** | Simplify, move to docs/ |

### 1.3 Reference Files (refs/)

| File Type | Max Lines | Action on Exceed |
|-----------|-----------|------------------|
| `refs/PROJECT-CONTEXT.md` | **100** | Keep essential only |
| `refs/prd/*.md` | **300** | Split into multiple PRDs |
| `refs/stack/STACK-DECISION.md` | **200** | Summarize, link to research |
| `refs/stack/STACK-RESEARCH.md` | **300** | Archive old research |
| `refs/stack/STACK-ALTERNATIVES.md` | **200** | Keep top alternatives only |
| `refs/dependencies/VERSIONS.lock.md` | **200** | Split by category |
| `refs/dependencies/UPGRADE-LOG.md` | **300** | Archive old entries |
| `refs/research/*.md` | **300** | Split by topic |
| `refs/index/INDEX.md` | **300** | Auto-generated, split if needed |

### 1.4 Source Code (MONITORED, not blocked)

| File Type | Recommended Max | Action on Exceed |
|-----------|-----------------|------------------|
| `*.py` | **300** | Refactor into modules |
| `*.ts/*.js` | **300** | Refactor into modules |
| `*.go` | **400** | Refactor into packages |
| Config files | **100** | Split by environment |

### 1.5 What to do when limit exceeded

```
NOW.md > 150 lines:
├─ Move "Completed" items to weekly log
├─ Move old "Critical Facts" to decisions/
└─ Keep only active/current content

Weekly log > 300 lines:
├─ Create YYYY-W{nn+1}.md
├─ Add bidirectional links
└─ Move remaining week's entries

Decision record > 300 lines:
├─ Extract "Related" section to new DEC file
├─ Link with "Superseded by" or "Related to"
└─ Keep core decision in original

PRD > 300 lines:
├─ Split into PRD-nnn-a, PRD-nnn-b
├─ Or separate by feature area
└─ Link with "Related PRD" section

refs/research/* > 300 lines:
├─ Archive completed research
├─ Keep only active research
└─ Summary in STACK-DECISION.md
```

---

## 2. File Structure (REQUIRED)

**Enforcement**: CI/CD validation
**Violation**: PR blocked

### Required Files

```text
memory/
├── NOW.md          (REQUIRED)
├── FIND.md         (REQUIRED)
├── timeline/       (REQUIRED directory)
└── decisions/      (RECOMMENDED directory)

refs/
├── PROJECT-CONTEXT.md  (REQUIRED)
├── index/
│   └── INDEX.md    (AUTO-GENERATED)
└── ...
```

### Required Sections in NOW.md

```markdown
## Status Dashboard     (REQUIRED)
## Active This Week     (REQUIRED)
## Quick Navigation     (REQUIRED)
## Critical Facts       (RECOMMENDED)
## Recent Decisions     (RECOMMENDED)
```

### Required Sections in Weekly Log

```markdown
## Daily Entries        (REQUIRED)
## Week Summary         (RECOMMENDED)
## Statistics           (RECOMMENDED)
```

---

## 3. ID Uniqueness (ZERO TOLERANCE)

**Enforcement**: Pre-commit hook + CI/CD
**Violation**: Commit blocked

### Decision IDs

```
Format: DEC-nnn (e.g., DEC-001, DEC-042, DEC-123)

Rules:
├─ Sequential numbering
├─ No gaps allowed (DEC-001, DEC-002, DEC-003...)
├─ No duplicates (checked automatically)
└─ Never reuse deleted IDs
```

### Weekly Log Names

```
Format: YYYY-Wnn.md (e.g., 2025-W48.md)

Rules:
├─ ISO week numbering
├─ Leading zero for week < 10 (W01, not W1)
└─ No duplicate weeks
```

---

## 4. Update Requirements (ENFORCED)

**Enforcement**: Pre-commit warning + CI/CD warning
**Violation**: Warning (commit allowed)

### Code Change → Memory Update

```
IF: *.py, *.js, *.ts, *.go, etc. files changed
THEN: memory/ should also be updated

Warning if code changed without memory update
```

### System File Change → Memory Update

```
IF: scripts/*, .githooks/*, .github/workflows/* changed
THEN: memory/ should also be updated

System files include:
├─ scripts/*.sh, scripts/*.py (automation)
├─ .githooks/* (pre-commit, commit-msg)
├─ .github/workflows/*.yml (CI/CD)
└─ RULES.md, CLAUDE.md, GITFLOW.md (project rules)

Log in timeline with:
├─ What: Brief description of change
├─ Why: Reason for change
├─ Changes: List of modifications
└─ Impact: Effect on project workflow
```

### Decision → INDEX Update

```
IF: New DEC-nnn.md file created
THEN: memory/decisions/INDEX.md should be updated

Warning if decision added without INDEX update
```

### Weekly Update Schedule

```
Every Friday (automated reminder):
├─ NOW.md should reflect current state
├─ Weekly log should have entries
└─ Decisions should be in INDEX
```

---

## 5. Naming Conventions (ENFORCED)

**Enforcement**: CI/CD validation
**Violation**: Warning

### Timeline Files

```
Correct:
├─ 2025-W48.md
├─ 2025-11-SUMMARY.md
├─ 2025-Q4-SUMMARY.md
└─ 2025-ANNUAL-SUMMARY.md

Incorrect:
├─ 2025-W8.md (missing leading zero)
├─ week48.md (wrong format)
├─ 2025-11-summary.md (case sensitive)
└─ November-2025.md (wrong format)
```

### Decision Files

```
Correct:
├─ DEC-001-project-structure.md
├─ DEC-042-api-versioning.md
└─ DEC-100-database-migration.md

Incorrect:
├─ DEC-1-structure.md (missing leading zeros)
├─ decision-001.md (wrong prefix)
└─ DEC001.md (missing hyphen)
```

### Documentation Files

```
Correct:
├─ docs/api/README.md
├─ docs/api/endpoints.md
└─ docs/api/authentication.md

Incorrect:
├─ docs/API/readme.md (case matters)
├─ docs/api/API_Endpoints.md (use lowercase-hyphen)
└─ docs/api docs/file.md (no spaces)
```

---

## 6. Token Budget (MONITORED)

**Enforcement**: CI/CD report
**Violation**: Warning when >90%

### Budget Limits

| File | Token Budget | Warning at |
|------|-------------|------------|
| `memory/NOW.md` | 600 | >540 (90%) |
| `memory/FIND.md` | 400 | >360 (90%) |
| `refs/PROJECT-CONTEXT.md` | 400 | >360 (90%) |
| `CLAUDE.md` | 1,200 | >1,080 (90%) |
| Session start total | **2,600** | >2,340 (90%) |

> Session Start = NOW.md + FIND.md + PROJECT-CONTEXT.md + CLAUDE.md

### Check Token Usage

```bash
# Full report
python3 scripts/count-tokens.py --report

# Budget check only (for CI)
python3 scripts/count-tokens.py --budget
```

---

## 7. Archive Policy (AUTOMATED)

**Enforcement**: Weekly GitHub Action
**Action**: Creates PR for review

### Archive Schedule

| Content | Active Period | Archive Trigger |
|---------|---------------|-----------------|
| Weekly logs | 12 weeks | Auto-archive to `archive/YYYY-Qn/` |
| Monthly summaries | 12 months | Manual archive |
| Decision records | Forever | Never archive |

### Archive Structure

```
memory/archive/
├─ 2024-Q1/
│   ├─ 2024-W01.md
│   ├─ 2024-W02.md
│   └─ ...
├─ 2024-Q2/
└─ 2024-Q3/
```

---

## Enforcement Summary

### Pre-commit Hook

```bash
# Automatically runs on every commit
# Blocks commit if:
├─ Line limits exceeded
├─ Duplicate decision IDs
└─ Invalid file names

# Warns if:
├─ Code changed without memory update
└─ Decision added without INDEX update
```

### CI/CD (GitHub Actions)

```yaml
# Runs on every push/PR
# Blocks merge if:
├─ Line limits exceeded
├─ Required files missing
├─ Decision ID duplicates
└─ Token budget exceeded

# Reports:
├─ Token usage
├─ File statistics
└─ Weekly summary
```

### Manual Validation

```bash
# Run anytime
./scripts/validate-memory.sh

# Strict mode (warnings = errors)
./scripts/validate-memory.sh --strict

# Attempt auto-fix
./scripts/validate-memory.sh --fix
```

---

## Bypass (EMERGENCY ONLY)

### Skip Pre-commit Hook

```bash
# NOT RECOMMENDED - CI will still catch violations
git commit --no-verify -m "Emergency commit"
```

### Skip CI Validation

**Not possible** - This is by design.

If you need to merge despite violations:
1. Fix the violations first
2. Or update branch protection rules (admin only)

---

## Quick Reference Card

```text
┌─────────────────────────────────────────────┐
│          ZERO TOLERANCE RULES               │
├─────────────────────────────────────────────┤
│ NOW.md           │ 150 lines │   600 tokens │
│ FIND.md          │ 100 lines │   400 tokens │
│ PROJECT-CONTEXT  │ 100 lines │   400 tokens │
│ CLAUDE.md        │ 300 lines │ 1,200 tokens │
├─────────────────────────────────────────────┤
│ Weekly log       │ 300 lines │ 1,200 tokens │
│ Decision         │ 300 lines │ 1,200 tokens │
│ PRD              │ 300 lines │ 1,200 tokens │
│ Topic README     │ 100 lines │   400 tokens │
├─────────────────────────────────────────────┤
│ Session start    │     -     │ 2,600 tokens │
├─────────────────────────────────────────────┤
│ Validate: ./scripts/validate-memory.sh     │
│ Tokens:   python3 scripts/count-tokens.py  │
└─────────────────────────────────────────────┘
```

---

## 8. Commit/Merge Protocol (MANDATORY)

**Enforcement**: Manual discipline
**Violation**: User trust breach

### Required Process

```text
1. Create/Edit → 2. Show User → 3. User Approve → 4. Commit → 5. PR → 6. User Approve → 7. Merge
```

### Before Commit

| Step | Action | Required |
|------|--------|----------|
| 1 | Show created/edited content to user | ✅ YES |
| 2 | Wait for explicit user approval | ✅ YES |
| 3 | User gives clear approval signal | ✅ YES |

### Before Merge

| Step | Action | Required |
|------|--------|----------|
| 1 | Create PR (not merge directly) | ✅ YES |
| 2 | Show PR link to user | ✅ YES |
| 3 | Wait for explicit merge approval | ✅ YES |

### Forbidden Actions

```text
❌ Commit without showing content first
❌ Merge PR without user approval
❌ Auto-merge to main without explicit request
❌ Skip verification/testing steps
❌ Assume user approval from silence
```

### Approval Detection

```text
Clear Approval Signals:
✅ Direct instruction to proceed
✅ Explicit confirmation words
✅ Commands like "commit", "merge", "PR"

NOT Approval:
❌ No response (silence)
❌ Questions or requests for clarification
❌ "Let me check" / "I'll review"
```

---

**Last Updated**: 2025-11-26
**Enforced By**: Git hooks + GitHub Actions
