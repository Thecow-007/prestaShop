"""Robot Framework variable file — loads .env and provides secrets as RF variables."""
from pathlib import Path
from dotenv import load_dotenv
import os

load_dotenv(Path(__file__).resolve().parent / ".env")

def get_variables():
    return {
        "CF_CLIENT_ID": os.environ["CF_CLIENT_ID"],
        "CF_CLIENT_SECRET": os.environ["CF_CLIENT_SECRET"],
    }
