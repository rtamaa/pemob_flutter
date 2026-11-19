import 'package:flutter/foundation.dart';

/// Konfigurasi alamat backend TabungKu Cloud.
///
/// 10.0.2.2 digunakan emulator Android untuk
/// mengakses localhost pada laptop.
///
/// Port 9000 merupakan port FastAPI yang
/// dipublikasikan melalui Docker Compose.
///
/// Alamat dapat diganti saat menjalankan Flutter:
/// flutter run --dart-define=API_URL=http://192.168.1.10:9000

const apiUrlBawaan = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:9000',
);

/// Alamat API yang digunakan aplikasi.
final apiUrl = ValueNotifier<String>(apiUrlBawaan);

/// Batas waktu maksimal permintaan ke backend.
const batasWaktu = Duration(seconds: 10);
