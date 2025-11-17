from pydantic import BaseModel, EmailStr, constr

class UserBase(BaseModel):
    email: EmailStr
    name: str
    role: str = "client"

class UserCreate(UserBase):
    password: constr(min_length=6, max_length=72) # type: ignore

class UserOut(UserBase):
    id: int

    model_config = {"from_attributes": True}