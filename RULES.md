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

| File Type | Max Lines | Action on Exceed |
|-----------|-----------|------------------|
| `memory/NOW.md` | **300** | Split to timeline |
| `memory/FIND.md` | **200** | Split or simplify |
| `memory/decisions/INDEX.md` | **300** | Split by year |
| `memory/timeline/YYYY-Wnn.md` | **500** | Create next week |
| `memory/timeline/*-SUMMARY.md` | **500** | Create quarterly summary |
| `memory/decisions/DEC-*.md` | **500** | Split into related decisions |
| `docs/*/README.md` | **100** | Move content to separate files |
| `docs/*/*.md` (content) | **500** | Split file |

### What to do when limit exceeded

```
NOW.md > 300 lines:
├─ Move "Completed" items to weekly log
├─ Move old "Critical Facts" to decisions/
└─ Keep only active/current content

Weekly log > 500 lines:
├─ Create YYYY-W{nn+1}.md
├─ Add bidirectional links
└─ Move remaining week's entries

Decision record > 500 lines:
├─ Extract "Related" section to new DEC file
├─ Link with "Superseded by" or "Related to"
└─ Keep core decision in original
```

---

## 2. File Structure (REQUIRED)

**Enforcement**: CI/CD validation
**Violation**: PR blocked

### Required Files

```
memory/
├── NOW.md          (REQUIRED)
├── FIND.md         (RECOMMENDED)
├── timeline/       (REQUIRED directory)
└── decisions/      (RECOMMENDED directory)
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
| `memory/NOW.md` | 1,200 | >1,080 (90%) |
| `memory/FIND.md` | 600 | >540 (90%) |
| `CLAUDE.md` | 2,500 | >2,250 (90%) |
| Session total | 3,800 | >3,400 (90%) |

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

```
┌─────────────────────────────────────────────┐
│          ZERO TOLERANCE RULES               │
├─────────────────────────────────────────────┤
│ NOW.md        │ 300 lines │ 1,200 tokens   │
│ FIND.md       │ 200 lines │   600 tokens   │
│ Weekly log    │ 500 lines │ 2,000 tokens   │
│ Decision      │ 500 lines │ 2,000 tokens   │
│ Topic README  │ 100 lines │   400 tokens   │
├─────────────────────────────────────────────┤
│ Session total │     -     │ 3,800 tokens   │
├─────────────────────────────────────────────┤
│ Validate: ./scripts/validate-memory.sh     │
│ Tokens:   python3 scripts/count-tokens.py  │
└─────────────────────────────────────────────┘
```

---

**Last Updated**: 2025-11-26
**Enforced By**: Git hooks + GitHub Actions
