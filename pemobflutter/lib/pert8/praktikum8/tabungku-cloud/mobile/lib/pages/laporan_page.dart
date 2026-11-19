import 'package:material_ui/material_ui.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/ringkasan_card.dart';

/// Data ringkasan laporan berdasarkan tanggal.
class DataLaporan {
  final Ringkasan hari;
  final Map<String, int> perKategori;
  final List<MapEntry<DateTime, Ringkasan>> tujuhHari;

  const DataLaporan(
      this.hari,
      this.perKategori,
      this.tujuhHari,
      );
}

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  DateTime _tanggal = DateTime.now();
  late Future<DataLaporan> _future;

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

  // Mengambil data laporan dari SQLite.
  Future<DataLaporan> _ambil() async {
    final basis = _tanggal;
    final tgl = fmtTanggal(basis);

    final hari = await DbHelper.ringkasan(tgl);

    final perKategori =
    await DbHelper.pengeluaranPerKategori(tgl);

    final tujuh = <MapEntry<DateTime, Ringkasan>>[];

    for (var i = 0; i < 7; i++) {
      final tanggal = DateTime(
        basis.year,
        basis.month,
        basis.day - i,
      );

      final hasil = await DbHelper.ringkasan(
        fmtTanggal(tanggal),
      );

      tujuh.add(MapEntry(tanggal, hasil));
    }

    return DataLaporan(hari, perKategori, tujuh);
  }

  // Mengganti tanggal laporan dan mengambil data baru.
  void _ganti(DateTime baru) {
    if (!mounted) return;

    setState(() {
      _tanggal = baru;
      _future = _ambil();
    });
  }

  // Memuat ulang laporan setelah data berubah.
  void _muat() {
    _ganti(_tanggal);
  }

  // Menggeser laporan berdasarkan jumlah hari.
  void _geser(int hari) {
    _ganti(
      DateTime(
        _tanggal.year,
        _tanggal.month,
        _tanggal.day + hari,
      ),
    );
  }

  // Menampilkan pemilih tanggal.
  Future<void> _pilihTanggal() async {
    final dipilih = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (dipilih != null && mounted) {
      _ganti(dipilih);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return FutureBuilder<DataLaporan>(
      future: _future,
      builder: (context, snapshot) {
        // Tampilan ketika data gagal dimuat.
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 56,
                    color: warna.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gagal Memuat Laporan',
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
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

        // Tampilan ketika laporan sedang dimuat.
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data!;

        final total7 = data.tujuhHari.fold<int>(
          0,
              (total, item) => total + item.value.tabungan,
        );

        final pemasukan7 = data.tujuhHari.fold<int>(
          0,
              (total, item) => total + item.value.pemasukan,
        );

        final pengeluaran7 = data.tujuhHari.fold<int>(
          0,
              (total, item) => total + item.value.pengeluaran,
        );

        return RefreshIndicator(
          onRefresh: () async {
            _muat();
            await _future;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              100,
            ),
            children: [
              // Header halaman laporan.
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: warna.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.insights_outlined,
                      size: 28,
                      color: warna.onPrimaryContainer,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Laporan Keuangan',
                          style: tema.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Pantau aktivitas dan perkembangan tabunganmu',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: warna.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: _muat,
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
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        tooltip: 'Hari sebelumnya',
                        onPressed: () => _geser(-1),
                      ),

                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _pilihTanggal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: warna.primary,
                                  size: 22,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  tampilTanggal(_tanggal),
                                  textAlign: TextAlign.center,
                                  style: tema.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Ketuk untuk memilih tanggal',
                                  textAlign: TextAlign.center,
                                  style: tema.textTheme.bodySmall?.copyWith(
                                    color: warna.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        tooltip: 'Hari berikutnya',
                        onPressed: () => _geser(1),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Ringkasan laporan sesuai tanggal.
              ValueListenableBuilder<int>(
                valueListenable: targetHarian,
                builder: (context, target, _) {
                  return RingkasanCard(
                    judul: 'Ringkasan Harian',
                    ringkasan: data.hari,
                    target: target,
                  );
                },
              ),

              const SizedBox(height: 20),

              // Pengeluaran berdasarkan kategori.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.pie_chart_outline,
                            color: warna.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pengeluaran per Kategori',
                              style: tema.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      if (data.perKategori.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 44,
                                  color: warna.onSurfaceVariant,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Belum Ada Pengeluaran',
                                  style: tema.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Tidak ada pengeluaran pada tanggal ini.',
                                  textAlign: TextAlign.center,
                                  style: tema.textTheme.bodySmall?.copyWith(
                                    color: warna.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        for (final item
                        in data.perKategori.entries)
                          _BarisKategori(
                            nama: item.key,
                            total: item.value,
                            semua: data.hari.pengeluaran,
                          ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Bagian ringkasan tujuh hari.
              Text(
                'Ringkasan 7 Hari',
                style: tema.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Tabungan 7 Hari',
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: warna.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        rupiah(total7),
                        style: tema.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: total7 >= 0
                              ? Colors.green
                              : warna.error,
                        ),
                      ),

                      const Divider(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: _InfoKeuangan(
                              ikon: Icons.south_west,
                              label: 'Pemasukan',
                              nilai: rupiah(pemasukan7),
                              warna: Colors.green,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _InfoKeuangan(
                              ikon: Icons.north_east,
                              label: 'Pengeluaran',
                              nilai: rupiah(pengeluaran7),
                              warna: warna.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Riwayat keuangan tujuh hari.
              Text(
                'Riwayat Harian',
                style: tema.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              for (final item in data.tujuhHari)
                _KartuRiwayat(
                  tanggal: item.key,
                  ringkasan: item.value,
                ),
            ],
          ),
        );
      },
    );
  }
}

// Widget informasi pemasukan/pengeluaran tujuh hari.
class _InfoKeuangan extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;
  final Color warna;

  const _InfoKeuangan({
    required this.ikon,
    required this.label,
    required this.nilai,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              ikon,
              color: warna,
              size: 18,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: tema.textTheme.bodySmall,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            nilai,
            style: tema.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: warna,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget pengeluaran setiap kategori.
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

    final persentase = semua > 0
        ? (total / semua).clamp(0.0, 1.0).toDouble()
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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

              const SizedBox(width: 8),

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
            borderRadius: BorderRadius.circular(6),
            backgroundColor: warna.surfaceContainerHighest,
            color: warna.primary,
          ),
        ],
      ),
    );
  }
}

// Widget riwayat kegiatan per tanggal.
class _KartuRiwayat extends StatelessWidget {
  final DateTime tanggal;
  final Ringkasan ringkasan;

  const _KartuRiwayat({
    required this.tanggal,
    required this.ringkasan,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: warna.primary,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    tampilTanggal(tanggal),
                    style: tema.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  rupiah(ringkasan.tabungan),
                  style: tema.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ringkasan.tabungan >= 0
                        ? Colors.green
                        : warna.error,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              '${ringkasan.jumlahKegiatan} kegiatan',
              style: tema.textTheme.bodySmall?.copyWith(
                color: warna.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 6),

            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                Text(
                  'Masuk: ${rupiah(ringkasan.pemasukan)}',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),

                Text(
                  'Keluar: ${rupiah(ringkasan.pengeluaran)}',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: warna.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}