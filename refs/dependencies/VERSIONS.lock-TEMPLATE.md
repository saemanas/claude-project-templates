# Versions Lock

**Status**: LOCKED
**Created**: {YYYY-MM-DD}
**Last Updated**: {YYYY-MM-DD}
**Decision Reference**: DEC-{NNN}

---

## IMPORTANT

This file is **LOCKED**.

**Prohibited Changes**:
- Package version changes
- Adding new packages
- Removing existing packages

**When Changes Are Needed**:
1. Explicitly request: "Dependency update/change is needed"
2. Provide reason and impact analysis
3. Change after user approval
4. Record change history in `UPGRADE-LOG.md`
5. Create new DEC-nnn decision record

---

## Runtime Versions

| Component | Version | EOL Date | Notes |
|-----------|---------|----------|-------|
| Node.js | 20.x LTS | 2026-04 | Hydrogen |
| Python | 3.11.x | 2027-10 | |
| Go | 1.21.x | - | |

---

## Frontend Dependencies

### Core
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| react | 18.2.0 | Yes | UI Framework |
| react-dom | 18.2.0 | Yes | React DOM |
| typescript | 5.3.3 | Yes | Type Safety |

### Build Tools
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| vite | 5.0.12 | Yes | Build Tool |
| @vitejs/plugin-react | 4.2.1 | Yes | Vite React Plugin |

### State Management
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| zustand | 4.5.0 | Yes | State Management |

### UI Components
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| tailwindcss | 3.4.1 | Yes | CSS Framework |

### Testing
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| vitest | 1.2.2 | Yes | Unit Testing |
| @testing-library/react | 14.1.2 | Yes | React Testing |
| playwright | 1.41.1 | Yes | E2E Testing |

---

## Backend Dependencies

### Core
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| fastapi | 0.109.0 | Yes | Web Framework |
| uvicorn | 0.27.0 | Yes | ASGI Server |
| gunicorn | 21.2.0 | Yes | Production Server |
| pydantic | 2.5.3 | Yes | Validation |

### Database
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| sqlalchemy | 2.0.25 | Yes | ORM |
| asyncpg | 0.29.0 | Yes | Async PostgreSQL |
| alembic | 1.13.1 | Yes | Migrations |

### Cache
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| redis | 5.0.1 | Yes | Redis Client |

### Authentication
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| python-jose | 3.3.0 | Yes | JWT |
| passlib | 1.7.4 | Yes | Password Hashing |

### Testing
| Package | Version | Locked | Purpose |
|---------|---------|--------|---------|
| pytest | 7.4.4 | Yes | Testing |
| pytest-asyncio | 0.23.3 | Yes | Async Testing |
| httpx | 0.26.0 | Yes | HTTP Client |

---

## Infrastructure

### Database
| Service | Version | Image | Locked |
|---------|---------|-------|--------|
| PostgreSQL | 16.x | postgres:16-alpine | Yes |
| Redis | 7.x | redis:7-alpine | Yes |

### Containers
| Service | Version | Image | Locked |
|---------|---------|-------|--------|
| Nginx | 1.25.x | nginx:1.25-alpine | Yes |
| Node | 20.x | node:20-alpine | Yes |
| Python | 3.11.x | python:3.11-slim | Yes |

### Monitoring
| Service | Version | Image | Locked |
|---------|---------|-------|--------|
| Prometheus | 2.48.x | prom/prometheus:v2.48.1 | Yes |
| Grafana | 10.x | grafana/grafana:10.2.3 | Yes |

---

## Version Compatibility Matrix

| Frontend | Backend | Database | Status |
|----------|---------|----------|--------|
| React 18.x | FastAPI 0.109.x | PostgreSQL 16.x | Tested |

---

## Lock File Hashes

Project lock file hashes (for integrity verification):

```
package-lock.json: {SHA256 hash}
requirements.txt: {SHA256 hash}
```

---

## Security Advisories

Last security review: {YYYY-MM-DD}

| Package | Advisory | Severity | Status |
|---------|----------|----------|--------|
| - | - | - | No known vulnerabilities |

---

## Upgrade Schedule

| Package | Current | Target | Planned Date | Reason |
|---------|---------|--------|--------------|--------|
| - | - | - | - | No upgrades scheduled |

---

**Note**: Changes to this file must be recorded in `UPGRADE-LOG.md`.
