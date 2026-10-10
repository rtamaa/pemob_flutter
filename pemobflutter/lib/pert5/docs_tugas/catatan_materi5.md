# Ringkasan Modul Praktikum Flutter Fundamental

## Pertemuan 5: Penyimpanan Lokal (SharedPreferences dan SQLite)

**Durasi:** 150 menit  
**Level:** Menengah  
**Prasyarat:** Pertemuan 1–4 (Form, Navigasi, Async, dan FutureBuilder)

## 1. Tujuan Pembelajaran

Setelah mengikuti praktikum ini, mahasiswa diharapkan mampu:

1. Memilih jenis penyimpanan lokal yang sesuai dengan kebutuhan aplikasi.
2. Menyimpan dan membaca pengaturan sederhana menggunakan `shared_preferences`.
3. Membuat database SQLite dan merancang tabel menggunakan `sqflite`.
4. Mengimplementasikan CRUD (Create, Read, Update, Delete) dan menghubungkannya dengan tampilan aplikasi.
5. Memastikan data tetap tersimpan meskipun aplikasi ditutup dan dibuka kembali.

## 2. Alat dan Bahan

- Flutter SDK.
- Visual Studio Code atau editor lainnya.
- Emulator atau perangkat Android.
- Koneksi internet untuk mengunduh paket Flutter.
- Proyek Flutter baru bernama `praktikum_5`.

Perintah untuk membuat proyek:

```bash
flutter create praktikum_5
cd praktikum_5
```

## 3. Materi Utama

### A. Pengertian Penyimpanan Lokal

Data yang disimpan di dalam variabel atau `State` biasanya akan hilang ketika aplikasi ditutup. Agar data tetap tersedia setelah aplikasi dibuka kembali, data perlu disimpan ke penyimpanan lokal perangkat. Proses ini disebut **persistence**.

Flutter menyediakan beberapa pilihan penyimpanan lokal sesuai jenis data yang digunakan.

| Jenis Penyimpanan | Kegunaan | Paket |
|---|---|---|
| Key-value | Menyimpan pengaturan kecil seperti nama, tema, dan status login | `shared_preferences` |
| Database SQLite | Menyimpan data terstruktur seperti catatan dan transaksi | `sqflite`, `path` |
| Berkas | Menyimpan dokumen, gambar, dan hasil ekspor data | `path_provider`, `dart:io` |

### B. SharedPreferences

`shared_preferences` digunakan untuk menyimpan data sederhana dalam bentuk pasangan kunci dan nilai (*key-value*). Paket ini cocok untuk menyimpan pengaturan aplikasi, bukan untuk mengelola data dalam jumlah besar atau data yang membutuhkan relasi antartabel.

Pasang paket dengan perintah:

```bash
flutter pub add shared_preferences
```

Contoh penggunaan:

```dart
final prefs = await SharedPreferences.getInstance();

// Menyimpan data
await prefs.setString('nama', 'Septiara');
await prefs.setBool('gelap', true);
await prefs.setInt('bukaKe', 1);

// Membaca data
String nama = prefs.getString('nama') ?? '';
bool gelap = prefs.getBool('gelap') ?? false;
int bukaKe = prefs.getInt('bukaKe') ?? 0;
```

**Keterangan:**

- `setString()` menyimpan data teks.
- `setBool()` menyimpan nilai benar atau salah.
- `setInt()` menyimpan bilangan bulat.
- `getString()`, `getBool()`, dan `getInt()` membaca data berdasarkan tipe datanya.
- `??` memberikan nilai bawaan jika data belum tersedia.

Dalam praktikum, SharedPreferences digunakan untuk menyimpan nama pengguna, pilihan mode gelap, dan jumlah aplikasi dibuka.

### C. SQLite dan sqflite

SQLite adalah database lokal yang digunakan untuk menyimpan data terstruktur di perangkat. Dalam Flutter, paket `sqflite` digunakan untuk menjalankan operasi database SQLite, sedangkan paket `path` membantu menyusun lokasi berkas database.

Pasang paket:

```bash
flutter pub add sqflite path
```

Contoh struktur tabel `catatan`:

| Kolom | Tipe Data | Keterangan |
|---|---|---|
| `id` | INTEGER | Primary key dan bertambah otomatis |
| `judul` | TEXT | Judul catatan, wajib diisi |
| `isi` | TEXT | Isi catatan, wajib diisi |

Contoh SQL untuk membuat tabel:

```sql
CREATE TABLE catatan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  judul TEXT NOT NULL,
  isi TEXT NOT NULL
);
```

`AUTOINCREMENT` membuat ID bertambah otomatis ketika data baru ditambahkan. Oleh karena itu, ID tidak perlu ditentukan secara manual saat membuat catatan baru.

### D. CRUD pada SQLite

CRUD merupakan empat operasi dasar untuk mengelola data dalam database.

| Operasi | Fungsi | Method sqflite |
|---|---|---|
| Create | Menambahkan data | `db.insert()` |
| Read | Membaca data | `db.query()` |
| Update | Memperbarui data | `db.update()` |
| Delete | Menghapus data | `db.delete()` |

Contoh operasi CRUD:

```dart
// Create
await db.insert('catatan', {
  'judul': 'Tugas Flutter',
  'isi': 'Mempelajari SQLite',
});

// Read
final data = await db.query('catatan');

// Update
await db.update(
  'catatan',
  {'judul': 'Tugas Flutter Revisi'},
  where: 'id = ?',
  whereArgs: [1],
);

// Delete
await db.delete(
  'catatan',
  where: 'id = ?',
  whereArgs: [1],
);
```

**Keamanan query:** Gunakan placeholder `?` dan `whereArgs` untuk memasukkan nilai ke dalam query. Cara ini lebih aman daripada menyambungkan teks dari pengguna secara langsung ke SQL karena membantu mencegah SQL injection.

### E. Model Data dan DbHelper

Model digunakan untuk merepresentasikan data dalam bentuk objek. Pada praktikum, model `Catatan` mempunyai atribut `id`, `judul`, dan `isi`.

Kelas `DbHelper` bertugas mengelola koneksi database dan menyediakan fungsi untuk menambah, membaca, mengubah, serta menghapus catatan.

Pembagian tugas ini membuat kode lebih teratur karena logika database tidak perlu ditulis berulang kali di dalam tampilan aplikasi.

Fungsi penting dalam pengelolaan database:

- `getDatabasesPath()` memperoleh lokasi penyimpanan database.
- `openDatabase()` membuka atau membuat database.
- `onCreate` membuat tabel ketika database pertama kali dibuat.
- `onUpgrade` memperbarui struktur database ketika versi database dinaikkan.

### F. Menghubungkan Database dengan UI

Tampilan aplikasi catatan menggunakan `StatefulWidget` karena daftar catatan dapat berubah ketika pengguna menambah, mengubah, atau menghapus data.

`FutureBuilder` digunakan untuk menampilkan hasil pembacaan database yang bersifat asynchronous.

| Kondisi | Tampilan |
|---|---|
| `ConnectionState.waiting` | Menampilkan indikator loading |
| `snapshot.hasError` | Menampilkan pesan kesalahan |
| Data kosong | Menampilkan pesan belum ada catatan |
| Data tersedia | Menampilkan daftar catatan |

Daftar catatan dapat dibuat menggunakan `ListView.builder()`. Setiap catatan ditampilkan menggunakan `ListTile`, dengan judul, isi singkat, dan tombol hapus.

Setelah pengguna kembali dari halaman form, daftar perlu dimuat ulang agar perubahan terbaru muncul di layar.

```dart
Future<void> _buka([Catatan? catatan]) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FormCatatanPage(catatan: catatan),
    ),
  );

  if (!mounted) return;

  setState(() {
    _future = DbHelper.semua();
  });
}
```

`mounted` digunakan untuk memastikan widget masih aktif sebelum `setState()` dipanggil setelah proses asynchronous selesai.

### G. Form Tambah dan Ubah Catatan

Satu halaman form dapat digunakan untuk menambahkan dan mengubah catatan.

- Jika objek catatan bernilai `null`, form digunakan untuk menambahkan catatan baru.
- Jika objek catatan tersedia, form menampilkan data lama untuk diubah.
- `TextEditingController` digunakan untuk membaca dan mengatur isi kolom.
- `Form` dan `TextFormField` digunakan untuk membuat serta memvalidasi input.
- `dispose()` digunakan untuk melepaskan controller ketika widget tidak lagi digunakan.

Sebelum data disimpan, validasi dilakukan agar judul dan isi catatan tidak kosong.

Setelah proses penyimpanan selesai, `Navigator.pop(context)` digunakan untuk kembali ke halaman daftar catatan.

### H. Pengujian Persistence

Persistence berarti data tetap tersedia meskipun aplikasi ditutup dan dijalankan kembali.

Pengujian dilakukan dengan langkah berikut:

1. Masukkan nama dan aktifkan mode gelap.
2. Tambahkan beberapa catatan ke database.
3. Hentikan aplikasi sepenuhnya menggunakan tombol Stop.
4. Jalankan aplikasi kembali.
5. Periksa apakah nama, mode gelap, dan seluruh catatan masih tersedia.

Jika data tetap ada, berarti penyimpanan lokal telah berjalan sesuai harapan.

## 4. Latihan Mandiri

1. Tambahkan `AlertDialog` untuk meminta konfirmasi sebelum catatan dihapus.
2. Tambahkan fitur pencarian berdasarkan judul menggunakan query `LIKE`.
3. Tambahkan kolom tanggal dibuat pada tabel catatan. Naikkan versi database menjadi `2` dan gunakan `onUpgrade` untuk menambahkan kolom tersebut.
4. Simpan pilihan urutan catatan, terbaru atau terlama, menggunakan SharedPreferences.

Contoh query pencarian:

```dart
final data = await db.query(
  'catatan',
  where: 'judul LIKE ?',
  whereArgs: ['%$kata%'],
);
```

## 5. Tugas Praktikum: Aplikasi Pencatat Pengeluaran

Buat aplikasi pencatat pengeluaran menggunakan Flutter dengan ketentuan berikut:

1. Membuat tabel `pengeluaran` dengan kolom `id`, `nama`, `jumlah`, `kategori`, dan `tanggal`.
2. Mengimplementasikan CRUD lengkap untuk menambah, membaca, mengubah, dan menghapus pengeluaran.
3. Menambahkan validasi form: nama wajib diisi, jumlah harus berupa angka lebih dari nol, dan kategori dipilih melalui dropdown.
4. Menampilkan total pengeluaran pada halaman utama.
5. Menyimpan minimal satu pengaturan menggunakan SharedPreferences, misalnya mode gelap atau kategori filter terakhir.
6. Memastikan data pengeluaran tetap tersedia setelah aplikasi ditutup dan dibuka kembali.

**Berkas yang dikumpulkan:**

- Tangkapan layar halaman daftar pengeluaran.
- Tangkapan layar form tambah atau ubah pengeluaran.
- Bukti data tetap tersimpan setelah aplikasi dijalankan ulang.
- Berkas kode program atau tautan repositori.

## 7. Pertanyaan Refleksi

**1. Mengapa SharedPreferences kurang cocok untuk menyimpan ratusan catatan? Apa pilihan yang lebih baik?**

SharedPreferences lebih cocok untuk data sederhana berupa pasangan kunci dan nilai. Untuk ratusan catatan yang memiliki banyak kolom dan membutuhkan operasi CRUD serta pencarian, SQLite dengan `sqflite` lebih tepat.

**2. Mengapa query menggunakan placeholder `?` dan `whereArgs`?**

Placeholder membantu memisahkan perintah SQL dari nilai input pengguna sehingga query lebih aman dan mengurangi risiko SQL injection.

**3. Mengapa daftar perlu dimuat ulang setelah kembali dari halaman form? Bagaimana caranya?**

Daftar perlu dimuat ulang agar perubahan data terbaru muncul di halaman utama. Pada praktikum, fungsi `_muat()` dipanggil setelah `Navigator.push()` selesai, kemudian `setState()` memperbarui Future yang digunakan oleh `FutureBuilder`.

**4. Apa fungsi `onCreate` dan `onUpgrade`, dan kapan masing-masing dijalankan?**

`onCreate` dijalankan ketika database pertama kali dibuat untuk membuat tabel awal. `onUpgrade` dijalankan ketika versi database dinaikkan sehingga struktur database dapat diperbarui tanpa harus selalu membuat database baru.

## 8. Troubleshooting Umum

| Masalah | Penyebab atau Solusi |
|---|---|
| `MissingPluginException` | Hentikan aplikasi sepenuhnya, lalu jalankan kembali menggunakan `flutter run`. |
| Data baru tidak muncul | Pastikan fungsi pemuatan ulang daftar dipanggil setelah tambah, ubah, atau hapus data. |
| `no such table` | Periksa proses pembuatan tabel pada `onCreate`. |
| `no such column` | Periksa skema tabel dan pastikan perubahan versi database ditangani melalui `onUpgrade`. |
| Data bernilai `null` saat pertama kali dibaca | Gunakan nilai bawaan, misalnya `prefs.getString('nama') ?? ''`. |
| Peringatan `use_build_context_synchronously` | Periksa `mounted` setelah `await` sebelum menggunakan `context` atau memperbarui state. |
| SQLite tidak berjalan di web atau desktop | Gunakan emulator Android atau perangkat iOS yang didukung. Untuk desktop, pertimbangkan `sqflite_common_ffi`. |

## 10. Kesimpulan

Penyimpanan lokal memungkinkan aplikasi Flutter menyimpan data agar tidak hilang ketika aplikasi ditutup. SharedPreferences cocok untuk menyimpan pengaturan sederhana, sedangkan SQLite dengan sqflite cocok untuk data terstruktur yang membutuhkan CRUD. Dengan menghubungkan database ke UI, melakukan validasi form, dan menguji persistence, aplikasi dapat mengelola data secara lebih teratur dan tetap menyimpan perubahan pengguna.