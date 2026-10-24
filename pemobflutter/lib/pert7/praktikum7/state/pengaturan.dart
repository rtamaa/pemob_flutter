
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pengaturan global sederhana.
/// Nilainya disimpan menggunakan shared_preferences
/// agar tetap tersimpan setelah aplikasi ditutup.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

final seedColor = ValueNotifier<Color>(Colors.teal);

final targetHarian = ValueNotifier<int>(20000);

/// Pilihan warna tema aplikasi.
const pilihanWarna = [
  Colors.teal,
  Colors.indigo,
  Colors.deepOrange,
  Colors.pink,
];

/// Memuat pengaturan yang tersimpan.
Future<void> muatPengaturan() async {
  final prefs = await SharedPreferences.getInstance();

  final gelap = prefs.getBool('gelap') ?? false;

  final warna = (prefs.getInt('warna') ?? 0)
      .clamp(0, pilihanWarna.length - 1)
      .toInt();

  themeMode.value = gelap ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = pilihanWarna[warna];
  targetHarian.value = prefs.getInt('target') ?? 20000;
}

/// Menyimpan pilihan tema terang atau gelap.
Future<void> simpanGelap(bool nilai) async {
  themeMode.value = nilai ? ThemeMode.dark : ThemeMode.light;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('gelap', nilai);
}

/// Menyimpan warna tema yang dipilih.
Future<void> simpanWarna(int index) async {
  if (index < 0 || index >= pilihanWarna.length) return;

  seedColor.value = pilihanWarna[index];

  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('warna', index);
}

/// Menyimpan target tabungan harian.
Future<void> simpanTarget(int nilai) async {
  targetHarian.value = nilai;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('target', nilai);
}
