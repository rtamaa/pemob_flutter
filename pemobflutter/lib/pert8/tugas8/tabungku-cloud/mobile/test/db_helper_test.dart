import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:tabungku/data/db_helper.dart';
import 'package:tabungku/models/kegiatan.dart';

void main() {
  const tanggalUji = '2026-10-06';
  const tanggalSebelumnya = '2026-10-05';

  // Menyiapkan database SQLite untuk pengujian.
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final lokasiDatabase = p.join(
      await getDatabasesPath(),
      'tabungku.db',
    );

    await databaseFactory.deleteDatabase(lokasiDatabase);
  });

  group('Pengujian Database TabungKu', () {
    // Pengujian menambahkan kegiatan dan transaksi.
    test(
      'Menambahkan kegiatan tanpa transaksi dan transaksi keuangan',
          () async {
        final versiSebelum = versiData.value;

        // Kegiatan tanpa transaksi keuangan.
        await DbHelper.tambah(
          const Kegiatan(
            judul: 'Belajar',
            tanggal: tanggalUji,
          ),
        );

        var hasil = await DbHelper.ringkasan(tanggalUji);

        expect(hasil.jumlahKegiatan, 1);
        expect(hasil.pemasukan, 0);
        expect(hasil.pengeluaran, 0);
        expect(versiData.value, versiSebelum + 1);

        // Kegiatan dengan pemasukan.
        await DbHelper.tambah(
          const Kegiatan(
            judul: 'Freelance',
            tanggal: tanggalUji,
            tipe: Tipe.pemasukan,
            nominal: 50000,
          ),
        );

        hasil = await DbHelper.ringkasan(tanggalUji);

        expect(hasil.pemasukan, 50000);
        expect(hasil.tabungan, 50000);

        // Kegiatan dengan pengeluaran.
        await DbHelper.tambah(
          const Kegiatan(
            judul: 'Makan siang',
            tanggal: tanggalUji,
            tipe: Tipe.pengeluaran,
            nominal: 15000,
            kategori: 'Makan',
          ),
        );

        hasil = await DbHelper.ringkasan(tanggalUji);

        expect(hasil.pengeluaran, 15000);
        expect(hasil.tabungan, 35000);

        final kategori = await DbHelper.pengeluaranPerKategori(
          tanggalUji,
        );

        expect(kategori, {
          'Makan': 15000,
        });
      },
    );

    // Pengujian perubahan status kegiatan.
    test('Menandai kegiatan sebagai selesai', () async {
      final daftarKegiatan = await DbHelper.pada(tanggalUji);

      await DbHelper.ubah(
        daftarKegiatan[0].salin(selesai: true),
      );

      await DbHelper.ubah(
        daftarKegiatan[1].salin(selesai: true),
      );

      final hasil = await DbHelper.ringkasan(tanggalUji);

      expect(hasil.selesai, 2);
      expect(hasil.jumlahKegiatan, 3);
    });

    // Pengujian perubahan nominal pengeluaran.
    test('Mengubah nominal transaksi pengeluaran', () async {
      final kegiatan = (await DbHelper.pada(tanggalUji))
          .firstWhere((item) => item.judul == 'Makan siang');

      // Membuat objek baru karena salin() tidak
      // menyediakan parameter nominal.
      final dataBaru = Kegiatan(
        id: kegiatan.id,
        judul: kegiatan.judul,
        tanggal: kegiatan.tanggal,
        selesai: kegiatan.selesai,
        tipe: kegiatan.tipe,
        nominal: 20000,
        kategori: kegiatan.kategori,
      );

      await DbHelper.ubah(dataBaru);

      final hasil = await DbHelper.ringkasan(tanggalUji);

      expect(hasil.pengeluaran, 20000);
      expect(hasil.tabungan, 30000);
    });

    // Pengujian penghapusan kegiatan.
    test('Menghapus kegiatan berdasarkan ID', () async {
      final kegiatan = (await DbHelper.pada(tanggalUji))
          .firstWhere((item) => item.judul == 'Belajar');

      await DbHelper.hapus(kegiatan.id!);

      final hasil = await DbHelper.ringkasan(tanggalUji);

      expect(hasil.jumlahKegiatan, 2);
    });

    // Pengujian pemisahan kegiatan berdasarkan tanggal.
    test('Data kegiatan dipisahkan berdasarkan tanggal', () async {
      await DbHelper.tambah(
        const Kegiatan(
          judul: 'Angkot',
          tanggal: tanggalSebelumnya,
          tipe: Tipe.pengeluaran,
          nominal: 10000,
          kategori: 'Transport',
        ),
      );

      final kegiatanHariIni = await DbHelper.pada(tanggalUji);

      expect(
        kegiatanHariIni.any((item) => item.judul == 'Angkot'),
        isFalse,
      );

      final hasil = await DbHelper.ringkasan(tanggalSebelumnya);

      expect(hasil.jumlahKegiatan, 1);
      expect(hasil.pengeluaran, 10000);
    });

    // Pengujian tabungan negatif.
    test('Menghitung tabungan negatif', () async {
      final hasil = await DbHelper.ringkasan(tanggalSebelumnya);

      expect(hasil.tabungan, lessThan(0));
    });

    // Pengujian tanggal yang tidak memiliki transaksi.
    test('Tanggal tanpa data menghasilkan nilai nol', () async {
      final hasil = await DbHelper.ringkasan('2000-01-01');

      expect(hasil.jumlahKegiatan, 0);
      expect(hasil.selesai, 0);
      expect(hasil.pemasukan, 0);
      expect(hasil.pengeluaran, 0);
      expect(hasil.tabungan, 0);
    });
  });
}