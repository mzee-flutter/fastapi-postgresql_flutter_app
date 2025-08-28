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