# 🔧 Настройка переменных окружения

Этот файл содержит инструкции по созданию и настройке файла `.env` для backend.

## 📝 Создание .env файла

Создайте файл `.env` в директории `backend/` со следующим содержимым:

```env
# Database Configuration
# Формат: postgresql://username:password@host:port/database_name
DATABASE_URL=postgresql://dry_user:12345@localhost:5432/dryclean_core

# JWT Configuration
# ВАЖНО: Измените SECRET_KEY на случайную строку в production!
SECRET_KEY=REPLACE_ME_SUPER_SECRET_KEY_CHANGE_IN_PRODUCTION
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=15
REFRESH_TOKEN_EXPIRE_DAYS=30
```

## 🚀 Быстрое создание через терминал

Выполните в директории `backend/`:

```bash
cat > .env << 'EOF'
DATABASE_URL=postgresql://dry_user:12345@localhost:5432/dryclean_core
SECRET_KEY=REPLACE_ME_SUPER_SECRET_KEY_CHANGE_IN_PRODUCTION
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=15
REFRESH_TOKEN_EXPIRE_DAYS=30
EOF
```

## ⚙️ Описание переменных

### DATABASE_URL
Строка подключения к PostgreSQL базе данных.

**Формат**: `postgresql://username:password@host:port/database_name`

**Примеры**:
- Локальная БД: `postgresql://dry_user:12345@localhost:5432/dryclean_core`
- Удаленная БД: `postgresql://user:pass@db.example.com:5432/dryclean_core`

### SECRET_KEY
Секретный ключ для подписи JWT токенов.

⚠️ **КРИТИЧЕСКИ ВАЖНО**: 
- В production используйте случайную строку минимум 32 символа
- Никогда не коммитьте реальный SECRET_KEY в Git
- Можно сгенерировать через: `python -c "import secrets; print(secrets.token_urlsafe(32))"`

### ALGORITHM
Алгоритм подписи JWT. Обычно `HS256`.

### ACCESS_TOKEN_EXPIRE_MINUTES
Время жизни access токена в минутах. По умолчанию: 15 минут.

### REFRESH_TOKEN_EXPIRE_DAYS
Время жизни refresh токена в днях. По умолчанию: 30 дней.

## 🔒 Безопасность

1. **Никогда не коммитьте `.env` файл в Git!**
   - Убедитесь, что `.env` добавлен в `.gitignore`

2. **Используйте разные ключи для разных окружений:**
   - Development: можно использовать простой ключ
   - Production: используйте криптографически стойкий случайный ключ

3. **Защитите доступ к `.env` файлу:**
   - Установите права доступа: `chmod 600 .env` (только владелец может читать)

## ✅ Проверка

После создания `.env` файла, убедитесь что:
1. Файл находится в `backend/.env`
2. Все переменные заполнены
3. DATABASE_URL указывает на существующую базу данных
4. SECRET_KEY изменен на безопасное значение (для production)

