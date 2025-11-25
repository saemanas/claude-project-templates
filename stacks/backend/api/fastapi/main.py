"""
FastAPI Backend - Main Application

Usage:
    Development: uvicorn main:app --reload --host 0.0.0.0 --port 8000
    Production:  gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator

from src.core.config import settings
from src.core.database import engine, Base
from src.api import router as api_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan handler - startup and shutdown events."""
    # Startup
    print(f"Starting application in {settings.ENV} mode...")

    # Create database tables
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    yield

    # Shutdown
    print("Shutting down application...")
    await engine.dispose()


# Create FastAPI app
app = FastAPI(
    title=settings.PROJECT_NAME,
    description=settings.PROJECT_DESCRIPTION,
    version=settings.VERSION,
    docs_url="/docs" if settings.DEBUG else None,
    redoc_url="/redoc" if settings.DEBUG else None,
    openapi_url="/openapi.json" if settings.DEBUG else None,
    lifespan=lifespan,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Prometheus metrics
Instrumentator().instrument(app).expose(app, endpoint="/metrics")

# Include API router
app.include_router(api_router, prefix="/api/v1")


# ==============================================================================
# HEALTH CHECK
# ==============================================================================


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": f"{settings.PROJECT_NAME} is running",
        "version": settings.VERSION,
        "env": settings.ENV,
    }


@app.get("/health")
async def health():
    """Health check endpoint."""
    return {"status": "healthy"}


@app.get("/health/ready")
async def readiness():
    """Readiness check - verifies all dependencies are ready."""
    # TODO: Check database connection
    # TODO: Check Redis connection
    return {"status": "ready"}


@app.get("/health/live")
async def liveness():
    """Liveness check - verifies the application is alive."""
    return {"status": "alive"}


# Kubernetes-style endpoints (aliases)
@app.get("/healthz")
async def healthz():
    """Kubernetes-style liveness probe."""
    return {"status": "alive"}


@app.get("/readyz")
async def readyz():
    """Kubernetes-style readiness probe."""
    # TODO: Check database connection
    # TODO: Check Redis connection
    return {"status": "ready"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.DEBUG,
    )
