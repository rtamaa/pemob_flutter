# Ringkasan Modul Praktikum Flutter Fundamental
## Pertemuan 6: Tema, Routing dan Navigasi, serta Animasi

### Tujuan Praktikum

Praktikum ini bertujuan agar mahasiswa mampu:

- Membuat tema terang dan gelap serta mengganti warna tema menggunakan `ThemeData` dan `ThemeMode`.
- Menggunakan `Theme.of(context)` untuk mengambil warna dan gaya teks dari tema aplikasi.
- Menerapkan named routes, mengirim argumen antarhalaman, dan menggunakan `onGenerateRoute`.
- Membuat navigasi tab bawah menggunakan `NavigationBar` dan `IndexedStack`.
- Membuat animasi implisit, transisi Hero, dan animasi eksplisit menggunakan `AnimationController`.

### Alat dan Bahan

- Flutter SDK, editor kode, dan emulator atau perangkat.
- Proyek Flutter baru dengan perintah `flutter create praktikum_6`.
- Tidak memerlukan paket tambahan.

### Materi Utama

#### 1. Tema Flutter

Tema digunakan untuk mengatur warna, tipografi, dan gaya komponen agar tampilan aplikasi konsisten. `ThemeData` digunakan untuk menentukan gaya aplikasi, sedangkan `ThemeMode` mengatur penggunaan tema terang, gelap, atau mengikuti sistem perangkat. `colorSchemeSeed` dapat digunakan untuk menghasilkan palet warna berdasarkan satu warna utama. Dengan `Theme.of(context)`, widget dapat mengambil warna dan gaya teks dari tema aktif sehingga tampilannya menyesuaikan ketika tema berubah.

Beberapa konsep penting:

- `ThemeData`: mengatur gaya aplikasi.
- `ThemeMode.light`: menggunakan tema terang.
- `ThemeMode.dark`: menggunakan tema gelap.
- `ThemeMode.system`: mengikuti tema perangkat.
- `Theme.of(context)`: mengambil tema yang sedang aktif.
- `ValueNotifier`: menyimpan nilai yang dapat berubah dan memberi tahu pendengar ketika nilainya berubah.
- `ListenableBuilder`: membangun ulang tampilan ketika objek yang diamati berubah.

Pada praktikum, pengguna dapat mengaktifkan mode gelap dan memilih warna tema seperti indigo, teal, deep orange, atau pink tanpa harus memulai ulang aplikasi.

#### 2. Routing dan Navigasi

Routing digunakan untuk mengatur perpindahan halaman dalam aplikasi. Selain menggunakan `Navigator.push()`, Flutter menyediakan named routes agar navigasi dapat diatur berdasarkan nama rute.

| Method | Fungsi |
| --- | --- |
| `Navigator.pushNamed()` | Membuka halaman berdasarkan nama rute dan dapat mengirim argumen. |
| `Navigator.pop()` | Menutup halaman saat ini dan kembali ke halaman sebelumnya. |
| `Navigator.pushReplacementNamed()` | Mengganti halaman saat ini sehingga halaman sebelumnya tidak langsung dapat dikunjungi melalui tombol kembali. |
| `Navigator.pushNamedAndRemoveUntil()` | Membuka halaman baru sekaligus menghapus halaman tertentu dari riwayat navigasi. |
| `onGenerateRoute` | Menentukan halaman yang dibuat berdasarkan nama rute dan argumen yang diterima. |

Pada praktikum, daftar rute didefinisikan melalui `routes`, sedangkan rute detail ditangani menggunakan `onGenerateRoute`. Argumen dikirim melalui `Navigator.pushNamed()` dan diterima sebagai objek pada halaman tujuan. Untuk aplikasi yang lebih besar dan membutuhkan deep link, `go_router` dapat menjadi alternatif pengelolaan navigasi.

#### 3. Model Item dan Animasi Hero

Class `Item` digunakan untuk menyimpan informasi berupa nama, ikon, dan warna item. Daftar item ditampilkan pada halaman Beranda menggunakan `ListView.builder`. Ketika salah satu item dipilih, aplikasi membuka halaman detail dengan mengirimkan objek item sebagai argumen.

`Hero` memberikan efek transisi ketika elemen yang sama berpindah dari satu halaman ke halaman lainnya. Kedua widget `Hero` harus memiliki `tag` yang sama agar Flutter dapat mengenali elemen yang akan dianimasikan. Tag juga harus unik untuk setiap elemen Hero yang tampil bersamaan pada halaman yang sama.

#### 4. Jenis-Jenis Animasi Flutter

Flutter menyediakan beberapa jenis animasi untuk membuat aplikasi lebih menarik dan interaktif.

| Jenis Animasi | Widget atau Kelas | Fungsi |
| --- | --- | --- |
| Implisit | `AnimatedContainer` | Menganimasikan perubahan ukuran, warna, dan bentuk. |
| Implisit | `AnimatedOpacity` | Menganimasikan perubahan transparansi widget. |
| Implisit | `AnimatedSwitcher` | Memberikan transisi ketika widget atau konten berganti. |
| Transisi halaman | `Hero` | Memberikan efek perpindahan elemen antarhalaman. |
| Eksplisit | `AnimationController` | Mengontrol jalannya animasi, seperti memulai, menghentikan, dan mengulang animasi. |
| Eksplisit | `RotationTransition` | Menampilkan rotasi berdasarkan nilai animasi. |

**Animasi implisit** berjalan otomatis ketika nilai properti widget berubah. Biasanya, perubahan nilai dilakukan melalui `setState()`. Sementara itu, **animasi eksplisit** memberikan kontrol lebih besar terhadap jalannya animasi, misalnya untuk mengatur pengulangan dan menghentikan animasi.

#### 5. Demonstrasi Animasi

Pada Bagian C, praktikum membuat tiga demonstrasi animasi.

- **AnimatedContainer:** tombol Ubah bentuk mengubah ukuran, warna, dan sudut kotak secara bertahap.
- **AnimatedSwitcher:** tombol Tambah mengubah angka dengan efek transisi membesar. `ValueKey` yang berbeda diperlukan agar Flutter mengenali perubahan widget.
- **AnimationController:** ikon roda gigi berputar terus-menerus dan dapat dihentikan atau dijalankan kembali menggunakan tombol Putar.

`AnimationController` membutuhkan `TickerProvider` untuk mengatur waktu animasi. Pada praktikum ini, `SingleTickerProviderStateMixin` digunakan untuk menyediakan `vsync`. Controller harus dibersihkan menggunakan `dispose()` agar tidak terus menggunakan sumber daya setelah widget dihapus.

#### 6. Navigasi Tab Bawah dengan NavigationBar

`NavigationBar` digunakan untuk menampilkan pilihan tab di bagian bawah aplikasi. Pada praktikum, terdapat tiga tab utama, yaitu Beranda, Animasi, dan Pengaturan.

`selectedIndex` menentukan tab yang sedang aktif, sedangkan `onDestinationSelected` menangani pemilihan tab. `IndexedStack` menampilkan halaman berdasarkan indeks yang dipilih sekaligus mempertahankan state halaman selama halaman tersebut tetap berada di dalam stack.

Dengan struktur ini, pengguna dapat berpindah tab tanpa harus kehilangan keadaan halaman yang masih tersimpan. Tema yang diubah melalui tab Pengaturan juga diterapkan pada bagian aplikasi lainnya, termasuk halaman detail.

### Latihan Mandiri

1. Menyimpan pilihan mode gelap dan warna tema menggunakan `shared_preferences`, kemudian memuatnya ketika aplikasi dimulai.
2. Menambahkan `Drawer` pada `ShellPage` untuk berpindah tab.
3. Mengganti transisi halaman detail dengan `PageRouteBuilder` dan `FadeTransition`.
4. Menambahkan `onUnknownRoute` untuk menampilkan halaman **404 - Halaman tidak ditemukan**.
5. Menambahkan animasi `AnimatedOpacity` untuk memudarkan dan memunculkan kartu ketika tombol ditekan.

### Tugas Praktikum: Aplikasi Galeri/Katalog Interaktif

Buat aplikasi Flutter dengan tema bebas, seperti profil diri, katalog produk, atau galeri tempat wisata, dengan ketentuan berikut:

- Memiliki minimal tiga tab menggunakan `NavigationBar`, misalnya Beranda, Favorit atau Katalog, dan Pengaturan.
- Menggunakan named routes dengan argumen untuk membuka halaman detail.
- Menggunakan animasi Hero pada halaman detail.
- Menerapkan minimal dua jenis animasi, yaitu satu animasi implisit dan satu animasi eksplisit menggunakan `AnimationController`.
- Menyediakan pengaturan tema terang dan gelap serta minimal tiga pilihan warna.
- Menyimpan pilihan tema agar tetap digunakan setelah aplikasi ditutup dan dibuka kembali.
- Mengambil warna dan gaya teks melalui `Theme.of(context)` untuk menghindari warna manual yang tidak menyesuaikan tema.

Pengumpulan tugas berupa tangkapan layar mode terang, mode gelap, dan halaman detail, serta berkas kode atau tautan repositori. Aplikasi ini akan menjadi bahan awal untuk mini proyek pada Pertemuan 7.


### Pertanyaan Refleksi

**1. Apa perbedaan animasi implisit dan eksplisit? Kapan memilih masing-masing?**

Animasi implisit berjalan otomatis ketika nilai properti widget berubah, sehingga cocok untuk perubahan sederhana seperti ukuran, warna, atau transparansi. Animasi eksplisit menggunakan `AnimationController` dan cocok ketika animasi membutuhkan kontrol khusus, seperti pengulangan, penghentian, atau pengaturan urutan.

**2. Mengapa dua Hero harus memiliki tag yang sama, dan apa yang terjadi bila tag-nya muncul dua kali pada halaman yang sama?**

Tag yang sama membuat Flutter mengenali elemen yang berpindah antarhalaman sehingga transisi Hero dapat berjalan. Jika beberapa Hero menggunakan tag yang sama pada halaman yang sama, Flutter dapat mengalami konflik dalam menentukan elemen yang akan dianimasikan.

**3. Apa keuntungan memakai `Theme.of(context)` dibanding menulis warna langsung pada widget?**

`Theme.of(context)` membuat widget mengikuti tema aplikasi yang sedang aktif. Ketika tema berubah menjadi terang atau gelap, warna dan gaya teks dapat menyesuaikan secara otomatis sehingga tampilan lebih konsisten dan mudah dikelola.

**4. Apa perbedaan berpindah tab dengan `IndexedStack` dan membuka halaman dengan `Navigator`?**

`IndexedStack` digunakan untuk berpindah di antara beberapa tab utama sambil mempertahankan state halaman. Sementara itu, `Navigator` digunakan untuk membuka halaman baru, seperti halaman detail, dan mengatur riwayat perpindahan halaman.

**5. Mengapa `AnimationController` wajib di-dispose?**

`AnimationController` harus dibersihkan menggunakan `dispose()` ketika widget dihapus agar animasi tidak terus berjalan dan sumber daya yang digunakan dapat dilepaskan.

### Troubleshooting Umum

| Masalah | Solusi |
| --- | --- |
| `Could not find a generator for route` | Periksa penulisan nama rute dan pastikan rute sudah didaftarkan di `routes` atau ditangani oleh `onGenerateRoute`. |
| Hero tidak beranimasi | Pastikan kedua Hero memiliki tag yang sama dan tag tersebut unik pada setiap halaman. |
| Tema tidak berubah saat saklar digeser | Pastikan `MaterialApp` dibangun ulang melalui `ListenableBuilder` dan nilai `themeMode.value` diperbarui. |
| Sebagian warna tidak ikut mode gelap | Ganti warna manual dengan nilai dari `Theme.of(context).colorScheme`. |
| `AnimatedContainer` tidak beranimasi | Pastikan nilai properti berubah melalui `setState()` dan durasi animasi sudah ditentukan. |
| `AnimatedSwitcher` tidak beranimasi | Pastikan widget yang berubah memiliki `Key` berbeda, misalnya menggunakan `ValueKey`. |
| Error `vsync` atau `TickerProvider` | Tambahkan `SingleTickerProviderStateMixin` pada state class yang menggunakan satu `AnimationController`. |

### Kesimpulan

Praktikum ini membahas cara mengatur tema aplikasi, mengelola perpindahan halaman, membuat navigasi tab bawah, dan menerapkan animasi pada Flutter. `ThemeData` dan `Theme.of(context)` membantu menjaga konsistensi tampilan, sedangkan named routes dan `Navigator` memudahkan pengelolaan halaman. `NavigationBar` dan `IndexedStack` digunakan untuk navigasi tab, sementara animasi implisit, Hero, dan `AnimationController` membuat interaksi aplikasi lebih menarik. Penyimpanan tema juga memungkinkan pilihan pengguna tetap digunakan setelah aplikasi dibuka kembali.