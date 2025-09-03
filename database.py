from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker





SQLALCHEMY_DATABASE_URL= "postgresql://mudasir:mudasir777@localhost:5432/crudDB"

SECRETE_KEY= "This is going to the secrete key for the jwt token generation"
ALGORITHM= "HS256"
ACCESS_TOKEN_EXPIRE_TIME= 60
REFRESH_TOKKEN_EXPIRE_TIME= 7



engine= create_engine(SQLALCHEMY_DATABASE_URL)


SessionLocal= sessionmaker(autocommit= False, autoflush= False, bind= engine)


Base= declarative_base()

def get_db():
    db= SessionLocal()
    try:
        yield db
    finally:
        db.close()


