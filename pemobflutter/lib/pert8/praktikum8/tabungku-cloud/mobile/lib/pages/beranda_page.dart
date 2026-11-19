import 'package:material_ui/material_ui.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/kegiatan_tile.dart';
import '../widgets/ringkasan_card.dart';

// Menampung data kegiatan dan ringkasan harian.
class DataHari {
  final List<Kegiatan> daftar;
  final Ringkasan ringkasan;

  const DataHari(this.daftar, this.ringkasan);
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late Future<DataHari> _future;

  @override
  void initState() {
    super.initState();
    _future = _ambil();
    versiData.addListener(_muat);
  }

  @override
  void dispose() {
    versiData.removeListener(_muat);
    super.dispose();
  }

  // Mengambil data kegiatan dan ringkasan dari SQLite.
  Future<DataHari> _ambil() async {
    final tanggal = fmtTanggal(DateTime.now());

    final daftar = await DbHelper.pada(tanggal);
    final ringkasan = await DbHelper.ringkasan(tanggal);

    return DataHari(daftar, ringkasan);
  }

  // Memperbarui data ketika ada perubahan kegiatan.
  void _muat() {
    if (!mounted) return;

    setState(() {
      _future = _ambil();
    });
  }

  // Menampilkan konfirmasi sebelum menghapus kegiatan.
  Future<void> _hapus(Kegiatan k) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: Text('"${k.judul}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ya == true) {
      await DbHelper.hapus(k.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return FutureBuilder<DataHari>(
      future: _future,
      builder: (context, snapshot) {
        // Tampilan ketika terjadi kesalahan.
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 56, color: warna.error),
                  const SizedBox(height: 12),
                  Text('Gagal memuat data', style: tema.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: tema.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _muat,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        // Tampilan ketika data sedang dimuat.
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final jumlahKegiatan = data.ringkasan.jumlahKegiatan;
        final kegiatanSelesai = data.ringkasan.selesai;

        return RefreshIndicator(
          onRefresh: () async {
            _muat();
            await _future;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // Header dashboard.
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: warna.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.savings_outlined,
                      color: warna.onPrimaryContainer,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard TabungKu',
                          style: tema.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tampilTanggal(DateTime.now()),
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: warna.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: _muat,
                    tooltip: 'Perbarui data',
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Ringkasan tabungan harian.
              ValueListenableBuilder<int>(
                valueListenable: targetHarian,
                builder: (context, target, _) {
                  return RingkasanCard(
                    judul: 'Ringkasan Hari Ini',
                    ringkasan: data.ringkasan,
                    target: target,
                  );
                },
              ),

              const SizedBox(height: 20),

              // Statistik aktivitas harian.
              Row(
                children: [
                  Expanded(
                    child: _KartuStatistik(
                      ikon: Icons.event_note_outlined,
                      judul: 'Total Kegiatan',
                      nilai: '$jumlahKegiatan',
                      warna: warna.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _KartuStatistik(
                      ikon: Icons.task_alt,
                      judul: 'Selesai',
                      nilai: '$kegiatanSelesai',
                      warna: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Judul daftar aktivitas.
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Aktivitas Hari Ini',
                      style: tema.textTheme.titleMedium?.copyWith(
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

              // Tampilan ketika belum ada kegiatan.
              if (data.daftar.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 56,
                          color: warna.primary,
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Belum Ada Aktivitas',
                          style: tema.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Mulai catat kegiatan, pemasukan, '
                          'dan pengeluaranmu hari ini.',
                          textAlign: TextAlign.center,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: warna.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 18),

                        FilledButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/form');
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Kegiatan'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Menampilkan daftar kegiatan.
                for (final k in data.daftar)
                  KegiatanTile(
                    kegiatan: k,
                    onToggle: () => DbHelper.ubah(k.salin(selesai: !k.selesai)),
                    onEdit: () {
                      Navigator.pushNamed(context, '/form', arguments: k);
                    },
                    onHapus: () => _hapus(k),
                  ),
            ],
          ),
        );
      },
    );
  }
}

// Widget statistik untuk dashboard Beranda.
class _KartuStatistik extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String nilai;
  final Color warna;

  const _KartuStatistik({
    required this.ikon,
    required this.judul,
    required this.nilai,
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
            Icon(ikon, size: 26, color: warna),

            const SizedBox(height: 12),

            Text(
              nilai,
              style: tema.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: warna,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tema.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
