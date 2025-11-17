from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.db.base import Base
from app.db.session import engine
from app.routers import auth
from app.db.models import User

app = FastAPI(
    title="DryClean API",
    version="1.0",
    description="Backend для приложения химчистки DryClean 🚀",
)

# ✅ CORS для Flutter и Web
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # можно указать ["http://localhost:52749"] для Chrome
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Автоматическое создание таблиц (если не используешь Alembic)
Base.metadata.create_all(bind=engine)

# ✅ Подключаем роутеры
app.include_router(auth.router)

@app.get("/")
def root():
    return {"message": "DryClean API работает 🚀"}
