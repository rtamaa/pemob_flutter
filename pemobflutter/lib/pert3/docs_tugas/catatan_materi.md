# Ringkasan Modul Praktikum Flutter Fundamental
## Pertemuan 3: Form Input dan State Management

### Tujuan Praktikum
Praktikum ini bertujuan agar mahasiswa mampu:
- Mengambil input pengguna menggunakan `TextField` dan `TextEditingController`.
- Membuat form dengan validasi menggunakan `Form`, `TextFormField`, dropdown, dan checkbox.
- Memahami keterbatasan `setState()` ketika data digunakan oleh banyak halaman.
- Mengelola state menggunakan `ChangeNotifier` dan Provider.
- Membedakan penggunaan `context.watch()` dan `context.read()`.

### Alat dan Bahan
- Flutter SDK, editor kode, dan emulator atau perangkat.
- Proyek Flutter baru dengan perintah `flutter create praktikum_3`.
- Koneksi internet untuk memasang paket Provider.

### Materi Utama

#### 1. Input Dasar dengan TextField
`TextField` digunakan untuk menerima teks dari pengguna. `TextEditingController` membantu membaca teks yang dimasukkan. Pada contoh praktikum, pengguna mengetik nama lalu menekan tombol **Sapa** untuk menampilkan sapaan. `dispose()` digunakan untuk melepaskan controller ketika tidak lagi dipakai.

#### 2. Form dan Validasi
`Form` mengelompokkan beberapa input agar dapat diperiksa bersama. `GlobalKey<FormState>` digunakan untuk menjalankan validasi melalui `validate()`. Setiap `TextFormField` memiliki `validator` yang menampilkan pesan kesalahan jika data belum sesuai.

Contoh form pendaftaran pada modul memuat:
- Nama lengkap yang wajib diisi.
- Email yang harus mengandung tanda `@`.
- Jurusan yang dipilih melalui dropdown.
- Checkbox persetujuan yang harus dicentang sebelum tombol Daftar aktif.

Jika semua data valid, aplikasi menampilkan pesan pendaftaran melalui `SnackBar`.

#### 3. State Management
State adalah data yang dapat berubah dan memengaruhi tampilan aplikasi.
- **State lokal (ephemeral):** digunakan dalam satu widget dan dapat dikelola dengan `setState()`.
- **App state (global):** digunakan oleh banyak widget atau halaman dan dapat dikelola dengan Provider, Riverpod, atau Bloc.

Provider membagikan objek state yang menggunakan `ChangeNotifier`. Ketika data berubah dan `notifyListeners()` dipanggil, widget yang berlangganan akan diperbarui.

| Perintah | Fungsi | Penggunaan |
|---|---|---|
| `context.watch<T>()` | Membaca data dan mengikuti perubahan | Di dalam `build()` |
| `context.read<T>()` | Membaca data tanpa berlangganan perubahan | Di dalam callback, seperti `onPressed` |

#### 4. Aplikasi Daftar Tugas dengan Provider
Modul mengarahkan pembuatan aplikasi daftar tugas dengan fitur:
- Menambahkan tugas.
- Menandai tugas selesai atau belum selesai.
- Menghapus tugas.
- Menampilkan jumlah tugas selesai pada AppBar.

Kelas `Tugas` menyimpan judul dan status tugas. `TugasModel` mengelola daftar melalui fungsi `tambah()`, `toggle()`, dan `hapus()`. Setiap perubahan memanggil `notifyListeners()` agar tampilan ikut diperbarui. Halaman daftar dan halaman tambah menggunakan model yang sama melalui Provider.

### Latihan Mandiri
1. Menambahkan validasi judul tugas minimal tiga karakter.
2. Membuat fungsi dan tombol untuk menghapus semua tugas yang sudah selesai.
3. Menampilkan `SnackBar` “Tugas ditambahkan” setelah tugas disimpan.
4. Menampilkan teks “Belum ada tugas” ketika daftar masih kosong.

### Tugas Praktikum: Aplikasi Daftar Belanja
Buat aplikasi dengan ketentuan:
- Form tambah barang berisi nama barang, jumlah lebih dari nol, dan kategori dropdown. Setiap input harus divalidasi.
- Halaman daftar menampilkan barang, menyediakan penanda “sudah dibeli”, dan fitur hapus.
- Data dikelola dalam satu `ChangeNotifier` dan dibagikan dengan Provider.
- AppBar menampilkan jumlah barang yang belum dibeli.
- Pengumpulan berupa tangkapan layar kedua halaman, termasuk pesan error validasi, serta file `main.dart` atau tautan repositori.

### Pertanyaan Refleksi
1. Mengapa `TextEditingController` perlu di-dispose?
2. Kapan cukup menggunakan `setState()` dan kapan sebaiknya memakai Provider?
3. Apa akibatnya jika `notifyListeners()` tidak dipanggil?
4. Mengapa `context.read()` digunakan di `onPressed`, bukan `context.watch()`?

### Kesimpulan
Modul ini membahas cara menerima dan memvalidasi input serta mengelola data pada aplikasi Flutter. `TextField` dan `Form` digunakan untuk input, sedangkan `setState()` cocok untuk perubahan lokal. Provider dan `ChangeNotifier` membantu membagikan data ke beberapa halaman dan memperbarui tampilan ketika data berubah.
