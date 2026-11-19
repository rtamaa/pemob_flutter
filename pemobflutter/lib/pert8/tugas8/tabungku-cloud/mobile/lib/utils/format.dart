// Utility untuk memformat tanggal dan nominal mata uang
// yang digunakan di seluruh aplikasi TabungKu.

/// Mengubah DateTime menjadi format yyyy-MM-dd untuk SQLite.
/// Contoh: 28 September 2026 menjadi "2026-09-28".
String fmtTanggal(DateTime tanggal) {
  final tahun = tanggal.year.toString();
  final bulan = _duaDigit(tanggal.month);
  final hari = _duaDigit(tanggal.day);

  return '$tahun-$bulan-$hari';
}

/// Menambahkan angka nol di depan jika kurang dari dua digit.
String _duaDigit(int angka) {
  return angka.toString().padLeft(2, '0');
}

// Daftar nama hari dalam bahasa Indonesia.
const _namaHari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

// Daftar nama bulan singkat dalam bahasa Indonesia.
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

/// Menampilkan tanggal dalam format bahasa Indonesia.
/// Contoh: "Senin, 28 Sep 2026".
String tampilTanggal(DateTime tanggal) {
  final hari = _namaHari[tanggal.weekday - 1];
  final bulan = _namaBulan[tanggal.month - 1];

  return '$hari, ${tanggal.day} $bulan ${tanggal.year}';
}

/// Mengubah angka menjadi format mata uang Rupiah.
/// Contoh:
/// 15000  -> "Rp 15.000"
/// -5000  -> "-Rp 5.000"
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
