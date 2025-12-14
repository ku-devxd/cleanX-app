# 🧹 DryCleanX - Система автоматизации для химчисток

Современная система автоматизации для химчисток.
Full-stack архитектура: FastAPI + PostgreSQL + Flutter.

---

## 🚀 Features

- 🔐 JWT-аутентификация (access + refresh токены)
- 👤 Регистрация / Логин / Logout
- 📦 Управление заказами (в разработке)
- 💳 Оплаты и транзакции (в разработке)
- 📱 Мобильное приложение Flutter
- ⚙️ Чистая архитектура backend + frontend
- 🌗 Светлая/тёмная тема (Flutter)
- 🌍 Готово для деплоя (Docker, Render, Railway — в планах)

---

## 🏗️ Tech Stack

### Backend
- FastAPI
- PostgreSQL
- SQLAlchemy
- Pydantic
- JWT (python-jose)
- Passlib (bcrypt)
- Uvicorn

### Frontend
- Flutter
- Material 3
- Riverpod (в планах)
- Clean Navigation (Navigator 2.0)

---

## 📁 Структура проекта

```
dryCleanX/
│
├── backend/
│   ├── app/
│   │   ├── core/         # конфиг, безопасность, JWT
│   │   ├── core_2/       # зависимости (get_db, get_current_user)
│   │   ├── db/           # база данных, сессии, модели
│   │   ├── routers/      # контроллеры FastAPI
│   │   ├── schemas/      # схемы pydantic
│   │   └── utils/        # утилиты (хэширование паролей)
│   ├── venv/             # виртуальное окружение Python
│   ├── requirements.txt  # зависимости Python
│   ├── setup.sh          # скрипт первоначальной настройки
│   └── start.sh          # скрипт запуска сервера
│
└── frontend/
    ├── lib/
    │   ├── app/          # инициализация приложения, тема, роутинг
    │   ├── core/         # модели, сервисы, утилиты
    │   └── ui/           # views и widgets
    ├── android/
    ├── ios/
    └── pubspec.yaml      # зависимости Flutter
```

---

## ⚙️ Установка и запуск

### 📋 Требования

- Python 3.8+
- PostgreSQL 12+
- Flutter SDK (для frontend)
- Git

---

### 🔧 Backend - Первоначальная настройка

#### 1. Настройка PostgreSQL

Создайте базу данных и пользователя:

```bash
# Войдите в PostgreSQL
psql -U postgres

# Создайте базу данных и пользователя
CREATE DATABASE dryclean_core;
CREATE USER dry_user WITH PASSWORD '12345';
GRANT ALL PRIVILEGES ON DATABASE dryclean_core TO dry_user;
\q
```

> ⚠️ **Важно**: В production используйте более безопасный пароль!

#### 2. Настройка Backend

**Вариант А: Автоматическая настройка (рекомендуется)**

```bash
cd backend
./setup.sh
```

**Вариант Б: Ручная настройка**

```bash
cd backend

# Создание виртуального окружения
python3 -m venv venv

# Активация виртуального окружения
source venv/bin/activate  # Linux/Mac
# или
venv\Scripts\activate     # Windows

# Установка зависимостей
pip install --upgrade pip
pip install -r app/requirements.txt

# Создание .env файла
cat > .env << EOF
DATABASE_URL=postgresql://dry_user:12345@localhost:5432/dryclean_core
SECRET_KEY=REPLACE_ME_SUPER_SECRET_KEY_CHANGE_IN_PRODUCTION
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=15
REFRESH_TOKEN_EXPIRE_DAYS=30
EOF
```

> ⚠️ **Важно**: Измените `SECRET_KEY` на случайную строку в production!

#### 3. Запуск Backend сервера

**Вариант А: Используя скрипт**

```bash
cd backend
source venv/bin/activate
./start.sh
```

**Вариант Б: Вручную**

```bash
cd backend
source venv/bin/activate
cd app
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Сервер будет доступен по адресу:
- **API**: http://127.0.0.1:8000
- **Swagger UI**: http://127.0.0.1:8000/docs
- **ReDoc**: http://127.0.0.1:8000/redoc

---

### 📱 Frontend - Установка и запуск

#### 1. Установка зависимостей

```bash
cd frontend
flutter pub get
```

#### 2. Запуск приложения

```bash
# Для запуска на подключенном устройстве/эмуляторе
flutter run

# Для запуска на конкретной платформе
flutter run -d chrome        # Web
flutter run -d macos         # macOS
flutter run -d ios           # iOS
flutter run -d android       # Android
```

#### 3. Настройка API URL

Если backend запущен на другом адресе, измените `baseUrl` в файле:
`frontend/lib/core/services/auth_service.dart`

```dart
static const String baseUrl = "http://127.0.0.1:8000";
```

---

## 🔐 API Endpoints

| Метод | Endpoint | Описание | Требует авторизации |
|-------|----------|----------|---------------------|
| POST | `/auth/register` | Регистрация нового пользователя | ❌ |
| POST | `/auth/login` | Авторизация пользователя | ❌ |
| GET | `/auth/me` | Получить данные текущего пользователя | ✅ |
| POST | `/auth/refresh` | Обновить access_token используя refresh_token | ❌ |

### Примеры запросов

#### Регистрация
```bash
curl -X POST "http://127.0.0.1:8000/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Иван Иванов",
    "email": "ivan@example.com",
    "password": "password123",
    "role": "client"
  }'
```

#### Логин
```bash
curl -X POST "http://127.0.0.1:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ivan@example.com",
    "password": "password123"
  }'
```

#### Получить данные пользователя
```bash
curl -X GET "http://127.0.0.1:8000/auth/me" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

#### Обновить токен
```bash
curl -X POST "http://127.0.0.1:8000/auth/refresh" \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "YOUR_REFRESH_TOKEN"
  }'
```

---

## 🧪 Проверка работоспособности

### Backend

1. Убедитесь, что PostgreSQL запущен:
   ```bash
   pg_isready
   ```

2. Проверьте подключение к базе данных:
   ```bash
   psql -U dry_user -d dryclean_core -h localhost
   ```

3. Откройте Swagger UI: http://127.0.0.1:8000/docs
   - Попробуйте зарегистрировать пользователя через `/auth/register`
   - Попробуйте авторизоваться через `/auth/login`

### Frontend

1. Убедитесь, что backend запущен и доступен
2. Запустите Flutter приложение
3. Попробуйте зарегистрироваться или войти

---

## 🐛 Решение проблем

### Backend не запускается

- **Проблема**: `ModuleNotFoundError`
  - **Решение**: Убедитесь, что виртуальное окружение активировано и зависимости установлены

- **Проблема**: `OperationalError: could not connect to server`
  - **Решение**: Проверьте, что PostgreSQL запущен и настройки в `.env` правильные

- **Проблема**: `database "dryclean_core" does not exist`
  - **Решение**: Создайте базу данных (см. раздел "Настройка PostgreSQL")

### Frontend не подключается к Backend

- **Проблема**: `Failed to connect to server`
  - **Решение**: 
    1. Убедитесь, что backend запущен
    2. Проверьте `baseUrl` в `auth_service.dart`
    3. Проверьте CORS настройки в `backend/app/main.py`

---

## 📝 Переменные окружения (.env)

Создайте файл `backend/.env` со следующим содержимым:

```env
# Database Configuration
DATABASE_URL=postgresql://dry_user:12345@localhost:5432/dryclean_core

# JWT Configuration
SECRET_KEY=REPLACE_ME_SUPER_SECRET_KEY_CHANGE_IN_PRODUCTION
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=15
REFRESH_TOKEN_EXPIRE_DAYS=30
```

> ⚠️ **Важно для production**:
> - Измените `SECRET_KEY` на случайную строку (минимум 32 символа)
> - Используйте безопасный пароль для базы данных
> - Не коммитьте `.env` файл в Git!

---

## 🧩 Планы разработки (Roadmap)

- [x] Базовый backend
- [x] JWT авторизация
- [ ] Модуль заказов (Orders)
- [ ] Модуль статусов (Workflow)
- [ ] Модуль клиентов (CRM)
- [ ] Модуль курьеров
- [ ] Мобильная карта курьера
- [ ] Dashboard администратора
- [ ] Docker + CI/CD GitHub Actions
- [ ] Деплой на Render / Railway

---

## 🧑‍💻 Author

Asadbek (Ps.)
Fullstack Developer / Junior Mobile Engineer
GitHub: https://github.com/ku-devxd/cleanX-app

---

## 📄 Лицензия

Этот проект создан для обучения и разработки.

---

⭐ Если тебе нравится проект — поставь звезду!

Это помогает развитию 🙏
