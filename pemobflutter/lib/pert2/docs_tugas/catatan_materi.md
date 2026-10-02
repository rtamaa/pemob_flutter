# Penjelasan Praktikum Flutter Pertemuan 2
## Layout, ListView, dan Navigasi Antar Halaman

Dokumen ini merangkum dan menjelaskan materi Modul Praktikum Flutter Fundamental Pertemuan 2.

## 1. Tujuan Pembelajaran

- Menyusun layout menggunakan `Container`, `Padding`, `Row`, `Column`, dan `Expanded`.
- Menampilkan daftar data menggunakan `ListView.builder`, `Card`, dan `ListTile`.
- Memodelkan data sederhana menggunakan class Dart.
- Berpindah halaman dan mengirim data menggunakan `Navigator.push` dan `Navigator.pop`.

## 2. Alat dan Bahan

- Flutter SDK.
- Visual Studio Code atau Android Studio.
- Emulator Android atau perangkat fisik dari pertemuan sebelumnya.
- Proyek baru yang dibuat dengan perintah:

```bash
flutter create praktikum_2
```

## 3. Teori Singkat

### 3.1 Widget Layout

| Widget | Fungsi |
|---|---|
| `Container` | Kotak serbaguna untuk mengatur ukuran, warna, border, radius, padding, dan margin. |
| `Padding` | Memberikan jarak di sekeliling widget anak. |
| `Row` | Menyusun widget secara horizontal. |
| `Column` | Menyusun widget secara vertikal. |
| `Expanded` | Membuat anak mengisi sisa ruang pada `Row` atau `Column`. |
| `BoxDecoration` | Mengatur dekorasi seperti warna latar dan sudut membulat. |
| `CircleAvatar` | Menampilkan avatar atau ikon pengguna berbentuk lingkaran. |

Pada `Row`, sumbu utama (*main axis*) adalah horizontal dan sumbu silang (*cross axis*) adalah vertikal. Pada `Column`, sumbu utama adalah vertikal dan sumbu silang adalah horizontal. `mainAxisAlignment` dan `crossAxisAlignment` mengatur perataan pada kedua sumbu tersebut.

### 3.2 Daftar Data

- `ListView.builder` membangun item sesuai kebutuhan tampilan sehingga efisien untuk daftar panjang.
- `itemCount` menentukan jumlah item.
- `itemBuilder` membangun widget untuk item berdasarkan indeks.
- `Card` membungkus satu baris data dengan tampilan kartu.
- `ListTile` menyediakan susunan `leading` (bagian awal), `title` (judul), `subtitle` (subjudul), dan `trailing` (bagian akhir).

### 3.3 Navigasi

Navigasi Flutter mengelola halaman sebagai tumpukan (*stack*). `Navigator.push` menambahkan halaman baru, sedangkan `Navigator.pop` menutup halaman aktif. `MaterialPageRoute` menentukan halaman tujuan dan transisi perpindahannya.

## 4. Langkah Praktikum

### Bagian A: Layout Kartu Profil

**Tujuan:** membuat kartu profil dengan avatar di kiri dan nama serta NIM di kanan. Ganti `[NAMA]` dan `[NIM]` dengan identitas sendiri.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 2',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 32,
                child: Icon(Icons.person, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('[NAMA]', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('[NIM]'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Penjelasan:**

1. `main()` menjalankan aplikasi melalui `MyApp`.
2. `MaterialApp` mengatur tema dan halaman awal aplikasi.
3. `Scaffold` menyediakan kerangka halaman seperti `AppBar` dan area isi.
4. `Padding` memberi jarak di sekeliling kartu.
5. `Container` menjadi wadah kartu, sedangkan `BoxDecoration` mengatur warna dan sudutnya.
6. `Row` meletakkan avatar dan teks secara berdampingan.
7. `CircleAvatar` menampilkan ikon pengguna, sementara `SizedBox` memberi jarak.
8. `Expanded` membuat bagian teks menggunakan sisa lebar yang tersedia.
9. `Column` menyusun nama dan NIM secara vertikal; `crossAxisAlignment.start` membuat teks rata kiri.

**Checkpoint:** kartu profil tampil dengan avatar di kiri dan teks di kanan. Coba hapus `Expanded` dan panjangkan nama untuk mengamati perbedaannya.

### Bagian B: Model Data dan ListView

**Tujuan:** menyimpan data menu sebagai objek dan menampilkannya dalam daftar yang dapat digulir.

```dart
class Makanan {
  final String nama;
  final int harga;
  const Makanan(this.nama, this.harga);
}

const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Menu')),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.restaurant),
              title: Text(item.nama),
              subtitle: Text('Rp ${item.harga}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
```

Pada `MyApp`, ubah halaman awal menjadi `home: const MenuPage()`.

**Penjelasan:**

- `Makanan` adalah class model yang menyimpan properti `nama` dan `harga`.
- `final` menandakan properti tidak dapat ditetapkan ulang setelah diinisialisasi.
- Constructor `Makanan(this.nama, this.harga)` mengisi properti dari parameter.
- `daftarMenu` berisi objek makanan.
- `ListView.builder` membuat item berdasarkan data dan kebutuhan tampilan.
- `itemCount` memakai panjang daftar, sedangkan `itemBuilder` mengambil objek berdasarkan `index`.
- `Card` membungkus setiap baris, dan `ListTile` mengatur ikon, nama, harga, serta ikon panah.

**Checkpoint:** empat menu tampil sebagai kartu yang dapat digulir.

### Bagian C: Navigasi ke Halaman Detail

Tambahkan `onTap` pada `ListTile` agar pilihan menu membuka halaman detail:

```dart
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetailPage(makanan: item),
    ),
  );
},
```

Buat halaman detail yang menerima objek melalui constructor:

```dart
class DetailPage extends StatelessWidget {
  final Makanan makanan;
  const DetailPage({super.key, required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(makanan.nama)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 80),
            const SizedBox(height: 16),
            Text(makanan.nama, style: const TextStyle(fontSize: 24)),
            Text('Rp ${makanan.harga}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan:**

- `onTap` dijalankan saat baris menu diketuk.
- `Navigator.push` membuka halaman baru.
- `MaterialPageRoute` menentukan halaman tujuan.
- `DetailPage(makanan: item)` meneruskan objek yang dipilih.
- `required` mewajibkan argumen `makanan` diberikan.
- Halaman detail membaca nama dan harga dari objek tersebut.
- `Navigator.pop(context)` menutup halaman detail dan kembali ke daftar.

**Checkpoint:** mengetuk menu membuka detail dengan data yang sesuai. Tombol Kembali atau tombol *back* perangkat menutup halaman detail.

## 5. Latihan Mandiri

### 5.1 Menambahkan Tiga Menu

Tambahkan tiga objek berikut ke `daftarMenu`, sehingga totalnya menjadi tujuh menu:

```dart
Makanan('Soto Ayam', 14000),
Makanan('Bakso', 13000),
Makanan('Es Jeruk', 5000),
```

Latihan ini menguji tampilan daftar yang lebih panjang dan kemampuan gulir `ListView.builder`.

### 5.2 Menambahkan Deskripsi

Tambahkan properti `deskripsi` pada model `Makanan` dan tampilkan pada halaman detail.

```dart
class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;
  const Makanan(this.nama, this.harga, this.deskripsi);
}
```

Setiap objek menu perlu diberi deskripsi. Di halaman detail, tampilkan dengan `Text(makanan.deskripsi)`.

### 5.3 Mengganti Card dengan Container

Gunakan `Container` dengan `BoxDecoration` sebagai pembungkus baris:

```dart
Container(
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius: BorderRadius.circular(16),
  ),
  child: ListTile(
    leading: const Icon(Icons.restaurant),
    title: Text(item.nama),
    subtitle: Text(formatRupiah(item.harga)),
    trailing: const Icon(Icons.chevron_right),
  ),
)
```

`margin` mengatur jarak luar, sedangkan `BoxDecoration` mengatur warna latar dan sudut membulat.

### 5.4 Format Harga Rupiah

Fungsi berikut menambahkan pemisah titik setiap tiga digit, misalnya `15000` menjadi `Rp 15.000`.

```dart
String formatRupiah(int angka) {
  final s = angka.toString();
  final buffer = StringBuffer();

  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(s[i]);
  }

  return 'Rp $buffer';
}
```

Fungsi mengubah angka menjadi teks, lalu menyisipkan titik sesuai posisi digit. `StringBuffer` menyusun hasil teks secara bertahap. Gunakan `formatRupiah(item.harga)` pada daftar dan `formatRupiah(makanan.harga)` pada detail.

## 6. Tugas: Aplikasi Daftar Kontak

Buat aplikasi dengan minimal enam kontak. Setiap kontak memiliki nama, nomor telepon, dan email. Data disimpan dalam list objek class. Halaman utama menggunakan `ListView.builder` dan `ListTile`; avatar berisi huruf pertama nama. Ketukan pada kontak membuka halaman detail berisi seluruh data dan tombol kembali.

### 6.1 Model Kontak

```dart
class Kontak {
  final String nama;
  final String telepon;
  final String email;
  const Kontak(this.nama, this.telepon, this.email);
}
```

Class `Kontak` mengelompokkan tiga informasi setiap kontak. Properti `final` tidak dapat ditetapkan ulang setelah objek dibuat.

### 6.2 Avatar Inisial dan Daftar

Contoh avatar:

```dart
CircleAvatar(
  child: Text(kontak.nama[0].toUpperCase()),
)
```

`kontak.nama[0]` mengambil karakter pertama nama dan `toUpperCase()` menjadikannya huruf kapital. Pada `ListTile`, nama dapat ditempatkan sebagai `title`, nomor telepon sebagai `subtitle`, dan ikon panah sebagai `trailing`.

### 6.3 Navigasi dan Halaman Detail

Gunakan `onTap` untuk memanggil `Navigator.push` dan meneruskan objek kontak melalui constructor halaman detail. Di halaman detail, `Column` dapat menyusun informasi secara vertikal dan `Row` menempatkan ikon bersama nomor telepon atau email. Tombol kembali menjalankan:

```dart
onPressed: () => Navigator.pop(context)
```

### 6.4 Berkas yang Dikumpulkan

Modul meminta:
- Screenshot halaman daftar kontak.
- Screenshot halaman detail kontak.
- Berkas `main.dart` atau tautan repositori.

## 7. Pertanyaan Refleksi

### 1. Apa perbedaan ListView biasa dengan ListView.builder?

`ListView` biasa dapat menerima daftar widget anak yang telah disiapkan. `ListView.builder` membangun item melalui `itemBuilder` sesuai kebutuhan tampilan. Karena itu, `ListView.builder` lebih sesuai untuk daftar panjang karena tidak perlu membuat seluruh item sekaligus sejak awal.

### 2. Mengapa Row dengan teks panjang dapat menyebabkan overflow, dan bagaimana Expanded membantu?

`Row` menyusun anak secara horizontal. Jika lebar yang dibutuhkan melebihi ruang yang tersedia, tampilan dapat mengalami overflow. `Expanded` membuat anak menggunakan sisa ruang. Pada teks, batas tersebut memungkinkan teks membungkus ke baris berikutnya alih-alih meluber melewati layar.

### 3. Bagaimana data dikirim dari halaman daftar ke halaman detail?

Data dikirim melalui constructor halaman detail ketika `Navigator.push` membuat route baru. Contohnya, objek menu diberikan melalui `DetailPage(makanan: item)`. Halaman detail menyimpan objek tersebut pada properti `makanan` dan mengakses data yang diperlukan. Pola yang sama digunakan untuk mengirim objek kontak.

## 8. Kesimpulan

Praktikum ini memperkenalkan penyusunan antarmuka Flutter menggunakan widget layout, pengelolaan data sederhana dengan class Dart, dan pembuatan daftar yang dapat digulir. Bagian profil mempraktikkan susunan horizontal dan vertikal serta penggunaan `Expanded`. Bagian daftar menu memperkenalkan model data dan `ListView.builder`. Bagian navigasi menunjukkan cara mengirim data ke halaman detail melalui constructor dengan `Navigator.push`, serta kembali menggunakan `Navigator.pop`. Konsep-konsep tersebut diterapkan kembali dalam latihan menu dan tugas daftar kontak.

