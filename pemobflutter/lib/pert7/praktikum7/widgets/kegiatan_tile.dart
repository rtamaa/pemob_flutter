
import 'package:flutter/material.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

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

    final warnaTipe = switch (kegiatan.tipe) {
      Tipe.pemasukan => Colors.green,
      Tipe.pengeluaran => Colors.red,
      Tipe.tanpa => tema.colorScheme.primary,
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Checkbox(
          value: kegiatan.selesai,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          kegiatan.judul,
          style: TextStyle(
            decoration: kegiatan.selesai
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: kegiatan.selesai
                ? tema.colorScheme.onSurfaceVariant
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kegiatan.tipe != Tipe.tanpa) ...[
              const SizedBox(height: 4),
              Text(
                '${kegiatan.tipe == Tipe.pemasukan ? 'Pemasukan' : 'Pengeluaran'}'
                    ' • ${rupiah(kegiatan.nominal)}',
                style: TextStyle(
                  color: warnaTipe,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (kegiatan.tipe == Tipe.pengeluaran)
                Text('Kategori: ${kegiatan.kategori}'),
            ],
            const SizedBox(height: 2),
            Text(
              'Tanggal: ${kegiatan.tanggal}',
              style: tema.textTheme.bodySmall,
            ),
          ],
        ),
        isThreeLine: kegiatan.tipe != Tipe.tanpa,
        trailing: PopupMenuButton<String>(
          tooltip: 'Menu kegiatan',
          onSelected: (pilihan) {
            if (pilihan == 'edit') {
              onEdit();
            } else if (pilihan == 'hapus') {
              onHapus();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'hapus',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
