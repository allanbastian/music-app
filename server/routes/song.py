import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile

from database import get_db
from sqlalchemy.orm import Session
import cloudinary
import cloudinary.uploader

from middleware.auth_middleware import auth_middleware
from models.song import Song

router = APIRouter()

cloudinary.config( 
    cloud_name = "drbsa90aa", 
    api_key = "924532833284913", 
    api_secret = "AMDZfyz7lRTaalU7GskDHGe1FmQ",
    secure=True
)

@router.post('/upload', status_code=201)
def upload_song(song: UploadFile = File(...), 
                thumbnail: UploadFile = File(...), 
                artist: str = Form(...),
                song_name: str = Form(...), 
                hex_code: str = Form(...), 
                db: Session = Depends(get_db),
                auth_dict = Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_result = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}')
    thumbnail_result = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}')
    
    new_song = Song(
        id = song_id,
        song_name = song_name,
        artist = artist,
        hex_code = hex_code,
        song_url= song_result['url'],
        thumbnail_url= thumbnail_result['url'],
    )
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

@router.get('/list')
def list_songs(db: Session = Depends(get_db), auth_dict = Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs