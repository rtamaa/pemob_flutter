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

  // Membuat tampilan untuk setiap transaksi
  Widget barisTransaksi({
    required String nama,
    required String tanggal,
    required String nominal,
    required bool masuk,
  }) {
    const hijau = Color(0xFF46745C);
    const pink = Color(0xFFD98EA9);
    const teks = Color(0xFF33463B);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            masuk ? Icons.arrow_downward : Icons.arrow_upward,
            color: masuk ? hijau : pink,
          ),
          const SizedBox(width: 12),
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
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              nominal,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: masuk ? hijau : pink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const hijau = Color(0xFF46745C);
    const sage = Color(0xFFA8CDB5);
    const pink = Color(0xFFD98EA9);
    const teks = Color(0xFF33463B);
    const abu = Color(0xFF7B8B80);

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

      // ListView agar halaman bisa digulir
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Card informasi tabungan
              Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama tabungan
                      const Row(
                        children: [
                          Icon(
                            Icons.laptop_mac,
                            color: hijau,
                            size: 30,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Saldo tabungan
                      const Text(
                        'Saldo Saat Ini',
                        style: TextStyle(
                          fontSize: 14,
                          color: abu,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Rp 3.500.000',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: hijau,
                        ),
                      ),

                      const SizedBox(height: 24),

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

                      const SizedBox(height: 12),

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

                      const SizedBox(height: 10),

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
              ),

              const SizedBox(height: 24),

              // Kategori aktivitas
              const Text(
                'Kategori Aktivitas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: teks,
                ),
              ),

              const SizedBox(height: 14),

              // Tiga Card kategori terpisah
              Row(
                children: [
                  // Menabung
                  Expanded(
                    child: Card(
                      elevation: 2,
                      color: const Color(0xFFE5F2E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 22,
                          horizontal: 4,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: hijau,
                              size: 36,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Menabung',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: teks,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Tarik
                  Expanded(
                    child: Card(
                      elevation: 2,
                      color: const Color(0xFFFFF0F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 22,
                          horizontal: 4,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_circle_up_outlined,
                              color: pink,
                              size: 36,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tarik',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: teks,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Riwayat
                  Expanded(
                    child: Card(
                      elevation: 2,
                      color: const Color(0xFFE5F2E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 22,
                          horizontal: 4,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history,
                              color: hijau,
                              size: 36,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Riwayat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: teks,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Judul daftar transaksi
              const Text(
                'Transaksi Terakhir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: teks,
                ),
              ),

              const SizedBox(height: 14),

              // Daftar transaksi menggunakan data statis
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    barisTransaksi(
                      nama: 'Menabung Bulanan',
                      tanggal: '10 November 2026',
                      nominal: '+ Rp 500.000',
                      masuk: true,
                    ),

                    const Divider(height: 1),

                    barisTransaksi(
                      nama: 'Uang Saku',
                      tanggal: '5 November 2026',
                      nominal: '+ Rp 200.000',
                      masuk: true,
                    ),

                    const Divider(height: 1),

                    barisTransaksi(
                      nama: 'Penarikan',
                      tanggal: '1 November 2026',
                      nominal: '- Rp 100.000',
                      masuk: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}