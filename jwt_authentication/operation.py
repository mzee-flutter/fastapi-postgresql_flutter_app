from fastapi import Depends, HTTPException, APIRouter, status
from . import models, schemas
from sqlalchemy.orm import Session
from datetime import datetime, timedelta, timezone
from database import get_db, REFRESH_TOKKEN_EXPIRE_TIME
from utils import hash_password, verify_password, create_access_token, create_refresh_token, _sha256
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
import jwt_authentication.models

auth_router= APIRouter(prefix="/auth", tags=["Authentication"])
oauth2_scheme= OAuth2PasswordBearer(tokenUrl="/auth/login")



@auth_router.post('/register', response_model=schemas.showUser)
def register_user(user: schemas.UserCreate, db: Session= Depends(get_db)):
    existing_user= db.query(models.User).filter(models.User.email== user.email).first()
    if existing_user:
        raise HTTPException(detail="Email already register")
    
    hash_password= hash_password(user.password)
    new_user= models.User( name= user.name, email= user.email, hashed_password= hash_password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user



#if we want to authorize the user on the swagger UI then we have to use the OAuth2passwordRequestForm = Depends()
# in place of schemas.UserLogin to automatically test the information using swagger UI 


#in this we can't directly authorize the user on the swagger UI
@auth_router.post("/login", response_model=schemas.Token)
def login_user(user: schemas.Userlogin  , db:Session= Depends(get_db)):
    loggedInUser= db.query(models.User).filter(models.User.email == user.email).first()
    if not loggedInUser or not  verify_password(user.password, loggedInUser.hashed_password):
        raise HTTPException(detail="Invalid email and password")
    
    token= create_access_token({"sub": str(loggedInUser.id)})
    return {"access_token":token, "token_type": "bearer"}




def createTokens(db: Session, user:models.User):
    access_token, expire_in = create_access_token(user.id, user.name, user.email)
    raw_refresh, hashed_refresh= create_refresh_token()

    expires_at= datetime.now(timezone.utc) + datetime(timedelta(days=REFRESH_TOKKEN_EXPIRE_TIME))
    db_refresh= models.RefreshToken(user_id= user.id, token_hash= hashed_refresh, expire_at= expires_at)
    db.add(db_refresh)
    db.commit()
    return access_token, raw_refresh, expire_in


def refresh_access_token(db:Session, raw_refresh:str):
    hash_refresh= _sha256(raw_refresh)
    record= db.query(models.RefreshToken).filter(models.RefreshToken.token_hash== hash_refresh).first()

    if not record or record.revoked or record.expire_at <= datetime.now(timezone.utc):
        raise HTTPException (detail= "Invalid or expired refresh token")
    
    user = record.user

    record.revoked= True
    db.add(record)
    db.commit()

    access_token, expire_in= create_access_token(user.id, user.name, user.email)
    new_raw_refresh, new_hashed_refresh = create_refresh_token()
    expire_at= datetime.now(timezone.utc) + datetime(timedelta(days=REFRESH_TOKKEN_EXPIRE_TIME))

    addingNewRefreshTokenToDB= models.RefreshToken(user_id= user.id, token_hash= new_hashed_refresh, expire_at= expire_at)
    db.add(addingNewRefreshTokenToDB)
    db.commit()
    return access_token, new_raw_refresh, expire_in
    



def revoke_refresh_token(db:Session, raw_refresh:str):
    hash_token= _sha256(raw_refresh)
    record = db.query(models.RefreshToken).filter(models.RefreshToken.token_hash==hash_token).first()

    if record and not record.revoked:
        record.revoked= True
        db.commit()





    


