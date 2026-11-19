import 'package:material_ui/material_ui.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/kegiatan_tile.dart';
import '../widgets/ringkasan_card.dart';

// Menggabungkan kegiatan dan ringkasan dalam satu data.
class DataHari {
  final List<Kegiatan> daftar;
  final Ringkasan ringkasan;

  const DataHari({required this.daftar, required this.ringkasan});
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late Future<DataHari> _dataHari;

  @override
  void initState() {
    super.initState();
    _dataHari = _muatDataHari();
    versiData.addListener(_perbaruiData);
  }

  @override
  void dispose() {
    versiData.removeListener(_perbaruiData);
    super.dispose();
  }

  // Mengambil data kegiatan dan ringkasan dari SQLite.
  Future<DataHari> _muatDataHari() async {
    final hariIni = fmtTanggal(DateTime.now());

    final hasil = await Future.wait([
      DbHelper.pada(hariIni),
      DbHelper.ringkasan(hariIni),
    ]);

    return DataHari(
      daftar: hasil[0] as List<Kegiatan>,
      ringkasan: hasil[1] as Ringkasan,
    );
  }

  // Memperbarui data ketika terjadi perubahan kegiatan.
  void _perbaruiData() {
    if (!mounted) return;

    setState(() {
      _dataHari = _muatDataHari();
    });
  }

  // Konfirmasi sebelum menghapus kegiatan.
  Future<void> _konfirmasiHapus(Kegiatan kegiatan) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Kegiatan'),
          content: Text(
            'Yakin ingin menghapus "${kegiatan.judul}" dari daftar kegiatan?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!mounted || setuju != true || kegiatan.id == null) {
      return;
    }

    await DbHelper.hapus(kegiatan.id!);
  }

  // Membuka form untuk menambahkan kegiatan.
  void _tambahKegiatan() {
    Navigator.pushNamed(context, '/form');
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return FutureBuilder<DataHari>(
      future: _dataHari,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: warna.error),
                  const SizedBox(height: 12),
                  Text(
                    'Gagal memuat data kegiatan',
                    style: tema.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _perbaruiData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final jumlahKegiatan = data.daftar.length;
        final jumlahSelesai = data.daftar
            .where((kegiatan) => kegiatan.selesai)
            .length;

        return RefreshIndicator(
          onRefresh: () async {
            _perbaruiData();
            await _dataHari;
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // Header beranda.
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard TabungKu',
                          style: tema.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tampilTanggal(DateTime.now()),
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: warna.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _perbaruiData,
                    tooltip: 'Perbarui data',
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Kartu ringkasan harian.
              ValueListenableBuilder<int>(
                valueListenable: targetHarian,
                builder: (context, target, _) {
                  return RingkasanCard(
                    judul: 'Keuangan Hari Ini',
                    ringkasan: data.ringkasan,
                    target: target,
                  );
                },
              ),

              const SizedBox(height: 20),

              // Informasi progres kegiatan.
              Row(
                children: [
                  Expanded(
                    child: _KartuStatistik(
                      judul: 'Total Kegiatan',
                      nilai: '$jumlahKegiatan',
                      ikon: Icons.event_note_outlined,
                      warna: warna.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KartuStatistik(
                      judul: 'Selesai',
                      nilai: '$jumlahSelesai',
                      ikon: Icons.task_alt,
                      warna: warna.tertiary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Judul daftar kegiatan.
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Aktivitas Hari Ini',
                      style: tema.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '$jumlahKegiatan kegiatan',
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: warna.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Menampilkan pesan jika belum ada kegiatan.
              if (data.daftar.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 52,
                          color: warna.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum Ada Kegiatan',
                          style: tema.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mulai catat kegiatan dan transaksi '
                          'tabunganmu hari ini.',
                          textAlign: TextAlign.center,
                          style: tema.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _tambahKegiatan,
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Kegiatan'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (final kegiatan in data.daftar)
                  KegiatanTile(
                    kegiatan: kegiatan,
                    onToggle: () {
                      DbHelper.ubah(kegiatan.salin(selesai: !kegiatan.selesai));
                    },
                    onEdit: () {
                      Navigator.pushNamed(
                        context,
                        '/form',
                        arguments: kegiatan,
                      );
                    },
                    onHapus: () {
                      _konfirmasiHapus(kegiatan);
                    },
                  ),

              // Tombol tambah kegiatan.
              if (data.daftar.isNotEmpty) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _tambahKegiatan,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Tambah Kegiatan Baru'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// Widget statistik yang dapat digunakan kembali.
class _KartuStatistik extends StatelessWidget {
  final String judul;
  final String nilai;
  final IconData ikon;
  final Color warna;

  const _KartuStatistik({
    required this.judul,
    required this.nilai,
    required this.ikon,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ikon, color: warna, size: 28),
            const SizedBox(height: 12),
            Text(
              nilai,
              style: tema.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(judul, style: tema.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
