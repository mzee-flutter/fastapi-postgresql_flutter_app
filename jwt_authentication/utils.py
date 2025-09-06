from passlib.context import CryptContext
import secrets, hashlib
from jose import jwt, JWTError
from datetime import datetime, timedelta, UTC
from database import ACCESS_TOKEN_EXPIRE_TIME, SECRETE_KEY, ALGORITHM



pwd_context= CryptContext(schemes=["bcrypt"], deprecated= "auto")


def hash_password(password:str) -> str:
    return pwd_context.hash(password)


def verify_password(password, hash_password) -> bool:
    return pwd_context.verify(password, hash_password)


#This is the hashlib.sha256 calculate the hash of the given string
#s.encode() convert into bytes because sha256 operates on bytes and finally return as String of hexadecimal digits.
def _sha256(input:str) ->str:
    return hashlib.sha256(input.encode()).hexdigest()



def create_access_token(data: dict):
    to_encode= data.copy()
    expire= datetime.now(UTC) + timedelta(minutes= ACCESS_TOKEN_EXPIRE_TIME)
    to_encode.update({"exp":expire})

    access_token= jwt.encode(to_encode, SECRETE_KEY,algorithm= ALGORITHM )
    return access_token, int(expire.timestamp() * 1000)






#This function return two tokens that is 
#One raw_token that is unhashed_token
#Second which is return by the _sha265 helper-function that is hashed_token
def create_refresh_token():
    raw_token= secrets.token_urlsafe(64)
    return raw_token, _sha256(raw_token) 


def decode_token(token:str):
    try:
        payload= jwt.decode (token, SECRETE_KEY, algorithms= [ALGORITHM])
        return payload
    except JWTError as e:
        print('JWT decode error:', e)
        return None

    
    