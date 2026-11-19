# TabungKu Cloud
### Praktikum dan Tugas Pemrograman Mobile — Pertemuan 8

**Docker Compose dan Kerangka Backend TabungKu Cloud**

TabungKu Cloud merupakan pengembangan aplikasi pencatatan kegiatan dan pengelolaan tabungan berbasis **Flutter** yang diintegrasikan dengan backend **FastAPI**, database **MySQL 8.4**, serta **Docker Compose**.

Pada Pertemuan 8, pengembangan dibagi menjadi dua bagian, yaitu **Praktikum 8** dan **Tugas 8**.

Praktikum 8 berfokus pada pembuatan infrastruktur backend dan integrasi dasar Flutter dengan FastAPI. Sementara itu, Tugas 8 mengembangkan sistem dengan menambahkan Adminer, pemeriksaan koneksi MySQL, pengaturan alamat API, dan monitoring status API serta database secara terpisah.

Antarmuka Flutter juga dikembangkan agar lebih modern, responsif, dan mudah digunakan, tanpa menghilangkan fungsi utama aplikasi TabungKu.

---

## Daftar Isi

1. [Tentang Proyek](#1-tentang-proyek)
2. [Tujuan Pengembangan](#2-tujuan-pengembangan)
3. [Praktikum 8 dan Tugas 8](#3-praktikum-8-dan-tugas-8)
4. [Fitur Utama](#4-fitur-utama)
5. [Teknologi yang Digunakan](#5-teknologi-yang-digunakan)
6. [Arsitektur Sistem](#6-arsitektur-sistem)
7. [Struktur Proyek](#7-struktur-proyek)
8. [Implementasi Praktikum 8](#8-implementasi-praktikum-8)
9. [Implementasi Tugas 8](#9-implementasi-tugas-8)
10. [Konfigurasi Environment](#10-konfigurasi-environment)
11. [Cara Menjalankan Proyek](#11-cara-menjalankan-proyek)
12. [Pengujian Sistem](#12-pengujian-sistem)
13. [Perintah Docker Compose](#13-perintah-docker-compose)
14. [Dokumentasi Screenshot](#14-dokumentasi-screenshot)
15. [Troubleshooting](#15-troubleshooting)
16. [Hasil dan Analisis](#16-hasil-dan-analisis)
17. [Kesimpulan](#17-kesimpulan)

---

## 1. Tentang Proyek

TabungKu Cloud merupakan aplikasi mobile berbasis Flutter yang digunakan untuk mencatat kegiatan harian, mengelola pemasukan dan pengeluaran, serta memantau perkembangan tabungan.

Pada pertemuan sebelumnya, aplikasi menggunakan SQLite sebagai penyimpanan lokal. Pada Pertemuan 8, aplikasi mulai dikembangkan menggunakan arsitektur client-server melalui backend FastAPI dan database MySQL.

Pengembangan ini bertujuan untuk memperkenalkan konsep komunikasi aplikasi mobile dengan REST API, pengelolaan database server, dan penggunaan container Docker.

Komponen utama proyek meliputi:

- **Flutter:** Menyediakan antarmuka aplikasi mobile.
- **SQLite:** Menyimpan kegiatan dan transaksi secara lokal.
- **FastAPI:** Menangani permintaan HTTP dan pemeriksaan kesehatan layanan.
- **MySQL 8.4:** Database server yang digunakan oleh backend.
- **Adminer:** Antarmuka berbasis web untuk mengakses database.
- **Docker Compose:** Menjalankan dan mengelola layanan backend.

Pada Pertemuan 8, Flutter berkomunikasi dengan FastAPI melalui endpoint `/health`. Penyimpanan kegiatan masih dilakukan menggunakan SQLite, sedangkan integrasi CRUD melalui backend menjadi pengembangan pada pertemuan berikutnya.

---

## 2. Tujuan Pengembangan

Tujuan pengembangan Praktikum dan Tugas Pertemuan 8 meliputi:

1. Memahami konsep image, container, volume, dan network pada Docker.
2. Menggunakan Dockerfile untuk membangun image backend Python.
3. Mengimplementasikan Docker Compose untuk menjalankan beberapa layanan.
4. Membuat backend menggunakan FastAPI.
5. Menghubungkan FastAPI dengan database MySQL.
6. Mengimplementasikan endpoint REST API `/health`.
7. Menghubungkan aplikasi Flutter dengan backend melalui jaringan lokal.
8. Menambahkan Adminer sebagai antarmuka manajemen database.
9. Membedakan kondisi API aktif dan database tidak terhubung.
10. Menangani HTTP 200, HTTP 503, dan kesalahan koneksi jaringan.
11. Melakukan pengujian menggunakan Swagger UI, PowerShell, dan emulator Android.
12. Mendokumentasikan hasil praktikum dan tugas.

---

## 3. Praktikum 8 dan Tugas 8

### 3.1. Praktikum 8

Praktikum 8 berfokus pada pembuatan dasar arsitektur TabungKu Cloud.

Kegiatan yang dilakukan meliputi:

- Menyiapkan proyek Flutter dan backend FastAPI.
- Membuat Dockerfile untuk backend.
- Mengonfigurasi Docker Compose dan MySQL.
- Menggunakan environment variable.
- Membuat endpoint `/health`.
- Menghubungkan aplikasi Flutter dengan FastAPI.
- Mengembangkan halaman monitoring Status Server.
- Menguji koneksi menggunakan HTTP dan MockClient.

### 3.2. Tugas 8

Tugas 8 merupakan pengembangan dari Praktikum 8 dengan fitur tambahan:

- Penambahan layanan Adminer.
- Pemeriksaan koneksi database menggunakan FastAPI.
- Pengambilan versi MySQL melalui query database.
- Penanganan HTTP 503 saat MySQL mengalami gangguan.
- Monitoring status API dan MySQL secara terpisah.
- Pengaturan alamat API melalui aplikasi Flutter.
- Pengujian beberapa kondisi respons menggunakan MockClient.
- Dokumentasi hasil pengujian Connected dan Disconnected.

### 3.3. Perbandingan Praktikum dan Tugas

| Komponen | Praktikum 8 | Tugas 8 |
|---|---|---|
| Flutter | Aplikasi TabungKu | Pengembangan aplikasi |
| FastAPI | Endpoint dasar | Pemeriksaan database |
| MySQL | Container database | Health check database |
| Docker Compose | Backend dan MySQL | Backend, MySQL, Adminer |
| Adminer | Tidak diwajibkan | Ditambahkan |
| HTTP 200 | Server aktif | API dan MySQL sehat |
| HTTP 503 | Bukan fokus utama | Database bermasalah |
| Status Server | Monitoring API | Monitoring API dan MySQL |
| Pengaturan URL | `--dart-define` | Pengaturan dalam aplikasi |
| Unit Test | MockClient dasar | MockClient beberapa skenario |

---

## 4. Fitur Utama

### 4.1. Dashboard Beranda

Halaman Beranda menampilkan ringkasan kegiatan harian, jumlah kegiatan selesai, total pemasukan, total pengeluaran, dan tabungan.

Pengguna juga dapat melihat aktivitas yang telah dicatat.

### 4.2. Pengelolaan Kegiatan

Pengguna dapat menambahkan, mengubah, menghapus, dan menandai kegiatan sebagai selesai.

Data kegiatan terdiri dari judul, tanggal, jenis transaksi, nominal, kategori, dan status penyelesaian.

### 4.3. Laporan Keuangan

Halaman Laporan menampilkan informasi pemasukan, pengeluaran, tabungan, serta pengeluaran berdasarkan kategori.

Data laporan diambil dari penyimpanan SQLite lokal.

### 4.4. Pengaturan Aplikasi

Pengguna dapat mengatur target tabungan, mode gelap, warna tema, dan mengakses halaman monitoring server.

Pada Tugas 8, konfigurasi alamat backend juga menjadi bagian dari pengembangan pengaturan aplikasi.

### 4.5. Monitoring Server

Halaman Status Server digunakan untuk memeriksa kondisi koneksi backend.

Pada Tugas 8, status FastAPI dan MySQL ditampilkan secara terpisah sehingga pengguna dapat mengetahui sumber gangguan layanan.

### 4.6. Adminer

Adminer digunakan untuk melihat dan mengelola database MySQL melalui browser.

### 4.7. Docker Compose

Backend FastAPI, MySQL, dan Adminer dijalankan melalui Docker Compose agar pengelolaan layanan lebih mudah dan terstruktur.

---

## 5. Teknologi yang Digunakan

| Teknologi | Fungsi |
|---|---|
| Flutter | Framework aplikasi mobile |
| Dart | Bahasa pemrograman Flutter |
| SQLite | Database lokal kegiatan |
| SharedPreferences | Penyimpanan pengaturan aplikasi |
| HTTP | Komunikasi Flutter dengan FastAPI |
| Python 3.12 | Bahasa pemrograman backend |
| FastAPI | Framework REST API |
| Uvicorn | Server FastAPI |
| SQLAlchemy | Koneksi dan query database |
| PyMySQL | Driver database MySQL |
| Pydantic Settings | Pengelolaan konfigurasi environment |
| MySQL 8.4 | Database backend |
| Adminer 5 | Antarmuka manajemen database |
| Docker | Containerisasi aplikasi |
| Docker Compose | Pengelolaan beberapa layanan |
| Android Studio | Pengembangan dan pengujian |
| Git dan GitHub | Version control dan dokumentasi |

---

## 6. Arsitektur Sistem

TabungKu Cloud menggunakan arsitektur client-server.

```text
┌─────────────────────────────────────┐
│         FLUTTER MOBILE              │
│                                     │
│  Beranda | Kegiatan | Laporan       │
│  Pengaturan | Status Server         │
│                                     │
│  SQLite + SharedPreferences         │
└─────────────────┬───────────────────┘
                  │
                  │ HTTP GET /health
                  ▼
┌─────────────────────────────────────┐
│          FASTAPI BACKEND            │
│                                     │
│      Python 3.12 + Uvicorn          │
│                                     │
│      Host Port      : 9000          │
│      Container Port : 8000          │
└─────────────────┬───────────────────┘
                  │
                  │ SQLAlchemy
                  │ PyMySQL
                  ▼
┌─────────────────────────────────────┐
│             MYSQL 8.4               │
│                                     │
│      Service        : db            │
│      Host Port      : 3307          │
│      Container Port : 3306          │
└─────────────────────────────────────┘
                  ▲
                  │
          ┌───────┴────────┐
          │    ADMINER 5   │
          │    Port 8081   │
          └────────────────┘
```

### Alur Komunikasi

1. Aplikasi Flutter mengirim HTTP GET ke endpoint `/health`.
2. FastAPI menerima dan memproses permintaan.
3. Backend memeriksa koneksi database MySQL.
4. MySQL mengembalikan hasil pemeriksaan.
5. FastAPI mengirim respons JSON beserta kode HTTP.
6. Flutter membaca respons dan menampilkan status layanan.

Aplikasi Flutter tidak terhubung langsung ke MySQL. Pemeriksaan database dilakukan melalui FastAPI.

---

## 7. Struktur Proyek

Struktur proyek Pertemuan 8:

```text
pert8/
│
├── docs-tugas/
│   └── img/
│       ├── 01.Status Server.png
│       ├── 02.Swagger UI.png
│       ├── 03.Status Server Disconnected.png
│       ├── 04.Adminer.png
│       └── 05.Swagger UI Succes.png
│
├── modul/
│
├── praktikum8/
│   └── tabungku-cloud/
│       ├── backend/
│       │   ├── app/
│       │   │   ├── __init__.py
│       │   │   ├── config.py
│       │   │   ├── database.py
│       │   │   └── main.py
│       │   ├── Dockerfile
│       │   └── requirements.txt
│       │
│       ├── mobile/
│       │   ├── android/
│       │   ├── lib/
│       │   ├── test/
│       │   └── pubspec.yaml
│       │
│       ├── .env.example
│       └── docker-compose.yml
│
├── tugas8/
│   └── tabungku-cloud/
│       ├── backend/
│       │   ├── app/
│       │   │   ├── __init__.py
│       │   │   ├── config.py
│       │   │   ├── database.py
│       │   │   └── main.py
│       │   ├── Dockerfile
│       │   └── requirements.txt
│       │
│       ├── mobile/
│       │   ├── android/
│       │   ├── lib/
│       │   ├── test/
│       │   └── pubspec.yaml
│       │
│       ├── .env.example
│       └── docker-compose.yml
│
└── README.md
```

Direktori `praktikum8/` berisi implementasi praktikum, sedangkan `tugas8/` berisi pengembangan tugas.

Folder `docs-tugas/img/` menyimpan dokumentasi pengujian dalam format PNG.

---

## 8. Implementasi Praktikum 8

### 8.1. Persiapan Proyek

Praktikum dimulai dengan menyiapkan aplikasi Flutter TabungKu dan struktur backend FastAPI.

Proyek Flutter menggunakan dependensi SQLite, HTTP, path, serta SharedPreferences.

### 8.2. Backend FastAPI

Backend menyediakan endpoint dasar:

```http
GET /
GET /health
```

Endpoint `/health` digunakan untuk memastikan server dapat diakses dari aplikasi Flutter.

### 8.3. Dockerfile dan Docker Compose

Dockerfile digunakan untuk membangun backend berbasis Python.

Docker Compose digunakan untuk menjalankan backend dan MySQL dalam container.

Konfigurasi mencakup environment variable, volume database, healthcheck, dan dependensi layanan.

### 8.4. Integrasi Flutter

Aplikasi Flutter mengakses backend melalui HTTP menggunakan alamat emulator:

```text
http://10.0.2.2:9000
```

Alamat tersebut mengarah ke layanan backend pada laptop melalui emulator Android.

### 8.5. Pengembangan Tampilan

Antarmuka Praktikum 8 dikembangkan pada halaman Beranda, Form Kegiatan, Laporan, Pengaturan, navigasi aplikasi, dan Status Server.

Perubahan difokuskan pada tampilan dan kerapian kode tanpa mengubah struktur tabel SQLite maupun fungsi utama kegiatan.

### 8.6. Pengujian Praktikum

Pengujian dilakukan menggunakan Docker Compose, Swagger UI, PowerShell, dan Flutter.

---

## 9. Implementasi Tugas 8

### 9.1. Penambahan Adminer

Layanan Adminer ditambahkan ke Docker Compose dengan port host `8081`.

Adminer digunakan untuk mengakses database MySQL melalui browser.

### 9.2. Pengembangan Health Check

Endpoint `/health` dikembangkan agar dapat memeriksa koneksi database dan menampilkan versi MySQL.

Pemeriksaan versi database dilakukan menggunakan query:

```sql
SELECT VERSION();
```

Ketika database berhasil diakses, backend mengembalikan HTTP 200.

Ketika database tidak dapat dihubungi, backend mengembalikan HTTP 503.

### 9.3. Monitoring API dan Database

Status API dan MySQL ditampilkan secara terpisah pada aplikasi Flutter.

Dengan demikian, sistem dapat membedakan gangguan pada backend dengan gangguan database.

### 9.4. Pengaturan Alamat API

Tugas 8 mencakup pengembangan fitur pengubahan alamat backend dari halaman Pengaturan.

Konfigurasi URL disimpan menggunakan SharedPreferences agar dapat digunakan kembali saat aplikasi dijalankan.

### 9.5. Pengujian HTTP

Pengujian MockClient mencakup respons HTTP 200, HTTP 503, dan respons HTTP lainnya.

### 9.6. Pengujian Emulator

Aplikasi diuji menggunakan Android Emulator Pixel 8 dengan skenario server terhubung dan tidak terhubung.

---

## 10. Konfigurasi Environment

### 10.1. Persyaratan

Sebelum menjalankan proyek, pastikan telah tersedia Docker Desktop, Flutter SDK, Android Studio, Android Emulator, Git, dan browser.

### 10.2. Membuat File Environment

Masuk ke direktori `tabungku-cloud` yang akan dijalankan.

Pada PowerShell, buat file `.env` dari `.env.example`:

```powershell
Copy-Item .env.example .env
```

Sesuaikan konfigurasi database dengan environment lokal.

**Penting:** Jangan mengunggah file `.env` ke GitHub karena dapat berisi username dan password database.

### 10.3. Konfigurasi Port

Konfigurasi Docker yang digunakan dalam pengujian:

| Layanan | Service | Port Host | Port Container |
|---|---|---:|---:|
| FastAPI | `backend` | 9000 | 8000 |
| MySQL | `db` | 3307 | 3306 |
| Adminer | `adminer` | 8081 | 8080 |

Penggunaan port host 9000 mengikuti latihan mandiri modul Pertemuan 8 yang meminta perubahan port API tanpa mengubah port internal container.

---

## ▶️ 11. Cara Menjalankan Proyek

### 11.1. Menjalankan Praktikum 8

Buka terminal PowerShell:

```powershell
cd D:\Flutter\pemobflutter\lib\pert8\praktikum8\tabungku-cloud
```

Jalankan Docker Compose:

```powershell
docker compose up -d --build
docker compose ps
```

Jalankan aplikasi Flutter:

```powershell
cd mobile
flutter pub get
flutter run
```

### 11.2. Menjalankan Tugas 8

Sebelum berpindah, hentikan lingkungan Praktikum 8:

```powershell
cd D:\Flutter\pemobflutter\lib\pert8\praktikum8\tabungku-cloud
docker compose down
```

Kemudian masuk ke direktori Tugas 8:

```powershell
cd D:\Flutter\pemobflutter\lib\pert8\tugas8\tabungku-cloud
```

Jalankan backend:

```powershell
docker compose up -d --build
docker compose ps
```

Jalankan aplikasi mobile:

```powershell
cd mobile
flutter pub get
flutter run
```

Pastikan alamat backend pada emulator menggunakan:

```text
http://10.0.2.2:9000
```

Praktikum 8 dan Tugas 8 menggunakan konfigurasi layanan yang serupa, sehingga sebaiknya tidak menjalankan kedua lingkungan Docker secara bersamaan pada port host yang sama.

### 11.3. Mengakses Layanan

| Layanan | URL |
|---|---|
| FastAPI | http://localhost:9000 |
| Swagger UI | http://localhost:9000/docs |
| Health Check | http://localhost:9000/health |
| Adminer | http://localhost:8081 |

### 11.4. Login Adminer

Gunakan konfigurasi berikut:

| Kolom | Nilai |
|---|---|
| System | MySQL / MariaDB |
| Server | `db` |
| Username | Sesuai `.env` |
| Password | Sesuai `.env` |
| Database | Sesuai `.env` |

---

## 12. Pengujian Sistem

Pengujian dilakukan menggunakan Docker Compose, Swagger UI, terminal PowerShell, serta Android Emulator Pixel 8.

### 12.1. Pengujian Docker Compose

Periksa container:

```powershell
docker compose ps
```

Container yang digunakan:

```text
tabungku-api       backend       Running
tabungku-db        db            Healthy
tabungku-adminer   adminer       Running
```

Hasil pengujian menunjukkan layanan backend, MySQL, dan Adminer dapat berjalan menggunakan Docker Compose.

### 12.2. Pengujian FastAPI dan MySQL Connected

Jalankan:

```powershell
curl.exe -i http://localhost:9000/health
```

Respons normal:

```http
HTTP/1.1 200 OK
```

Contoh respons JSON dari pengujian:

```json
{
  "status": "ok",
  "waktu_server": "2026-11-19T10:08:49",
  "database": "connected",
  "mysql_version": "8.4.13"
}
```

Hasil ini menunjukkan FastAPI berjalan dan berhasil memeriksa database MySQL.

### 12.3. Pengujian Database Disconnected

Hentikan MySQL:

```powershell
docker compose stop db
```

Uji kembali endpoint:

```powershell
curl.exe -i http://localhost:9000/health
```

Hasil pengujian:

```http
HTTP/1.1 503 Service Unavailable
```

Respons menunjukkan status database `error`.

Artinya, FastAPI masih berjalan tetapi MySQL tidak dapat diakses.

Pada halaman monitoring Tugas 8, kondisi ini ditampilkan sebagai API Connected dan Database Disconnected.

### 12.4. Pengujian FastAPI Disconnected

Aktifkan kembali MySQL:

```powershell
docker compose start db
```

Kemudian hentikan backend:

```powershell
docker compose stop backend
```

Pada Android Emulator Pixel 8, buka halaman Status Server dan tekan tombol **Periksa Koneksi Lagi**.

Aplikasi menampilkan kegagalan koneksi:

```text
Connection refused
```

Hal ini menunjukkan bahwa FastAPI tidak dapat dihubungi.

### 12.5. Pengujian Pemulihan Koneksi

Hidupkan kembali layanan:

```powershell
docker compose start backend
docker compose ps
```

Tunggu MySQL menunjukkan status `healthy`.

Setelah itu, ulangi pemeriksaan endpoint `/health` dan halaman Status Server untuk memastikan koneksi kembali normal.

### 12.6. Pengujian Flutter

Masuk ke direktori mobile pada proyek yang diuji:

```powershell
cd mobile
flutter analyze
flutter test
```

Unit test menggunakan MockClient untuk memeriksa respons HTTP tanpa harus mengandalkan server yang sedang berjalan.

Hasil akhir pengujian mengikuti output terminal terbaru sebelum pengumpulan.

### 12.7. Ringkasan Pengujian

| Skenario | Hasil |
|---|---|
| Docker Compose berjalan | Berhasil |
| MySQL berstatus healthy | Berhasil |
| Swagger UI dapat diakses | Berhasil |
| FastAPI dan MySQL aktif | HTTP 200 |
| MySQL dihentikan | HTTP 503 |
| FastAPI dihentikan | Connection refused |
| MySQL dijalankan kembali | Healthy |
| Backend dijalankan kembali | Running |
| Monitoring Flutter | Berfungsi pada emulator Pixel 8 |

---

## 13. Perintah Docker Compose

| Perintah | Keterangan |
|---|---|
| `docker compose up -d` | Menjalankan semua layanan |
| `docker compose up -d --build` | Build dan menjalankan layanan |
| `docker compose ps` | Melihat status container |
| `docker compose stop db` | Menghentikan MySQL |
| `docker compose start db` | Menyalakan kembali MySQL |
| `docker compose stop backend` | Menghentikan FastAPI |
| `docker compose start backend` | Menyalakan kembali FastAPI |
| `docker compose logs backend` | Menampilkan log backend |
| `docker compose logs db` | Menampilkan log MySQL |
| `docker compose restart` | Menjalankan ulang layanan |
| `docker compose down` | Menghapus container dan network |
| `docker compose down -v` | Menghapus container dan volume database |

**Perhatian:** Hindari menjalankan `docker compose down -v` jika ingin mempertahankan data MySQL yang tersimpan pada named volume.

---

## 14. Dokumentasi Screenshot

Dokumentasi hasil Praktikum dan Tugas Pertemuan 8 disimpan pada folder `docs-tugas/img/`.

Screenshot diambil dari pengujian menggunakan Android Studio, Android Emulator Pixel 8, Swagger UI, dan Adminer.

### 14.1. Tampilan Status Server

Halaman Status Server digunakan untuk menampilkan kondisi koneksi FastAPI dan database MySQL dari aplikasi Flutter.

![Status Server](docs-tugas/img/01-Status-Server.png)

*Gambar 1. Tampilan halaman monitoring Status Server pada TabungKu Cloud.*

### 14.2. Dokumentasi Swagger UI

Swagger UI menyediakan dokumentasi interaktif endpoint FastAPI dan memungkinkan pengujian HTTP langsung melalui browser.

![Swagger UI](docs-tugas/img/02-Swagger-UI.png)

*Gambar 2. Dokumentasi endpoint FastAPI menggunakan Swagger UI.*

### 14.3. Status Server Disconnected

Pengujian dilakukan dengan menghentikan layanan melalui Docker Compose, kemudian melakukan pemeriksaan ulang dari aplikasi Flutter.

Aplikasi menampilkan status dan informasi gangguan koneksi sesuai kondisi layanan.

![Status Server Disconnected](docs-tugas/img/03-Status-Server-Disconnected.png)

*Gambar 3. Tampilan halaman Status Server ketika layanan mengalami gangguan.*

### 14.4. Pengelolaan Database dengan Adminer

Adminer digunakan untuk mengakses layanan MySQL melalui browser.

Alamat Adminer:

`http://localhost:8081`

![Adminer MySQL](docs-tugas/img/04-Adminer.png)

*Gambar 4. Antarmuka Adminer untuk pengelolaan database MySQL.*

### 14.5. Hasil Pengujian Swagger UI

Endpoint `/health` digunakan untuk memeriksa koneksi backend dan database. Ketika sistem berjalan normal, endpoint memberikan respons HTTP 200.

![Swagger UI Success](docs-tugas/img/05-Swagger-UI-Succes.png)

*Gambar 5. Dokumentasi hasil pemeriksaan endpoint FastAPI menggunakan Swagger UI.*

### 14.6. Daftar Screenshot

| No. | Nama File | Dokumentasi |
|---|---|---|
| 1 | `01.Status Server.png` | Monitoring Status Server |
| 2 | `02.Swagger UI.png` | Swagger UI FastAPI |
| 3 | `03.Status Server Disconnected.png` | Pengujian gangguan koneksi |
| 4 | `04.Adminer.png` | Pengelolaan database |
| 5 | `05.Swagger UI Succes.png` | Hasil pengujian API |

Seluruh screenshot digunakan sebagai dokumentasi implementasi serta pengujian aplikasi TabungKu Cloud Pertemuan 8.

---

## 15. Troubleshooting

### 15.1. Docker Tidak Berjalan

Pastikan Docker Desktop aktif, kemudian jalankan:

```powershell
docker compose ps
```

Untuk memeriksa log:

```powershell
docker compose logs
```

### 15.2. Backend Tidak Dapat Diakses

Periksa status backend:

```powershell
docker compose logs backend
```

Pastikan port host `9000` tersedia.

### 15.3. MySQL Tidak Terhubung

Periksa:

```powershell
docker compose ps
docker compose logs db
```

Pastikan container MySQL berjalan dan berstatus `healthy`.

### 15.4. Adminer Menampilkan Kesalahan Koneksi

Pastikan container MySQL aktif:

```powershell
docker compose start db
```

Gunakan nama server `db` pada halaman login Adminer.

### 15.5. Flutter Menampilkan Connection Refused

Pastikan backend aktif dan alamat API pada emulator benar:

```text
http://10.0.2.2:9000
```

Uji endpoint menggunakan browser laptop:

```text
http://localhost:9000/health
```

### 15.6. Konflik Port Docker

Jika dua proyek menggunakan port yang sama, hentikan lingkungan Docker yang tidak digunakan sebelum menjalankan lingkungan lainnya.

### 15.7. Emulator Pixel 8 Mengalami Stuck

Gunakan Device Manager pada Android Studio untuk menghentikan emulator dan melakukan Cold Boot.

Hindari Wipe Data jika data aplikasi ingin dipertahankan.

---

## 16. Hasil dan Analisis

### 16.1. Hasil Praktikum 8

Pada Praktikum 8, infrastruktur backend berhasil dijalankan menggunakan Docker Compose. Layanan FastAPI dapat diakses melalui localhost dan Swagger UI, sedangkan MySQL berjalan dengan status `healthy`.

Pengembangan aplikasi Flutter dilakukan dengan memperbarui tampilan halaman utama, formulir kegiatan, laporan, pengaturan, dan monitoring server.

Pada pengujian backend yang telah dikembangkan, endpoint `/health` memberikan HTTP 200 ketika MySQL terhubung dan HTTP 503 ketika database dihentikan. Setelah MySQL dihidupkan kembali, koneksi dapat dipulihkan.

### 16.2. Hasil Tugas 8

Pada Tugas 8, pengembangan berfokus pada pemeriksaan status API dan MySQL secara terpisah, penambahan Adminer, serta penanganan kondisi gangguan database.

Pengujian pada Android Emulator Pixel 8 menunjukkan bahwa aplikasi dapat mendeteksi kondisi FastAPI tidak terhubung dan menampilkan pesan kesalahan koneksi.

Pengujian gangguan MySQL dilakukan dengan menghentikan container database. Backend yang tetap aktif dapat membedakan gangguan database melalui HTTP 503.

### 16.3. Analisis Keseluruhan

Penggunaan Docker Compose membuat pengelolaan FastAPI, MySQL, dan Adminer lebih mudah karena seluruh layanan dapat dijalankan melalui satu konfigurasi.

Mekanisme pemeriksaan kesehatan server membantu membedakan kegagalan API dengan kegagalan database.

Selain itu, integrasi Flutter dengan FastAPI memberikan dasar untuk pengembangan aplikasi berbasis cloud pada pertemuan berikutnya.

---

## 17. Kesimpulan

Berdasarkan implementasi dan pengujian, Praktikum dan Tugas Pertemuan 8 telah menerapkan dasar arsitektur TabungKu Cloud menggunakan Flutter, FastAPI, MySQL, dan Docker Compose.

**Praktikum 8** berfokus pada persiapan infrastruktur backend, pengembangan endpoint API, dan integrasi dasar Flutter dengan server.

**Tugas 8** mengembangkan fitur monitoring database, menambahkan Adminer, serta menerapkan penanganan HTTP 503 untuk membedakan gangguan database dengan gangguan backend.

Pengujian menggunakan localhost, Swagger UI, PowerShell, dan Android Emulator Pixel 8 menunjukkan bahwa sistem dapat mendeteksi kondisi koneksi normal maupun gangguan layanan.

Proyek ini menjadi dasar untuk pengembangan fitur berikutnya, seperti CRUD melalui FastAPI, autentikasi pengguna, dan integrasi penyimpanan data mobile dengan database server.

---

**TabungKu Cloud — Praktikum dan Tugas Pertemuan 8**

*Pemrograman Mobile | Flutter • FastAPI • MySQL • Docker Compose • Adminer*