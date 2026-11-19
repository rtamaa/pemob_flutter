import 'package:material_ui/material_ui.dart';

import '../state/pengaturan.dart';
import '../utils/format.dart';

/// Halaman untuk mengatur preferensi aplikasi TabungKu.
class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor, targetHarian]),
      builder: (context, _) {
        final tema = Theme.of(context);
        final warna = tema.colorScheme;
        final modeGelap = themeMode.value == ThemeMode.dark;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Header halaman pengaturan.
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: warna.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.tune_outlined,
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
                        'Pengaturan TabungKu',
                        style: tema.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sesuaikan aplikasi dengan kebutuhanmu',
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

            // Informasi singkat aplikasi.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: warna.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.savings_outlined,
                        size: 28,
                        color: warna.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TabungKu Cloud',
                            style: tema.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kelola aktivitas dan tabungan harianmu',
                            style: tema.textTheme.bodySmall?.copyWith(
                              color: warna.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pengaturan target tabungan.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _JudulPengaturan(
                      ikon: Icons.flag_outlined,
                      judul: 'Target Tabungan',
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Target tabungan harian',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: warna.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      rupiah(targetHarian.value),
                      style: tema.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: warna.primary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Logika slider tetap mengikuti kode dosen.
                    Slider(
                      value: targetHarian.value.toDouble(),
                      min: 0,
                      max: 100000,
                      divisions: 20,
                      label: rupiah(targetHarian.value),
                      onChanged: (nilai) {
                        targetHarian.value = nilai.round();
                      },
                      onChangeEnd: (nilai) {
                        simpanTarget(nilai.round());
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rp 0', style: tema.textTheme.bodySmall),
                          Text('Rp 100.000', style: tema.textTheme.bodySmall),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: warna.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 20,
                            color: warna.onPrimaryContainer,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Tentukan target harian untuk '
                              'membantu memantau kebiasaan menabung.',
                              style: tema.textTheme.bodySmall?.copyWith(
                                color: warna.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pengaturan tampilan.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _JudulPengaturan(
                      ikon: Icons.palette_outlined,
                      judul: 'Tampilan Aplikasi',
                    ),

                    const SizedBox(height: 12),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: Icon(
                        modeGelap
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: warna.primary,
                      ),
                      title: const Text('Mode Gelap'),
                      subtitle: Text(
                        modeGelap
                            ? 'Tampilan gelap sedang aktif'
                            : 'Tampilan terang sedang aktif',
                      ),
                      value: modeGelap,
                      onChanged: simpanGelap,
                    ),

                    const Divider(height: 28),

                    Text(
                      'Warna Tema',
                      style: tema.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Pilih warna utama yang kamu sukai.',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: warna.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Pilihan warna tetap menggunakan
                    // pilihanWarna dan simpanWarna.
                    Wrap(
                      spacing: 14,
                      runSpacing: 12,
                      children: [
                        for (var i = 0; i < pilihanWarna.length; i++)
                          _PilihanWarna(
                            warna: pilihanWarna[i],
                            terpilih: seedColor.value == pilihanWarna[i],
                            onTap: () => simpanWarna(i),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Informasi koneksi backend.
            Text(
              'Koneksi & Server',
              style: tema.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: warna.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.dns_outlined,
                    color: warna.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  'Status Server',
                  style: tema.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Periksa koneksi FastAPI dan MySQL'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, '/status');
                },
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                'TabungKu Cloud • Praktikum 8',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: warna.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget judul setiap kelompok pengaturan.
class _JudulPengaturan extends StatelessWidget {
  final IconData ikon;
  final String judul;

  const _JudulPengaturan({required this.ikon, required this.judul});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Row(
      children: [
        Icon(ikon, size: 22, color: warna.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            judul,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget pemilih warna tema.
class _PilihanWarna extends StatelessWidget {
  final Color warna;
  final bool terpilih;
  final VoidCallback onTap;

  const _PilihanWarna({
    required this.warna,
    required this.terpilih,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: terpilih ? 'Warna terpilih' : 'Pilih warna tema',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: terpilih ? warna : Colors.transparent,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            backgroundColor: warna,
            child: terpilih
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}
