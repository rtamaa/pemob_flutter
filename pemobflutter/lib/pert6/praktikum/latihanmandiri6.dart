import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final modeGelap = prefs.getBool('modeGelap') ?? false;
  final warnaTema = prefs.getInt('warnaTema') ?? Colors.indigo.value;

  themeMode.value = modeGelap ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = Color(warnaTema);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Praktikum Flutter',
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
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments as Item;

              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return DetailPage(item: item);
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
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

class Item {
  final String nama;
  final IconData ikon;
  final Color warna;

  const Item(this.nama, this.ikon, this.warna);
}

const daftarItem = [
  Item('Flutter', Icons.flutter_dash, Colors.blue),
  Item('Musik', Icons.music_note, Colors.pink),
  Item('Kamera', Icons.camera_alt, Colors.orange),
  Item('Peta', Icons.map, Colors.green),
];

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daftarItem.length,
      itemBuilder: (context, index) {
        final item = daftarItem[index];

        return Card(
          child: ListTile(
            leading: Hero(
              tag: 'ikon-${item.nama}',
              child: Icon(
                item.ikon,
                color: item.warna,
                size: 36,
              ),
            ),
            title: Text(item.nama),
            subtitle: const Text('Ketuk untuk melihat detail'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: item,
              );
            },
          ),
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail ${item.nama}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: Icon(
                item.ikon,
                color: item.warna,
                size: 120,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              item.nama,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Ini adalah halaman detail ${item.nama}.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    const pilihanWarna = [
      Colors.indigo,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.teal,
      Colors.red,
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: themeMode,
            builder: (context, mode, child) {
              return SwitchListTile(
                title: const Text('Tema Gelap'),
                subtitle: const Text('Aktifkan atau nonaktifkan tema gelap'),
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
        const SizedBox(height: 16),
        Text(
          'Warna Tema',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<Color>(
          valueListenable: seedColor,
          builder: (context, warnaAktif, child) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: pilihanWarna.map((warna) {
                final terpilih = warnaAktif.value == warna.value;

                return InkWell(
                  onTap: () async {
                    seedColor.value = warna;

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('warnaTema', warna.value);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: CircleAvatar(
                    backgroundColor: warna,
                    radius: 24,
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
      ],
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab>
    with SingleTickerProviderStateMixin {
  bool _besar = false;
  int _hitung = 0;
  bool _terlihat = true;
  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();

    _putar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'AnimatedContainer',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: _besar ? 200 : 100,
            decoration: BoxDecoration(
              color: _besar ? Colors.orange : Colors.blue,
              borderRadius: BorderRadius.circular(_besar ? 100 : 16),
            ),
            child: const Icon(
              Icons.flutter_dash,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _besar = !_besar;
            });
          },
          child: const Text('Ubah Ukuran dan Warna'),
        ),
        const Divider(height: 32),
        Text(
          'AnimatedSwitcher',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Text(
              '$_hitung',
              key: ValueKey<int>(_hitung),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _hitung++;
            });
          },
          child: const Text('Tambah Angka'),
        ),
        const Divider(height: 32),
        Text(
          'RotationTransition',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: const Icon(
              Icons.settings,
              size: 80,
              color: Colors.indigo,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _putar.stop();
              },
              child: const Text('Berhenti'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                _putar.repeat();
              },
              child: const Text('Putar'),
            ),
          ],
        ),
        const Divider(height: 32),
        Text(
          'AnimatedOpacity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _terlihat ? 1.0 : 0.0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Animasi Transparansi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _terlihat = !_terlihat;
            });
          },
          child: Text(_terlihat ? 'Sembunyikan' : 'Tampilkan'),
        ),
      ],
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
    AnimasiTab(),
    PengaturanTab(),
  ];

  final List<String> _judul = const [
    'Beranda',
    'Animasi',
    'Pengaturan',
  ];

  void _pilihHalaman(int index) {
    Navigator.pop(context);

    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_judul[_index]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Praktikum Flutter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              selected: _index == 0,
              onTap: () => _pilihHalaman(0),
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('Animasi'),
              selected: _index == 1,
              onTap: () => _pilihHalaman(1),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              selected: _index == 2,
              onTap: () => _pilihHalaman(2),
            ),
          ],
        ),
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
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation),
            label: 'Animasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
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
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Halaman yang kamu cari tidak tersedia.'),
            const SizedBox(height: 24),
            ElevatedButton(
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
