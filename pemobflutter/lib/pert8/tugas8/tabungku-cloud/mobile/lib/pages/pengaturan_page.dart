import 'package:material_ui/material_ui.dart';

import '../config/api_config.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        themeMode,
        seedColor,
        targetHarian,
        apiUrl,
      ]),
      builder: (context, _) {
        final tema = Theme.of(context);
        final warna = tema.colorScheme;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Header halaman pengaturan.
            Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 32,
                  color: warna.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengaturan TabungKu',
                        style: tema.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

            // Kartu informasi aplikasi.
            Card(
              color: warna.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: warna.primary,
                      child: Icon(
                        Icons.savings_outlined,
                        size: 30,
                        color: warna.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TabungKu Cloud',
                            style: tema.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: warna.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Catat kegiatan dan kelola keuanganmu '
                                'dalam satu aplikasi.',
                            style: tema.textTheme.bodySmall?.copyWith(
                              color: warna.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bagian target tabungan.
            _JudulPengaturan(
              judul: 'Target Tabungan',
              ikon: Icons.flag_outlined,
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target tabungan harian',
                      style: tema.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rupiah(targetHarian.value),
                      style: tema.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: warna.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: targetHarian.value
                          .toDouble()
                          .clamp(0.0, 100000.0),
                      min: 0,
                      max: 100000,
                      divisions: 20,
                      label: rupiah(targetHarian.value),
                      onChanged: (v) {
                        targetHarian.value = v.round();
                      },
                      onChangeEnd: (v) {
                        simpanTarget(v.round());
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rupiah(0),
                          style: tema.textTheme.bodySmall,
                        ),
                        Text(
                          rupiah(100000),
                          style: tema.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bagian tampilan aplikasi.
            _JudulPengaturan(
              judul: 'Tampilan Aplikasi',
              ikon: Icons.palette_outlined,
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      secondary: Icon(
                        Icons.dark_mode_outlined,
                        color: warna.primary,
                      ),
                      title: const Text('Mode Gelap'),
                      subtitle: const Text(
                        'Aktifkan tampilan gelap pada aplikasi',
                      ),
                      value: themeMode.value == ThemeMode.dark,
                      onChanged: simpanGelap,
                    ),

                    const Divider(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Warna Tema',
                        style: tema.textTheme.titleSmall,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Wrap(
                        spacing: 14,
                        runSpacing: 12,
                        children: [
                          for (var i = 0; i < pilihanWarna.length; i++)
                            Tooltip(
                              message: 'Warna tema ${i + 1}',
                              child: GestureDetector(
                                onTap: () => simpanWarna(i),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: seedColor.value ==
                                          pilihanWarna[i]
                                          ? warna.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: pilihanWarna[i],
                                    child: seedColor.value == pilihanWarna[i]
                                        ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bagian koneksi server.
            _JudulPengaturan(
              judul: 'Koneksi Server',
              ikon: Icons.cloud_outlined,
            ),

            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: warna.primaryContainer,
                      child: Icon(
                        Icons.link,
                        color: warna.onPrimaryContainer,
                      ),
                    ),
                    title: const Text('Alamat API'),
                    subtitle: Text(
                      apiUrl.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: warna.primaryContainer,
                      child: Icon(
                        Icons.dns_outlined,
                        color: warna.onPrimaryContainer,
                      ),
                    ),
                    title: const Text('Status Server'),
                    subtitle: const Text(
                      'Periksa koneksi ke backend TabungKu',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(context, '/status');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Alamat API menggunakan konfigurasi bawaan aplikasi. '
                    'Untuk mengganti alamat server, gunakan parameter '
                    '--dart-define=API_URL saat menjalankan Flutter.',
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

// Widget judul yang digunakan untuk setiap bagian pengaturan.
class _JudulPengaturan extends StatelessWidget {
  final String judul;
  final IconData ikon;

  const _JudulPengaturan({
    required this.judul,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Row(
      children: [
        Icon(
          ikon,
          color: warna.primary,
          size: 24,
        ),
        const SizedBox(width: 10),
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