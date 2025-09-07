from fastapi import Depends, HTTPException, APIRouter, status
from . import models, schemas
from sqlalchemy.orm import Session
from datetime import datetime, timedelta, timezone
from database import get_db, REFRESH_TOKKEN_EXPIRE_TIME
from jwt_authentication.utils import hash_password, verify_password, create_access_token, create_refresh_token, _sha256
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
import jwt_authentication.models


def register_user(user: schemas.UserCreate, db: Session):
    existing_user= db.query(models.User).filter(models.User.email== user.email).first()
    if existing_user:
        raise HTTPException(detail="Email already register")
    
    hashed_password= hash_password(user.password)
    new_user= models.User( name= user.name, email= user.email, hashed_password= hashed_password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user



#if we want to authorize the user on the swagger UI then we have to use the OAuth2passwordRequestForm = Depends()
# in place of schemas.UserLogin to automatically test the information using swagger UI 


#in this we can't directly authorize the user on the swagger UI
def login_user(user: schemas.Userlogin  , db:Session):
    loggedInUser= db.query(models.User).filter(models.User.email == user.email).first()
    if not loggedInUser or not  verify_password(user.password, loggedInUser.hashed_password):
        raise HTTPException(detail="Invalid email and password",status_code= 401)
    return loggedInUser




def createTokens(user:models.User, db: Session ):

    payload= {"sub":str(user.id)}
    access_token, expire_at = create_access_token(payload)
    raw_refresh, hashed_refresh= create_refresh_token()

    
    refresh_expires_at= datetime.now(timezone.utc) + timedelta(days=REFRESH_TOKKEN_EXPIRE_TIME)
    db_refresh= models.RefreshToken(user_id= user.id, token_hash= hashed_refresh, expire_at= refresh_expires_at)
    db.add(db_refresh)
    db.commit()
    return access_token, raw_refresh, expire_at


def refresh_access_token( raw_refresh:str, db:Session):
    hash_refresh= _sha256(raw_refresh)
    record= db.query(models.RefreshToken).filter(models.RefreshToken.token_hash== hash_refresh).first()

    if not record or record.revoked or record.expire_at <= datetime.now(timezone.utc):
        raise HTTPException (detail= "Invalid or expired refresh token", status_code=401)
    
    user = record.user

    record.revoked= True
    db.add(record)
    db.commit()

    data= {
        "sub":str(user.id)}

    access_token, expire_in= create_access_token(data)
    new_raw_refresh, new_hashed_refresh = create_refresh_token()
    expire_at= datetime.now(timezone.utc) + timedelta(days=REFRESH_TOKKEN_EXPIRE_TIME)

    addingNewRefreshTokenToDB= models.RefreshToken(user_id= user.id, token_hash= new_hashed_refresh, expire_at= expire_at)
    db.add(addingNewRefreshTokenToDB)
    db.commit()
    return access_token, new_raw_refresh, expire_in
    



def revoke_refresh_token(db:Session, raw_refresh:str):
    hash_token= _sha256(raw_refresh)
    record = db.query(models.RefreshToken).filter(models.RefreshToken.token_hash==hash_token).first()

    if not record:
        raise HTTPException(status_code=400, detail="Invalid refresh token")
    
    if record.revoked:
        raise HTTPException(status_code=400, detail="token already revoked")
    
    record.revoked = True
    db.commit()

    
       





    


