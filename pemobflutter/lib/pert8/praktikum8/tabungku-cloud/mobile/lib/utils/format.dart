// Utility untuk memformat tanggal dan mata uang
// pada aplikasi TabungKu Cloud.

/// Mengubah tanggal ke format yyyy-MM-dd.
/// Format ini digunakan untuk menyimpan tanggal di SQLite.
/// Contoh: 28 September 2026 menjadi "2026-09-28".
String fmtTanggal(DateTime tanggal) {
  final tahun = tanggal.year.toString();
  final bulan = _duaDigit(tanggal.month);
  final hari = _duaDigit(tanggal.day);

  return '$tahun-$bulan-$hari';
}

/// Membuat angka selalu memiliki minimal dua digit.
String _duaDigit(int angka) {
  return angka.toString().padLeft(2, '0');
}

// Nama hari dalam bahasa Indonesia.
const _namaHari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

// Singkatan nama bulan dalam bahasa Indonesia.
const _namaBulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Menampilkan tanggal menggunakan format bahasa Indonesia.
/// Contoh: Senin, 28 Sep 2026.
String tampilTanggal(DateTime tanggal) {
  final hari = _namaHari[tanggal.weekday - 1];
  final bulan = _namaBulan[tanggal.month - 1];

  return '$hari, ${tanggal.day} $bulan ${tanggal.year}';
}

/// Mengubah nominal menjadi format mata uang Rupiah.
/// Contoh:
/// 15000   -> Rp 15.000
/// -5000   -> -Rp 5.000
/// 1000000 -> Rp 1.000.000
String rupiah(int nilai) {
  final negatif = nilai < 0;
  final angka = nilai.abs().toString();

  final hasil = StringBuffer();

  for (var i = 0; i < angka.length; i++) {
    final sisaDigit = angka.length - i;

    if (i > 0 && sisaDigit % 3 == 0) {
      hasil.write('.');
    }

    hasil.write(angka[i]);
  }

  return '${negatif ? '-' : ''}Rp $hasil';
}
