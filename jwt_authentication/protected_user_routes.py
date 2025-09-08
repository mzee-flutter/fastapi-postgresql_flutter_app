from sqlalchemy.orm import Session
from fastapi import HTTPException, status, Depends, APIRouter
from database import get_db
from fastapi.security import OAuth2PasswordBearer
from . import schemas, models, utils



user_router= APIRouter(prefix="/users", tags= ["Users"])
oauth2_schemes= OAuth2PasswordBearer(tokenUrl="/auth/login")


def get_current_user(token: str=(Depends(oauth2_schemes)), db: Session= Depends(get_db)) -> schemas.showUser:
    payload= utils.decode_token(token)
    if not payload:
        raise HTTPException(
                            status_code= status.HTTP_401_UNAUTHORIZED, 
                            detail="Invalid or expire token",
                            headers={"WWW-Authenticate": "Bearer",}
                        )
    
    user = db.query(models.User).filter(models.User.id == int(payload["sub"])).first()
    if not user:
        raise HTTPException(detail="user not found")
    return schemas.showUser.model_validate(user)


@user_router.get('/me', response_model=schemas.showUser)
def get_me(current_user: models.User= Depends(get_current_user)):
    return current_user



