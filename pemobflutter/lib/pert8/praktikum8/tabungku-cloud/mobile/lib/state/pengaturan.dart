import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pengaturan global aplikasi TabungKu Cloud.
/// Preferensi disimpan secara lokal menggunakan shared_preferences.

// Nilai awal dan batas maksimal target tabungan.
const int targetAwal = 20000;
const int batasTarget = 100000;

// State tema dan target tabungan.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.teal);
final targetHarian = ValueNotifier<int>(targetAwal);

// Pilihan warna yang tersedia di halaman Pengaturan.
const pilihanWarna = [
  Colors.teal,
  Colors.indigo,
  Colors.deepOrange,
  Colors.pink,
];

/// Memuat preferensi yang sebelumnya disimpan pengguna.
Future<void> muatPengaturan() async {
  final prefs = await SharedPreferences.getInstance();

  // Membaca pengaturan mode gelap.
  final modeGelap = prefs.getBool('gelap') ?? false;

  // Memastikan indeks warna berada dalam rentang yang valid.
  final indeksWarna = (prefs.getInt('warna') ?? 0)
      .clamp(0, pilihanWarna.length - 1)
      .toInt();

  // Memastikan target sesuai dengan rentang pada Slider.
  final targetTersimpan = (prefs.getInt('target') ?? targetAwal)
      .clamp(0, batasTarget)
      .toInt();

  // Memperbarui state aplikasi.
  themeMode.value = modeGelap ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = pilihanWarna[indeksWarna];
  targetHarian.value = targetTersimpan;
}

/// Menyimpan pilihan mode terang atau gelap.
Future<void> simpanGelap(bool aktif) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('gelap', aktif);

  themeMode.value = aktif ? ThemeMode.dark : ThemeMode.light;
}

/// Menyimpan pilihan warna tema aplikasi.
Future<void> simpanWarna(int index) async {
  // Mengabaikan indeks yang tidak tersedia.
  if (index < 0 || index >= pilihanWarna.length) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('warna', index);

  seedColor.value = pilihanWarna[index];
}

/// Menyimpan target tabungan harian.
Future<void> simpanTarget(int nilai) async {
  // Target dibatasi dari Rp0 sampai Rp100.000.
  final targetValid = nilai.clamp(0, batasTarget).toInt();

  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('target', targetValid);

  targetHarian.value = targetValid;
}
