import uuid
import bcrypt
from fastapi import Depends, HTTPException
from database import get_db
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session

router = APIRouter()

@router.post('/signup')
def singup_user(user: UserCreate, db: Session=Depends(get_db)):
    # check if user already exists in db
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(400, 'User with the same email already exits!')
    
    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), email=user.email, password=hashed_pw, name=user.name)
    # add user to db if doesnt exist
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db