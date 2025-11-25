# Stack Decision

**Status**: LOCKED
**Decided**: {YYYY-MM-DD}
**Decision Record**: DEC-001
**Last Reviewed**: {YYYY-MM-DD}

---

## IMPORTANT

```
This file is LOCKED.
To change:
1. User explicitly requests: "I want to discuss changing the stack"
2. AI provides impact analysis and discussion
3. User gives final approval
4. Create DEC-nnn record, then update
```

---

## Decision Summary

**Selected Stack**: {stack summary - e.g., React + FastAPI + PostgreSQL}

**Rationale**: {core reason in one sentence}

---

## Frontend

| Category | Choice | Version | Locked |
|----------|--------|---------|--------|
| Framework | {React/Vue/Svelte/None} | {18.x} | Yes |
| Build Tool | {Vite/Webpack/None} | {5.x} | Yes |
| Language | {TypeScript/JavaScript} | {5.x} | Yes |
| Styling | {Tailwind/CSS Modules/Styled} | {3.x} | Yes |
| State | {Zustand/Redux/Context} | {x.x} | Yes |
| Routing | {React Router/TanStack} | {x.x} | Yes |
| HTTP Client | {Axios/Fetch/TanStack Query} | {x.x} | Yes |

### Why This Choice
{Frontend selection rationale - 2-3 sentences}

---

## Backend

| Category | Choice | Version | Locked |
|----------|--------|---------|--------|
| Framework | {FastAPI/Express/Go} | {0.109.x} | Yes |
| Language | {Python/Node.js/Go} | {3.11.x} | Yes |
| ORM | {SQLAlchemy/Prisma/GORM} | {2.x} | Yes |
| Auth | {JWT/Session/OAuth} | - | Yes |
| Validation | {Pydantic/Zod/Native} | {2.x} | Yes |

### Why This Choice
{Backend selection rationale - 2-3 sentences}

---

## Database

| Category | Choice | Version | Locked |
|----------|--------|---------|--------|
| Primary DB | {PostgreSQL/MySQL/MongoDB} | {16.x} | Yes |
| Cache | {Redis/Memcached/None} | {7.x} | Yes |
| Search | {PostgreSQL FTS/Elasticsearch/None} | - | Yes |

### Why This Choice
{Database selection rationale - 2-3 sentences}

---

## Infrastructure

| Category | Choice | Version | Locked |
|----------|--------|---------|--------|
| Container | Docker | 24.x | Yes |
| Orchestration | Docker Compose | 2.x | Yes |
| Reverse Proxy | {Nginx/Traefik/None} | {alpine} | Yes |
| Monitoring | {Prometheus+Grafana/None} | {latest} | Yes |

### Why This Choice
{Infrastructure selection rationale - 2-3 sentences}

---

## Development Environment

| Category | Choice |
|----------|--------|
| OS | macOS (M1/M2/M3 + Intel) |
| IDE | {VS Code/Cursor/etc.} |
| Package Manager | {npm/pnpm/yarn} + {pip/poetry} |

---

## Alternatives Considered

### Frontend
| Option | Pros | Cons | Why Not |
|--------|------|------|---------|
| {Alternative 1} | {pros} | {cons} | {reason not chosen} |
| {Alternative 2} | {pros} | {cons} | {reason not chosen} |

### Backend
| Option | Pros | Cons | Why Not |
|--------|------|------|---------|
| {Alternative 1} | {pros} | {cons} | {reason not chosen} |

---

## Compatibility Matrix

| Component | PostgreSQL | Redis | Docker | Mac ARM | Mac Intel |
|-----------|------------|-------|--------|---------|-----------|
| Frontend | N/A | N/A | Yes | Yes | Yes |
| Backend | Yes | Yes | Yes | Yes | Yes |
| DB | - | N/A | Yes | Yes | Yes |
| Cache | N/A | - | Yes | Yes | Yes |

---

## Context7 Documentation Cache

**PREFERRED**: Always try Context7 MCP first for optimal token efficiency.
- Context7 + cache = query once, reuse = saves tokens (OPTIMAL)
- Web search = fallback if Context7 unavailable
- All Stack/Dependencies should be cached after querying official docs

### Documentation Cache Status

| Library | Context7 ID | Docs Updated | Cache Directory |
|---------|-------------|--------------|-----------------|
| {Framework} | {/org/repo} | {YYYY-MM-DD} | [docs-cache/{name}/](../dependencies/docs-cache/{name}/) |
| {ORM} | {/org/repo} | {YYYY-MM-DD} | [docs-cache/{name}/](../dependencies/docs-cache/{name}/) |
| {Library} | {/org/repo} | {YYYY-MM-DD} | [docs-cache/{name}/](../dependencies/docs-cache/{name}/) |

**Structure**: Each dependency directory contains INDEX.md + topic-specific files

### Context7 Usage Rules

1. **Stack Decision**: Try Context7 first, fallback to web search if unavailable
2. **Implementation**: Check docs-cache first → Query Context7 (or web search) if missing
3. **Upgrade**: Verify breaking changes via Context7 or official docs, then update cache

→ Detailed Guide: [CONTEXT7-GUIDE.md](../dependencies/CONTEXT7-GUIDE.md)

---

## Research References

- Stack Research: [STACK-RESEARCH.md](./STACK-RESEARCH.md)
- Alternatives Analysis: [STACK-ALTERNATIVES.md](./STACK-ALTERNATIVES.md)
- Context7 Guide: [CONTEXT7-GUIDE.md](../dependencies/CONTEXT7-GUIDE.md)
- Docs Cache: [docs-cache/](../dependencies/docs-cache/)

---

## Change History

| Version | Date | Changes | Decision |
|---------|------|---------|----------|
| 1.0.0 | {YYYY-MM-DD} | Initial decision | DEC-001 |

---

## How to Request Changes

1. **User Request**: "I want to change the stack" or specific change request
2. **AI Analysis**:
   - Impact relative to current progress
   - Migration cost estimation
   - Alternative suggestions
3. **User Confirmation**: "Should we proceed with this change?"
4. **Execute Change**:
   - Update this file
   - Update VERSIONS.lock.md
   - Create DEC-nnn record
   - Update memory/NOW.md

---

**LOCKED**: This decision is maintained until user explicitly requests changes.
