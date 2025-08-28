from pydantic import BaseModel, EmailStr


class UserCreate(BaseModel):
    name:str
    email:EmailStr
    password:str



class Userlogin(BaseModel):
    email:EmailStr
    password:str


class showUser(BaseModel):
    id:int
    name:str
    email:EmailStr
    class Config:
        orm_mode=True



class Token(BaseModel):
    access_token:str
    token_type:str