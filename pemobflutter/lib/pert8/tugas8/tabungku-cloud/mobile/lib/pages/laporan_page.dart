import 'package:material_ui/material_ui.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/ringkasan_card.dart';

// Menampung data laporan berdasarkan tanggal yang dipilih.
class DataLaporan {
  final Ringkasan hari;
  final Map<String, int> perKategori;
  final List<MapEntry<DateTime, Ringkasan>> tujuhHari;

  const DataLaporan({
    required this.hari,
    required this.perKategori,
    required this.tujuhHari,
  });
}

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  DateTime _tanggal = DateTime.now();
  late Future<DataLaporan> _dataLaporan;

  @override
  void initState() {
    super.initState();
    _dataLaporan = _muatLaporan();
    versiData.addListener(_perbaruiLaporan);
  }

  @override
  void dispose() {
    versiData.removeListener(_perbaruiLaporan);
    super.dispose();
  }

  // Memuat laporan harian, kategori, dan riwayat 7 hari.
  Future<DataLaporan> _muatLaporan() async {
    final tanggalDipilih = _tanggal;
    final tanggalDatabase = fmtTanggal(tanggalDipilih);

    final ringkasanHari = await DbHelper.ringkasan(tanggalDatabase);
    final kategori = await DbHelper.pengeluaranPerKategori(tanggalDatabase);

    final riwayat = <MapEntry<DateTime, Ringkasan>>[];

    for (var i = 0; i < 7; i++) {
      final tanggal = DateTime(
        tanggalDipilih.year,
        tanggalDipilih.month,
        tanggalDipilih.day - i,
      );

      final ringkasan = await DbHelper.ringkasan(fmtTanggal(tanggal));

      riwayat.add(MapEntry(tanggal, ringkasan));
    }

    return DataLaporan(
      hari: ringkasanHari,
      perKategori: kategori,
      tujuhHari: riwayat,
    );
  }

  // Memperbarui tampilan ketika isi database berubah.
  void _perbaruiLaporan() {
    if (!mounted) return;

    setState(() {
      _dataLaporan = _muatLaporan();
    });
  }

  // Mengubah tanggal laporan.
  void _gantiTanggal(DateTime tanggalBaru) {
    setState(() {
      _tanggal = tanggalBaru;
      _dataLaporan = _muatLaporan();
    });
  }

  // Berpindah ke tanggal sebelumnya atau berikutnya.
  void _geserTanggal(int jumlahHari) {
    final tanggalBaru = DateTime(
      _tanggal.year,
      _tanggal.month,
      _tanggal.day + jumlahHari,
    );

    _gantiTanggal(tanggalBaru);
  }

  // Membuka kalender untuk memilih tanggal laporan.
  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (hasil != null && mounted) {
      _gantiTanggal(hasil);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return FutureBuilder<DataLaporan>(
      future: _dataLaporan,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: warna.error, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Gagal Memuat Laporan',
                    style: tema.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _perbaruiLaporan,
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

        final laporan = snapshot.data!;

        final totalTabungan = laporan.tujuhHari.fold<int>(
          0,
          (jumlah, data) => jumlah + data.value.tabungan,
        );

        final totalPemasukan = laporan.tujuhHari.fold<int>(
          0,
          (jumlah, data) => jumlah + data.value.pemasukan,
        );

        final totalPengeluaran = laporan.tujuhHari.fold<int>(
          0,
          (jumlah, data) => jumlah + data.value.pengeluaran,
        );

        return RefreshIndicator(
          onRefresh: () async {
            _perbaruiLaporan();
            await _dataLaporan;
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // Header dashboard laporan.
              Row(
                children: [
                  Icon(
                    Icons.insert_chart_outlined,
                    size: 32,
                    color: warna.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Laporan Keuangan',
                          style: tema.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Pantau perkembangan tabunganmu',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: warna.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _perbaruiLaporan,
                    tooltip: 'Perbarui laporan',
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Navigasi tanggal laporan.
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _geserTanggal(-1),
                        tooltip: 'Hari sebelumnya',
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _pilihTanggal,
                          icon: const Icon(Icons.calendar_month),
                          label: Text(
                            tampilTanggal(_tanggal),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _geserTanggal(1),
                        tooltip: 'Hari berikutnya',
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Ringkasan laporan berdasarkan tanggal.
              ValueListenableBuilder<int>(
                valueListenable: targetHarian,
                builder: (context, target, _) {
                  return RingkasanCard(
                    judul: 'Ringkasan Keuangan',
                    ringkasan: laporan.hari,
                    target: target,
                  );
                },
              ),

              const SizedBox(height: 24),

              // Pengeluaran berdasarkan kategori.
              _JudulLaporan(
                judul: 'Pengeluaran per Kategori',
                ikon: Icons.pie_chart_outline,
              ),

              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: laporan.perKategori.isEmpty
                      ? Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 40,
                              color: warna.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Belum ada pengeluaran pada tanggal ini.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            for (final kategori in laporan.perKategori.entries)
                              _BarisKategori(
                                nama: kategori.key,
                                total: kategori.value,
                                semua: laporan.hari.pengeluaran,
                              ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Ringkasan keuangan 7 hari.
              _JudulLaporan(judul: 'Ringkasan 7 Hari', ikon: Icons.trending_up),

              const SizedBox(height: 12),

              Card(
                color: warna.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Tabungan',
                        style: tema.textTheme.titleSmall?.copyWith(
                          color: warna.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rupiah(totalTabungan),
                        style: tema.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: totalTabungan >= 0
                              ? warna.onPrimaryContainer
                              : warna.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoKeuangan(
                              judul: 'Pemasukan',
                              nominal: totalPemasukan,
                              ikon: Icons.south_west,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoKeuangan(
                              judul: 'Pengeluaran',
                              nominal: totalPengeluaran,
                              ikon: Icons.north_east,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Daftar riwayat keuangan 7 hari.
              _JudulLaporan(judul: 'Riwayat Harian', ikon: Icons.history),

              const SizedBox(height: 12),

              for (final data in laporan.tujuhHari)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: warna.primaryContainer,
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: warna.onPrimaryContainer,
                      ),
                    ),
                    title: Text(tampilTanggal(data.key)),
                    subtitle: Text(
                      '${data.value.jumlahKegiatan} kegiatan\n'
                      'Masuk: ${rupiah(data.value.pemasukan)}\n'
                      'Keluar: ${rupiah(data.value.pengeluaran)}',
                    ),
                    isThreeLine: true,
                    trailing: SizedBox(
                      width: 105,
                      child: Text(
                        rupiah(data.value.tabungan),
                        textAlign: TextAlign.end,
                        style: tema.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: data.value.tabungan >= 0
                              ? Colors.green
                              : warna.error,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Widget untuk menampilkan judul setiap bagian laporan.
class _JudulLaporan extends StatelessWidget {
  final String judul;
  final IconData ikon;

  const _JudulLaporan({required this.judul, required this.ikon});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Row(
      children: [
        Icon(ikon, color: warna.primary),
        const SizedBox(width: 8),
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

// Widget informasi pemasukan dan pengeluaran.
class _InfoKeuangan extends StatelessWidget {
  final String judul;
  final int nominal;
  final IconData ikon;

  const _InfoKeuangan({
    required this.judul,
    required this.nominal,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(ikon, size: 16, color: warna.onPrimaryContainer),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                judul,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: warna.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          rupiah(nominal),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: tema.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: warna.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}

// Widget progress pengeluaran berdasarkan kategori.
class _BarisKategori extends StatelessWidget {
  final String nama;
  final int total;
  final int semua;

  const _BarisKategori({
    required this.nama,
    required this.total,
    required this.semua,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    final persentase = semua <= 0 ? 0.0 : (total / semua).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nama,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                rupiah(total),
                style: tema.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: persentase,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: warna.primary,
            backgroundColor: warna.surfaceContainerHighest,
          ),
          const SizedBox(height: 4),
          Text(
            '${(persentase * 100).toStringAsFixed(1)}% dari total pengeluaran',
            style: tema.textTheme.bodySmall?.copyWith(
              color: warna.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
