import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

// Model untuk menyimpan informasi kondisi server.
class StatusServer {
  final bool apiOk;
  final bool databaseOk;
  final String waktuServer;
  final String? versiMysql;
  final String? detail;
  final Duration latensi;

  const StatusServer({
    required this.apiOk,
    required this.databaseOk,
    required this.waktuServer,
    required this.latensi,
    this.versiMysql,
    this.detail,
  });
}

// Membaca respons dari endpoint /health FastAPI.
Future<StatusServer> cekServer({http.Client? client}) async {
  final httpClient = client ?? http.Client();
  final pengukurWaktu = Stopwatch()..start();

  try {
    // Mengirim permintaan ke backend TabungKu.
    final alamat = Uri.parse('${apiUrl.value}/health');

    final response = await httpClient
        .get(alamat)
        .timeout(batasWaktu);

    pengukurWaktu.stop();

    // Status 200 menunjukkan API berhasil.
    // Status 503 menunjukkan API dapat dihubungi,
    // tetapi ada masalah pada layanan database.
    if (response.statusCode != 200 &&
        response.statusCode != 503) {
      throw Exception(
        'Pemeriksaan server gagal. '
            'Kode HTTP: ${response.statusCode}',
      );
    }

    // Mengubah respons JSON menjadi Map.
    final hasilJson = jsonDecode(response.body);

    if (hasilJson is! Map<String, dynamic>) {
      throw const FormatException(
        'Format respons API tidak valid',
      );
    }

    // Pada HTTP 503, informasi kesalahan dapat
    // berada di dalam objek "detail".
    final detailJson = hasilJson['detail'];

    final informasi = detailJson is Map<String, dynamic>
        ? detailJson
        : hasilJson;

    // Mendukung status database "ok" dan "connected".
    final statusDatabase = informasi['database']
        ?.toString()
        .toLowerCase();

    final databaseTerhubung =
        response.statusCode == 200 &&
            (statusDatabase == 'ok' ||
                statusDatabase == 'connected');

    // Mengambil pesan kesalahan jika tersedia.
    String? pesanKesalahan;

    if (!databaseTerhubung) {
      pesanKesalahan =
          informasi['pesan']?.toString() ??
              (detailJson is String ? detailJson : null) ??
              'Database tidak dapat dihubungi';
    }

    // Menyusun hasil pemeriksaan server.
    return StatusServer(
      apiOk: true,
      databaseOk: databaseTerhubung,
      waktuServer:
      hasilJson['waktu_server']?.toString() ??
          'Tidak tersedia',
      versiMysql:
      hasilJson['mysql_version']?.toString(),
      detail: pesanKesalahan,
      latensi: pengukurWaktu.elapsed,
    );
  } finally {
    pengukurWaktu.stop();

    // Client bawaan ditutup setelah digunakan.
    // Client dari luar tidak ditutup agar dapat
    // digunakan kembali dalam pengujian.
    if (client == null) {
      httpClient.close();
    }
  }
}