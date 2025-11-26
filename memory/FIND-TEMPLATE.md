# Project Map & Navigation

**Lines**: {CURRENT}/100

---

## Project Structure

```text
{PROJECT_ROOT}/
├── src/                    # {Brief: e.g., "Main application code"}
│   ├── api/                # {Brief: e.g., "REST endpoints"}
│   ├── models/             # {Brief: e.g., "Data models"}
│   └── utils/              # {Brief: e.g., "Helper functions"}
├── tests/                  # {Brief: e.g., "Test files"}
├── stacks/                 # {Brief: e.g., "Docker configs"}
└── docs/                   # {Brief: e.g., "Documentation"}
```

> Update this structure when folders are added/removed.

---

## Key Files by Function

| Function | File(s) | Notes |
|----------|---------|-------|
| Entry point | `src/main.py` | App startup |
| Config | `src/config.py` | Env loading |
| Auth | `src/api/auth.py` | JWT handling |
| Database | `src/models/db.py` | Connection |
| {Add as needed} | | |

> Keep only actively-used files. Remove outdated entries.

---

## Memory & Docs

| Need | Location |
|------|----------|
| Current state | [NOW.md](./NOW.md) |
| Project context | [refs/PROJECT-CONTEXT.md](../refs/PROJECT-CONTEXT.md) |
| PRD | [refs/prd/](../refs/prd/) |
| Tech stack | [refs/stack/STACK-DECISION.md](../refs/stack/STACK-DECISION.md) |
| Decisions | [decisions/INDEX.md](./decisions/INDEX.md) |
| This week | [timeline/](./timeline/) |

---

## Git Queries (On-Demand Detail)

```bash
# All files (full list)
git ls-files

# Recent changes
git diff --name-only HEAD~5

# Find by keyword
git grep "keyword"

# File history
git log --oneline -10 -- path/to/file
```

---

## By Question

| Question | Where to Look |
|----------|---------------|
| "Where is X feature?" | Key Files table above |
| "What files exist?" | `git ls-files` |
| "What changed recently?" | `git diff --name-only HEAD~5` |
| "Why this decision?" | [decisions/](./decisions/) |
| "What's the tech stack?" | [refs/stack/](../refs/stack/) |

---

**Token cost**: ~400 tokens (100 lines max)
**Update frequency**: When project structure changes
