# Ringkasan Modul Praktikum Flutter Fundamental
## Pertemuan 7: Mini Proyek Terpadu — TabungKu (To-Do List + Manajemen Keuangan)

### Tujuan Praktikum

Praktikum ini bertujuan agar mahasiswa mampu:

- Menganalisis kebutuhan, aturan bisnis, struktur data, dan tampilan aplikasi sebelum melakukan pengembangan.
- Menggabungkan widget, layout, form, validasi, state, SQLite, `shared_preferences`, tema, routing, navigasi, dan animasi dalam satu aplikasi.
- Membuat aplikasi daftar kegiatan yang dapat terhubung dengan pencatatan pemasukan dan pengeluaran.
- Membuat CRUD untuk data kegiatan menggunakan SQLite.
- Menggunakan query `COUNT`, `SUM`, `GROUP BY`, dan `COALESCE` untuk membuat ringkasan dan laporan keuangan.
- Membuat target tabungan harian dan progress pencapaiannya.
- Membuat pengaturan mode gelap, warna tema, dan target tabungan yang tetap tersimpan setelah aplikasi ditutup.
- Menggunakan `NavigationBar` dan named routes untuk mengatur navigasi aplikasi.
- Menjaga data antarhalaman tetap sinkron ketika terjadi perubahan.
- Melakukan pengujian, dokumentasi, dan demonstrasi aplikasi.

### Alat dan Bahan

- Flutter SDK.
- Editor kode seperti Visual Studio Code atau Android Studio.
- Emulator Android atau perangkat Android.
- Proyek Flutter dari praktikum sebelumnya.
- Paket `sqflite` untuk database SQLite.
- Paket `path` untuk menentukan lokasi database.
- Paket `shared_preferences` untuk menyimpan pengaturan aplikasi.

### Materi Utama

#### 1. Konsep Aplikasi TabungKu

TabungKu merupakan mini proyek yang menggabungkan **To-Do List** dengan **manajemen keuangan sederhana**. Pengguna dapat mencatat kegiatan sehari-hari sekaligus mencatat pemasukan atau pengeluaran yang berhubungan dengan kegiatan tersebut.

Setiap kegiatan memiliki informasi:

- Nama kegiatan.
- Tanggal.
- Status selesai atau belum selesai.
- Jenis kegiatan.
- Nominal.
- Kategori pengeluaran.

Jenis kegiatan terdiri dari:

- **Tanpa uang** — kegiatan tidak berhubungan dengan uang.
- **Pemasukan** — kegiatan menghasilkan uang.
- **Pengeluaran** — kegiatan menggunakan uang.

Contohnya, pengguna dapat mencatat kegiatan **Makan siang** sebagai pengeluaran Rp15.000 dengan kategori Makan, kemudian mencatat kegiatan **Freelance** sebagai pemasukan Rp50.000.

Dengan begitu, aplikasi tidak hanya berfungsi sebagai daftar kegiatan, tetapi juga dapat memberikan gambaran kondisi keuangan harian.

#### 2. Aturan Bisnis TabungKu

Aplikasi memiliki beberapa aturan bisnis yang harus diterapkan.

- Setiap kegiatan memiliki nama dan tanggal.
- Setiap kegiatan memiliki status selesai atau belum selesai.
- Jenis kegiatan dapat berupa tanpa uang, pemasukan, atau pengeluaran.
- Nominal harus lebih dari `0` untuk pemasukan dan pengeluaran.
- Kegiatan tanpa uang menggunakan nominal `0`.
- Pengeluaran memiliki kategori.
- Kategori pengeluaran terdiri dari Makan, Transport, Belajar, Hiburan, dan Lainnya.
- Tabungan harian dihitung dari seluruh kegiatan pada tanggal tersebut, baik yang sudah selesai maupun belum selesai.
- Rumus tabungan harian adalah:

**Tabungan = Total Pemasukan − Total Pengeluaran**

- Target tabungan harian secara default adalah **Rp20.000**.
- Target dapat diubah oleh pengguna.
- Target tetap tersimpan setelah aplikasi ditutup.
- Jika tabungan negatif, aplikasi menampilkan peringatan.
- Jika tabungan mencapai target, aplikasi memberikan informasi bahwa target telah tercapai.

Contoh:

| Kegiatan | Jenis | Nominal | Kategori | Status |
| --- | --- | ---: | --- | --- |
| Makan siang | Pengeluaran | Rp15.000 | Makan | Selesai |
| Naik angkot | Pengeluaran | Rp10.000 | Transport | Selesai |
| Freelance | Pemasukan | Rp50.000 | - | Belum selesai |
| Belajar Flutter | Tanpa uang | Rp0 | - | Belum selesai |

Hasil ringkasan:

- Total kegiatan: `4`
- Selesai: `2`
- Pemasukan: `Rp50.000`
- Pengeluaran: `Rp25.000`
- Tabungan: `Rp25.000`
- Target: `Rp20.000`
- Status: target tercapai.

#### 3. Model Data Kegiatan

Class `Kegiatan` digunakan untuk merepresentasikan data kegiatan di dalam aplikasi.

Data yang digunakan adalah:

| Data | Keterangan |
| --- | --- |
| `id` | ID unik kegiatan |
| `judul` | Nama kegiatan |
| `tanggal` | Tanggal kegiatan |
| `selesai` | Status kegiatan |
| `tipe` | Jenis kegiatan |
| `nominal` | Jumlah uang |
| `kategori` | Kategori pengeluaran |

Jenis kegiatan menggunakan enum `Tipe`:

```text
tanpa
pemasukan
pengeluaran
```

Model `Ringkasan` digunakan untuk menyimpan hasil perhitungan seperti jumlah kegiatan, jumlah selesai, total pemasukan, total pengeluaran, dan tabungan.

#### 4. Database SQLite

SQLite digunakan untuk menyimpan data kegiatan secara permanen.

Tabel utama yang digunakan adalah `kegiatan`.

| Kolom | Tipe | Keterangan |
| --- | --- | --- |
| `id` | INTEGER | Primary key, auto increment |
| `judul` | TEXT | Nama kegiatan |
| `tanggal` | TEXT | Format `yyyy-MM-dd` |
| `selesai` | INTEGER | `0` belum selesai, `1` selesai |
| `tipe` | TEXT | `tanpa`, `pemasukan`, `pengeluaran` |
| `nominal` | INTEGER | Nominal dalam rupiah |
| `kategori` | TEXT | Kategori pengeluaran atau `-` |

Data disimpan menggunakan SQLite agar kegiatan tetap tersedia ketika aplikasi ditutup dan dibuka kembali.

Class `DbHelper` digunakan untuk mengatur database dan menyediakan operasi seperti:

- `tambah()` untuk menambahkan kegiatan.
- `pada()` untuk mengambil kegiatan berdasarkan tanggal.
- `ubah()` untuk mengubah kegiatan.
- `hapus()` untuk menghapus kegiatan.
- `ringkasan()` untuk mengambil ringkasan keuangan.
- `pengeluaranPerKategori()` untuk menghitung pengeluaran berdasarkan kategori.

#### 5. CRUD Kegiatan

CRUD digunakan untuk mengelola kegiatan.

| Operasi | Fungsi |
| --- | --- |
| Create | Menambahkan kegiatan |
| Read | Menampilkan kegiatan |
| Update | Mengubah kegiatan |
| Delete | Menghapus kegiatan |

Pada halaman Beranda, pengguna dapat melihat kegiatan hari ini, mengubah status selesai, mengedit kegiatan, dan menghapus kegiatan.

Ketika pengguna menghapus kegiatan, aplikasi menampilkan konfirmasi terlebih dahulu agar data tidak terhapus secara tidak sengaja.

#### 6. Form Tambah dan Edit Kegiatan

Form kegiatan digunakan untuk menambahkan dan mengubah data.

Form berisi:

- Nama kegiatan.
- Tanggal.
- Jenis keuangan.
- Nominal.
- Kategori.

Validasi diterapkan pada form.

Beberapa aturan validasi:

- Nama kegiatan tidak boleh kosong.
- Nominal harus berupa angka.
- Nominal pemasukan harus lebih dari `0`.
- Nominal pengeluaran harus lebih dari `0`.
- Kategori hanya digunakan untuk pengeluaran.
- Nominal tidak ditampilkan untuk kegiatan tanpa uang.

Dengan validasi tersebut, data yang disimpan dapat sesuai dengan aturan bisnis aplikasi.

#### 7. Halaman Hari Ini

Halaman **Hari Ini** digunakan untuk menampilkan daftar kegiatan pada tanggal sekarang.

Fitur yang tersedia meliputi:

- Menampilkan kegiatan hari ini.
- Menandai kegiatan selesai menggunakan checkbox.
- Mengedit kegiatan.
- Menghapus kegiatan.
- Menampilkan ringkasan kegiatan dan keuangan.

Ringkasan menampilkan jumlah kegiatan, jumlah yang selesai, pemasukan, pengeluaran, dan tabungan.

#### 8. Ringkasan Keuangan

Ringkasan digunakan untuk mengetahui kondisi keuangan pada tanggal tertentu.

Informasi yang dihitung adalah:

- Jumlah seluruh kegiatan.
- Jumlah kegiatan selesai.
- Total pemasukan.
- Total pengeluaran.
- Total tabungan.

Query SQLite dapat menggunakan `COUNT`, `SUM`, `CASE WHEN`, dan `COALESCE`.

Contoh konsep query:

```sql
COUNT(*)
SUM(selesai)
SUM(CASE WHEN tipe = 'pemasukan' THEN nominal ELSE 0 END)
SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal ELSE 0 END)
```

`COALESCE` digunakan agar hasil perhitungan tidak menjadi `NULL` ketika tidak terdapat data.

#### 9. Halaman Laporan

Halaman Laporan digunakan untuk melihat kondisi keuangan berdasarkan tanggal yang dipilih.

Fitur laporan meliputi:

- Memilih tanggal menggunakan date picker.
- Melihat jumlah kegiatan.
- Melihat jumlah kegiatan selesai.
- Melihat total pemasukan.
- Melihat total pengeluaran.
- Melihat tabungan.
- Melihat pengeluaran berdasarkan kategori.
- Melihat tabungan selama 7 hari terakhir.

Pengeluaran berdasarkan kategori dapat dihitung menggunakan `GROUP BY`.

Contohnya:

```sql
SELECT kategori, SUM(nominal)
FROM kegiatan
WHERE tanggal = ?
  AND tipe = 'pengeluaran'
GROUP BY kategori
```

Dengan laporan tersebut, pengguna dapat mengetahui kategori pengeluaran yang paling banyak digunakan.

#### 10. Format Tanggal

Tanggal kegiatan disimpan dengan format:

```text
yyyy-MM-dd
```

Contoh:

```text
2026-10-24
```

Format ini digunakan karena lebih mudah untuk melakukan perbandingan dan pengurutan tanggal di database dibandingkan format tampilan seperti `dd/MM/yyyy`.

Format tampilan tanggal dapat dibuat berbeda dari format penyimpanan sehingga pengguna tetap mendapatkan tampilan tanggal yang lebih mudah dibaca.

#### 11. Target Tabungan dan Progress

TabungKu memiliki target tabungan harian dengan nilai awal:

**Rp20.000**

Pengguna dapat mengubah target tersebut melalui halaman Pengaturan.

Progress tabungan digunakan untuk menunjukkan seberapa dekat tabungan saat ini dengan target.

Jika:

**Tabungan < Target**

maka target belum tercapai.

Jika:

**Tabungan >= Target**

maka target sudah tercapai dan aplikasi dapat memberikan apresiasi kepada pengguna.

Jika:

**Tabungan < 0**

maka aplikasi memberikan peringatan karena pengeluaran lebih besar daripada pemasukan.

Progress tabungan dapat dibuat menggunakan animasi agar perubahan nilai terlihat lebih menarik.

#### 12. Pengaturan dengan SharedPreferences

`shared_preferences` digunakan untuk menyimpan pengaturan yang sederhana.

Pengaturan yang disimpan meliputi:

- Mode terang atau gelap.
- Warna tema.
- Target tabungan harian.

Dengan `shared_preferences`, pengaturan pengguna tetap tersedia setelah aplikasi ditutup dan dibuka kembali.

Contohnya, jika pengguna mengubah target dari Rp20.000 menjadi Rp30.000, nilai tersebut tidak kembali ke Rp20.000 ketika aplikasi dijalankan kembali.

#### 13. Tema Aplikasi

TabungKu menyediakan pengaturan tampilan agar pengguna dapat memilih tema aplikasi.

Pengaturan tema dapat mencakup:

- Mode terang.
- Mode gelap.
- Warna tema.

`ThemeData` digunakan untuk menentukan tampilan aplikasi, sedangkan `ThemeMode` digunakan untuk mengatur mode tema.

Pengaturan tema sebaiknya diambil melalui `Theme.of(context)` agar widget mengikuti tema aktif dan tidak menggunakan warna manual yang tidak menyesuaikan tema.

#### 14. NavigationBar dan Named Routes

Aplikasi menggunakan `NavigationBar` untuk navigasi utama.

Terdapat tiga tab utama:

1. **Beranda**
2. **Laporan**
3. **Pengaturan**

`NavigationBar` digunakan untuk berpindah antarbagian utama aplikasi.

Named route digunakan untuk membuka halaman form kegiatan. Dengan named route, halaman tambah atau edit kegiatan dapat dipanggil berdasarkan nama rute yang telah ditentukan.

Struktur ini membuat navigasi aplikasi lebih terorganisasi.

#### 15. Penyegaran Data Antarhalaman

Karena data kegiatan digunakan oleh beberapa halaman, perubahan data harus dapat diketahui oleh halaman lainnya.

Modul menggunakan `ValueNotifier<int> versiData` sebagai penanda perubahan data.

Ketika kegiatan ditambah, diubah, atau dihapus, nilai `versiData` dinaikkan.

Halaman yang membutuhkan data dapat memasang listener:

```dart
versiData.addListener(_muat);
```

Kemudian listener dilepas ketika halaman dihancurkan:

```dart
versiData.removeListener(_muat);
```

Pola ini membuat halaman dapat memuat ulang data setelah terjadi perubahan.

Jika `removeListener()` tidak dilakukan, listener dapat tetap aktif setelah halaman tidak digunakan sehingga dapat menyebabkan masalah pada aplikasi.

### Fitur Utama TabungKu

Berdasarkan modul, fitur aplikasi dibagi menjadi delapan bagian utama:

| Fitur | Keterangan |
| --- | --- |
| F1 | Daftar kegiatan hari ini, checkbox, edit, dan hapus |
| F2 | Form tambah/edit dan validasi |
| F3 | Penyimpanan data menggunakan SQLite |
| F4 | Ringkasan kegiatan dan keuangan |
| F5 | Laporan berdasarkan tanggal, kategori, dan 7 hari terakhir |
| F6 | Target tabungan dan animated progress |
| F7 | Pengaturan dark mode, warna tema, dan target |
| F8 | NavigationBar dan named route |

### Tahapan Pengembangan

Pengembangan aplikasi dilakukan secara bertahap.

#### Tahap 1 – Analisis dan Rancangan

Menganalisis kebutuhan, aturan bisnis, tampilan, struktur data, dan tabel database.

#### Tahap 2 – Model dan Database

Membuat model `Kegiatan`, enum `Tipe`, model `Ringkasan`, serta `DbHelper` untuk SQLite.

#### Tahap 3 – Halaman Hari Ini

Membuat daftar kegiatan, checkbox selesai, edit, dan hapus.

#### Tahap 4 – Form Kegiatan

Membuat form tambah/edit serta validasi input.

#### Tahap 5 – Ringkasan dan Laporan

Membuat query `COUNT`, `SUM`, `GROUP BY`, dan laporan keuangan.

#### Tahap 6 – Pengaturan dan Navigasi

Menambahkan target tabungan, tema, `NavigationBar`, named routes, dan progress.

#### Tahap 7 – Pengujian dan Dokumentasi

Melakukan pengujian fitur, memperbaiki kode, membuat README, mengambil screenshot, dan menyiapkan demonstrasi aplikasi.

### Pengujian Aplikasi

Beberapa pengujian yang dilakukan pada aplikasi TabungKu:

| No | Pengujian | Hasil yang Diharapkan |
| --- | --- | --- |
| 1 | Menambah kegiatan tanpa uang | Kegiatan muncul dan ringkasan keuangan tidak berubah |
| 2 | Menambah pemasukan Rp50.000 | Pemasukan dan tabungan bertambah |
| 3 | Menambah pengeluaran Rp15.000 kategori Makan | Pengeluaran bertambah dan kategori muncul pada laporan |
| 4 | Mengosongkan nama atau memasukkan nominal `0` | Muncul pesan validasi dan data tidak disimpan |
| 5 | Menyelesaikan dua kegiatan | Status berubah dan jumlah selesai bertambah |
| 6 | Mengedit nominal kegiatan | Ringkasan dan laporan ikut berubah |
| 7 | Membatalkan lalu menghapus kegiatan | Pembatalan mempertahankan data, penghapusan menghilangkan data |
| 8 | Menambahkan kegiatan pada tanggal sebelumnya | Tidak muncul di Hari Ini tetapi muncul pada laporan |
| 9 | Mengubah tema dan target kemudian restart | Pengaturan tetap tersimpan |
| 10 | Pengeluaran lebih besar dari pemasukan | Tabungan negatif dan peringatan ditampilkan |

### Latihan Pengembangan Lanjutan

Modul menyediakan beberapa pilihan pengembangan lanjutan. Minimal dua fitur dapat dipilih untuk dikembangkan.

Beberapa contohnya:

- **Plan vs Actual:** menghitung target berdasarkan kegiatan yang sudah selesai.
- **Laporan bulanan:** menampilkan laporan dan grafik berdasarkan bulan.
- **Search/Filter:** mencari kegiatan berdasarkan nama, tipe, atau kategori.
- **Custom Category:** memungkinkan pengguna membuat kategori sendiri dengan pengembangan database.
- **Motivational Quote API:** menampilkan kutipan motivasi dari API.
- **Recurring Activities:** membuat kegiatan yang berulang secara otomatis.
- **Export Report:** menyalin atau mengekspor laporan dalam bentuk teks.

### Pertanyaan Refleksi

**1. Mengapa tanggal disimpan menggunakan `yyyy-MM-dd` dibandingkan `dd/MM/yyyy`?**

Format `yyyy-MM-dd` lebih mudah digunakan untuk pengurutan dan perbandingan tanggal di database. Urutan tahun, bulan, dan hari juga membuat data lebih mudah diproses secara konsisten.

**2. Mengapa `SUM` dilakukan di database dibandingkan di Dart? Kapan cara sebaliknya lebih baik?**

`SUM` di database membuat perhitungan dapat dilakukan langsung pada data yang tersimpan sehingga aplikasi tidak perlu mengambil seluruh data terlebih dahulu. Perhitungan di Dart lebih cocok jika data yang dibutuhkan sudah tersedia di aplikasi atau jumlah datanya sedikit.

**3. Bagaimana cara menjaga tiga tab tetap sinkron? Apa risikonya jika `removeListener()` dilupakan?**

Tiga tab dapat tetap sinkron dengan menggunakan `ValueNotifier` sebagai pemberi informasi ketika data berubah. Jika `removeListener()` dilupakan, listener dapat tetap aktif walaupun halaman sudah tidak digunakan dan dapat menyebabkan masalah seperti penggunaan sumber daya yang tidak diperlukan atau pemanggilan `setState()` pada widget yang sudah tidak aktif.

**4. Apa dampaknya jika perhitungan hanya menghitung kegiatan yang sudah selesai dibandingkan semua kegiatan?**

Jika hanya kegiatan selesai yang dihitung, transaksi dari kegiatan yang belum selesai tidak akan masuk dalam perhitungan keuangan. Modul TabungKu memilih untuk menghitung semua kegiatan pada tanggal tersebut agar kondisi keuangan harian mencakup seluruh transaksi yang dicatat.

**5. Bagian mana yang paling sulit dan apa yang akan diubah jika mengerjakan proyek ini kembali?**

Bagian yang cukup sulit adalah menggabungkan database, form, laporan, pengaturan, dan sinkronisasi data dalam satu aplikasi. Jika mengerjakan kembali, rancangan database dan alur data akan dibuat lebih awal agar proses pengembangan setiap fitur lebih terstruktur.

### Troubleshooting Umum

| Masalah | Solusi |
| --- | --- |
| Ringkasan tidak berubah | Pastikan `versiData` dinaikkan dan halaman memasang listener. |
| Nilai query menjadi `NULL` | Gunakan `COALESCE` pada query `SUM`. |
| Tabel atau kolom tidak ditemukan | Periksa versi schema database atau hapus data aplikasi untuk membuat database kembali. |
| Nominal masih muncul pada tipe tanpa uang | Sembunyikan field nominal ketika tipe `tanpa` dan simpan nilai `0`. |
| Data antarhalaman tidak diperbarui | Periksa penggunaan `addListener()` dan `removeListener()`. |
| `MissingPluginException` | Hentikan aplikasi sepenuhnya lalu jalankan kembali setelah menambahkan package. |
| Form tertutup keyboard | Gunakan `ListView` agar form dapat di-scroll. |
| Target kembali ke nilai awal | Pastikan target disimpan dan dibaca kembali melalui `shared_preferences`. |
| Animasi progress tidak berjalan | Pastikan nilai progress berubah dan widget animasi memiliki durasi yang sesuai. |

### Kesimpulan

Praktikum ini membahas pembuatan mini proyek Flutter **TabungKu** yang menggabungkan daftar kegiatan dengan manajemen keuangan sederhana. Aplikasi menggunakan SQLite untuk menyimpan kegiatan, `shared_preferences` untuk menyimpan pengaturan, dan `ValueNotifier` untuk menjaga data antarhalaman tetap sinkron.

Materi yang dipelajari meliputi analisis kebutuhan, model data, CRUD, form dan validasi, query `COUNT`, `SUM`, `GROUP BY`, dan `COALESCE`, laporan keuangan, target tabungan, progress, tema, `NavigationBar`, named routes, serta sinkronisasi data.

Melalui mini proyek ini, materi dari pertemuan sebelumnya dapat digabungkan menjadi sebuah aplikasi yang lebih lengkap. TabungKu tidak hanya berfungsi sebagai To-Do List, tetapi juga membantu pengguna mencatat pemasukan, pengeluaran, dan memantau pencapaian target tabungan harian.