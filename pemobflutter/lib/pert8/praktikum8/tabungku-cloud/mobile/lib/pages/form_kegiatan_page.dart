import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

/// Form untuk menambahkan atau mengubah kegiatan TabungKu.
class FormKegiatanPage extends StatefulWidget {
  final Kegiatan? kegiatan;

  const FormKegiatanPage({super.key, this.kegiatan});

  @override
  State<FormKegiatanPage> createState() => _FormKegiatanPageState();
}

class _FormKegiatanPageState extends State<FormKegiatanPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judul;
  late final TextEditingController _nominal;

  late DateTime _tanggal;
  late Tipe _tipe;
  late String _kategori;

  bool _sedangMenyimpan = false;

  @override
  void initState() {
    super.initState();

    final k = widget.kegiatan;

    _judul = TextEditingController(text: k?.judul ?? '');

    _nominal = TextEditingController(
      text: (k != null && k.nominal > 0) ? '${k.nominal}' : '',
    );

    _tanggal = k != null ? DateTime.parse(k.tanggal) : DateTime.now();

    _tipe = k?.tipe ?? Tipe.tanpa;

    _kategori = (k != null && kategoriPengeluaran.contains(k.kategori))
        ? k.kategori
        : kategoriPengeluaran.first;
  }

  @override
  void dispose() {
    _judul.dispose();
    _nominal.dispose();
    super.dispose();
  }

  // Memilih tanggal kegiatan.
  Future<void> _pilihTanggal() async {
    final dipilih = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (dipilih != null && mounted) {
      setState(() {
        _tanggal = dipilih;
      });
    }
  }

  // Menyimpan kegiatan baru atau perubahan kegiatan.
  Future<void> _simpan() async {
    if (_sedangMenyimpan) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sedangMenyimpan = true;
    });

    try {
      final adaUang = _tipe != Tipe.tanpa;

      final kegiatan = Kegiatan(
        id: widget.kegiatan?.id,
        judul: _judul.text.trim(),
        tanggal: fmtTanggal(_tanggal),
        selesai: widget.kegiatan?.selesai ?? false,
        tipe: _tipe,
        nominal: adaUang ? int.parse(_nominal.text.trim()) : 0,
        kategori: _tipe == Tipe.pengeluaran ? _kategori : '-',
      );

      if (widget.kegiatan == null) {
        await DbHelper.tambah(kegiatan);
      } else {
        await DbHelper.ubah(kegiatan);
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan kegiatan: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _sedangMenyimpan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;
    final baru = widget.kegiatan == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(baru ? 'Tambah Kegiatan' : 'Edit Kegiatan'),
        centerTitle: true,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // Header halaman.
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: warna.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      baru ? Icons.note_add_outlined : Icons.edit_note_outlined,
                      color: warna.primary,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          baru ? 'Catat Aktivitas Baru' : 'Perbarui Aktivitas',
                          style: tema.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: warna.onPrimaryContainer,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          baru
                              ? 'Catat kegiatan dan kelola keuanganmu '
                                    'dengan lebih teratur.'
                              : 'Sesuaikan informasi kegiatan '
                                    'yang sudah tersimpan.',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: warna.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Informasi dasar kegiatan.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _JudulBagian(
                      ikon: Icons.event_note_outlined,
                      judul: 'Informasi Kegiatan',
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _judul,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nama kegiatan',
                        hintText: 'Contoh: Belajar Flutter',
                        prefixIcon: Icon(Icons.edit_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (nilai) {
                        if (nilai == null || nilai.trim().isEmpty) {
                          return 'Nama kegiatan wajib diisi';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Pemilihan tanggal.
                    Material(
                      type: MaterialType.transparency,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: warna.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(
                          Icons.calendar_month_outlined,
                          color: warna.primary,
                        ),
                        title: const Text('Tanggal Kegiatan'),
                        subtitle: Text(tampilTanggal(_tanggal)),
                        trailing: const Icon(Icons.edit_calendar_outlined),
                        onTap: _pilihTanggal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Jenis transaksi.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _JudulBagian(
                      ikon: Icons.account_balance_wallet_outlined,
                      judul: 'Jenis Aktivitas',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Apakah kegiatan ini melibatkan uang?',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: warna.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // SegmentedButton tetap mengikuti
                    // logika pilihan tipe dari kode dosen.
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: SegmentedButton<Tipe>(
                              showSelectedIcon: false,
                              segments: const [
                                ButtonSegment(
                                  value: Tipe.tanpa,
                                  label: Text('Tidak'),
                                ),
                                ButtonSegment(
                                  value: Tipe.pemasukan,
                                  label: Text('Pemasukan'),
                                ),
                                ButtonSegment(
                                  value: Tipe.pengeluaran,
                                  label: Text('Pengeluaran'),
                                ),
                              ],
                              selected: {_tipe},
                              onSelectionChanged: (pilihan) {
                                setState(() {
                                  _tipe = pilihan.first;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Informasi keuangan hanya muncul jika
            // jenis kegiatan melibatkan transaksi.
            if (_tipe != Tipe.tanpa) ...[
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _JudulBagian(
                        ikon: Icons.payments_outlined,
                        judul: 'Detail Keuangan',
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nominal,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Nominal transaksi',
                          hintText: 'Contoh: 20000',
                          prefixText: 'Rp ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (nilai) {
                          final nominal = int.tryParse((nilai ?? '').trim());

                          if (nominal == null || nominal <= 0) {
                            return 'Isi nominal berupa angka lebih dari 0';
                          }

                          return null;
                        },
                      ),

                      // Kategori hanya ditampilkan
                      // untuk transaksi pengeluaran.
                      if (_tipe == Tipe.pengeluaran) ...[
                        const SizedBox(height: 20),

                        Text(
                          'Kategori Pengeluaran',
                          style: tema.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            for (final kategori in kategoriPengeluaran)
                              ChoiceChip(
                                label: Text(kategori),
                                selected: _kategori == kategori,
                                onSelected: (_) {
                                  setState(() {
                                    _kategori = kategori;
                                  });
                                },
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Tombol simpan kegiatan.
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _sedangMenyimpan ? null : _simpan,
                icon: _sedangMenyimpan
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        baru ? Icons.save_outlined : Icons.check_circle_outline,
                      ),
                label: Text(
                  _sedangMenyimpan
                      ? 'Menyimpan...'
                      : baru
                      ? 'Simpan Kegiatan'
                      : 'Simpan Perubahan',
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                'Data kegiatan disimpan pada aplikasi TabungKu.',
                textAlign: TextAlign.center,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: warna.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget judul untuk setiap bagian formulir.
class _JudulBagian extends StatelessWidget {
  final IconData ikon;
  final String judul;

  const _JudulBagian({required this.ikon, required this.judul});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Row(
      children: [
        Icon(ikon, color: warna.primary, size: 22),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            judul,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
