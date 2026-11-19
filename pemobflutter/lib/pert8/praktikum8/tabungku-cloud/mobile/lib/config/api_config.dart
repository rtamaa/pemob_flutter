// Konfigurasi alamat backend TabungKu Cloud.
//
// Alamat 10.0.2.2 digunakan emulator Android untuk
// mengakses localhost pada laptop.
//
// Port 9000 adalah port FastAPI yang dipublikasikan
// melalui Docker Compose.
//
// Untuk perangkat fisik, alamat dapat diganti dengan:
// flutter run --dart-define=API_URL=http://192.168.1.10:9000

/// Alamat backend yang digunakan aplikasi.
const String apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:9000',
);

/// Batas waktu maksimal permintaan ke backend.
const Duration batasWaktu = Duration(seconds: 10);