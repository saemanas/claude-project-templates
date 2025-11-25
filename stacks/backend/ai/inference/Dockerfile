# AI Inference Dockerfile
# Optimized for ML model serving

FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r app && useradd -r -g app app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY --chown=app:app . .

# Create models directory
RUN mkdir -p /app/models && chown -R app:app /app/models

# Switch to non-root user
USER app

# Expose port
EXPOSE 8001

# Environment variables
ENV MODEL_PATH=/app/models
ENV PYTHONUNBUFFERED=1

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:8001/health')" || exit 1

# Run with gunicorn (fewer workers for ML workloads)
CMD ["gunicorn", "main:app", "-w", "2", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8001", "--timeout", "120"]
