from datetime import datetime

from fastapi import FastAPI, HTTPException
from sqlalchemy import text

from .database import engine

app = FastAPI(
    title="TabungKu API",
    version="0.1.0",
)


@app.get("/")
def beranda():
    return {
        "pesan": "Selamat datang di TabungKu API. Dokumentasi: /docs"
    }


@app.get("/health")
def health():
    waktu = datetime.now().isoformat(timespec="seconds")

    try:
        with engine.connect() as connection:
            versi_mysql = connection.execute(
                text("SELECT VERSION()")
            ).scalar()

        return {
            "status": "ok",
            "waktu_server": waktu,
            "database": "connected",
            "mysql_version": versi_mysql,
        }

    except Exception as e:
        raise HTTPException(
            status_code=503,
            detail={
                "status": "error",
                "waktu_server": waktu,
                "database": "error",
                "pesan": str(e),
            },
        )


@app.get("/info")
def info():
    return {
        "nama_aplikasi": "TabungKu API",
        "versi": "0.1.0",
        "zona_waktu": "Asia/Jakarta",
        "dokumentasi": "/docs",
    }