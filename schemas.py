from pydantic import BaseModel


class ItemBase(BaseModel):
    name: str
    description: str



class CreateItem(ItemBase):
    pass

class Item(ItemBase):
    id: int


class config:
    orm_mode =True


