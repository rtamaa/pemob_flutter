import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Nilai awal pengaturan aplikasi.
const int targetAwal = 20000;
const int batasTarget = 100000;

// State global yang dapat dipantau oleh halaman Flutter.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.teal);
final targetHarian = ValueNotifier<int>(targetAwal);

// Daftar pilihan warna tema aplikasi.
const pilihanWarna = [
  Colors.teal,
  Colors.indigo,
  Colors.deepOrange,
  Colors.pink,
];

// Memuat preferensi pengguna dari penyimpanan lokal.
Future<void> muatPengaturan() async {
  final prefs = await SharedPreferences.getInstance();

  final modeGelap = prefs.getBool('gelap') ?? false;
  final indeksWarna = (prefs.getInt('warna') ?? 0)
      .clamp(0, pilihanWarna.length - 1)
      .toInt();
  final targetTersimpan = (prefs.getInt('target') ?? targetAwal)
      .clamp(0, batasTarget)
      .toInt();

  themeMode.value = modeGelap ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = pilihanWarna[indeksWarna];
  targetHarian.value = targetTersimpan;
}

// Menyimpan preferensi mode gelap.
Future<void> simpanGelap(bool aktif) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('gelap', aktif);
  themeMode.value = aktif ? ThemeMode.dark : ThemeMode.light;
}

// Menyimpan pilihan warna dengan validasi indeks.
Future<void> simpanWarna(int index) async {
  if (index < 0 || index >= pilihanWarna.length) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('warna', index);
  seedColor.value = pilihanWarna[index];
}

// Menyimpan target tabungan dalam rentang yang diperbolehkan.
Future<void> simpanTarget(int nilai) async {
  final targetValid = nilai.clamp(0, batasTarget).toInt();

  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt('target', targetValid);
  targetHarian.value = targetValid;
}
