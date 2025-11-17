from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings

# Создаём движок SQLAlchemy (соединение с базой)
engine = create_engine(settings.DATABASE_URL)

# Создаём "фабрику" сессий для запросов
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# from app.core.config import DATABASE_URL    
# from sqlalchemy import create_engine
# from sqlalchemy.orm import sessionmaker
# from app.db.base import Base

# engine = create_engine(DATABASE_URL, future=True)  # future=True для SQLAlchemy 2.0+

# SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)

# Base.metadata.create_all(bind=engine)  # именно тут создаются таблицы
