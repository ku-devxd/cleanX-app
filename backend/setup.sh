#!/bin/bash

# Скрипт для первоначальной настройки backend

echo "🔧 Настройка backend проекта..."

# Создание виртуального окружения если его нет
if [ ! -d "venv" ]; then
    echo "📦 Создание виртуального окружения..."
    python3 -m venv venv
fi

# Активация виртуального окружения
echo "✅ Активация виртуального окружения..."
source venv/bin/activate

# Установка зависимостей
echo "📥 Установка зависимостей..."
pip install --upgrade pip
pip install -r app/requirements.txt

# Создание .env файла если его нет
if [ ! -f ".env" ]; then
    echo "📝 Создание .env файла..."
    cat > .env << EOF
# Database Configuration
DATABASE_URL=postgresql://dry_user:12345@localhost:5432/dryclean_core

# JWT Configuration
SECRET_KEY=REPLACE_ME_SUPER_SECRET_KEY_CHANGE_IN_PRODUCTION
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=15
REFRESH_TOKEN_EXPIRE_DAYS=30
EOF
    echo "✅ .env файл создан! Не забудьте изменить SECRET_KEY и DATABASE_URL!"
fi

echo ""
echo "✅ Настройка завершена!"
echo ""
echo "📋 Следующие шаги:"
echo "1. Настройте PostgreSQL и создайте базу данных"
echo "2. Отредактируйте .env файл с правильными настройками"
echo "3. Запустите сервер: ./start.sh или uvicorn app.main:app --reload"

