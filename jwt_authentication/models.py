from database import Base
from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, DateTime, func
from sqlalchemy.orm import relationship 
import uuid



class User(Base):
    __tablename__= "users"

    id= Column(Integer, primary_key=True, index=True)
    name=Column(String, index= True)
    email= Column(String, unique= True, index=True, nullable= False)
    hashed_password= Column(String, nullable= False)
    created_at= Column(DateTime(timezone=True), server_default= func.now())

    refresh_tokens= relationship("RefreshToken", back_populates= "user")



class RefreshToken(Base):
    __tablename__= "refresh_tokens"
    id= Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id= Column(Integer, ForeignKey("users.id", ondelete='CASCADE'))
    token_hash= Column(String(128),unique=True, index=True)
    expire_at= Column(DateTime(timezone=True))
    revoked= Column(Boolean, default=False)

    user= relationship("User", back_populates="refresh_tokens")



#The last line means that it is the python base relationship between the attributes of the models 
#inside the database the relationship between tables are formed using FOREIGN-KEY
#These both the user and the refresh_tokens have one-to-many and many-to-one relationship 
#That each user have multiple refresh_tokens but 
#For each token there is only one user 

#These both attributes basically refer of point out each other.