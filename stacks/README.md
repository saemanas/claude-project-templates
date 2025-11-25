# IT Development Stacks

**Status**: Template (Created after AI discussion and user approval)
**Purpose**: Development stack combinations suited to project needs

> **IMPORTANT**: Stacks are NOT created during `init-project.sh`.
> After project initialization, discuss with AI to decide the appropriate stack.
> AI will create the stack after your approval.

---

## Stack Decision Process

```
1. Run init-project.sh
   └─ Memory system created
   └─ NO stacks created yet

2. Discuss with AI
   └─ Describe project requirements
   └─ AI researches and recommends stack
   └─ AI writes refs/stack/STACK-RESEARCH.md

3. User approves stack
   └─ AI creates refs/stack/STACK-DECISION.md (LOCKED)
   └─ AI creates refs/dependencies/VERSIONS.lock.md (LOCKED)

4. AI creates stack (from PICSO/templates/stacks/)
   └─ Copies selected components to project root
   └─ Creates docker-compose.yml (customized)
   └─ Creates Makefile (unified management)
   └─ All services have healthz/readyz endpoints
   └─ Immediately deployable
```

### How AI Creates Stack

AI copies files from `PICSO/templates/stacks/` to the project:

```bash
# Example: User approved FastAPI + React + PostgreSQL + Redis

# AI copies:
templates/stacks/backend/api/fastapi/ → project/backend/api/
templates/stacks/frontend/web/react/  → project/frontend/web/
templates/stacks/infra/db/            → project/infra/db/
templates/stacks/infra/cache/         → project/infra/cache/
templates/stacks/Makefile             → project/Makefile
templates/stacks/docker-compose.yml   → project/docker-compose.yml (customized)
```

**No scripts needed** - AI directly copies and customizes files.

---

## Directory Structure

```
stacks/
├── Makefile              # Unified project management
├── docker-compose.yml    # All services configuration
│
├── backend/              # Backend services
│   ├── api/              # REST/GraphQL API server (FastAPI)
│   └── ai/               # AI/ML services (inference)
│
├── frontend/             # Frontend services
│   └── web/              # Web application (React + Vite)
│
├── mobile/               # Mobile applications
│   └── app/              # Expo (React Native)
│
└── infra/                # Common infrastructure
    ├── db/               # Database (PostgreSQL)
    ├── cache/            # Cache (Redis)
    ├── proxy/            # Reverse proxy (Nginx)
    ├── monitoring/       # Monitoring (Prometheus + Grafana)
    └── mail/             # Development mail (Mailhog)
```

---

## Unified Management (Makefile)

After stack creation, all services are managed via Makefile:

```bash
# Service Management
make up                    # Start all services
make down                  # Stop all services
make restart               # Restart all services
make logs                  # View all logs
make status                # Show service status

# Specific Service
make up SERVICE=backend    # Start only backend
make logs SERVICE=frontend # View frontend logs

# Health Checks
make healthcheck           # Check all services health
make check-ready           # Check deployment readiness

# Development
make build                 # Build all services
make rebuild               # Rebuild without cache
make test                  # Run all tests
make lint                  # Run linters
make format                # Format code

# Database
make db-migrate            # Run migrations
make db-rollback           # Rollback migration
make db-reset              # Reset database (DESTRUCTIVE)

# Production
make deploy                # Deploy to production
make prod-up               # Start production services

# Cleanup
make clean                 # Remove containers and volumes
make clean-all             # Remove everything including images
```

---

## Stack Selection Guide

### Recommended Combinations by Project Type

| Project Type | Backend | Frontend | Mobile | Infra |
|--------------|---------|----------|--------|-------|
| **Web API Server** | `api` | - | - | `db`, `cache`, `monitoring` |
| **Web Fullstack** | `api` | `web` | - | `db`, `cache`, `proxy`, `monitoring` |
| **Mobile App + Backend** | `api` | - | `app` | `db`, `cache`, `monitoring` |
| **AI Service** | `api`, `ai` | `web` | - | `db`, `cache`, `monitoring` |
| **Web + Mobile** | `api` | `web` | `app` | `db`, `cache`, `proxy`, `monitoring` |

---

## Stack Details

### backend/api (FastAPI)

**Purpose**: REST/GraphQL API Server

| Feature | Description |
|---------|-------------|
| Framework | FastAPI 0.109+ |
| Language | Python 3.11+ |
| ORM | SQLAlchemy 2.x (async) |
| Validation | Pydantic v2 |
| Auth | JWT (python-jose) |
| Metrics | Prometheus |

**Endpoints**:
- `/healthz` - Liveness probe
- `/readyz` - Readiness probe
- `/docs` - Swagger UI
- `/metrics` - Prometheus metrics

### backend/ai (Inference Service)

**Purpose**: AI/ML Model Serving

| Feature | Description |
|---------|-------------|
| Framework | FastAPI |
| Language | Python 3.11+ |
| ML | transformers, torch |
| Metrics | Prometheus |

**Endpoints**:
- `/healthz` - Liveness probe
- `/readyz` - Readiness probe (checks model loaded)
- `/inference` - Run inference
- `/models` - List available models

### frontend/web (React + Vite)

**Purpose**: Web Application

| Feature | Description |
|---------|-------------|
| Framework | React 18 |
| Build | Vite 5 |
| Language | TypeScript |
| Styling | Tailwind CSS |
| State | Zustand |
| Data | TanStack Query |

### mobile/app (Expo)

**Purpose**: Mobile Application

| Feature | Description |
|---------|-------------|
| Framework | Expo (React Native) |
| Language | TypeScript |
| Navigation | Expo Router |
| OTA Updates | Supported |

### infra/

**Purpose**: Common Infrastructure Services

| Component | Service | Image | Port | Health |
|-----------|---------|-------|------|--------|
| `db` | PostgreSQL 16 | `postgres:16-alpine` | 5432 | pg_isready |
| `cache` | Redis 7 | `redis:7-alpine` | 6379 | redis-cli ping |
| `proxy` | Nginx | `nginx:alpine` | 80, 443 | - |
| `monitoring` | Prometheus | `prom/prometheus` | 9090 | - |
| `monitoring` | Grafana | `grafana/grafana` | 3001 | - |
| `mail` | Mailhog | `mailhog/mailhog` | 8025 | - |

---

## Service URLs (Local)

| Service | URL | Notes |
|---------|-----|-------|
| Frontend (Web) | http://localhost:3000 | React/Vue/Svelte |
| Backend (API) | http://localhost:8000 | FastAPI |
| API Docs | http://localhost:8000/docs | Swagger UI |
| Backend AI | http://localhost:8001 | Inference Service |
| PostgreSQL | localhost:5432 | Direct DB connection |
| Redis | localhost:6379 | Direct cache connection |
| Grafana | http://localhost:3001 | admin / admin |
| Prometheus | http://localhost:9090 | Metrics |
| Mailhog | http://localhost:8025 | Development mail UI |

---

## Deployment Readiness

All stacks are deployment-ready from creation:

1. **Health Endpoints**
   - `/healthz` - Kubernetes liveness probe
   - `/readyz` - Kubernetes readiness probe

2. **Docker Compose**
   - All services have health checks
   - Proper dependency ordering
   - Volume persistence

3. **Makefile**
   - `make healthcheck` - Verify all services
   - `make check-ready` - Verify deployment readiness
   - `make deploy` - Deploy to production

---

## Requirements

### Required
- Docker Desktop (Mac)
- Docker Compose v2
- Make

### Language-specific (Based on selected stack)
| Stack | Requirements | Install |
|-------|--------------|---------|
| FastAPI | Python 3.11+ | `brew install python@3.11` |
| React/Vite | Node.js 20+ | `brew install node` |
| Expo | Node.js 20+ | `brew install node` |

---

## Important Notes

1. **Stack is decided after AI discussion**
   - NOT selected during init-project.sh
   - AI researches and recommends based on requirements
   - Record in `refs/stack/STACK-DECISION.md` (LOCKED)

2. **All stacks are deployment-ready**
   - healthz/readyz endpoints included
   - Docker health checks configured
   - Makefile for unified management

3. **All services are free**
   - Open source only
   - Supports both Mac ARM + Intel

---

**Version**: 2.1.0
**Last Updated**: 2025-11-26
