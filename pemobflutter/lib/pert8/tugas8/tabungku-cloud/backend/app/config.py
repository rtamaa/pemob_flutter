from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Konfigurasi database dari environment variable."""

    database_url: str = (
        "mysql+pymysql://tabungku:rahasia_tabungku@db:3306/tabungku"
    )


settings = Settings()