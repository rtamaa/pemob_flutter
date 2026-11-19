import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:tabungku/config/api_config.dart';
import 'package:tabungku/services/health_service.dart';

void main() {
  const alamatServerUji = 'http://server-uji:8000';

  setUp(() {
    // Menggunakan alamat simulasi agar tidak mengakses Docker.
    apiUrl.value = alamatServerUji;
  });

  group('Pengujian Koneksi TabungKu Cloud', () {
    // Test 1: FastAPI dan database berhasil terhubung.
    test('API dan MySQL terhubung dengan status ok', () async {
      final client = MockClient((request) async {
        expect(
          request.url.toString(),
          '$alamatServerUji/health',
        );

        return http.Response(
          jsonEncode({
            'status': 'ok',
            'waktu_server': '2026-10-06T08:00:00',
            'database': 'ok',
            'mysql_version': '8.4.6',
          }),
          200,
          headers: {
            'content-type': 'application/json',
          },
        );
      });

      final hasil = await cekServer(client: client);

      expect(hasil.apiOk, isTrue);
      expect(hasil.databaseOk, isTrue);
      expect(hasil.versiMysql, '8.4.6');
      expect(hasil.waktuServer, '2026-10-06T08:00:00');
      expect(hasil.latensi, isA<Duration>());

      client.close();
    });

    // Test 2: Mendukung respons database "connected".
    test('API dan MySQL terhubung dengan status connected', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/health');

        return http.Response(
          jsonEncode({
            'status': 'ok',
            'waktu_server': '2026-10-06T08:00:00',
            'database': 'connected',
            'mysql_version': '8.4.13',
          }),
          200,
          headers: {
            'content-type': 'application/json',
          },
        );
      });

      final hasil = await cekServer(client: client);

      expect(hasil.apiOk, isTrue);
      expect(hasil.databaseOk, isTrue);
      expect(hasil.versiMysql, '8.4.13');

      client.close();
    });

    // Test 3: API terhubung tetapi database mengalami gangguan.
    test('HTTP 503 menunjukkan database tidak terhubung', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/health');

        return http.Response(
          jsonEncode({
            'status': 'error',
            'waktu_server': '2026-10-06T08:00:00',
            'database': 'error',
            'detail': "Can't connect to MySQL server",
          }),
          503,
          headers: {
            'content-type': 'application/json',
          },
        );
      });

      final hasil = await cekServer(client: client);

      expect(hasil.apiOk, isTrue);
      expect(hasil.databaseOk, isFalse);
      expect(hasil.detail, contains('MySQL'));

      client.close();
    });

    // Test 4: Format kesalahan database berupa objek detail.
    test('HTTP 503 membaca pesan dari objek detail', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'detail': {
              'database': 'error',
              'pesan': 'Database tidak dapat dihubungi',
            },
          }),
          503,
          headers: {
            'content-type': 'application/json',
          },
        );
      });

      final hasil = await cekServer(client: client);

      expect(hasil.apiOk, isTrue);
      expect(hasil.databaseOk, isFalse);
      expect(
        hasil.detail,
        'Database tidak dapat dihubungi',
      );

      client.close();
    });

    // Test 5: HTTP 500 dianggap kesalahan server.
    test('HTTP 500 menghasilkan exception', () async {
      final client = MockClient(
            (request) async => http.Response(
          'Kesalahan internal server',
          500,
        ),
      );

      await expectLater(
        cekServer(client: client),
        throwsA(
          isA<Exception>().having(
                (error) => error.toString(),
            'pesan kesalahan',
            contains('500'),
          ),
        ),
      );

      client.close();
    });
  });
}