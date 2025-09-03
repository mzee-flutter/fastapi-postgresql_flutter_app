from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, HTTPException
from jwt_authentication import models, schemas, operation
from database import get_db
from  fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm





auth_router= APIRouter(prefix="auth", tags= ["Authentication"])
auth2_scheme= OAuth2PasswordBearer(tokenUrl="/auth/login")




@auth_router.post("/register", response_model= schemas.showUser)
def register(body: schemas.UserCreate, db: Session= Depends(get_db)):
    return operation.register_user()



@auth_router.post("/login", response_model= schemas.TokenResponse)
def login(body:schemas.Userlogin, db: Session= Depends(get_db)):
    user= operation.login_user(user=body, db= db)
    access, refresh, exp= operation.createTokens(body, db)
    return schemas.TokenResponse(access_token= access, refresh_token= refresh, expire_at= exp)



@auth_router.post("/refresh", response_model= schemas.TokenResponse)
def refresh(body:schemas.RefreshRequest, db: Session= Depends(get_db)):
    access, new_refresh, exp = operation.create_refresh_token(db, body.refresh_token)
    return schemas.TokenResponse(access_token= access, refresh_token= new_refresh, expire_at= exp)


@auth_router("/logout", response_model= schemas.RefreshRequest)
def logout(body: schemas.RefreshRequest, db: Session= Depends(get_db)):
    operation.revoke_refresh_token(db, body.refresh_token)
    return{"Ok": "The user is successfully logout"}
    
