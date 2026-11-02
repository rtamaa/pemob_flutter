# 📸 Studio Self-Photo – Prototype Aplikasi Booking Studio Foto

### Ujian Tengah Semester (UTS) – Praktikum Pemrograman Mobile

Repositori ini berisi dokumentasi perancangan antarmuka aplikasi **Studio Self-Photo** sebagai bagian dari tugas Ujian Tengah Semester (UTS) Praktikum Pemrograman Mobile.

Perancangan dilakukan melalui tiga tahap, yaitu **Wireframe, Mockup, dan Prototype** menggunakan Figma. Aplikasi Studio Self-Photo dirancang untuk membantu pelanggan melihat informasi paket foto, memilih jadwal sesi, melakukan pemesanan (*booking*), memantau status pemesanan, serta memberikan review dan kritik atau saran secara lebih mudah dan terstruktur.

Perancangan aplikasi mengacu pada dokumen **Business Requirements Document (BRD)** dan **Product Requirements Document (PRD)** Studio Self-Photo.

---

## Identitas Mahasiswa

| Keterangan | Informasi    |
| --- |--------------|
| Nama | [Septiara Pratama] |
| NIM | [20240801027] |
| Kelas | [CR002]      |
| Mata Kuliah | Praktikum Pemrograman Mobile |
| Program Studi | [Teknik Informatika]      |
| Universitas | [Universitas Esa Unggul] |
| Nama Proyek | Studio Self-Photo |
| Tools | Figma |

---

##Tahapan Perancangan

**1. Wireframe**

Wireframe merupakan rancangan awal aplikasi yang menggambarkan struktur halaman, susunan menu, tombol, formulir, serta alur navigasi menggunakan tampilan sederhana berwarna hitam, putih, dan abu-abu.

Wireframe Studio Self-Photo mencakup halaman utama aplikasi serta berbagai kondisi pendukung, seperti validasi formulir, pemilihan jadwal, status pemesanan, dan pembatalan booking.

**2. Mockup**

Mockup merupakan pengembangan wireframe menjadi desain visual yang lebih detail dengan menggunakan warna utama merah muda (*pink*), putih, serta elemen antarmuka yang konsisten.

Desain Studio Self-Photo menggunakan konsep modern, sederhana, dan ramah pengguna agar pelanggan dapat melakukan pemesanan sesi foto dengan mudah melalui perangkat mobile.

**3. Prototype**

Prototype merupakan simulasi interaktif dari desain aplikasi yang memungkinkan pengguna mencoba perpindahan halaman, memilih paket foto, menentukan jadwal, melihat riwayat booking, serta menjelajahi fitur lainnya melalui tombol yang dihubungkan menggunakan fitur Prototype pada Figma.

Prototype juga mencakup beberapa skenario validasi dan penanganan kesalahan untuk menggambarkan respons aplikasi terhadap kondisi tertentu.

---

## 🔗 Akses Prototype Figma

Prototype interaktif aplikasi Studio Self-Photo dapat diakses melalui tautan berikut:

👉 **https://www.figma.com/design/44PW9iXNWxF7Q8bspMWMlT/Untitled?node-id=0-1&t=xnBaYtd5TARlmOxL-1**

---

## 📋 Fitur dan Halaman Aplikasi

Prototype Studio Self-Photo mencakup beberapa bagian utama:

### 1. Autentikasi Pengguna

- Splash Screen
- Beranda Publik
- Masuk (Login)
- Daftar Akun (Registrasi)
- Validasi Login dan Registrasi
- Beranda Pelanggan setelah Login

### 2. Informasi Studio dan Paket Foto

- Beranda Pelanggan
- Daftar Paket Foto
- Detail Paket Silver
- Detail Paket Gold
- Detail Paket Platinum
- Panduan Booking

Terdapat tiga pilihan paket foto:

| Paket | Harga | Durasi | Fasilitas Paket |
| --- | --- | --- | --- |
| Silver | Rp150.000 | 20 menit | 5 hasil edit terbaik |
| Gold | Rp250.000 | 40 menit | 10 hasil edit + 1 frame |
| Platinum | Rp350.000 | 60 menit | 15 hasil edit + album + 2 frame |

### 3. Booking Sesi Foto

- Pemilihan Tanggal melalui Kalender
- Pemilihan Paket Foto
- Pemilihan Waktu Sesi
- Detail Booking
- Permintaan Khusus (Opsional)
- Konfirmasi Booking
- Booking Berhasil
- Validasi Jadwal yang Tidak Tersedia
- Penanganan Slot yang Sudah Terisi
- Penanganan Slot yang Diblokir untuk Perawatan Studio
- Simulasi Gangguan Koneksi saat Booking

Ruangan studio ditetapkan secara otomatis berdasarkan paket yang dipilih.

### 4. Riwayat Booking dan Pembayaran

- Riwayat Booking Pelanggan
- Filter Semua
- Filter Dikonfirmasi
- Filter Menunggu
- Filter Dibatalkan
- Detail Pemesanan
- Informasi Pembayaran melalui Transfer Bank Manual
- Petunjuk Pengiriman Bukti Transfer melalui WhatsApp Admin
- Konfirmasi Pembatalan Booking
- Riwayat Booking Setelah Dibatalkan
- Informasi Pembatalan yang Tidak Diizinkan

Status pemesanan yang digunakan dalam rancangan meliputi **Draft, Menunggu Pembayaran, Menunggu Konfirmasi Admin, Dikonfirmasi, dan Dibatalkan**.

Pembatalan hanya dapat dilakukan apabila memenuhi ketentuan studio. Booking yang sudah Dikonfirmasi tidak dapat dibatalkan melalui aplikasi pelanggan, dan pembatalan juga dibatasi oleh ketentuan H-1 sebelum jadwal sesi.

### 5. Review dan Kritik & Saran

- Form Review Pengguna
- Pemberian Rating dan Ulasan
- Konfirmasi Pengiriman Review
- Informasi Moderasi Review oleh Admin
- Penanganan Review Kedua pada Booking yang Sama
- Form Kritik & Saran
- Validasi dan Konfirmasi Pengiriman Kritik & Saran

Setiap booking yang memenuhi persyaratan hanya dapat diberikan **satu review**.

### 6. Profil dan Pengaturan Akun

- Profil Saya
- Ubah Data Profil
- Validasi Perubahan Profil
- Ganti Password
- Validasi Password
- Konfirmasi Perubahan Password
- Logout

---

## 🧭 Panduan Penggunaan Prototype

Untuk mencoba prototype aplikasi Studio Self-Photo, ikuti langkah-langkah berikut:

1. **Buka Prototype:** Akses tautan Figma yang tersedia menggunakan browser.
2. **Halaman Awal:** Mulai dari Splash Screen atau Beranda Publik untuk melihat informasi awal Studio Self-Photo.
3. **Autentikasi:** Pilih Login atau Registrasi untuk mencoba alur masuk ke aplikasi.
4. **Beranda Pelanggan:** Setelah simulasi login berhasil, jelajahi informasi studio, paket foto, dan fitur yang tersedia.
5. **Pilih Paket Foto:** Buka Daftar Paket, kemudian pilih Silver, Gold, atau Platinum untuk melihat detail paket.
6. **Booking Sesi Foto:** Pilih tanggal, paket, dan jam yang tersedia. Periksa Detail Booking, kemudian tekan tombol Booking Sekarang.
7. **Booking Berhasil:** Lihat kode booking, jadwal sesi, total pembayaran, serta petunjuk pembayaran manual.
8. **Riwayat Booking:** Buka menu Riwayat untuk melihat pemesanan dan mencoba filter berdasarkan status booking.
9. **Pembatalan Booking:** Coba alur pembatalan pada pemesanan yang memenuhi ketentuan dan lihat tampilan setelah status berubah menjadi Dibatalkan.
10. **Review dan Kritik & Saran:** Jelajahi halaman pemberian review serta formulir masukan pelanggan.
11. **Profil Pengguna:** Buka menu Profil untuk melihat informasi akun, memperbarui profil, dan mencoba fitur Ganti Password.

**Petunjuk Interaksi:** Klik area kosong pada tampilan prototype Figma untuk menampilkan *hotspot highlight* pada tombol atau komponen yang dapat diinteraksikan, apabila fitur tersebut tersedia.

---

## 🛠️ Teknologi dan Tools

- **Figma Design:** Digunakan untuk merancang wireframe, mockup, dan prototype interaktif aplikasi.
- **Figma Agent:** Membantu pembuatan serta penyempurnaan desain dan berbagai kondisi antarmuka.
- **Flutter:** Teknologi yang direncanakan untuk pengembangan aplikasi mobile pelanggan.
- **Laravel REST API:** Teknologi yang direncanakan untuk pengembangan backend dan pengelolaan data aplikasi.
- **GitHub:** Digunakan untuk menyimpan dokumentasi dan tautan hasil perancangan.

---

## 📌 Status Pengembangan

Proyek Studio Self-Photo saat ini berada pada tahap **perancangan antarmuka dan prototype** untuk kebutuhan UTS Praktikum Pemrograman Mobile.

Prototype dibuat untuk menggambarkan alur dan pengalaman pengguna, sehingga beberapa proses masih berupa simulasi, bukan implementasi sistem secara langsung.

Beberapa hal yang perlu diperhatikan:

- Login dan registrasi pada prototype merupakan simulasi antarmuka.
- Ketersediaan jadwal dan pemilihan waktu belum terhubung dengan database nyata.
- Pembayaran menggunakan konsep **transfer bank manual** dan bukti pembayaran dikirim melalui WhatsApp Admin.
- Perubahan status booking dan pembatalan dalam Figma merupakan simulasi alur.
- Pengiriman review, kritik, dan saran belum terhubung dengan layanan backend.
- Penanganan koneksi terputus merupakan simulasi kondisi kesalahan aplikasi.

Pada tahap pengembangan selanjutnya, rancangan ini direncanakan untuk diimplementasikan menggunakan **Flutter** sebagai aplikasi mobile pelanggan dan **Laravel REST API** sebagai backend.

---

## 📄 Dokumentasi

Dokumentasi perancangan Studio Self-Photo mencakup:

- **Wireframe:** Rancangan struktur dan tata letak aplikasi dalam bentuk low-fidelity.
- **Mockup:** Rancangan antarmuka visual dalam bentuk high-fidelity.
- **Prototype:** Simulasi interaktif alur penggunaan aplikasi.
- **BRD (Business Requirements Document):** Dokumen kebutuhan bisnis aplikasi.
- **PRD (Product Requirements Document):** Dokumen kebutuhan produk dan fitur aplikasi.

Dokumentasi wireframe, mockup, dan prototype disiapkan sebagai bagian dari laporan UTS Praktikum Pemrograman Mobile.

**Project:** Studio Self-Photo — Aplikasi Booking Studio Foto

**Tahun:** 2026