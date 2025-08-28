from passlib.context import CryptContext
from jose import jwt, JWTError
from datetime import datetime, timedelta, UTC
from database import ACCESS_TOKEN_EXPIRE_TIME, SECRETE_KEY, ALGORITHM



pwd_context= CryptContext(schemes=["bcrypt"], deprecated= "auto")


def hash_password(password:str):
    return pwd_context.hash(password)


def verify_password(password, hash_password):
    return pwd_context.verify(password, hash_password)

def create_token(data: dict):
    to_encode= data.copy()
    expire= datetime.now(UTC) + timedelta(minutes= ACCESS_TOKEN_EXPIRE_TIME)
    to_encode.update({"exp":expire})
    return jwt.encode(to_encode, SECRETE_KEY,algorithm= ALGORITHM )


def decode_token(token:str):
    try:
        payload= jwt.decode (token, SECRETE_KEY, algorithms= ALGORITHM)
        return payload
    except JWTError:
        return None

    
    