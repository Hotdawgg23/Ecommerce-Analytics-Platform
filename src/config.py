"""
Central config for DB connection.
Reads from environment variables.

"""

import os
from dotenv import load_dotenv

load_dotenv()  # loads .env file if present, no-op otherwise

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "ecommerce_analysis")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "surya123")

SQLALCHEMY_URL = (
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# Path to raw Olist CSVs (downloaded from Kaggle, placed here)
RAW_DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data", "raw")
