# Core Rules - Immutable

**Status**: LOCKED
**Version**: 1.0.0
**Modified**: Never (unless explicitly requested by user with acknowledgment)

---

## THIS FILE IS IMMUTABLE

These rules define the foundation of the Project Memory System.
They are the result of research and testing, achieving:

- **81% token reduction** (3,800 vs 20,000+ tokens/session)
- **Zero information loss** over any project duration
- **Consistent enforcement** via automation

**DO NOT MODIFY** without explicit user request and acknowledgment.

---

## Rule 1: Line Limits (Zero Tolerance)

```yaml
limits:
  memory/NOW.md: 300
  memory/FIND.md: 200
  memory/decisions/INDEX.md: 300
  memory/timeline/YYYY-Wnn.md: 500
  memory/timeline/*-SUMMARY.md: 500
  memory/decisions/DEC-*.md: 500
  docs/*/README.md: 100
  docs/*/*.md: 500
```

**Why**: Each limit is calculated for optimal token budget.
**Violation**: Commit blocked, PR blocked.

---

## Rule 2: Token Budget

```yaml
budgets:
  NOW.md: 1200 tokens
  FIND.md: 600 tokens
  CLAUDE.md: 2500 tokens (one-time)
  topic_doc: 2000 tokens

sessions:
  minimal: 1200  # NOW.md only
  standard: 1800  # NOW.md + FIND.md
  full: 3800  # + one topic doc
  complex: 6000  # multiple docs (warn)
```

**Why**: Predictable, minimal token usage per session.
**Target**: 81% reduction from traditional approaches.

---

## Rule 3: File Structure

```yaml
required:
  - memory/NOW.md
  - memory/timeline/

recommended:
  - memory/FIND.md
  - memory/decisions/INDEX.md
  - CLAUDE.md
  - GITFLOW.md
  - RULES.md

protected:
  - .protected/
  - .githooks/
  - .github/workflows/
  - scripts/
```

**Why**: Consistent structure enables automation.
**Violation**: Warning or error depending on file.

---

## Rule 4: Gitflow Branching

```yaml
protected_branches:
  - main
  - develop

allowed_merges:
  main:
    - release/*
    - hotfix/*
  develop:
    - feature/*
    - bugfix/*
    - release/*
    - hotfix/*
    - main

branch_naming:
  - feature/*
  - bugfix/*
  - hotfix/*
  - release/*
```

**Why**: Prevents accidental production changes.
**Violation**: Commit blocked, PR blocked.

---

## Rule 5: Naming Conventions

```yaml
timeline:
  weekly: "YYYY-Wnn.md"  # e.g., 2025-W48.md
  monthly: "YYYY-MM-SUMMARY.md"
  quarterly: "YYYY-Qn-SUMMARY.md"
  annual: "YYYY-ANNUAL-SUMMARY.md"

decisions:
  format: "DEC-nnn-title.md"  # e.g., DEC-001-api-design.md
  id: sequential, zero-padded, unique

commits:
  format: "<type>: <description>"
  types:
    - feat
    - fix
    - hotfix
    - docs
    - refactor
    - test
    - chore
```

**Why**: Enables automated processing and searching.
**Violation**: Warning.

---

## Rule 6: Update Requirements

```yaml
triggers:
  code_change:
    - memory/timeline/YYYY-Wnn.md (log)
    - memory/NOW.md (if status changed)

  decision_made:
    - memory/decisions/DEC-nnn.md (create)
    - memory/decisions/INDEX.md (update)
    - memory/NOW.md (update)

  weekly:
    - memory/NOW.md (rollup)
    - memory/timeline/YYYY-Wnn.md (summary)

  monthly:
    - memory/timeline/YYYY-MM-SUMMARY.md (create)
```

**Why**: Maintains accurate project state.
**Violation**: Warning.

---

## Rule 7: Archive Policy

```yaml
archive:
  weekly_logs:
    active_period: 12 weeks
    archive_to: memory/archive/YYYY-Qn/
    trigger: automated (weekly)

  monthly_summaries:
    active_period: 12 months
    archive_to: memory/archive/YYYY/
    trigger: manual

  decisions:
    archive: never
    reason: permanent record
```

**Why**: Keeps active memory small, preserves history.
**Violation**: N/A (automated).

---

## Rule 8: Protection Policy

```yaml
locked_files:
  - .protected/*
  - .githooks/*
  - .github/workflows/*
  - scripts/*

protected_rules:
  - RULES.md
  - GITFLOW.md
  - Line limits
  - Token budgets
  - Naming conventions

modification_requires:
  - Explicit user request
  - User acknowledgment
  - Version bump
```

**Why**: Core system must remain stable.
**Violation**: Blocked unless user explicitly requests.

---

## Enforcement Summary

| Rule | Local (pre-commit) | Remote (CI/CD) |
|------|-------------------|----------------|
| Line limits | BLOCK | BLOCK |
| Token budget | WARN | WARN |
| File structure | WARN | BLOCK (required) |
| Gitflow | BLOCK | BLOCK |
| Naming | WARN | WARN |
| Update reqs | WARN | WARN |
| Archive | N/A | AUTO |
| Protection | BLOCK | BLOCK |

---

## Modification Protocol

If user explicitly requests modification:

```
1. AI asks for confirmation
2. User acknowledges impact
3. Create system/* branch
4. Make modification
5. Update version
6. Update CHECKSUMS.sha256
7. Create PR with [SYSTEM] tag
8. Require additional review
```

---

**THIS FILE IS LOCKED**

Modification requires:
1. Explicit user request: "Modify CORE-RULES.md"
2. User acknowledgment: "I understand this affects the core system"
3. Version update after modification

**Checksum**: (auto-generated)
**Last Verified**: 2025-11-26
