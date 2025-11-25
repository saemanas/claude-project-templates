# ============================================================================
# Project Makefile - Unified Service Management
# ============================================================================
#
# Usage:
#   make help          - Show this help
#   make up            - Start all services
#   make down          - Stop all services
#   make logs          - View all logs
#   make test          - Run all tests
#   make build         - Build all services
#   make deploy        - Deploy to production (when configured)
#
# ============================================================================

.PHONY: help up down logs build test clean deploy check lint format \
        backend frontend db cache monitoring \
        backend-logs frontend-logs db-logs \
        backend-test frontend-test \
        backend-shell frontend-shell db-shell \
        healthcheck

# Default target
.DEFAULT_GOAL := help

# ============================================================================
# CONFIGURATION
# ============================================================================

# Docker Compose files
COMPOSE_FILE := docker-compose.yml
COMPOSE_DEV := docker-compose.dev.yml
COMPOSE_PROD := docker-compose.prod.yml

# Project name (from .env or default)
PROJECT_NAME ?= $(shell basename $(CURDIR))

# Environment
ENV ?= development

# Colors for output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

# ============================================================================
# HELP
# ============================================================================

help: ## Show this help message
	@echo ""
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(CYAN)  Project: $(PROJECT_NAME)$(NC)"
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(GREEN)Usage:$(NC)"
	@echo "  make $(CYAN)<target>$(NC) [OPTIONS]"
	@echo ""
	@echo "$(GREEN)Service Management:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Examples:$(NC)"
	@echo "  make up                    # Start all services"
	@echo "  make up SERVICE=backend    # Start only backend"
	@echo "  make logs SERVICE=backend  # View backend logs"
	@echo "  make test                  # Run all tests"
	@echo ""

# ============================================================================
# CORE COMMANDS
# ============================================================================

up: ## Start all services (or specific: make up SERVICE=backend)
ifdef SERVICE
	@echo "$(GREEN)[Starting]$(NC) $(SERVICE)..."
	@docker compose -f $(COMPOSE_FILE) up -d $(SERVICE)
else
	@echo "$(GREEN)[Starting]$(NC) All services..."
	@docker compose -f $(COMPOSE_FILE) up -d
endif
	@echo "$(GREEN)[Done]$(NC) Services started"
	@make healthcheck

down: ## Stop all services (or specific: make down SERVICE=backend)
ifdef SERVICE
	@echo "$(YELLOW)[Stopping]$(NC) $(SERVICE)..."
	@docker compose -f $(COMPOSE_FILE) stop $(SERVICE)
else
	@echo "$(YELLOW)[Stopping]$(NC) All services..."
	@docker compose -f $(COMPOSE_FILE) down
endif
	@echo "$(GREEN)[Done]$(NC) Services stopped"

restart: ## Restart all services (or specific: make restart SERVICE=backend)
	@make down SERVICE=$(SERVICE)
	@make up SERVICE=$(SERVICE)

logs: ## View logs (all or specific: make logs SERVICE=backend)
ifdef SERVICE
	@docker compose -f $(COMPOSE_FILE) logs -f $(SERVICE)
else
	@docker compose -f $(COMPOSE_FILE) logs -f
endif

build: ## Build all services (or specific: make build SERVICE=backend)
ifdef SERVICE
	@echo "$(GREEN)[Building]$(NC) $(SERVICE)..."
	@docker compose -f $(COMPOSE_FILE) build $(SERVICE)
else
	@echo "$(GREEN)[Building]$(NC) All services..."
	@docker compose -f $(COMPOSE_FILE) build
endif
	@echo "$(GREEN)[Done]$(NC) Build complete"

rebuild: ## Rebuild services without cache
ifdef SERVICE
	@docker compose -f $(COMPOSE_FILE) build --no-cache $(SERVICE)
else
	@docker compose -f $(COMPOSE_FILE) build --no-cache
endif

# ============================================================================
# HEALTH CHECK
# ============================================================================

healthcheck: ## Check health of all services
	@echo ""
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(CYAN)  Health Check$(NC)"
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(GREEN)Checking services...$(NC)"
	@sleep 2
	@echo ""
	@echo "Backend API:"
	@curl -sf http://localhost:8000/healthz && echo "  $(GREEN)✓ healthy$(NC)" || echo "  $(RED)✗ unhealthy$(NC)"
	@echo ""
	@echo "Backend AI:"
	@curl -sf http://localhost:8001/healthz && echo "  $(GREEN)✓ healthy$(NC)" || echo "  $(RED)✗ unhealthy or not started$(NC)"
	@echo ""
	@echo "Frontend:"
	@curl -sf http://localhost:3000 > /dev/null && echo "  $(GREEN)✓ healthy$(NC)" || echo "  $(RED)✗ unhealthy or not started$(NC)"
	@echo ""
	@echo "Database (PostgreSQL):"
	@docker compose exec -T db pg_isready -U postgres > /dev/null 2>&1 && echo "  $(GREEN)✓ ready$(NC)" || echo "  $(RED)✗ not ready$(NC)"
	@echo ""
	@echo "Cache (Redis):"
	@docker compose exec -T cache redis-cli ping > /dev/null 2>&1 && echo "  $(GREEN)✓ ready$(NC)" || echo "  $(RED)✗ not ready$(NC)"
	@echo ""

check-ready: ## Check if services are ready for deployment
	@echo "$(GREEN)[Checking]$(NC) Deployment readiness..."
	@curl -sf http://localhost:8000/readyz || (echo "$(RED)Backend API not ready$(NC)" && exit 1)
	@echo "$(GREEN)[Ready]$(NC) All services ready for deployment"

# ============================================================================
# TESTING
# ============================================================================

test: ## Run all tests
	@echo "$(GREEN)[Testing]$(NC) Running all tests..."
	@make test-backend
	@make test-frontend
	@echo "$(GREEN)[Done]$(NC) All tests passed"

test-backend: ## Run backend tests
	@echo "$(GREEN)[Testing]$(NC) Backend..."
	@docker compose exec -T backend pytest tests/ -v --tb=short || \
		(cd backend/api && python -m pytest tests/ -v --tb=short)

test-frontend: ## Run frontend tests
	@echo "$(GREEN)[Testing]$(NC) Frontend..."
	@docker compose exec -T frontend npm test || \
		(cd frontend/web && npm test)

test-e2e: ## Run end-to-end tests
	@echo "$(GREEN)[Testing]$(NC) E2E..."
	@echo "TODO: Configure E2E tests"

# ============================================================================
# DEVELOPMENT
# ============================================================================

shell-backend: ## Open shell in backend container
	@docker compose exec backend /bin/bash

shell-frontend: ## Open shell in frontend container
	@docker compose exec frontend /bin/sh

shell-db: ## Open psql shell
	@docker compose exec db psql -U postgres

shell-cache: ## Open redis-cli
	@docker compose exec cache redis-cli

lint: ## Run linters
	@echo "$(GREEN)[Linting]$(NC) Backend..."
	@cd backend/api && ruff check . || true
	@echo "$(GREEN)[Linting]$(NC) Frontend..."
	@cd frontend/web && npm run lint || true

format: ## Format code
	@echo "$(GREEN)[Formatting]$(NC) Backend..."
	@cd backend/api && ruff format . || true
	@echo "$(GREEN)[Formatting]$(NC) Frontend..."
	@cd frontend/web && npm run format || true

# ============================================================================
# DATABASE
# ============================================================================

db-migrate: ## Run database migrations
	@echo "$(GREEN)[Migrating]$(NC) Database..."
	@docker compose exec backend alembic upgrade head

db-rollback: ## Rollback last migration
	@echo "$(YELLOW)[Rollback]$(NC) Database..."
	@docker compose exec backend alembic downgrade -1

db-reset: ## Reset database (DESTRUCTIVE)
	@echo "$(RED)[WARNING]$(NC) This will delete all data!"
	@read -p "Are you sure? [y/N] " confirm && [ "$$confirm" = "y" ]
	@docker compose exec db psql -U postgres -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
	@make db-migrate

# ============================================================================
# PRODUCTION
# ============================================================================

deploy: ## Deploy to production (requires configuration)
	@echo "$(GREEN)[Deploying]$(NC) to production..."
	@echo "TODO: Configure deployment"
	@echo "  - VPS deployment"
	@echo "  - Cloudflare DNS"
	@echo "  - SSL certificates"

prod-up: ## Start production services
	@docker compose -f $(COMPOSE_PROD) up -d

prod-down: ## Stop production services
	@docker compose -f $(COMPOSE_PROD) down

# ============================================================================
# CLEANUP
# ============================================================================

clean: ## Remove containers and volumes
	@echo "$(YELLOW)[Cleaning]$(NC) Removing containers..."
	@docker compose -f $(COMPOSE_FILE) down -v --remove-orphans

clean-all: ## Remove everything including images
	@echo "$(RED)[Cleaning]$(NC) Removing all containers, volumes, and images..."
	@docker compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans

prune: ## Prune Docker system
	@echo "$(YELLOW)[Pruning]$(NC) Docker system..."
	@docker system prune -f

# ============================================================================
# STATUS
# ============================================================================

status: ## Show status of all services
	@echo ""
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(CYAN)  Service Status$(NC)"
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@docker compose -f $(COMPOSE_FILE) ps
	@echo ""

ps: status ## Alias for status

# ============================================================================
# INFO
# ============================================================================

info: ## Show service URLs and info
	@echo ""
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(CYAN)  Service URLs$(NC)"
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "  $(GREEN)Frontend$(NC)      http://localhost:3000"
	@echo "  $(GREEN)Backend API$(NC)   http://localhost:8000"
	@echo "  $(GREEN)API Docs$(NC)      http://localhost:8000/docs"
	@echo "  $(GREEN)Backend AI$(NC)    http://localhost:8001"
	@echo "  $(GREEN)PostgreSQL$(NC)    localhost:5432"
	@echo "  $(GREEN)Redis$(NC)         localhost:6379"
	@echo "  $(GREEN)Grafana$(NC)       http://localhost:3001 (admin/admin)"
	@echo "  $(GREEN)Prometheus$(NC)    http://localhost:9090"
	@echo "  $(GREEN)Mailhog$(NC)       http://localhost:8025"
	@echo ""

urls: info ## Alias for info
