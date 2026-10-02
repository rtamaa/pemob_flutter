# Catatan Praktikum Pertemuan 1 - Pengenalan Flutter

Catatan rangkuman dari laporan praktikum **Flutter Fundamental Pertemuan 1**. Isinya dibuat seperti catatan belajar supaya lebih mudah dibaca dan dipahami.

---

## 1. Pengenalan Flutter

Flutter adalah framework/UI toolkit dari Google yang digunakan untuk membuat aplikasi. Flutter menggunakan bahasa pemrograman **Dart**.

Pada pertemuan pertama dipelajari dasar Flutter, mulai dari instalasi, membuat project, memahami struktur project, mengenal widget, membuat layout, sampai membuat aplikasi yang memiliki state. fileciteturn9file0L14-L17

### Intinya

- **Flutter** = framework untuk membuat aplikasi.
- **Dart** = bahasa pemrograman yang digunakan Flutter.
- **Widget** = bagian dasar penyusun tampilan aplikasi.
- **Hot Reload** = melihat perubahan kode dengan cepat tanpa menjalankan ulang seluruh aplikasi.

---

## 2. Perintah Flutter di Terminal

### `flutter doctor`

Digunakan untuk mengecek apakah lingkungan Flutter sudah siap, termasuk Flutter, Android toolchain, dan editor.

```powershell
flutter doctor
```

### `flutter doctor --android-licenses`

Digunakan untuk menerima lisensi Android SDK.

```powershell
flutter doctor --android-licenses
```

### Membuat project

```powershell
flutter create praktikum_1
```

Perintah ini membuat project Flutter baru beserta struktur folder dasarnya.

### Masuk ke project

```powershell
cd praktikum_1
```

Digunakan untuk masuk ke folder project.

### Menjalankan aplikasi

```powershell
flutter run
```

Digunakan untuk menjalankan aplikasi pada emulator atau perangkat. Pada project pertama, aplikasi yang muncul adalah counter bawaan Flutter. fileciteturn9file0L19-L30

### Melihat perangkat

```powershell
flutter devices
```

Digunakan untuk melihat emulator atau perangkat yang terdeteksi.

---

# 3. Struktur Project Flutter

Struktur dasar project:

```text
project/
├── lib/
│   └── main.dart
├── pubspec.yaml
├── android/
├── ios/
└── test/
```

### `lib/main.dart`

Tempat kode utama aplikasi Flutter.

### `pubspec.yaml`

Digunakan untuk konfigurasi project, dependency, dan aset.

### `android/` dan `ios/`

Berisi kode dan konfigurasi untuk platform native Android dan iOS.

### `test/`

Digunakan untuk menyimpan file pengujian. fileciteturn9file0L32-L39

---

# 4. `main()` dan `runApp()`

Program Flutter dimulai dari:

```dart
void main() {
  runApp(const MyApp());
}
```

- `main()` = titik awal program.
- `runApp()` = menjalankan widget utama sebagai aplikasi.

Jadi alurnya:

```text
main()
   ↓
runApp()
   ↓
MyApp
   ↓
Tampilan aplikasi
```

---

# 5. StatelessWidget

`StatelessWidget` digunakan ketika tampilan tidak memiliki data internal yang berubah.

Contohnya aplikasi **Hello Flutter** yang hanya menampilkan nama.

```dart
class MyApp extends StatelessWidget {
```

Pada bagian ini kita belajar membuat tampilan sederhana menggunakan `MaterialApp`, `Scaffold`, `AppBar`, `Center`, dan `Text`. fileciteturn9file0L41-L69

---

# 6. Hello Flutter

Contoh sederhana:

```dart
return MaterialApp(
  title: 'Praktikum 1',
  home: Scaffold(
    appBar: AppBar(
      title: const Text('Hello Flutter'),
    ),
    body: const Center(
      child: Text(
        'Halo, nama saya [NAMA]!',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ),
);
```

Hasil yang diharapkan:

```text
┌─────────────────────────┐
│     Hello Flutter       │
├─────────────────────────┤
│                         │
│  Halo, nama saya Tia!   │
│                         │
└─────────────────────────┘
```

Nama `[NAMA]` diganti dengan nama sendiri.

---

# 7. Widget yang Digunakan

## MaterialApp

`MaterialApp` merupakan pembungkus utama aplikasi dan dapat digunakan untuk menentukan `title` serta halaman awal melalui `home`.

## Scaffold

`Scaffold` digunakan sebagai kerangka dasar halaman.

Biasanya berisi:

```text
Scaffold
├── AppBar
├── body
└── FloatingActionButton
```

## AppBar

`AppBar` digunakan untuk bagian atas halaman, biasanya berisi judul.

## Text

`Text` digunakan untuk menampilkan tulisan.

Contoh:

```dart
Text('Halo, nama saya Tia!')
```

## Center

`Center` digunakan untuk menempatkan widget di tengah.

## Icon

`Icon` digunakan untuk menampilkan ikon.

## SizedBox

`SizedBox` dapat digunakan untuk memberikan jarak antar-widget.

## Column

`Column` digunakan untuk menyusun beberapa widget secara vertikal.

---

# 8. Widget Tree

Widget tree menunjukkan hubungan antara widget satu dengan widget lainnya.

Pada praktikum:

```text
MaterialApp
└── Scaffold
    ├── AppBar
    │   └── Text
    └── Center
        └── Column
            ├── Icon
            ├── SizedBox
            ├── Text
            └── Text
```

Dengan melihat widget tree, kita bisa lebih mudah memahami susunan tampilan aplikasi.

---

# 9. Layout Dasar dengan Column

Pada bagian E, tampilan dibuat agar icon, nama, dan NIM berada di tengah secara vertikal.

```dart
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Icon(
        Icons.flutter_dash,
        size: 80,
        color: Colors.blue,
      ),
      SizedBox(height: 16),
      Text(
        'Halo, nama saya [NAMA]!',
        style: TextStyle(fontSize: 24),
      ),
      Text('NIM: [NIM]'),
    ],
  ),
),
```

Penjelasan:

- `Center` → membuat isi berada di tengah.
- `Column` → menyusun isi dari atas ke bawah.
- `mainAxisAlignment.center` → membuat isi Column berada di tengah.
- `Icon` → menampilkan icon Flutter.
- `SizedBox` → memberikan jarak.
- `Text` → menampilkan nama dan NIM. fileciteturn9file0L70-L90

---

# 10. StatefulWidget

`StatefulWidget` digunakan ketika data pada tampilan dapat berubah.

Contoh paling mudah adalah aplikasi **Counter**.

Nilai awal:

```text
0
```

Ketika tombol `+` ditekan:

```text
0 → 1 → 2 → 3 → ...
```

Karena nilai berubah, digunakan `StatefulWidget`. fileciteturn9file0L92-L121

---

# 11. State dan `_count`

Pada Counter terdapat:

```dart
int _count = 0;
```

`_count` digunakan untuk menyimpan nilai counter.

Nilainya dapat berubah selama aplikasi berjalan.

Contohnya:

```text
_count = 0
_count = 1
_count = 2
_count = 3
```

---

# 12. `setState()`

`setState()` digunakan untuk memberi tahu Flutter bahwa state telah berubah sehingga tampilan perlu diperbarui.

Contohnya:

```dart
setState(() => _count++);
```

`_count++` berarti nilai `_count` ditambah 1.

Alurnya:

```text
Tombol ditekan
      ↓
_count bertambah
      ↓
setState()
      ↓
Flutter memperbarui tampilan
      ↓
Angka berubah
```

Kalau nilai diubah tanpa `setState()`, perubahan tersebut tidak otomatis membuat tampilan diperbarui. fileciteturn9file0L122-L127 fileciteturn9file0L237-L245

---

# 13. FloatingActionButton

`FloatingActionButton` adalah tombol bulat yang melayang di halaman.

Pada Counter digunakan untuk menambah nilai:

```dart
FloatingActionButton(
  onPressed: () => setState(() => _count++),
  child: const Icon(Icons.add),
)
```

- `onPressed` → aksi saat tombol ditekan.
- `Icon(Icons.add)` → menampilkan tanda tambah.

---

# 14. Latihan Mandiri

Ada 4 latihan pada halaman Counter:

1. Mengubah warna AppBar dan teks.
2. Menambahkan tombol kurang.
3. Menambahkan tombol reset.
4. Mencegah angka menjadi negatif. fileciteturn9file0L129-L132

Contoh:

```dart
void _tambah() => setState(() => _count++);

void _kurang() {
  if (_count > 0) {
    setState(() => _count--);
  }
}

void _reset() => setState(() => _count = 0);
```

Penjelasan:

- `_tambah()` → menambah angka.
- `_kurang()` → mengurangi angka jika masih lebih dari 0.
- `_reset()` → mengembalikan angka menjadi 0.

---

# 15. Beberapa Tombol Counter

Kalau ingin memiliki tombol tambah, kurang, dan reset, tombol dapat disusun menggunakan `Column`.

```text
      (+)
      ↓
      (-)
      ↓
     Reset
```

Setiap tombol mempunyai `heroTag` yang berbeda agar tidak terjadi konflik antar `FloatingActionButton`.

Contohnya:

```dart
heroTag: 'tambah'
heroTag: 'kurang'
heroTag: 'reset'
```

---

# 16. Tugas Kartu Perkenalan

Tugas ini membuat aplikasi satu halaman yang berisi informasi diri.

Yang ditampilkan:

- Foto atau icon
- Nama
- NIM
- Jurusan
- Hobi

Widget yang digunakan:

```text
Column
├── Icon / Foto
├── Text
├── Text
├── Text
└── Text
```

Contoh struktur:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Icon(Icons.account_circle, size: 120),
    SizedBox(height: 20),
    Text('[NAMA]'),
    SizedBox(height: 8),
    Text('NIM: [NIM]'),
    Text('Jurusan: [JURUSAN]'),
    Text('Hobi: [HOBI]'),
  ],
)
```

Data `[NAMA]`, `[NIM]`, `[JURUSAN]`, dan `[HOBI]` harus diganti dengan data sendiri. fileciteturn9file0L182-L228

---

# 17. Stateless vs Stateful

### StatelessWidget

Digunakan untuk tampilan yang tidak memiliki data internal yang berubah.

Contoh:

```text
Menampilkan nama
Menampilkan NIM
Menampilkan icon
```

### StatefulWidget

Digunakan ketika terdapat data yang dapat berubah selama aplikasi berjalan.

Contoh:

```text
Counter
0 → 1 → 2 → 3
```

Jadi gampangnya:

> **Stateless = tampilannya tidak berubah**  
> **Stateful = ada data/tampilan yang bisa berubah**

---

# 18. Kenapa Harus Menggunakan `setState()`?

Misalnya:

```dart
_count++;
```

Nilainya memang berubah, tetapi Flutter perlu diberi tahu bahwa ada perubahan.

Karena itu digunakan:

```dart
setState(() {
  _count++;
});
```

Setelah `setState()` dipanggil, Flutter menjalankan kembali proses `build()` sehingga tampilan menggunakan nilai terbaru. fileciteturn9file0L237-L245

---

# 19. Hot Reload

Hot Reload adalah fitur Flutter yang membuat perubahan kode bisa langsung dilihat pada aplikasi yang sedang berjalan.

Contoh:

```dart
Text('Halo, nama saya Tia!')
```

diubah menjadi:

```dart
Text('Halo, nama saya Septiara!')
```

Setelah Hot Reload, perubahan dapat langsung terlihat tanpa menjalankan seluruh aplikasi dari awal.

Jadi:

```text
Edit kode
   ↓
Hot Reload
   ↓
Perubahan langsung terlihat
```

---

# 20. Troubleshooting

### Flutter tidak dikenali

Kalau muncul masalah Flutter tidak dikenali, periksa PATH dan buka kembali terminal.

### Lisensi Android belum diterima

Jalankan:

```powershell
flutter doctor --android-licenses
```

### Emulator lambat

Periksa virtualisasi VT-x/AMD-V pada BIOS.

### Perangkat tidak terdeteksi

Cek perangkat menggunakan:

```powershell
flutter devices
```

dan pastikan USB debugging aktif jika menggunakan perangkat Android. fileciteturn9file0L251-L258

---

# 21. Refleksi

### Apa perbedaan StatelessWidget dan StatefulWidget?

StatelessWidget digunakan untuk tampilan yang tidak memiliki data internal yang berubah. StatefulWidget memiliki State yang menyimpan data yang dapat berubah selama aplikasi berjalan.

### Kenapa `_count` harus menggunakan `setState()`?

Karena `setState()` memberi tahu Flutter bahwa state sudah berubah sehingga `build()` dijalankan kembali dan tampilan menggunakan nilai terbaru.

### Apa keuntungan Hot Reload?

Perubahan kode dapat langsung dilihat pada aplikasi yang sedang berjalan tanpa harus mengulang seluruh proses dari awal. fileciteturn9file0L237-L249

---

# 22. Kesimpulan

Pada Pertemuan 1 dipelajari dasar pengembangan aplikasi menggunakan Flutter dan Dart. Mulai dari mengecek instalasi dengan `flutter doctor`, membuat project Flutter, memahami struktur project, mengenal widget tree, membuat layout menggunakan `Column`, sampai menggunakan `StatefulWidget` dan `setState()`.

Latihan Counter membantu memahami bagaimana state dapat berubah, sedangkan tugas Kartu Perkenalan digunakan untuk menerapkan widget dasar dalam membuat satu halaman aplikasi. fileciteturn9file0L260-L265

---

# 23. Inti yang Perlu Diingat

```text
Flutter
   ↓
Dart
   ↓
Widget
   ↓
MaterialApp
   ↓
Scaffold
   ↓
AppBar + Body
   ↓
Column / Center / Text / Icon
```

Kalau aplikasi memiliki data yang berubah:

```text
StatefulWidget
      ↓
     State
      ↓
  setState()
      ↓
Tampilan diperbarui
```

**Intinya:** Flutter membangun tampilan menggunakan widget. Kalau tampilannya tidak membutuhkan perubahan state, gunakan `StatelessWidget`. Kalau datanya dapat berubah, gunakan `StatefulWidget` dan `setState()`.

---