"""API Router - aggregates all endpoint routers."""

from fastapi import APIRouter

# Import routers
# from src.api.auth import router as auth_router
# from src.api.users import router as users_router

router = APIRouter()

# Include routers
# router.include_router(auth_router, prefix="/auth", tags=["auth"])
# router.include_router(users_router, prefix="/users", tags=["users"])


@router.get("/")
async def api_root():
    """API root endpoint."""
    return {"message": "API v1", "docs": "/docs"}
