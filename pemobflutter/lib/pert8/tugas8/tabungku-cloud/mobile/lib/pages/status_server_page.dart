import 'package:material_ui/material_ui.dart';

import '../config/api_config.dart';
import '../services/health_service.dart';

/// Menampilkan hasil pemeriksaan koneksi FastAPI dan MySQL.
class StatusServerPage extends StatefulWidget {
  const StatusServerPage({super.key});

  @override
  State<StatusServerPage> createState() => _StatusServerPageState();
}

class _StatusServerPageState extends State<StatusServerPage> {
  late Future<StatusServer> _future;

  @override
  void initState() {
    super.initState();
    _future = cekServer();
  }

  void _ulangi() {
    setState(() {
      _future = cekServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Status Server'), centerTitle: true),
      body: FutureBuilder<StatusServer>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Memeriksa koneksi server...',
                    style: tema.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final s = snapshot.data;
          final apiTerhubung = s?.apiOk ?? false;
          final databaseTerhubung = s?.databaseOk ?? false;
          final semuaTerhubung = apiTerhubung && databaseTerhubung;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              // Header monitoring server.
              Row(
                children: [
                  Icon(
                    Icons.monitor_heart_outlined,
                    size: 32,
                    color: warna.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monitoring Server',
                          style: tema.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Pantau koneksi layanan TabungKu Cloud',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: warna.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Ringkasan kondisi server.
              Card(
                color: semuaTerhubung
                    ? warna.primaryContainer
                    : warna.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: semuaTerhubung
                            ? warna.primary
                            : warna.error,
                        child: Icon(
                          semuaTerhubung
                              ? Icons.cloud_done_outlined
                              : Icons.cloud_off_outlined,
                          size: 30,
                          color: semuaTerhubung
                              ? warna.onPrimary
                              : warna.onError,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              semuaTerhubung
                                  ? 'Semua Layanan Terhubung'
                                  : 'Koneksi Belum Normal',
                              style: tema.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: semuaTerhubung
                                    ? warna.onPrimaryContainer
                                    : warna.onErrorContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              semuaTerhubung
                                  ? 'FastAPI dan database MySQL '
                                        'berjalan dengan baik.'
                                  : 'Periksa status API dan database '
                                        'pada informasi di bawah.',
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: semuaTerhubung
                                    ? warna.onPrimaryContainer
                                    : warna.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Judul bagian status layanan.
              _JudulBagian(ikon: Icons.dns_outlined, judul: 'Status Layanan'),

              const SizedBox(height: 12),

              // Status FastAPI.
              _KartuStatus(
                judul: 'FastAPI Backend',
                keterangan: s != null
                    ? 'Waktu respons: ${s.latensi.inMilliseconds} ms'
                    : '${snapshot.error}',
                terhubung: apiTerhubung,
                ikon: Icons.cloud_outlined,
              ),

              const SizedBox(height: 10),

              // Status database MySQL.
              _KartuStatus(
                judul: 'Database MySQL',
                keterangan: s == null
                    ? 'Tidak diketahui karena API tidak terhubung'
                    : s.databaseOk
                    ? 'Versi MySQL: ${s.versiMysql}'
                    : s.detail ?? 'Database tidak dapat dihubungi',
                terhubung: databaseTerhubung,
                ikon: Icons.storage_outlined,
              ),

              const SizedBox(height: 24),

              // Judul informasi server.
              _JudulBagian(ikon: Icons.info_outline, judul: 'Informasi Server'),

              const SizedBox(height: 12),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: warna.primaryContainer,
                        child: Icon(
                          Icons.link,
                          color: warna.onPrimaryContainer,
                        ),
                      ),
                      title: const Text('Alamat API'),
                      subtitle: Text(
                        apiUrl.value,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    if (s != null) ...[
                      const Divider(height: 1),

                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: warna.primaryContainer,
                          child: Icon(
                            Icons.schedule_outlined,
                            color: warna.onPrimaryContainer,
                          ),
                        ),
                        title: const Text('Waktu Server'),
                        subtitle: Text(s.waktuServer),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol untuk memeriksa koneksi kembali.
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _ulangi,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Periksa Koneksi Lagi'),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Pastikan Docker Compose menjalankan layanan '
                'FastAPI dan MySQL sebelum melakukan pemeriksaan.',
                textAlign: TextAlign.center,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: warna.onSurfaceVariant,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Judul untuk setiap kelompok informasi.
class _JudulBagian extends StatelessWidget {
  final IconData ikon;
  final String judul;

  const _JudulBagian({required this.ikon, required this.judul});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Row(
      children: [
        Icon(ikon, color: warna.primary),
        const SizedBox(width: 10),
        Text(
          judul,
          style: tema.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Kartu untuk menampilkan kondisi setiap layanan.
class _KartuStatus extends StatelessWidget {
  final String judul;
  final String keterangan;
  final bool terhubung;
  final IconData ikon;

  const _KartuStatus({
    required this.judul,
    required this.keterangan,
    required this.terhubung,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: terhubung
                ? warna.primaryContainer
                : warna.errorContainer,
            child: Icon(
              ikon,
              color: terhubung
                  ? warna.onPrimaryContainer
                  : warna.onErrorContainer,
            ),
          ),
          title: Text(
            judul,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(keterangan),
          ),
          trailing: Icon(
            terhubung ? Icons.check_circle : Icons.cancel,
            color: terhubung ? Colors.green : warna.error,
          ),
        ),
      ),
    );
  }
}
