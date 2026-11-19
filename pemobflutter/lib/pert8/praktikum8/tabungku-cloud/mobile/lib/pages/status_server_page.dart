import 'package:material_ui/material_ui.dart';

import '../config/api_config.dart';
import '../services/health_service.dart';

/// Halaman monitoring koneksi backend TabungKu Cloud.
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

  // Memeriksa ulang kondisi koneksi backend.
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
          // Menampilkan indikator saat pengecekan berlangsung.
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final terhubung = snapshot.hasData;
          final status = snapshot.data;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              // Header halaman monitoring.
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: warna.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.monitor_heart_outlined,
                      size: 28,
                      color: warna.onPrimaryContainer,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monitoring Server',
                          style: tema.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pantau koneksi backend TabungKu Cloud',
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

              // Kartu status koneksi utama.
              Card(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: terhubung
                      ? warna.primaryContainer
                      : warna.errorContainer,
                  child: Column(
                    children: [
                      Icon(
                        terhubung
                            ? Icons.cloud_done_outlined
                            : Icons.cloud_off_outlined,
                        size: 64,
                        color: terhubung
                            ? warna.onPrimaryContainer
                            : warna.onErrorContainer,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        terhubung
                            ? 'Server Terhubung'
                            : 'Server Tidak Terhubung',
                        textAlign: TextAlign.center,
                        style: tema.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: terhubung
                              ? warna.onPrimaryContainer
                              : warna.onErrorContainer,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        terhubung
                            ? 'Backend berhasil merespons '
                                  'permintaan dari aplikasi.'
                            : 'Aplikasi belum dapat menghubungi '
                                  'backend TabungKu Cloud.',
                        textAlign: TextAlign.center,
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: terhubung
                              ? warna.onPrimaryContainer
                              : warna.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Informasi pemeriksaan koneksi.
              Text(
                'Informasi Koneksi',
                style: tema.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _KartuInformasi(
                ikon: Icons.dns_outlined,
                judul: 'FastAPI Backend',
                keterangan: terhubung
                    ? 'API berhasil dihubungi'
                    : 'API belum dapat dihubungi',
                berhasil: terhubung,
              ),

              const SizedBox(height: 10),

              _KartuInformasi(
                ikon: Icons.link_outlined,
                judul: 'Alamat API',
                keterangan: apiUrl,
              ),

              if (status != null) ...[
                const SizedBox(height: 10),

                _KartuInformasi(
                  ikon: Icons.schedule_outlined,
                  judul: 'Waktu Server',
                  keterangan: status.waktuServer,
                ),

                const SizedBox(height: 10),

                _KartuInformasi(
                  ikon: Icons.speed_outlined,
                  judul: 'Latensi Koneksi',
                  keterangan: '${status.latensi.inMilliseconds} ms',
                ),
              ],

              if (snapshot.hasError) ...[
                const SizedBox(height: 10),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline, color: warna.error),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detail Kesalahan',
                                style: tema.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              SelectableText(
                                '${snapshot.error}',
                                style: tema.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Tombol untuk memeriksa ulang status backend.
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _ulangi,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Periksa Koneksi Lagi'),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Pastikan backend Docker sedang berjalan.',
                  textAlign: TextAlign.center,
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: warna.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Widget kartu informasi koneksi server.
class _KartuInformasi extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String keterangan;
  final bool? berhasil;

  const _KartuInformasi({
    required this.ikon,
    required this.judul,
    required this.keterangan,
    this.berhasil,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(ikon, size: 23, color: warna.onPrimaryContainer),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: tema.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    keterangan,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: warna.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            if (berhasil != null) ...[
              const SizedBox(width: 8),

              Icon(
                berhasil! ? Icons.check_circle : Icons.cancel,
                color: berhasil! ? Colors.green : warna.error,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
