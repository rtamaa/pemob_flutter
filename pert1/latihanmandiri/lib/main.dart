
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 1',
      debugShowCheckedModeBanner: false,
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  // Fungsi untuk menambah angka
  void tambah() {
    setState(() {
      _count++;
    });
  }

  // Fungsi untuk mengurangi angka
  void kurang() {
    setState(() {
      if (_count > 0) {
        _count--;
      }
    });
  }

  // Fungsi untuk mereset angka
  void reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Counter Saya',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 16),

            const Text(
              'Halo, nama saya Tia!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.deepPurple,
              ),
            ),

            const Text(
              'NIM: 2024080127',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Nilai Counter:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '$_count',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol kurang
                FloatingActionButton(
                  heroTag: 'kurang',
                  onPressed: kurang,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.remove),
                ),

                const SizedBox(width: 20),

                // Tombol reset
                FloatingActionButton(
                  heroTag: 'reset',
                  onPressed: reset,
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.refresh),
                ),

                const SizedBox(width: 20),

                // Tombol tambah
                FloatingActionButton(
                  heroTag: 'tambah',
                  onPressed: tambah,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}