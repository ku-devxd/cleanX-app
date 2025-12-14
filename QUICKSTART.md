# 🚀 Быстрый старт

Краткая инструкция для быстрого запуска проекта.

## ⚡ Backend (5 минут)

### 1. Настройка PostgreSQL
```bash
# Войдите в PostgreSQL
psql -U postgres

# Выполните:
CREATE DATABASE dryclean_core;
CREATE USER dry_user WITH PASSWORD '12345';
GRANT ALL PRIVILEGES ON DATABASE dryclean_core TO dry_user;
\q
```

### 2. Настройка и запуск Backend
```bash
cd backend

# Автоматическая настройка
./setup.sh

# Или вручную:
python3 -m venv venv
source venv/bin/activate
pip install -r app/requirements.txt

# Создайте .env файл (см. backend/ENV_SETUP.md)
# Затем запустите:
./start.sh
# или
cd app && uvicorn main:app --reload
```

Backend будет доступен на: http://127.0.0.1:8000
Swagger UI: http://127.0.0.1:8000/docs

## 📱 Frontend (2 минуты)

```bash
cd frontend
flutter pub get
flutter run
```

## ✅ Проверка

1. Откройте http://127.0.0.1:8000/docs
2. Попробуйте зарегистрировать пользователя через `/auth/register`
3. Попробуйте авторизоваться через `/auth/login`
4. Запустите Flutter приложение и проверьте подключение

## 🆘 Проблемы?

См. подробные инструкции в [README.md](README.md)

