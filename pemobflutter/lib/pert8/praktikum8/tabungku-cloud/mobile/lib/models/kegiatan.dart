/// Jenis aktivitas yang dapat dicatat pengguna.
enum Tipe { tanpa, pemasukan, pengeluaran }

/// Daftar kategori untuk transaksi pengeluaran.
const kategoriPengeluaran = [
  'Makan',
  'Transport',
  'Belajar',
  'Hiburan',
  'Lainnya',
];

/// Model data kegiatan yang disimpan dalam SQLite.
class Kegiatan {
  final int? id;
  final String judul;
  final String tanggal;
  final bool selesai;
  final Tipe tipe;
  final int nominal;
  final String kategori;

  const Kegiatan({
    this.id,
    required this.judul,
    required this.tanggal,
    this.selesai = false,
    this.tipe = Tipe.tanpa,
    this.nominal = 0,
    this.kategori = '-',
  });

  /// Membuat salinan kegiatan dengan perubahan tertentu.
  ///
  /// Parameter opsional memungkinkan pembaruan data
  /// tanpa harus membuat objek baru secara manual.
  Kegiatan salin({
    bool? selesai,
    String? judul,
    String? tanggal,
    Tipe? tipe,
    int? nominal,
    String? kategori,
  }) {
    return Kegiatan(
      id: id,
      judul: judul ?? this.judul,
      tanggal: tanggal ?? this.tanggal,
      selesai: selesai ?? this.selesai,
      tipe: tipe ?? this.tipe,
      nominal: nominal ?? this.nominal,
      kategori: kategori ?? this.kategori,
    );
  }

  /// Mengubah objek Kegiatan menjadi Map untuk SQLite.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'judul': judul,
      'tanggal': tanggal,
      'selesai': selesai ? 1 : 0,
      'tipe': tipe.name,
      'nominal': nominal,
      'kategori': kategori,
    };
  }

  /// Membuat objek Kegiatan dari hasil query SQLite.
  factory Kegiatan.fromMap(Map<String, Object?> data) {
    return Kegiatan(
      id: data['id'] as int?,
      judul: data['judul'] as String,
      tanggal: data['tanggal'] as String,
      selesai: (data['selesai'] as int) == 1,
      tipe: Tipe.values.byName(data['tipe'] as String),
      nominal: data['nominal'] as int,
      kategori: data['kategori'] as String,
    );
  }
}

/// Ringkasan aktivitas dan transaksi keuangan harian.
class Ringkasan {
  final int jumlahKegiatan;
  final int selesai;
  final int pemasukan;
  final int pengeluaran;

  const Ringkasan({
    required this.jumlahKegiatan,
    required this.selesai,
    required this.pemasukan,
    required this.pengeluaran,
  });

  /// Menghitung selisih antara pemasukan dan pengeluaran.
  int get tabungan => pemasukan - pengeluaran;
}
