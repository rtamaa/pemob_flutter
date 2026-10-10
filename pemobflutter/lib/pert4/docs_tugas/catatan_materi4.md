# Ringkasan Modul Praktikum Flutter Fundamental
## Pertemuan 4: Mengambil Data dari REST API (HTTP, Async, dan FutureBuilder)

### Tujuan Praktikum

Praktikum ini bertujuan agar mahasiswa mampu:

- Memahami pemrograman asinkron menggunakan `Future`, `async`, dan `await`.
- Mengambil data dari REST API menggunakan paket `http`.
- Mengubah data JSON menjadi objek Dart menggunakan `fromJson()`.
- Menampilkan data dengan `FutureBuilder` beserta status loading, error, dan data.
- Menangani kegagalan jaringan dan menyediakan tombol coba lagi.

### Alat dan Bahan

- Flutter SDK, editor kode, dan emulator atau perangkat.
- Proyek Flutter baru dengan perintah `flutter create praktikum_4`.
- Koneksi internet untuk mengakses API JSONPlaceholder.
- Paket `http` yang dipasang menggunakan perintah `flutter pub add http`.

### Materi Utama

#### 1. Pemrograman Asinkron

Pemrograman asinkron digunakan untuk menjalankan proses yang membutuhkan waktu, seperti mengambil data dari internet, tanpa membuat tampilan aplikasi membeku.

- `Future`: menampung hasil proses yang akan tersedia kemudian.
- `async`: menandai fungsi yang menjalankan proses asinkron.
- `await`: menunggu hasil proses asinkron tanpa memblokir seluruh UI.
- `Future.delayed()`: memberikan jeda waktu sebelum menghasilkan nilai.

Pada Bagian A, fungsi `ambilSalam()` digunakan untuk menyimulasikan proses selama dua detik. Selama proses berlangsung, aplikasi menampilkan indikator loading, kemudian menampilkan teks setelah proses selesai.

#### 2. REST API, HTTP, dan JSON

REST API memungkinkan aplikasi mengambil data dari server melalui permintaan HTTP. Pada praktikum ini, API JSONPlaceholder digunakan untuk mengambil daftar pengguna melalui endpoint `/users`.

| Konsep | Fungsi |
| --- | --- |
| `http.get(uri)` | Mengirim permintaan untuk mengambil data. |
| `jsonDecode(body)` | Mengubah teks JSON menjadi struktur data Dart. |
| `fromJson()` | Mengubah data `Map` menjadi objek model. |
| Status `200` | Menunjukkan permintaan berhasil. |
| Status `404` | Menunjukkan data atau halaman tidak ditemukan. |
| Status `500` | Menunjukkan terjadi kesalahan pada server. |

Permintaan HTTP juga diberi batas waktu menggunakan `timeout()` agar aplikasi dapat menangani proses yang terlalu lama.

#### 3. Model Data dengan fromJson

Model digunakan untuk menyimpan data API dalam bentuk objek Dart yang lebih terstruktur. Pada praktikum ini, class `Pengguna` memiliki atribut `id`, `name`, `email`, `phone`, dan `website`. Konstruktor `Pengguna.fromJson()` mengambil nilai dari JSON dan memasukkannya ke dalam objek. Dengan model ini, data dapat diakses melalui atribut seperti `p.name` dan `p.email`, sehingga lebih mudah digunakan dalam tampilan aplikasi.

#### 4. Menampilkan Data dengan FutureBuilder

`FutureBuilder` digunakan untuk membangun tampilan berdasarkan status proses asinkron. Pada halaman daftar pengguna, `FutureBuilder` menangani tiga kondisi utama, yaitu loading ketika data sedang diambil, error ketika permintaan gagal, dan data ketika permintaan berhasil. Informasi status, hasil, serta kesalahan dapat diperiksa melalui objek `snapshot`.

| Properti | Fungsi |
| --- | --- |
| `snapshot.connectionState` | Memeriksa status proses, termasuk apakah masih menunggu. |
| `snapshot.hasError` | Memeriksa apakah proses menghasilkan kesalahan. |
| `snapshot.hasData` | Memeriksa apakah data tersedia. |
| `snapshot.data` | Mengambil hasil proses yang berhasil. |
| `snapshot.error` | Mengambil informasi kesalahan. |

Future dibuat di dalam `initState()`, bukan di dalam `build()`, agar permintaan data tidak dijalankan berulang kali setiap kali tampilan dibangun ulang.

#### 5. Daftar Pengguna dan Halaman Detail

Data pengguna ditampilkan menggunakan `ListView.builder`, sedangkan `ListTile` digunakan untuk menampilkan nama dan email pengguna. Setiap pengguna dapat dipilih untuk membuka halaman detail melalui `Navigator.push()`. Halaman detail menampilkan email, nomor telepon, dan situs web pengguna. Tombol refresh pada AppBar menjalankan fungsi `_muatUlang()` untuk mengambil kembali data dari API.

#### 6. Penanganan Error dan Refresh

Aplikasi harus menangani kemungkinan kegagalan saat mengambil data dari internet. Jika permintaan gagal atau server memberikan status selain `200`, fungsi pengambilan data melempar `Exception` yang kemudian dapat ditampilkan melalui `snapshot.error`. Tombol **Coba lagi** digunakan untuk mengulangi permintaan, sedangkan tombol refresh digunakan untuk memuat ulang data.

Pengujian dilakukan dengan mengubah URL menjadi `/userz` untuk menghasilkan error `404` dan mematikan koneksi internet untuk mengamati error jaringan. Setelah itu, URL atau koneksi dikembalikan seperti semula dan permintaan dicoba kembali.

### Latihan Mandiri

1. Menambahkan atribut `username` dan `city` pada model `Pengguna`, kemudian menampilkannya pada halaman detail. Data kota diambil dari JSON bersarang melalui `json['address']['city']`.
2. Membungkus `ListView` dengan `RefreshIndicator` agar pengguna dapat menarik daftar ke bawah untuk memuat ulang data.
3. Menampilkan teks **"Tidak ada data"** apabila daftar pengguna kosong.
4. Menampilkan jumlah pengguna pada AppBar setelah data berhasil dimuat.

### Tugas Praktikum: Aplikasi Daftar Postingan

Buat aplikasi Flutter yang mengambil data postingan dan komentar dari JSONPlaceholder dengan ketentuan berikut:

- Halaman utama menampilkan daftar postingan berupa judul dan potongan isi menggunakan `FutureBuilder`.
- Ketika postingan dipilih, aplikasi membuka halaman detail yang menampilkan isi lengkap dan daftar komentar.
- Data postingan diambil dari endpoint `/posts`, sedangkan komentar diambil dari endpoint `/posts/{id}/comments`.
- Membuat model `Post` dan `Komentar` dengan konstruktor `fromJson()`.
- Memisahkan kode model, layanan pengambilan data, dan UI.
- Menangani loading dan error pada halaman daftar maupun detail, termasuk menyediakan tombol coba lagi.

Pengumpulan tugas berupa tangkapan layar halaman daftar, halaman detail, dan tampilan error, beserta berkas `main.dart` atau tautan repositori.


### Pertanyaan Refleksi

**1. Apa yang terjadi jika Future dibuat di dalam `build()` dan bukan di `initState()`? Mengapa?**

Future dapat dibuat ulang setiap kali `build()` dijalankan sehingga permintaan data bisa berulang dan proses loading dapat terus terjadi. Karena itu, Future sebaiknya disimpan di `initState()` jika tidak perlu dibuat ulang setiap kali tampilan dibangun.

**2. Apa perbedaan `snapshot.hasError` dengan memeriksa `response.statusCode`? Mengapa keduanya diperlukan?**

`response.statusCode` digunakan untuk memeriksa kode status HTTP dari server, misalnya `200` atau `404`. Sementara itu, `snapshot.hasError` digunakan untuk memeriksa apakah proses Future menghasilkan kesalahan. Keduanya diperlukan karena kegagalan dapat berasal dari respons server maupun masalah jaringan atau proses lainnya.

**3. Mengapa data JSON sebaiknya diubah menjadi class model, bukan dipakai langsung sebagai Map?**

Class model membuat data lebih terstruktur, memudahkan akses atribut, dan membantu memisahkan pengolahan data dari tampilan aplikasi. Dengan model, data dapat diakses melalui atribut seperti `pengguna.name` tanpa harus mengambil nilai dari Map berulang kali.

**4. Mengapa UI wajib menyediakan status loading dan error, bukan hanya status data?**

Loading memberi tahu pengguna bahwa aplikasi sedang mengambil data, sedangkan error memberikan informasi ketika permintaan gagal. Dengan begitu, pengguna tidak hanya melihat layar kosong ketika proses berlangsung atau mengalami masalah.

### Troubleshooting Umum

| Masalah | Solusi |
| --- | --- |
| `SocketException` atau `Failed host lookup` | Periksa koneksi internet emulator. Untuk Android, pastikan izin `INTERNET` tersedia di `AndroidManifest.xml`. |
| Paket `http` tidak ditemukan | Jalankan `flutter pub get`, kemudian restart aplikasi, bukan hanya hot reload. |
| Data terus dimuat ulang setiap layar berubah | Pindahkan pembuatan Future ke `initState()`. |
| Error `type 'Null' is not a subtype` | Periksa respons JSON, nama kunci, dan tipe data yang diterima agar sesuai dengan model. |
| API publik lambat atau tidak tersedia | Tunggu dan coba lagi, atau gunakan berkas JSON cadangan dari dosen/asisten. |

### Kesimpulan

Praktikum ini membahas cara mengambil dan menampilkan data dari REST API menggunakan Flutter. `Future`, `async`, dan `await` membantu menjalankan proses asinkron, sedangkan paket `http` digunakan untuk mengirim permintaan ke server. Data JSON diubah menjadi objek melalui `fromJson()`, lalu ditampilkan menggunakan `FutureBuilder`. Penanganan loading, error, refresh, dan halaman detail membuat aplikasi lebih terstruktur serta nyaman digunakan.