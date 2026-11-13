import 'package:flutter/material.dart';

void main() {
  runApp(const TabungKuApp());
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F7F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA8CDB5),
        ),
      ),
      home: const RingkasanPage(),
    );
  }
}

class RingkasanPage extends StatelessWidget {
  const RingkasanPage({super.key});

  // Warna utama aplikasi
  static const hijau = Color(0xFF46745C);
  static const sage = Color(0xFFA8CDB5);
  static const pink = Color(0xFFD98EA9);
  static const teks = Color(0xFF33463B);
  static const abu = Color(0xFF7B8B80);

  // Card informasi tabungan
  Widget kartuTabungan(bool ringkas) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(ringkas ? 14 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama tabungan
            Row(
              children: [
                Icon(
                  Icons.laptop_mac,
                  color: hijau,
                  size: ringkas ? 26 : 30,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tabungan Aktif',
                        style: TextStyle(
                          fontSize: 12,
                          color: abu,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tabungan Laptop',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: teks,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Penyesuaian ukuran tablet
            SizedBox(height: ringkas ? 8 : 20),
            const Divider(height: 1),
            SizedBox(height: ringkas ? 8 : 12),

            // Saldo tabungan
            const Text(
              'Saldo Saat Ini',
              style: TextStyle(
                fontSize: 14,
                color: abu,
              ),
            ),
            SizedBox(height: ringkas ? 2 : 6),
            Text(
              'Rp 3.500.000',
              style: TextStyle(
                fontSize: ringkas ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: hijau,
              ),
            ),

            SizedBox(height: ringkas ? 10 : 24),

            // Target tabungan
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target Tabungan',
                  style: TextStyle(color: abu),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Rp 7.000.000',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: teks,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: ringkas ? 8 : 12),

            // Progres tabungan
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.5,
                minHeight: 10,
                backgroundColor: Color(0xFFFFE5EE),
                valueColor: AlwaysStoppedAnimation<Color>(sage),
              ),
            ),

            SizedBox(height: ringkas ? 6 : 10),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progres Tabungan',
                  style: TextStyle(
                    fontSize: 12,
                    color: abu,
                  ),
                ),
                Text(
                  '50%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: hijau,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Card kategori aktivitas
  Widget kartuKategori({
    required String judul,
    required IconData ikon,
    required Color warna,
    required Color latar,
    required bool ringkas,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: latar,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ringkas ? 10 : 22,
            horizontal: 4,
          ),
          child: Column(
            children: [
              Icon(
                ikon,
                color: warna,
                size: ringkas ? 26 : 36,
              ),
              SizedBox(height: ringkas ? 4 : 10),
              Text(
                judul,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ringkas ? 12 : 14,
                  color: teks,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bagian kategori aktivitas
  Widget kategoriAktivitas(bool ringkas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Aktivitas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: teks,
          ),
        ),

        SizedBox(height: ringkas ? 8 : 14),

        // Tiga Card kategori tetap terpisah
        Row(
          children: [
            kartuKategori(
              judul: 'Menabung',
              ikon: Icons.add_circle_outline,
              warna: hijau,
              latar: const Color(0xFFE5F2E9),
              ringkas: ringkas,
            ),
            const SizedBox(width: 4),
            kartuKategori(
              judul: 'Tarik',
              ikon: Icons.arrow_circle_up_outlined,
              warna: pink,
              latar: const Color(0xFFFFF0F5),
              ringkas: ringkas,
            ),
            const SizedBox(width: 4),
            kartuKategori(
              judul: 'Riwayat',
              ikon: Icons.history,
              warna: hijau,
              latar: const Color(0xFFE5F2E9),
              ringkas: ringkas,
            ),
          ],
        ),
      ],
    );
  }


  // Membuat Card untuk setiap transaksi
  Widget barisTransaksi({
    required String nama,
    required String tanggal,
    required String nominal,
    required bool masuk,
    required bool ringkas,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: ringkas ? 6 : 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(ringkas ? 8 : 16),
        child: Row(
          children: [
            // Ikon transaksi
            Container(
              padding: EdgeInsets.all(ringkas ? 6 : 10),
              decoration: BoxDecoration(
                color: masuk
                    ? const Color(0xFFE5F2E9)
                    : const Color(0xFFFFF0F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                masuk ? Icons.arrow_downward : Icons.arrow_upward,
                color: masuk ? hijau : pink,
                size: ringkas ? 20 : 22,
              ),
            ),

            const SizedBox(width: 12),

            // Nama dan tanggal transaksi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: teks,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tanggal,
                    style: const TextStyle(
                      fontSize: 12,
                      color: abu,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Nominal transaksi
            Flexible(
              child: Text(
                nominal,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: hijau,
                ).copyWith(
                  color: masuk ? hijau : pink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Daftar transaksi dengan Card terpisah
  Widget daftarTransaksi(bool ringkas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Transaksi Terakhir',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: teks,
          ),
        ),

        SizedBox(height: ringkas ? 8 : 14),

        barisTransaksi(
          nama: 'Menabung Bulanan',
          tanggal: '10 November 2026',
          nominal: '+ Rp 500.000',
          masuk: true,
          ringkas: ringkas,
        ),

        barisTransaksi(
          nama: 'Uang Saku',
          tanggal: '5 November 2026',
          nominal: '+ Rp 200.000',
          masuk: true,
          ringkas: ringkas,
        ),

        barisTransaksi(
          nama: 'Penarikan',
          tanggal: '1 November 2026',
          nominal: '- Rp 100.000',
          masuk: false,
          ringkas: ringkas,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bagian atas halaman
      appBar: AppBar(
        title: const Text(
          'Ringkasan Tabungan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: sage,
        foregroundColor: teks,
      ),

      // Menyesuaikan tampilan dengan ukuran layar
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool tablet = constraints.maxWidth >= 600;

          // Tablet dengan tinggi layar pendek memakai
          // jarak dan ukuran Card yang lebih ringkas
          final bool ringkas =
              tablet && constraints.maxHeight < 700;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: tablet ? 700 : 500,
              ),
              child: ListView(
                padding: EdgeInsets.all(
                  ringkas ? 12 : (tablet ? 24 : 16),
                ),
                children: [
                  // Card informasi tabungan
                  kartuTabungan(ringkas),

                  SizedBox(height: ringkas ? 10 : 24),

                  // Kategori aktivitas
                  kategoriAktivitas(ringkas),

                  SizedBox(height: ringkas ? 10 : 24),

                  // Tiga Card transaksi
                  daftarTransaksi(ringkas),

                  SizedBox(height: ringkas ? 4 : 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}