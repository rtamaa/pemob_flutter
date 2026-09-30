# Praktikum Flutter Fundamental – Pertemuan 1

## Pengenalan Flutter, dan Aplikasi Pertama

### 1. Tujuan Praktikum

Pada praktikum ini dipelajari dasar-dasar Flutter dan Dart serta cara membuat aplikasi Flutter sederhana.

Tujuan praktikum:

* Mengenal Flutter dan Dart.
* Memahami perbedaan Flutter dengan pengembangan aplikasi native.
* Melakukan instalasi dan pengecekan Flutter.
* Membuat project Flutter pertama.
* Memahami struktur project Flutter.
* Mengenal konsep widget.
* Membuat tampilan sederhana menggunakan Flutter.
* Memahami penggunaan `StatelessWidget` dan `StatefulWidget`.
* Menggunakan fitur Hot Reload.

### 2. Pengenalan Flutter dan Dart

**Flutter** adalah framework dari Google yang digunakan untuk membuat aplikasi pada berbagai platform seperti:

* Android
* iOS
* Web
* Desktop

Flutter memungkinkan pengembang membuat aplikasi dari satu codebase.

**Dart** adalah bahasa pemrograman yang digunakan untuk membuat aplikasi Flutter.

Flutter menggunakan konsep **Widget** sebagai dasar dalam membangun tampilan aplikasi.

### 3. Konsep Dasar Widget

Widget merupakan komponen utama dalam Flutter yang digunakan untuk membuat tampilan aplikasi.

Beberapa widget yang dipelajari:

* `MaterialApp`
* `Scaffold`
* `AppBar`
* `Center`
* `Text`
* `Column`
* `Row`
* `Icon`
* `SizedBox`

Flutter juga memiliki dua jenis widget utama:

**StatelessWidget**

Widget yang tampilannya tidak memiliki perubahan state.

**StatefulWidget**

Widget yang dapat mengalami perubahan state selama aplikasi berjalan.

### 4. Instalasi dan Verifikasi Flutter

Setelah Flutter selesai diinstal, pengecekan dapat dilakukan menggunakan perintah:

```bash
flutter doctor
```

Perintah tersebut digunakan untuk mengetahui apakah terdapat masalah pada instalasi Flutter dan perangkat pendukungnya.

Untuk Android, lisensi dapat diperiksa atau disetujui menggunakan:

```bash
flutter doctor --android-licenses
```

Jika hasil pengecekan menunjukkan tanda centang pada bagian yang dibutuhkan, maka lingkungan Flutter sudah siap digunakan.

### 5. Membuat Project Flutter

Untuk membuat project Flutter baru digunakan perintah:

```bash
flutter create praktikum_1
```

Kemudian masuk ke folder project:

```bash
cd praktikum_1
```

Untuk menjalankan aplikasi:

```bash
flutter run
```

Setelah dijalankan, Flutter akan menampilkan aplikasi contoh berupa aplikasi counter.

### 6. Struktur Project Flutter

Beberapa bagian penting dalam project Flutter yaitu:

```text
praktikum_1/
├── lib/
│   └── main.dart
├── android/
├── ios/
├── test/
└── pubspec.yaml
```

Penjelasan:

* `lib/main.dart` digunakan sebagai tempat utama kode Dart aplikasi.
* `pubspec.yaml` digunakan untuk mengatur informasi project dan dependency.
* `android/` berisi bagian project untuk platform Android.
* `ios/` berisi bagian project untuk platform iOS.
* `test/` digunakan untuk menyimpan file pengujian.

### 7. Membuat Aplikasi Hello Flutter

Tampilan sederhana Flutter dapat dibuat menggunakan beberapa widget.

Struktur widget yang digunakan:

```text
MaterialApp
    |
  Scaffold
    |
  AppBar
    |
  Center
    |
   Text
```

`MaterialApp` digunakan sebagai dasar aplikasi.

`Scaffold` menyediakan struktur dasar halaman.

`AppBar` digunakan untuk membuat bagian atas aplikasi.

`Center` digunakan untuk menempatkan widget di tengah.

`Text` digunakan untuk menampilkan tulisan.

### 8. Menggunakan Column

Widget `Column` digunakan untuk menyusun beberapa widget secara vertikal.

Contohnya dapat digunakan untuk membuat tampilan informasi pengguna yang berisi:

* Icon
* Nama
* NIM

Widget `SizedBox` dapat digunakan untuk memberikan jarak antar-widget.

Contoh struktur:

```text
Column
 ├── Icon
 ├── SizedBox
 ├── Text (Nama)
 └── Text (NIM)
```

### 9. StatefulWidget dan Counter

`StatefulWidget` digunakan ketika tampilan aplikasi membutuhkan perubahan data atau state.

Pada contoh counter, terdapat variabel `_count` yang nilainya dapat berubah.

Perubahan state dilakukan menggunakan:

```dart
setState(() {
  _count++;
});
```

`setState()` digunakan untuk memberi tahu Flutter bahwa terdapat perubahan state sehingga tampilan dapat diperbarui.

### 10. Hot Reload

Hot Reload merupakan fitur Flutter yang memungkinkan perubahan kode ditampilkan dengan cepat tanpa harus menjalankan ulang aplikasi dari awal.

Fitur ini berguna ketika sedang mengembangkan atau memperbaiki tampilan aplikasi.

### 11. Latihan Mandiri

Latihan pada praktikum meliputi:

* Mengubah warna tampilan.
* Menambahkan tombol minus.
* Menambahkan tombol reset.
* Mencegah nilai counter menjadi negatif.

Latihan ini digunakan untuk memahami penggunaan `StatefulWidget` dan perubahan state.

### 12. Tugas Kartu Perkenalan

Tugas pada praktikum adalah membuat **Kartu Perkenalan**.

Informasi yang ditampilkan meliputi:

* Foto atau icon.
* Nama.
* NIM.
* Program studi.
* Hobi.

Widget yang dapat digunakan:

* `Column`
* `Text`
* `Icon`
* `SizedBox`

Contoh struktur:

```text
Column
 ├── Icon / Foto
 ├── Text (Nama)
 ├── Text (NIM)
 ├── Text (Program Studi)
 └── Text (Hobi)
```

### 13. Troubleshooting

Beberapa masalah yang dapat terjadi ketika menggunakan Flutter:

**Flutter tidak dikenali**

Jika perintah `flutter` tidak dapat digunakan, periksa konfigurasi PATH Flutter.

**Masalah Android License**

Gunakan:

```bash
flutter doctor --android-licenses
```

Kemudian ikuti proses persetujuan lisensi.

**Emulator lambat**

Periksa konfigurasi virtualisasi pada komputer dan gunakan emulator dengan spesifikasi yang sesuai.

**Device tidak terdeteksi**

Pastikan perangkat sudah terhubung dan, jika menggunakan Android, USB Debugging sudah diaktifkan.

### 14. Kesimpulan

Pada Pertemuan 1 dipelajari dasar-dasar Flutter dan Dart, mulai dari pengenalan Flutter, instalasi dan verifikasi, pembuatan project pertama, struktur project, hingga konsep widget.

Selain itu, dipelajari penggunaan `StatelessWidget`, `StatefulWidget`, `Column`, `Text`, `Icon`, dan `SizedBox`. Praktikum juga mengenalkan `setState()` untuk mengubah state serta fitur Hot Reload untuk mempercepat proses pengembangan aplikasi.
