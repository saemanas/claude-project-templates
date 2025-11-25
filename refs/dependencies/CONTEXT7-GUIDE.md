# Context7 MCP Usage Guide

**Purpose**: Retrieve and cache official Stack/Dependencies documentation via Context7 MCP
**Core Principles**: Latest information-based development + Token optimization + Version tracking

---

## What is Context7 MCP?

Context7 is an MCP server that retrieves **up-to-date official documentation** for libraries/frameworks in real-time.
- Always provides latest version docs
- Includes code examples
- Token-optimized responses

---

## AI Workflow

### 1. Stack Decision (Required)

```
User: "Build a backend with FastAPI"

AI Actions:
1. Verify Context7 MCP availability
2. Resolve library ID with resolve-library-id
3. Retrieve official docs with get-library-docs
4. Create docs-cache/{dependency}/ directory and save cache
5. Record version in VERSIONS.lock.md
```

### 2. Context7 MCP Usage

#### Step 1: Resolve Library ID
```
mcp__context7__resolve-library-id
  libraryName: "fastapi"
```

#### Step 2: Retrieve Documentation (by topic)
```
mcp__context7__get-library-docs
  context7CompatibleLibraryID: "/tiangolo/fastapi"
  topic: "dependency injection"  # specific topic
  tokens: 5000  # token limit
```

### 3. Save Documentation Cache (Directory Structure)

Save retrieved docs in **per-dependency directories**:

```
refs/dependencies/docs-cache/
├── README.md
│
├── fastapi/                    # FastAPI related
│   ├── INDEX.md                # Overview + file list (required)
│   ├── quickstart.md           # Quick start
│   ├── dependency-injection.md # DI patterns
│   ├── authentication.md       # Authentication
│   └── ...
│
├── react/                      # React related
│   ├── INDEX.md
│   ├── hooks.md
│   └── ...
│
└── sqlalchemy/                 # SQLAlchemy related
    ├── INDEX.md
    ├── async-usage.md
    └── ...
```

---

## Cache File Formats

### INDEX.md (Required - in each dependency directory)

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

---

## Project Usage

### Features in Use
- {feature}: `{file path}`

### Notes
- {note}

---

**Total Token Cost**: ~{n} tokens
```

### Topic File ({topic}.md)

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

{Core code example}

---

## Project Application

- Applied in: `{path}`
- Related Decision: DEC-{nnn}

---

**Source**: Context7 MCP - {context7_id}
```

---

## Version Management Integration

### VERSIONS.lock.md Update

```markdown
## Backend Dependencies

| Package | Version | Context7 ID | Docs Cache | Updated |
|---------|---------|-------------|------------|---------|
| fastapi | 0.109.0 | /tiangolo/fastapi | [fastapi/](./docs-cache/fastapi/) | 2024-01-15 |
| sqlalchemy | 2.0.25 | /sqlalchemy/sqlalchemy | [sqlalchemy/](./docs-cache/sqlalchemy/) | 2024-01-15 |
```

### UPGRADE-LOG.md Record

```markdown
## 2024-01-20: FastAPI 0.109.0 → 0.110.0

### Context7 Query Results
- Breaking Changes: {none/present}
- New Features: {list}
- Deprecations: {list}

### Impact Analysis
- Affected Files: {list}
- Migration Required: {yes/no}

### Cache Updates
- Updated files: docs-cache/fastapi/INDEX.md, authentication.md

### Decision
- DEC-{nnn}: {decision content}
```

---

## Token Optimization Strategies

### 1. Topic-based Queries

```
# Bad: Query entire documentation at once
get-library-docs(tokens: 50000)

# Good: Query only needed topics
get-library-docs(topic: "authentication", tokens: 3000)
get-library-docs(topic: "dependency injection", tokens: 3000)
```

### 2. Cache-First Approach

```
AI Decision Flow:
1. Check docs-cache/{dependency}/INDEX.md
2. Verify required topic file exists
3. Cache valid → Use cache
4. Cache missing or expired → Query Context7 → Create new file
```

### 3. Cache Validity Periods

| Dependency Type | Cache Validity | Examples |
|-----------------|----------------|----------|
| Stable | 3 months | PostgreSQL, Redis |
| Active | 1 month | FastAPI, React, Next.js |
| Rapidly Changing | 2 weeks | LangChain, OpenAI SDK |

---

## Practical Examples

### Example 1: New Project Start

```
User: "Build a Todo app with FastAPI + React"

AI:
1. Query Context7 for FastAPI docs (quickstart, crud)
2. Query Context7 for React docs (hooks, state)
3. Create docs-cache/fastapi/ directory
   - INDEX.md, quickstart.md, crud.md
4. Create docs-cache/react/ directory
   - INDEX.md, hooks.md, state.md
5. Update VERSIONS.lock.md
6. Write STACK-DECISION.md
7. Start implementation (referencing cache)
```

### Example 2: Adding New Feature (Authentication)

```
User: "Add JWT authentication"

AI:
1. Check docs-cache/fastapi/INDEX.md
2. authentication.md not found
3. Query Context7: topic="oauth2 jwt"
4. Create docs-cache/fastapi/authentication.md
5. Update INDEX.md file list
6. Proceed with implementation
```

### Example 3: Version Upgrade

```
User: "Upgrade FastAPI to latest version"

AI:
1. Query Context7 for latest version info
2. Check breaking changes
3. Analyze impact (check cached topics)
4. Report to user and request approval
5. If approved:
   - Update entire docs-cache/fastapi/
   - Update VERSIONS.lock.md
   - Record in UPGRADE-LOG.md
```

---

## Context7 MCP Availability Check

**Context7 MCP is PREFERRED for stack decisions.** Always try Context7 first for optimal token efficiency.

```
1. Check for context7 in MCP tool list at session start
2. If available (PREFERRED):
   - Query official docs via Context7
   - Cache results to docs-cache/{dependency}/
   - Then proceed with implementation
3. If NOT available (FALLBACK):
   - Notify user: "Context7 MCP is not configured.
                   Recommend setup for optimal token efficiency.
                   See: https://github.com/upstash/context7"
   - Proceed with web search as fallback
   - Still save results to docs-cache/ for future reference
```

**Why Context7 First?**
- Context7 + cache = query once, reuse = saves tokens (OPTIMAL)
- Web search = less structured, harder to cache effectively
- Always try Context7 first, fallback to web search only if unavailable

---

## Important Notes

1. **Context7 First, Web Search Fallback**
   - Always attempt Context7 first for best results
   - If unavailable, web search is acceptable fallback
   - Recommend user to set up Context7 for future sessions

2. **Cache is Reference Only**
   - Always re-verify with Context7 for critical decisions
   - Don't blindly trust cache

3. **Token Budget Management**
   - Avoid excessive Context7 usage in single session
   - Query by topic

4. **File Size Limits**
   - INDEX.md: max 150 lines
   - Topic files: max 200 lines
   - Split if exceeded

---

**File Location**: `refs/dependencies/CONTEXT7-GUIDE.md`
**Related Files**:
- `refs/dependencies/VERSIONS.lock.md`
- `refs/dependencies/UPGRADE-LOG.md`
- `refs/dependencies/docs-cache/{dependency}/INDEX.md`
