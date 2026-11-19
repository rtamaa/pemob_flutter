import 'package:material_ui/material_ui.dart';

import 'models/kegiatan.dart';
import 'pages/form_kegiatan_page.dart';
import 'pages/shell_page.dart';
import 'pages/status_server_page.dart';
import 'state/pengaturan.dart';

// Titik awal aplikasi TabungKu.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Membaca pengaturan tersimpan sebelum aplikasi ditampilkan.
  await muatPengaturan();

  runApp(const MyApp());
}

// Mengatur tampilan tema terang dan gelap.
ThemeData buatTema(Color warnaUtama, Brightness mode) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: warnaUtama,
    brightness: mode,
    scaffoldBackgroundColor: mode == Brightness.light
        ? const Color(0xFFF7F9FC)
        : null,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
}

// Widget utama yang mengatur tema dan navigasi.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        themeMode,
        seedColor,
      ]),
      builder: (context, _) {
        return MaterialApp(
          title: 'TabungKu Cloud',
          debugShowCheckedModeBanner: false,

          // Tema mengikuti preferensi pengguna.
          theme: buatTema(
            seedColor.value,
            Brightness.light,
          ),
          darkTheme: buatTema(
            seedColor.value,
            Brightness.dark,
          ),
          themeMode: themeMode.value,

          // Halaman awal.
          initialRoute: '/',

          // Navigasi utama aplikasi.
          routes: {
            '/': (context) => const ShellPage(),
            '/status': (context) => const StatusServerPage(),
          },

          // Navigasi untuk membuat atau mengubah kegiatan.
          onGenerateRoute: (settings) {
            if (settings.name == '/form') {
              final kegiatan = settings.arguments as Kegiatan?;

              return MaterialPageRoute(
                builder: (context) => FormKegiatanPage(
                  kegiatan: kegiatan,
                ),
                settings: settings,
              );
            }

            return null;
          },
        );
      },
    );
  }
}