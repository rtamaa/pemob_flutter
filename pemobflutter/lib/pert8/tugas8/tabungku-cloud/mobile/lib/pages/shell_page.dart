import 'package:material_ui/material_ui.dart';

import 'beranda_page.dart';
import 'laporan_page.dart';
import 'pengaturan_page.dart';

/// Halaman utama yang mengatur navigasi aplikasi TabungKu.
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _halamanAktif = 0;

  // Daftar halaman yang ditampilkan melalui navigasi bawah.
  static const List<Widget> _daftarHalaman = [
    BerandaPage(),
    LaporanPage(),
    PengaturanPage(),
  ];

  static const List<String> _namaHalaman = [
    'Beranda',
    'Laporan',
    'Pengaturan',
  ];

  void _pindahHalaman(int index) {
    if (_halamanAktif == index) return;

    setState(() {
      _halamanAktif = index;
    });
  }

  void _bukaFormKegiatan() {
    Navigator.pushNamed(context, '/form');
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.savings_outlined,
                color: warna.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
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
                  Text(
                    _namaHalaman[_halamanAktif],
                    style: tema.textTheme.bodySmall?.copyWith(
                      color: warna.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (_halamanAktif == 0)
            IconButton(
              tooltip: 'Lihat status server',
              icon: const Icon(Icons.cloud_outlined),
              onPressed: () {
                Navigator.pushNamed(context, '/status');
              },
            ),
          const SizedBox(width: 8),
        ],
      ),

      // IndexedStack mempertahankan state setiap halaman.
      body: IndexedStack(
        index: _halamanAktif,
        children: _daftarHalaman,
      ),

      // Tombol tambah kegiatan khusus halaman beranda.
      floatingActionButton: _halamanAktif == 0
          ? FloatingActionButton.extended(
        onPressed: _bukaFormKegiatan,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
        tooltip: 'Tambah kegiatan baru',
      )
          : null,

      // Navigasi utama aplikasi.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _halamanAktif,
        onDestinationSelected: _pindahHalaman,
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