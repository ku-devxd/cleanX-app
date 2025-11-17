# from pydantic import BaseModel, EmailStr

# # Модель для базовой информации
# class UserBase(BaseModel):
#     email: EmailStr
#     name: str
#     role: str = "client"

# # Для регистрации (с паролем)
# class UserCreate(UserBase):
#     password: str

# # Для возврата наружу (без пароля)
# class UserOut(UserBase):
#     id: int

#     class Config:
#         orm_mode = True


from pydantic import BaseModel, EmailStr, constr
from app.db.models import User

# Модель для базовой информации
class UserBase(BaseModel):
    email: EmailStr
    name: str
    role: str = "client"


# Для регистрации (с паролем)
class UserCreate(UserBase):
    # Ограничиваем длину пароля до 72 байт (bcrypt limit)
    password: constr(min_length=6, max_length=72) # type: ignore


# Для возврата наружу (без пароля)
class UserOut(UserBase):
    id: int

    model_config = {
        "from_attributes": True  # вместо orm_mode в Pydantic v2
    }
