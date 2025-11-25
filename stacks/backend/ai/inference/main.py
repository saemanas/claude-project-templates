"""
AI Inference Service - Main Application

Usage:
    Development: uvicorn main:app --reload --host 0.0.0.0 --port 8001
    Production:  gunicorn main:app -w 2 -k uvicorn.workers.UvicornWorker
"""

from contextlib import asynccontextmanager
from typing import Optional

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from prometheus_fastapi_instrumentator import Instrumentator

import os

# Configuration
ENV = os.getenv("ENV", "development")
DEBUG = os.getenv("DEBUG", "true").lower() == "true"
MODEL_PATH = os.getenv("MODEL_PATH", "./models")
CORS_ORIGINS = os.getenv("CORS_ORIGINS", "http://localhost:3000").split(",")

# Model placeholder (will be loaded on startup)
model = None


class InferenceRequest(BaseModel):
    """Inference request schema."""

    text: str
    max_length: Optional[int] = 100
    temperature: Optional[float] = 0.7


class InferenceResponse(BaseModel):
    """Inference response schema."""

    result: str
    model: str
    tokens_used: int


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan handler - load and unload model."""
    global model

    # Startup - Load model
    print(f"Loading model from {MODEL_PATH}...")
    # TODO: Load your model here
    # Example with transformers:
    # from transformers import AutoModelForCausalLM, AutoTokenizer
    # model = AutoModelForCausalLM.from_pretrained(MODEL_PATH)
    model = {"name": "placeholder", "loaded": True}
    print("Model loaded successfully")

    yield

    # Shutdown - Cleanup
    print("Unloading model...")
    model = None


# Create FastAPI app
app = FastAPI(
    title="AI Inference Service",
    description="AI/ML Model Inference API",
    version="0.1.0",
    docs_url="/docs" if DEBUG else None,
    redoc_url="/redoc" if DEBUG else None,
    lifespan=lifespan,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Prometheus metrics
Instrumentator().instrument(app).expose(app, endpoint="/metrics")


# ==============================================================================
# ENDPOINTS
# ==============================================================================


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "service": "AI Inference",
        "version": "0.1.0",
        "model_loaded": model is not None,
    }


@app.get("/health")
async def health():
    """Health check endpoint."""
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    return {"status": "healthy", "model_loaded": True}


@app.get("/healthz")
async def healthz():
    """Kubernetes-style health check (liveness)."""
    return {"status": "alive"}


@app.get("/readyz")
async def readyz():
    """Kubernetes-style readiness check."""
    if model is None:
        raise HTTPException(status_code=503, detail="Model not ready")
    return {"status": "ready", "model_loaded": True}


@app.post("/inference", response_model=InferenceResponse)
async def inference(request: InferenceRequest):
    """Run inference on the loaded model."""
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")

    # TODO: Implement actual inference
    # Example:
    # result = model.generate(request.text, max_length=request.max_length)

    return InferenceResponse(
        result=f"Processed: {request.text[:50]}...",
        model=model.get("name", "unknown"),
        tokens_used=len(request.text.split()),
    )


@app.get("/models")
async def list_models():
    """List available models."""
    # TODO: Implement model listing
    return {
        "available": ["placeholder"],
        "loaded": model.get("name") if model else None,
    }


@app.post("/models/{model_name}/load")
async def load_model(model_name: str):
    """Load a specific model."""
    global model

    # TODO: Implement model loading
    model = {"name": model_name, "loaded": True}

    return {"status": "loaded", "model": model_name}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8001, reload=DEBUG)
