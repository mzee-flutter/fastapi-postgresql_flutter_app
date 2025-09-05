from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
import schemas, models, operation
from database import Base, engine, get_db
from jwt_authentication.protected_user_routes import user_router
from jwt_authentication.auth_routes import auth_router



app= FastAPI(docs_url='/docs', redoc_url='/redoc', openapi_url='/openapi.json')
app.include_router(user_router)
app.include_router(auth_router)

Base.metadata.create_all(bind=engine)



@app.post("/items/", response_model= schemas.Item)
def create_item(item: schemas.CreateItem, db: Session= Depends(get_db)):
    return operation.create_item(item = item, db = db)



@app.get("/items/", response_model= List[schemas.Item])
def get_items(db: Session= Depends(get_db)):
    return operation.get_items(db=db)


@app.get("/items/{item_id}", response_model= schemas.Item)
def get_item(item_id: int, db: Session = Depends(get_db)):
    db_item=  operation.get_item(item_id=item_id, db= db)
    if db_item is None:
        raise HTTPException(status_code= 404, detail= "Item not found.")
    return db_item


@app.put("/items/{item_id}", response_model= schemas.Item)
def updateItem(item_id: int, updated_item: schemas.Item, db: Session= Depends(get_db)):
    itemToBeUpdated= operation.update_item(item_id= item_id, db= db, updated_item= updated_item)
    if itemToBeUpdated:
        return itemToBeUpdated
    else:
        raise HTTPException(status_code=404, detail= "There is no such item to be updated.")



@app.delete("/items/{item_id}", response_model= schemas.Item)
def delete_item(item_id:int, db: Session= Depends(get_db)):
    item= operation.delete_item(item_id= item_id, db= db)
    if not item:
        raise HTTPException(status_code=404, detail= "Item does not found to be deleted.")
    return item

