# Praktikum Flutter Fundamental – Pertemuan 2

## Catatan Materi yang Dipelajari

Pada Pertemuan 2, saya mempelajari cara membuat tampilan aplikasi Flutter yang lebih terstruktur dan interaktif. Materi yang dipelajari meliputi penggunaan **layout**, menampilkan data dalam bentuk daftar menggunakan **ListView**, membuat **model data dengan class Dart**, serta membuat **navigasi antar halaman**.

---

## 1. Layout pada Flutter

Pada pertemuan ini dipelajari beberapa widget yang digunakan untuk mengatur posisi dan tampilan komponen dalam aplikasi.

### Container

`Container` digunakan sebagai kotak untuk membungkus widget.

Container dapat digunakan untuk mengatur:

* Ukuran
* Warna
* Border
* Radius/sudut
* Padding
* Margin

### Padding

`Padding` digunakan untuk memberikan jarak di sekeliling widget.

Contohnya:

```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: Container(...),
)
```

### Row

`Row` digunakan untuk menyusun widget secara **horizontal** atau dari kiri ke kanan.

Contohnya pada kartu profil, avatar berada di sebelah kiri dan informasi nama berada di sebelah kanan.

### Column

`Column` digunakan untuk menyusun widget secara **vertikal** atau dari atas ke bawah.

### Expanded

`Expanded` digunakan agar sebuah widget dapat menggunakan **sisa ruang yang tersedia** di dalam `Row` atau `Column`.

Expanded juga dapat membantu mencegah teks atau widget mengalami overflow ketika ruangnya terbatas.

---

## 2. Memahami Main Axis dan Cross Axis

Pada layout Flutter terdapat dua sumbu utama:

### Row

```text
Main Axis   → Horizontal
Cross Axis  ↓ Vertikal
```

### Column

```text
Main Axis   ↓ Vertikal
Cross Axis  → Horizontal
```

Untuk mengatur posisi widget pada kedua sumbu tersebut digunakan:

```dart
mainAxisAlignment
crossAxisAlignment
```

Jadi, kedua properti tersebut digunakan untuk mengatur **perataan dan posisi widget** pada `Row` maupun `Column`.

---

## 3. Membuat Kartu Profil

Pada praktikum dibuat sebuah halaman **Profil**.

Tampilan tersebut menggunakan beberapa widget:

```text
Padding
   ↓
Container
   ↓
Row
 ┌───────┬──────────────┐
 │Avatar │ Nama dan NIM │
 └───────┴──────────────┘
```

Avatar dibuat menggunakan:

```dart
CircleAvatar
```

Kemudian informasi nama dan NIM diletakkan menggunakan `Column`.

`Expanded` digunakan pada bagian informasi agar teks dapat menyesuaikan ruang yang tersedia.

---

## 4. Membuat Model Data dengan Class Dart

Pada pertemuan ini mulai dipelajari cara membuat **model data sederhana menggunakan class Dart**.

Contohnya dibuat class:

```dart
class Makanan {
  final String nama;
  final int harga;

  const Makanan(this.nama, this.harga);
}
```

Class tersebut digunakan untuk menyimpan data makanan berupa:

* Nama makanan
* Harga makanan

Kemudian dibuat sebuah list:

```dart
const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
];
```

Dari sini dipelajari bahwa data dapat dibuat menjadi objek menggunakan **class**, kemudian beberapa objek tersebut dapat disimpan dalam sebuah `List`.

---

## 5. Menampilkan Data dengan ListView.builder

Untuk menampilkan daftar menu digunakan:

```dart
ListView.builder
```

`ListView.builder` digunakan untuk membuat daftar yang ditampilkan sesuai kebutuhan dan lebih cocok untuk data yang jumlahnya banyak.

Contohnya:

```dart
ListView.builder(
  itemCount: daftarMenu.length,
  itemBuilder: (context, index) {
    final item = daftarMenu[index];

    return Card(
      child: ListTile(
        title: Text(item.nama),
        subtitle: Text('Rp ${item.harga}'),
      ),
    );
  },
)
```

Pada praktikum, `ListView.builder` digunakan untuk menampilkan daftar makanan yang dapat di-scroll.

---

## 6. Menggunakan Card dan ListTile

Selain `ListView.builder`, dipelajari juga:

### Card

`Card` digunakan untuk membuat tampilan seperti kartu sehingga setiap data menu terlihat lebih rapi.

### ListTile

`ListTile` menyediakan struktur baris yang sudah siap digunakan.

Bagian yang digunakan antara lain:

```text
leading
   ↓
Icon

title
   ↓
Nama makanan

subtitle
   ↓
Harga

trailing
   ↓
Icon panah
```

Contohnya:

```dart
ListTile(
  leading: const Icon(Icons.restaurant),
  title: Text(item.nama),
  subtitle: Text('Rp ${item.harga}'),
  trailing: const Icon(Icons.chevron_right),
)
```

---

## 7. Navigasi Antar Halaman

Materi berikutnya adalah membuat aplikasi yang dapat berpindah dari satu halaman ke halaman lainnya.

Navigasi Flutter menggunakan `Navigator`.

Dua perintah utama yang dipelajari:

```dart
Navigator.push()
```

dan

```dart
Navigator.pop()
```

### Navigator.push()

Digunakan untuk **membuka atau menambahkan halaman baru** ke dalam stack navigasi.

Contohnya:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DetailPage(makanan: item),
  ),
);
```

### Navigator.pop()

Digunakan untuk **menutup halaman saat ini dan kembali ke halaman sebelumnya**.

Contohnya:

```dart
Navigator.pop(context);
```

Konsepnya:

```text
Halaman Menu
     │
     │ Navigator.push()
     ↓
Halaman Detail
     │
     │ Navigator.pop()
     ↓
Halaman Menu
```

---

## 8. Mengirim Data ke Halaman Detail

Selain berpindah halaman, dipelajari juga cara **mengirim data dari halaman daftar ke halaman detail**.

Data makanan dikirim melalui constructor:

```dart
class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({
    super.key,
    required this.makanan,
  });
}
```

Kemudian data yang dikirim dapat digunakan pada halaman detail:

```dart
Text(makanan.nama)
```

dan:

```dart
Text('Rp ${makanan.harga}')
```

Dengan cara ini, ketika pengguna memilih makanan tertentu, halaman detail akan menampilkan **data makanan yang sesuai dengan item yang dipilih**.

---

## 9. Latihan Mandiri

Beberapa latihan yang dipelajari pada pertemuan ini:

1. Menambahkan 3 menu baru ke dalam `daftarMenu`.
2. Menambahkan properti `deskripsi` pada class `Makanan`.
3. Menampilkan deskripsi pada halaman detail.
4. Mengganti `Card` dengan `Container`.
5. Membuat format harga menggunakan fungsi sendiri.

Latihan tersebut digunakan untuk memperdalam pemahaman mengenai **List, class, layout, dan navigasi**.

---

## 10. Tugas Daftar Kontak

Tugas pada Pertemuan 2 adalah membuat aplikasi **Daftar Kontak**.

Ketentuannya:

* Minimal 6 kontak.
* Setiap kontak memiliki nama, nomor telepon, dan email.
* Data disimpan dalam `List` yang berisi objek dari sebuah `class`.
* Daftar kontak ditampilkan menggunakan `ListView.builder`.
* Setiap kontak menggunakan `ListTile`.
* Avatar berisi huruf pertama dari nama.
* Ketika kontak ditekan, akan membuka halaman detail.
* Halaman detail menampilkan seluruh data kontak.
* Terdapat tombol kembali ke halaman daftar.

Hasil yang dikumpulkan berupa screenshot kedua halaman dan file `main.dart` atau link repository.

---

## 11. Troubleshooting yang Dipelajari

Beberapa masalah yang dibahas pada praktikum:

### Overflow pada layar

Jika muncul garis kuning-hitam karena widget terlalu besar, dapat menggunakan:

```dart
Expanded
```

atau:

```dart
SingleChildScrollView
```

### ListView di dalam Column

Jika `ListView` tidak memiliki tinggi yang jelas ketika berada di dalam `Column`, dapat menggunakan:

```dart
Expanded(
  child: ListView(...)
)
```

### Navigator Error

Jika muncul error karena `context` tidak memiliki `Navigator`, pastikan halaman berada di bawah:

```dart
MaterialApp
```

### Perubahan kode tidak muncul

Jika perubahan tidak muncul, dapat menggunakan **Hot Restart**, terutama ketika mengubah `main()` atau data `const`.

---

# 📝 Kesimpulan

Pada Pertemuan 2, saya mempelajari cara membuat tampilan Flutter yang lebih terstruktur menggunakan berbagai widget layout seperti **Container, Padding, Row, Column, dan Expanded**.

Saya juga mempelajari cara membuat dan menyimpan data menggunakan **class Dart**, kemudian menampilkan data tersebut dalam bentuk daftar menggunakan **ListView.builder, Card, dan ListTile**.

Selain itu, saya mempelajari konsep **navigasi antar halaman** menggunakan `Navigator.push()` dan `Navigator.pop()`, termasuk cara mengirim data dari halaman daftar ke halaman detail melalui constructor.

Dari materi ini, saya mulai memahami bagaimana membuat aplikasi Flutter yang tidak hanya menampilkan tampilan statis, tetapi juga dapat **menampilkan banyak data, mengatur layout dengan lebih rapi, berpindah halaman, dan mengirim data antar halaman**.
