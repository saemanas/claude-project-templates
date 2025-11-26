# How to Find Things

**Lines**: {CURRENT}/50

---

## Key Documents

| Topic | Location |
|-------|----------|
| Current State | [NOW.md](./NOW.md) |
| Project Context | [refs/PROJECT-CONTEXT.md](../refs/PROJECT-CONTEXT.md) |
| {PRD/Main Doc} | [refs/prd/{PRD-001}.md](../refs/prd/{PRD-001}.md) |

---

## Original Materials (READ-ONLY)

| Category | Location |
|----------|----------|
| {Category 1} | [refs/base/{path}/](../refs/base/{path}/) |
| {Category 2} | [refs/base/{path}/](../refs/base/{path}/) |

---

## By Question

| Question | Answer |
|----------|--------|
| "{Question 1}?" | {Answer or link} |
| "{Question 2}?" | {Answer or link} |
| "{Question 3}?" | {Answer or link} |

---

## Timeline

- This week: [timeline/{YYYY-Wnn}.md](./timeline/{YYYY-Wnn}.md)
- Decisions: [decisions/INDEX.md](./decisions/INDEX.md)

---

## Git History (On-Demand)

```bash
git log --oneline -20          # Recent 20 commits
git log --since="YYYY-MM-DD"   # Since specific date
git log --oneline -- path/     # Changes to specific path
git diff HEAD~5                # Last 5 commits diff
```

---

**Token cost**: ~300 tokens
