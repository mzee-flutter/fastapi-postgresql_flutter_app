from fastapi import Depends, HTTPException, APIRouter, status
from . import models, schemas, utils
from sqlalchemy.orm import Session
from database import get_db
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

auth_router= APIRouter(prefix="/auth", tags=["Authentication"])
oauth2_scheme= OAuth2PasswordBearer(tokenUrl="/auth/login")



@auth_router.post('/register', response_model=schemas.showUser)
def register_user(user: schemas.UserCreate, db: Session= Depends(get_db)):
    existing_user= db.query(models.User).filter(models.User.email== user.email).first()
    if existing_user:
        raise HTTPException(detail="Email already register")
    
    hash_password= utils.hash_password(user.password)
    new_user= models.User( name= user.name, email= user.email, hashed_password= hash_password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user



#if we want to authorize the user on the swagger UI then we have to use the OAuth2passwordRequestForm = Depends()
# in place of schemas.UserLogin to automatically test the information using swagger UI 


#in this we can't directly authorize the user on the swagger UI
@auth_router.post("/login", response_model=schemas.Token)
def login_user(user: schemas.Userlogin, db:Session= Depends(get_db)):
    loggedInUser= db.query(models.User).filter(models.User.email == user.email).first()
    if not loggedInUser or not  utils.verify_password(user.password, loggedInUser.hashed_password):
        raise HTTPException(detail="Invalid email and password")
    
    token= utils.create_token({"sub": str(loggedInUser.id)})
    return {"access_token":token, "token_type": "bearer"}


    

