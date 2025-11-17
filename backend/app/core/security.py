# app/core/security.py
from datetime import datetime, timedelta
from typing import Any, Dict, Optional

from jose import JWTError, jwt
from fastapi import HTTPException, status

from app.core.config import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES, REFRESH_TOKEN_EXPIRE_DAYS

def _create_token(data: Dict[str, Any], expires_delta: timedelta) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    token = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return token

def create_access_token(subject: str, role: str = "client", minutes: Optional[int] = None) -> str:
    minutes = minutes or ACCESS_TOKEN_EXPIRE_MINUTES
    payload = {"sub": subject, "role": role, "type": "access"}
    return _create_token(payload, timedelta(minutes=minutes))

def create_refresh_token(subject: str, role: str = "client", days: Optional[int] = None) -> str:
    days = days or REFRESH_TOKEN_EXPIRE_DAYS
    payload = {"sub": subject, "role": role, "type": "refresh"}
    return _create_token(payload, timedelta(days=days))

def decode_token(token: str) -> Dict[str, Any]:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token invalid or expired") from e

def verify_access_token(token: str) -> Dict[str, Any]:
    payload = decode_token(token)
    token_type = payload.get("type")
    if token_type != "access":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Not an access token")
    return payload

def verify_refresh_token(token: str) -> Dict[str, Any]:
    payload = decode_token(token)
    token_type = payload.get("type")
    if token_type != "refresh":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Not a refresh token")
    return payload