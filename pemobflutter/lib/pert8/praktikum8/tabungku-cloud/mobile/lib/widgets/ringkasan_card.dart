import 'package:material_ui/material_ui.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

/// Kartu ringkasan keuangan dan aktivitas TabungKu.
class RingkasanCard extends StatelessWidget {
  final String judul;
  final Ringkasan ringkasan;
  final int? target;

  const RingkasanCard({
    super.key,
    required this.judul,
    required this.ringkasan,
    this.target,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    final r = ringkasan;
    final t = target;
    final saldo = r.tabungan;

    final targetAktif = t != null && t > 0;

    final progres = targetAktif ? (saldo / t).clamp(0.0, 1.0).toDouble() : 0.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header utama kartu ringkasan.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: warna.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: warna.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        judul,
                        style: tema.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: warna.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  'Total Tabungan',
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: warna.onPrimaryContainer,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  rupiah(saldo),
                  style: tema.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: saldo >= 0 ? warna.onPrimaryContainer : warna.error,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  saldo >= 0
                      ? 'Terus tingkatkan kebiasaan menabungmu!'
                      : 'Pengeluaranmu lebih besar dari pemasukan.',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: warna.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          // Statistik aktivitas dan transaksi.
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _InfoRingkasan(
                        ikon: Icons.check_circle_outline,
                        label: 'Kegiatan',
                        nilai: '${r.selesai}/${r.jumlahKegiatan}',
                        warna: warna.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoRingkasan(
                        ikon: Icons.south_west,
                        label: 'Pemasukan',
                        nilai: rupiah(r.pemasukan),
                        warna: Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _InfoRingkasan(
                        ikon: Icons.north_east,
                        label: 'Pengeluaran',
                        nilai: rupiah(r.pengeluaran),
                        warna: warna.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoRingkasan(
                        ikon: Icons.savings_outlined,
                        label: 'Saldo',
                        nilai: rupiah(saldo),
                        warna: saldo >= 0 ? warna.primary : warna.error,
                      ),
                    ),
                  ],
                ),

                // Progress target tabungan harian.
                if (targetAktif) ...[
                  const Divider(height: 32),

                  Row(
                    children: [
                      Icon(Icons.flag_outlined, size: 20, color: warna.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Target Harian',
                          style: tema.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${(progres * 100).toStringAsFixed(0)}%',
                        style: tema.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: warna.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: progres),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, nilai, _) {
                      return LinearProgressIndicator(
                        value: nilai,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: warna.surfaceContainerHighest,
                        color: warna.primary,
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _pesan(saldo, t),
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: warna.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pesan berdasarkan kondisi tabungan dan target.
String _pesan(int tabungan, int target) {
  if (tabungan >= target) {
    return 'Target ${rupiah(target)} tercapai! '
        'Pertahankan kebiasaan menabungmu.';
  }

  if (tabungan < 0) {
    return 'Pengeluaran melebihi pemasukan. '
        'Coba tunda pengeluaran yang belum perlu.';
  }

  return 'Target ${rupiah(target)}: masih kurang '
      '${rupiah(target - tabungan)}.';
}

/// Widget statistik kecil dalam kartu ringkasan.
class _InfoRingkasan extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;
  final Color warna;

  const _InfoRingkasan({
    required this.ikon,
    required this.label,
    required this.nilai,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final skemaWarna = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: skemaWarna.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 22, color: warna),

          const SizedBox(height: 8),

          Text(label, style: tema.textTheme.bodySmall),

          const SizedBox(height: 4),

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
      ),
    );
  }
}
