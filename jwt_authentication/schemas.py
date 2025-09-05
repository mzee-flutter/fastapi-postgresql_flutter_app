from pydantic import BaseModel, EmailStr


class UserCreate(BaseModel):
    name:str
    email:EmailStr
    password:str



class Userlogin(BaseModel):
    email:EmailStr
    password:str

class TokenResponse(BaseModel):
    access_token:str
    token_type:str= "bearer"
    refresh_token:str
    expire_at:int


class RefreshRequest(BaseModel):
    refresh_token:str

class showUser(BaseModel):
    id:int
    name:str
    email:EmailStr
    class Config:
        from_attributes =True



class Token(BaseModel):
    access_token:str
    token_type:str