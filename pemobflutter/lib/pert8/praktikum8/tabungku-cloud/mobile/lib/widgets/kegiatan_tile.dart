import 'package:material_ui/material_ui.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

/// Kartu aktivitas yang menampilkan informasi kegiatan TabungKu.
class KegiatanTile extends StatelessWidget {
  final Kegiatan kegiatan;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  const KegiatanTile({
    super.key,
    required this.kegiatan,
    required this.onToggle,
    required this.onEdit,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    final selesai = kegiatan.selesai;
    final pemasukan = kegiatan.tipe == Tipe.pemasukan;
    final pengeluaran = kegiatan.tipe == Tipe.pengeluaran;
    final adaTransaksi = kegiatan.tipe != Tipe.tanpa;

    final warnaTransaksi = pemasukan
        ? Colors.green
        : pengeluaran
        ? warna.error
        : warna.primary;

    final ikonTransaksi = pemasukan
        ? Icons.south_west
        : pengeluaran
        ? Icons.north_east
        : Icons.event_note_outlined;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Checkbox untuk menandai kegiatan selesai.
            Checkbox(value: selesai, onChanged: (_) => onToggle()),

            const SizedBox(width: 4),

            // Informasi utama kegiatan.
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kegiatan.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tema.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: selesai
                              ? TextDecoration.lineThrough
                              : null,
                          color: selesai
                              ? warna.onSurfaceVariant
                              : warna.onSurface,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Icon(ikonTransaksi, size: 15, color: warnaTransaksi),

                          const SizedBox(width: 5),

                          Expanded(
                            child: Text(
                              pengeluaran
                                  ? kegiatan.kategori
                                  : pemasukan
                                  ? 'Pemasukan'
                                  : 'Kegiatan',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: warna.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Nominal pemasukan atau pengeluaran.
                      if (adaTransaksi) ...[
                        const SizedBox(height: 6),
                        Text(
                          '${pemasukan ? '+' : '-'}'
                          '${rupiah(kegiatan.nominal)}',
                          style: tema.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: warnaTransaksi,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Tombol untuk mengubah kegiatan.
            IconButton(
              onPressed: onEdit,
              tooltip: 'Edit kegiatan',
              icon: const Icon(Icons.edit_outlined),
              color: warna.primary,
            ),

            // Tombol menghapus kegiatan.
            IconButton(
              onPressed: onHapus,
              tooltip: 'Hapus kegiatan',
              icon: const Icon(Icons.delete_outline),
              color: warna.error,
            ),
          ],
        ),
      ),
    );
  }
}
