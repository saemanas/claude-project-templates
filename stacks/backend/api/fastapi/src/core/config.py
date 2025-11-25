"""
Application Configuration

Uses pydantic-settings for type-safe configuration management.
All settings can be overridden via environment variables.
"""

from functools import lru_cache
from typing import List

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # ==========================================================================
    # Application
    # ==========================================================================
    PROJECT_NAME: str = "API"
    PROJECT_DESCRIPTION: str = "Backend API Service"
    VERSION: str = "0.1.0"
    ENV: str = "development"
    DEBUG: bool = True
    LOG_LEVEL: str = "debug"

    # ==========================================================================
    # Server
    # ==========================================================================
    HOST: str = "0.0.0.0"
    PORT: int = 8000

    # ==========================================================================
    # Database (PostgreSQL)
    # ==========================================================================
    DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5432/app"

    # Connection pool settings
    DB_POOL_SIZE: int = 5
    DB_MAX_OVERFLOW: int = 10
    DB_POOL_TIMEOUT: int = 30

    # ==========================================================================
    # Cache (Redis)
    # ==========================================================================
    REDIS_URL: str = "redis://localhost:6379/0"
    REDIS_POOL_SIZE: int = 10

    # ==========================================================================
    # Security
    # ==========================================================================
    SECRET_KEY: str = "change-me-in-production-use-openssl-rand-hex-32"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    # ==========================================================================
    # CORS
    # ==========================================================================
    CORS_ORIGINS: List[str] = ["http://localhost:3000", "http://localhost"]

    # ==========================================================================
    # Email (Mailhog for development)
    # ==========================================================================
    SMTP_HOST: str = "localhost"
    SMTP_PORT: int = 1025
    SMTP_USER: str = ""
    SMTP_PASSWORD: str = ""
    EMAIL_FROM: str = "noreply@localhost"

    # ==========================================================================
    # External Services
    # ==========================================================================
    # Add external service configurations here
    # OPENAI_API_KEY: str = ""
    # AWS_ACCESS_KEY_ID: str = ""


@lru_cache
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()


settings = get_settings()
