import 'package:material_ui/material_ui.dart';

import 'beranda_page.dart';
import 'laporan_page.dart';
import 'pengaturan_page.dart';

/// Kerangka utama aplikasi TabungKu Cloud.
/// Menampilkan Beranda, Laporan, dan Pengaturan.
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  // Menyimpan halaman agar state tidak hilang
  // ketika pengguna berpindah tab.
  static const _halaman = [BerandaPage(), LaporanPage(), PengaturanPage()];

  // Keterangan sesuai tab yang sedang aktif.
  static const _subjudul = [
    'Kelola aktivitas dan tabunganmu',
    'Pantau perkembangan keuangan',
    'Sesuaikan preferensi aplikasi',
  ];

  // Mengganti halaman melalui navigasi bawah.
  void _pindahHalaman(int index) {
    setState(() {
      _index = index;
    });
  }

  // Membuka form untuk menambahkan kegiatan.
  void _tambahKegiatan() {
    Navigator.pushNamed(context, '/form');
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      // AppBar utama aplikasi.
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: 16,
        centerTitle: false,
        title: Row(
          children: [
            // Logo aplikasi TabungKu.
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.savings_outlined,
                color: warna.onPrimaryContainer,
                size: 25,
              ),
            ),

            const SizedBox(width: 12),

            // Nama aplikasi dan keterangan halaman.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TabungKu',
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    _subjudul[_index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: warna.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Tombol status server hanya pada tab Beranda.
        actions: [
          if (_index == 0)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/status');
              },
              tooltip: 'Status Server',
              icon: const Icon(Icons.dns_outlined),
            ),
          const SizedBox(width: 8),
        ],
      ),

      // Menjaga state ketiga halaman saat berpindah tab.
      body: IndexedStack(index: _index, children: _halaman),

      // Tombol tambah kegiatan pada halaman Beranda.
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: _tambahKegiatan,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Kegiatan'),
              tooltip: 'Tambah kegiatan baru',
            )
          : null,

      // Navigasi bawah aplikasi.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _pindahHalaman,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Laporan',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
