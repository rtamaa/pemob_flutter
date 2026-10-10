import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);
final favoritWisata = ValueNotifier<Set<String>>({});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final modeGelap = prefs.getBool('modeGelap') ?? false;
  final warnaTema = prefs.getInt('warnaTema') ?? Colors.indigo.value;
  final daftarFavorit = prefs.getStringList('favoritWisata') ?? [];

  themeMode.value = modeGelap ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = Color(warnaTema);
  favoritWisata.value = daftarFavorit.toSet();

  runApp(const GaleriApp());
}

class Wisata {
  final String id;
  final String nama;
  final String lokasi;
  final String deskripsi;
  final IconData ikon;

  const Wisata({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.ikon,
  });
}

const daftarWisata = [
  Wisata(
    id: '1',
    nama: 'Raja Ampat',
    lokasi: 'Papua Barat Daya',
    deskripsi:
    'Raja Ampat terkenal dengan gugusan pulau yang indah, air laut jernih, dan keanekaragaman hayati bawah laut. Tempat ini cocok untuk snorkeling, menyelam, dan menikmati pemandangan alam.',
    ikon: Icons.sailing,
  ),
  Wisata(
    id: '2',
    nama: 'Candi Borobudur',
    lokasi: 'Magelang, Jawa Tengah',
    deskripsi:
    'Candi Borobudur merupakan warisan budaya yang terkenal dengan arsitektur batu dan relief bersejarah. Pengunjung dapat mempelajari sejarah sekaligus menikmati pemandangan di sekitar candi.',
    ikon: Icons.account_balance,
  ),
  Wisata(
    id: '3',
    nama: 'Gunung Bromo',
    lokasi: 'Jawa Timur',
    deskripsi:
    'Gunung Bromo menawarkan pemandangan pegunungan, lautan pasir, dan matahari terbit yang menawan. Kawasan ini menjadi salah satu tujuan wisata alam populer di Indonesia.',
    ikon: Icons.landscape,
  ),
  Wisata(
    id: '4',
    nama: 'Danau Toba',
    lokasi: 'Sumatera Utara',
    deskripsi:
    'Danau Toba merupakan danau vulkanik besar dengan panorama perbukitan dan Pulau Samosir. Wisatawan dapat menikmati suasana alam dan mengenal kebudayaan Batak.',
    ikon: Icons.water,
  ),
  Wisata(
    id: '5',
    nama: 'Labuan Bajo',
    lokasi: 'Nusa Tenggara Timur',
    deskripsi:
    'Labuan Bajo merupakan pintu gerbang menuju Taman Nasional Komodo. Kawasan ini terkenal dengan pulau-pulau eksotis, pantai, dan pemandangan laut yang memukau.',
    ikon: Icons.beach_access,
  ),
  Wisata(
    id: '6',
    nama: 'Kawah Ijen',
    lokasi: 'Jawa Timur',
    deskripsi:
    'Kawah Ijen terkenal dengan danau kawah berwarna biru kehijauan dan fenomena api biru yang dapat terlihat dalam kondisi tertentu. Kawasan ini menawarkan pengalaman wisata alam pegunungan.',
    ikon: Icons.terrain,
  ),
];

Future<void> ubahFavorit(String id) async {
  final favoritBaru = Set<String>.from(favoritWisata.value);

  if (favoritBaru.contains(id)) {
    favoritBaru.remove(id);
  } else {
    favoritBaru.add(id);
  }

  favoritWisata.value = favoritBaru;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    'favoritWisata',
    favoritBaru.toList(),
  );
}

class GaleriApp extends StatelessWidget {
  const GaleriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Galeri Wisata Indonesia',
          themeMode: themeMode.value,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor.value,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor.value,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final wisata = settings.arguments as Wisata;

              return MaterialPageRoute(
                settings: settings,
                builder: (context) => DetailPage(wisata: wisata),
              );
            }

            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const NotFoundPage(),
            );
          },
        );
      },
    );
  }
}

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  final List<Widget> _halaman = const [
    BerandaTab(),
    FavoritTab(),
    PengaturanTab(),
  ];

  final List<String> _judul = const [
    'Galeri Wisata',
    'Wisata Favorit',
    'Pengaturan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_judul[_index]),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _index,
        children: _halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jelajahi Indonesia',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Temukan destinasi menarik untuk perjalananmu.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: warna.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pesona Nusantara',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: warna.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Inspirasi perjalanan alam dan budaya.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color: warna.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.travel_explore,
                        size: 64,
                        color: warna.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Destinasi Pilihan',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AnimasiWisataPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.animation),
                    label: const Text('Lihat Demo Animasi'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return KartuWisata(wisata: daftarWisata[index]);
              },
              childCount: daftarWisata.length,
            ),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }
}

class KartuWisata extends StatelessWidget {
  final Wisata wisata;

  const KartuWisata({
    super.key,
    required this.wisata,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: wisata,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'wisata-${wisata.id}',
                child: Container(
                  color: warna.primaryContainer,
                  child: Icon(
                    wisata.ikon,
                    size: 72,
                    color: warna.primary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 6, 4),
              child: Text(
                wisata.nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 6, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      wisata.lokasi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  ValueListenableBuilder<Set<String>>(
                    valueListenable: favoritWisata,
                    builder: (context, favorit, child) {
                      final aktif = favorit.contains(wisata.id);

                      return IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => ubahFavorit(wisata.id),
                        icon: Icon(
                          aktif ? Icons.favorite : Icons.favorite_border,
                          color: aktif ? warna.error : warna.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritTab extends StatelessWidget {
  const FavoritTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: favoritWisata,
      builder: (context, favorit, child) {
        final daftar = daftarWisata
            .where((wisata) => favorit.contains(wisata.id))
            .toList();

        if (daftar.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 76,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada wisata favorit',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan ikon hati pada destinasi yang kamu sukai.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: daftar.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            return KartuWisata(wisata: daftar[index]);
          },
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final Wisata wisata;

  const DetailPage({
    super.key,
    required this.wisata,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(wisata.nama),
        actions: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: favoritWisata,
            builder: (context, favorit, child) {
              final aktif = favorit.contains(wisata.id);

              return IconButton(
                onPressed: () => ubahFavorit(wisata.id),
                icon: Icon(
                  aktif ? Icons.favorite : Icons.favorite_border,
                  color: aktif ? warna.error : warna.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'wisata-${wisata.id}',
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                wisata.ikon,
                size: 140,
                color: warna.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            wisata.nama,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: warna.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  wisata.lokasi,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Tentang Destinasi',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            wisata.deskripsi,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.7,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => ubahFavorit(wisata.id),
            icon: const Icon(Icons.favorite),
            label: const Text('Tambah / Hapus Favorit'),
          ),
        ],
      ),
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    const pilihanWarna = [
      Colors.indigo,
      Colors.teal,
      Colors.deepOrange,
      Colors.purple,
      Colors.blue,
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Pengaturan Tampilan',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: themeMode,
            builder: (context, mode, child) {
              return SwitchListTile(
                title: const Text('Mode Gelap'),
                subtitle: const Text(
                  'Simpan pilihan tema untuk penggunaan berikutnya',
                ),
                secondary: Icon(
                  mode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                value: mode == ThemeMode.dark,
                onChanged: (value) async {
                  themeMode.value =
                  value ? ThemeMode.dark : ThemeMode.light;

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('modeGelap', value);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Pilih Warna Tema',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih warna yang ingin digunakan pada aplikasi.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<Color>(
          valueListenable: seedColor,
          builder: (context, warnaAktif, child) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: pilihanWarna.map((pilihan) {
                final terpilih = warnaAktif.value == pilihan.value;

                return InkWell(
                  onTap: () async {
                    seedColor.value = pilihan;

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('warnaTema', pilihan.value);
                  },
                  borderRadius: BorderRadius.circular(32),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: pilihan,
                    child: terpilih
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                        : null,
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 32),
        Card(
          child: ListTile(
            leading: Icon(
              Icons.info_outline,
              color: warna.primary,
            ),
            title: const Text('Galeri Wisata Indonesia'),
            subtitle: const Text(
              'Aplikasi katalog destinasi wisata interaktif',
            ),
          ),
        ),
      ],
    );
  }
}

class AnimasiWisataPage extends StatefulWidget {
  const AnimasiWisataPage({super.key});

  @override
  State<AnimasiWisataPage> createState() => _AnimasiWisataPageState();
}

class _AnimasiWisataPageState extends State<AnimasiWisataPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotasi;
  bool _besar = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rotasi = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animasi Wisata'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Animasi Eksplisit',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _rotasi,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotasi.value * 6.283185307,
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.explore,
                      size: 120,
                      color: warna.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'AnimationController dan AnimatedBuilder',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      if (_controller.isAnimating) {
                        _controller.stop();
                      } else {
                        _controller.repeat();
                      }
                      setState(() {});
                    },
                    child: Text(
                      _controller.isAnimating ? 'Berhenti' : 'Putar',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Animasi Implisit',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    width: _besar ? 200 : 120,
                    height: _besar ? 200 : 120,
                    decoration: BoxDecoration(
                      color: warna.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        _besar ? 100 : 24,
                      ),
                    ),
                    child: Icon(
                      Icons.landscape,
                      size: _besar ? 100 : 64,
                      color: warna.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'AnimatedContainer',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _besar = !_besar;
                      });
                    },
                    child: Text(
                      _besar ? 'Perkecil' : 'Perbesar',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Tidak Ditemukan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 72),
            const SizedBox(height: 16),
            Text(
              'Halaman tidak ditemukan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (route) => false,
                );
              },
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}