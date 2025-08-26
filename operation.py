from sqlalchemy.orm import Session
import schemas, models



def get_items(db: Session ):
    return db.query(models.Item).all()



def create_item(db: Session, item: schemas.CreateItem):
    db_item= models.Item(name=item.name, description= item.description)
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item




def get_item(db: Session, item_id: int):
    db_item= db.query(models.Item).filter(models.Item.id==item_id).first()
    return db_item


def update_item(db:Session, item_id:int, updated_item: schemas.Item):
    item= db.query(models.Item).filter(models.Item.id == item_id).first()
    if not item:
        raise Exception("updation failed")

    item.name= updated_item.name
    item.description= updated_item.description
    db.commit()
    db.refresh(item)
    return item



def delete_item(db:Session, item_id: int):
    item= db.query(models.Item).filter(models.Item.id==item_id).first()
    if item:
        db.delete(item)
        db.commit()
    return item
