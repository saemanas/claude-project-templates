# docs-cache/

**Purpose**: Cache official documentation retrieved via Context7 MCP, organized by dependency directories

---

## Structure

```
docs-cache/
├── README.md (this file)
│
├── fastapi/                    # FastAPI related docs
│   ├── INDEX.md                # Overview + file list
│   ├── quickstart.md           # Quick start guide
│   ├── dependency-injection.md # DI patterns
│   ├── authentication.md       # Auth related
│   └── ...
│
├── react/                      # React related docs
│   ├── INDEX.md
│   ├── hooks.md
│   ├── state-management.md
│   └── ...
│
├── sqlalchemy/                 # SQLAlchemy related docs
│   ├── INDEX.md
│   ├── async-usage.md
│   ├── relationships.md
│   └── ...
│
└── {dependency-name}/          # Other dependencies
    ├── INDEX.md
    └── {topic}.md
```

---

## Directory Naming Convention

| Dependency | Directory Name |
|------------|----------------|
| FastAPI | `fastapi/` |
| React | `react/` |
| PostgreSQL | `postgresql/` |
| SQLAlchemy | `sqlalchemy/` |
| Redis | `redis/` |
| TanStack Query | `tanstack-query/` |
| Pydantic | `pydantic/` |
| Tailwind CSS | `tailwindcss/` |
| Expo | `expo/` |

**Rules**: lowercase, hyphen-separated, based on official package name

---

## INDEX.md Template (Required)

Each dependency directory must include `INDEX.md`:

```markdown
# {Dependency Name} - Documentation Cache

**Version**: {version}
**Context7 ID**: {/org/repo}
**Last Updated**: {YYYY-MM-DD}
**Source**: Context7 MCP

---

## Cached Files

| File | Topic | Tokens | Updated |
|------|-------|--------|---------|
| [quickstart.md](./quickstart.md) | Quick Start | ~500 | {date} |
| [authentication.md](./authentication.md) | Authentication | ~800 | {date} |
| ... | ... | ... | ... |

---

## Project Usage

### Features in Use
- {feature 1}: `{file path}`
- {feature 2}: `{file path}`

### Notes
- {note 1}
- {note 2}

---

## Quick Reference

### Installation
{installation command}

### Basic Import
{core import code}

---

**Total Token Cost**: ~{n} tokens
```

---

## Topic File Template

```markdown
# {Dependency} - {Topic}

**Context7 Query**: `topic: "{topic}"`
**Tokens Used**: {n}
**Retrieved**: {YYYY-MM-DD}

---

## Key Content

{Core content retrieved from Context7}

---

## Code Example

```{language}
{Core code example}
```

---

## Project Application

- Applied in: `{path}`
- Related Decision: DEC-{nnn}

---

**Source**: Context7 MCP - {context7_id}
```

---

## Cache Management Rules

### File Size Limits
- INDEX.md: max 150 lines
- Topic files: max 200 lines
- Split if exceeded

### Update Frequency
| Dependency Type | Cache Validity |
|-----------------|----------------|
| Stable (PostgreSQL, Redis) | 3 months |
| Active (FastAPI, React) | 1 month |
| Rapidly Changing (AI/ML) | 2 weeks |

### Deletion Criteria
- When dependency is removed from project
- When removed from VERSIONS.lock.md

---

## AI Behavior Rules

### 1. Adding New Dependency
```
1. Create docs-cache/{dependency}/ directory
2. Create INDEX.md (basic info)
3. Create necessary topic files
4. Update VERSIONS.lock.md
```

### 2. During Implementation
```
1. Check docs-cache/{dependency}/INDEX.md
2. Check if required topic file exists
3. If missing → Query Context7 → Create new file
4. If exists → Use cache (check validity)
```

### 3. Version Upgrade
```
1. Query Context7 for latest info
2. Check breaking changes
3. Update all affected files
4. Update INDEX.md version info
```

---

## Example: FastAPI Directory

```
docs-cache/fastapi/
├── INDEX.md              # Overview, version, file list
├── quickstart.md         # Quick start
├── path-parameters.md    # Path parameters
├── query-parameters.md   # Query parameters
├── request-body.md       # Request body (Pydantic)
├── dependency-injection.md # Dependency injection
├── authentication.md     # JWT, OAuth2
├── middleware.md         # Middleware
├── background-tasks.md   # Background tasks
├── testing.md            # Testing
└── deployment.md         # Deployment
```

Each file contains only **essential information** for that topic (token optimization)
