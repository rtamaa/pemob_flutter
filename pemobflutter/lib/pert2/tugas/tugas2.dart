
import 'package:flutter/material.dart';

// 1. Model data Kontak
class Kontak {
  final String nama;
  final String telepon;
  final String email;

  const Kontak(this.nama, this.telepon, this.email);
}

// 2. Daftar kontak
const daftarKontak = [
  Kontak('Andi Saputra', '081234567890', 'andi@gmail.com'),
  Kontak('Budi Santoso', '082345678901', 'budi@gmail.com'),
  Kontak('Citra Lestari', '083456789012', 'citra@gmail.com'),
  Kontak('Dewi Anggraini', '084567890123', 'dewi@gmail.com'),
  Kontak('Eko Prasetyo', '085678901234', 'eko@gmail.com'),
  Kontak('Fitri Amelia', '086789012345', 'fitri@gmail.com'),
];

// 3. Aplikasi utama
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Kontak',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const KontakPage(),
    );
  }
}

// 4. Halaman daftar kontak
class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final item = daftarKontak[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  item.nama[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

              title: Text(item.nama),

              subtitle: Text(item.telepon),

              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailKontakPage(
                      kontak: item,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 5. Halaman detail kontak
class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;

  const DetailKontakPage({
    super.key,
    required this.kontak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kontak'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  kontak.nama[0],
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                kontak.nama,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Nomor Telepon'),
                subtitle: Text(kontak.telepon),
              ),

              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(kontak.email),
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
      ),
    );
  }
}