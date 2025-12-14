#!/bin/bash

# Скрипт для запуска backend сервера
# Убедитесь, что виртуальное окружение активировано и зависимости установлены

echo "🚀 Запуск backend сервера..."
echo "📍 Убедитесь, что PostgreSQL запущен и база данных создана!"
echo ""

# Проверка виртуального окружения
if [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠️  Виртуальное окружение не активировано!"
    echo "💡 Выполните: source venv/bin/activate"
    exit 1
fi

# Запуск сервера
cd app
uvicorn main:app --reload --host 0.0.0.0 --port 8000

