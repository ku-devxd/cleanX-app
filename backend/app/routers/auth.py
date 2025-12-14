# app/routers/auth.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel

from app.db import models
from app.schemas.user_schema import UserCreate, UserOut
from app.schemas.token_schema import Token
from app.utils.hashing import hash_password, verify_password
from app.core.security import create_access_token, create_refresh_token, verify_refresh_token
from app.core_2.dependencies import get_db, get_current_user

router = APIRouter(prefix="/auth", tags=["auth"])

# register/login request/response helpers
class LoginRequest(BaseModel):
    email: str
    password: str

class RefreshTokenRequest(BaseModel):
    refresh_token: str

@router.post("/register", response_model=Token, status_code=status.HTTP_201_CREATED)
def register(user: UserCreate, db: Session = Depends(get_db)):
    existing = db.query(models.User).filter(models.User.email == user.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")

    new_user = models.User(
        name=user.name,
        email=user.email,
        hashed_password=hash_password(user.password),
        role=user.role,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    access = create_access_token(subject=new_user.email, role=new_user.role)
    refresh = create_refresh_token(subject=new_user.email, role=new_user.role)

    return {"access_token": access, "refresh_token": refresh, "token_type": "bearer"}

@router.post("/login", response_model=Token)
def login(request: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == request.email).first()
    if not user or not verify_password(request.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    access = create_access_token(subject=user.email, role=user.role)
    refresh = create_refresh_token(subject=user.email, role=user.role)

    return {"access_token": access, "refresh_token": refresh, "token_type": "bearer"}

@router.post("/refresh", response_model=Token)
def refresh_token(request: RefreshTokenRequest, db: Session = Depends(get_db)):
    """
    Обновляет access и refresh токены используя refresh_token
    """
    token = request.refresh_token
    if not token:
        raise HTTPException(status_code=400, detail="Missing refresh_token")

    data = verify_refresh_token(token)
    email = data.get("sub")
    role = data.get("role", "client")

    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=401, detail="User not found")

    access = create_access_token(subject=email, role=role)
    refresh = create_refresh_token(subject=email, role=role)
    return {"access_token": access, "refresh_token": refresh, "token_type": "bearer"}

@router.get("/me", response_model=UserOut)
def me(current_user = Depends(get_current_user)):
    # The UserOut Pydantic model should support ORM (model_config/orm_mode)
    return current_user