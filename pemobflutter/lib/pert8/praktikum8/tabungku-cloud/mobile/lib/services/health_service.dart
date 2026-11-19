import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// Model untuk menyimpan hasil pemeriksaan backend.
class StatusServer {
  final String status;
  final String waktuServer;
  final Duration latensi;

  const StatusServer({
    required this.status,
    required this.waktuServer,
    required this.latensi,
  });
}

/// Memeriksa status backend FastAPI melalui endpoint /health.
///
/// Pengujian dilakukan dengan HTTP GET dan mengukur
/// waktu respons dari server.
Future<StatusServer> cekServer({http.Client? client}) async {
  final httpClient = client ?? http.Client();
  final pengukurWaktu = Stopwatch()..start();

  try {
    // Mengakses endpoint health pada backend.
    final alamat = Uri.parse('$apiUrl/health');

    final response = await httpClient.get(alamat).timeout(batasWaktu);

    pengukurWaktu.stop();

    // Backend harus mengembalikan HTTP 200.
    if (response.statusCode != 200) {
      throw Exception(
        'Pemeriksaan server gagal. '
        'Kode HTTP: ${response.statusCode}',
      );
    }

    // Mengubah respons JSON menjadi data Map.
    final hasilJson = jsonDecode(response.body);

    // Memastikan format data yang diterima sesuai.
    if (hasilJson is! Map<String, dynamic>) {
      throw const FormatException('Format respons API tidak valid');
    }

    // Membuat objek hasil pemeriksaan server.
    return StatusServer(
      status: hasilJson['status']?.toString() ?? 'unknown',
      waktuServer: hasilJson['waktu_server']?.toString() ?? 'Tidak tersedia',
      latensi: pengukurWaktu.elapsed,
    );
  } finally {
    pengukurWaktu.stop();

    // Client buatan fungsi ditutup setelah digunakan.
    // Client dari pengujian tidak ditutup otomatis.
    if (client == null) {
      httpClient.close();
    }
  }
}
