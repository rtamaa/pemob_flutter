
import 'package:flutter_test/flutter_test.dart';
import 'package:tabungku_layout/main.dart';

void main() {
  testWidgets('Test halaman ringkasan tabungan', (tester) async {
    await tester.pumpWidget(const TabungKuApp());

    // Cek judul halaman
    expect(find.text('Ringkasan Tabungan'), findsOneWidget);

    // Cek informasi tabungan
    expect(find.text('Tabungan Laptop'), findsOneWidget);
    expect(find.text('Rp 3.500.000'), findsOneWidget);
    expect(find.text('Rp 7.000.000'), findsOneWidget);

    // Cek kategori
    expect(find.text('Menabung'), findsWidgets);
    expect(find.text('Tarik'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);

    // Cek daftar transaksi
    expect(find.text('Daftar Transaksi'), findsOneWidget);
    expect(find.text('Uang Saku'), findsOneWidget);
    expect(find.text('Penarikan'), findsOneWidget);
  });
}