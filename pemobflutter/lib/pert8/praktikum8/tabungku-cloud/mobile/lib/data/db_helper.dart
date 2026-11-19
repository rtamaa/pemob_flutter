import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/kegiatan.dart';

// Notifier untuk memberi tahu halaman ketika data berubah.
final versiData = ValueNotifier<int>(0);

/// Mengelola penyimpanan dan pengambilan data SQLite TabungKu.
class DbHelper {
  static Database? _db;

  // Nama database dan tabel.
  static const String _namaDatabase = 'tabungku.db';
  static const String _namaTabel = 'kegiatan';

  /// Membuka database atau menggunakan koneksi yang sudah ada.
  static Future<Database> get _database async {
    if (_db != null) {
      return _db!;
    }

    final lokasi = p.join(await getDatabasesPath(), _namaDatabase);

    _db = await openDatabase(
      lokasi,
      version: 1,
      onCreate: (database, versi) async {
        await database.execute('''
          CREATE TABLE $_namaTabel (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            tanggal TEXT NOT NULL,
            selesai INTEGER NOT NULL DEFAULT 0,
            tipe TEXT NOT NULL DEFAULT 'tanpa',
            nominal INTEGER NOT NULL DEFAULT 0,
            kategori TEXT NOT NULL DEFAULT '-'
          )
        ''');
      },
    );

    return _db!;
  }

  /// Memberi tahu halaman bahwa data kegiatan telah berubah.
  static void _berubah() {
    versiData.value++;
  }

  /// Menambahkan kegiatan baru ke database.
  static Future<int> tambah(Kegiatan kegiatan) async {
    final database = await _database;

    final id = await database.insert(_namaTabel, kegiatan.toMap());

    _berubah();
    return id;
  }

  /// Memperbarui data kegiatan berdasarkan ID.
  static Future<int> ubah(Kegiatan kegiatan) async {
    final database = await _database;

    final jumlahBaris = await database.update(
      _namaTabel,
      kegiatan.toMap(),
      where: 'id = ?',
      whereArgs: [kegiatan.id],
    );

    _berubah();
    return jumlahBaris;
  }

  /// Menghapus kegiatan berdasarkan ID.
  static Future<int> hapus(int id) async {
    final database = await _database;

    final jumlahBaris = await database.delete(
      _namaTabel,
      where: 'id = ?',
      whereArgs: [id],
    );

    _berubah();
    return jumlahBaris;
  }

  /// Mengambil seluruh kegiatan pada tanggal tertentu.
  ///
  /// Kegiatan yang belum selesai ditampilkan terlebih dahulu,
  /// kemudian diurutkan berdasarkan ID terbaru.
  static Future<List<Kegiatan>> pada(String tanggal) async {
    final database = await _database;

    final hasil = await database.query(
      _namaTabel,
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'selesai ASC, id DESC',
    );

    return hasil.map(Kegiatan.fromMap).toList();
  }

  /// Menghitung ringkasan kegiatan dan keuangan harian.
  static Future<Ringkasan> ringkasan(String tanggal) async {
    final database = await _database;

    final hasil = await database.rawQuery(
      '''
      SELECT
        COUNT(*) AS jumlah,
        COALESCE(SUM(selesai), 0) AS selesai,
        COALESCE(
          SUM(
            CASE WHEN tipe = 'pemasukan'
            THEN nominal END
          ),
          0
        ) AS masuk,
        COALESCE(
          SUM(
            CASE WHEN tipe = 'pengeluaran'
            THEN nominal END
          ),
          0
        ) AS keluar
      FROM $_namaTabel
      WHERE tanggal = ?
      ''',
      [tanggal],
    );

    final data = hasil.first;

    return Ringkasan(
      jumlahKegiatan: data['jumlah'] as int,
      selesai: data['selesai'] as int,
      pemasukan: data['masuk'] as int,
      pengeluaran: data['keluar'] as int,
    );
  }

  /// Menghitung pengeluaran berdasarkan kategori tertentu.
  static Future<Map<String, int>> pengeluaranPerKategori(String tanggal) async {
    final database = await _database;

    final hasil = await database.rawQuery(
      '''
      SELECT
        kategori,
        SUM(nominal) AS total
      FROM $_namaTabel
      WHERE tanggal = ?
        AND tipe = 'pengeluaran'
      GROUP BY kategori
      ORDER BY total DESC
      ''',
      [tanggal],
    );

    return {
      for (final item in hasil)
        item['kategori'] as String: item['total'] as int,
    };
  }
}
