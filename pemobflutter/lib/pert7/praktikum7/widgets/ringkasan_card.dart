
import 'package:flutter/material.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

class RingkasanCard extends StatelessWidget {
  final String judul;
  final Ringkasan ringkasan;
  final int target;

  const RingkasanCard({
    super.key,
    required this.judul,
    required this.ringkasan,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final progres = target > 0
        ? (ringkasan.tabungan / target).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: tema.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Kegiatan',
                    nilai:
                    '${ringkasan.selesai}/${ringkasan.jumlahKegiatan}',
                    ikon: Icons.check_circle_outline,
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Tabungan',
                    nilai: rupiah(ringkasan.tabungan),
                    ikon: Icons.savings_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _InfoItem(
              label: 'Pemasukan',
              nilai: rupiah(ringkasan.pemasukan),
              ikon: Icons.arrow_downward,
              warna: Colors.green,
            ),

            const SizedBox(height: 8),

            _InfoItem(
              label: 'Pengeluaran',
              nilai: rupiah(ringkasan.pengeluaran),
              ikon: Icons.arrow_upward,
              warna: Colors.red,
            ),

            const SizedBox(height: 16),

            Text(
              'Target harian: ${rupiah(target)}',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: progres,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),

            const SizedBox(height: 4),

            Text(
              target <= 0
                  ? 'Target belum diatur'
                  : '${(progres * 100).round()}% dari target',
              style: tema.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String nilai;
  final IconData ikon;
  final Color? warna;

  const _InfoItem({
    required this.label,
    required this.nilai,
    required this.ikon,
    this.warna,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Row(
      children: [
        Icon(
          ikon,
          color: warna ?? tema.colorScheme.primary,
          size: 22,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tema.textTheme.bodySmall,
              ),
              Text(
                nilai,
                style: tema.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
