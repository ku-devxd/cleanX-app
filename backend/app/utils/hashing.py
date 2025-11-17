from passlib.context import CryptContext

# Настраиваем bcrypt для безопасного хэширования
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str):
    """Хэширует пароль перед сохранением в базу"""
    return pwd_context.hash(password)

def verify_password(plain_password, hashed_password):
    """Проверяет, совпадает ли пароль с хэшем"""
    return pwd_context.verify(plain_password, hashed_password)
