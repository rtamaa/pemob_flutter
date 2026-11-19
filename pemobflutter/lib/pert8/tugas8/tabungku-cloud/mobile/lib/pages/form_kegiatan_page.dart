import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

/// Halaman untuk menambahkan atau mengubah kegiatan TabungKu.
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

  bool get _modeEdit => widget.kegiatan != null;

  @override
  void initState() {
    super.initState();

    final dataAwal = widget.kegiatan;

    _judul = TextEditingController(text: dataAwal?.judul ?? '');

    _nominal = TextEditingController(
      text: dataAwal != null && dataAwal.nominal > 0
          ? dataAwal.nominal.toString()
          : '',
    );

    _tanggal = dataAwal != null
        ? DateTime.parse(dataAwal.tanggal)
        : DateTime.now();

    _tipe = dataAwal?.tipe ?? Tipe.tanpa;

    _kategori =
        dataAwal != null && kategoriPengeluaran.contains(dataAwal.kategori)
        ? dataAwal.kategori
        : kategoriPengeluaran.first;
  }

  @override
  void dispose() {
    _judul.dispose();
    _nominal.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (hasil == null || !mounted) return;

    setState(() {
      _tanggal = hasil;
    });
  }

  Future<void> _simpanKegiatan() async {
    if (_sedangMenyimpan) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sedangMenyimpan = true;
    });

    try {
      final menggunakanUang = _tipe != Tipe.tanpa;

      final kegiatanBaru = Kegiatan(
        id: widget.kegiatan?.id,
        judul: _judul.text.trim(),
        tanggal: fmtTanggal(_tanggal),
        selesai: widget.kegiatan?.selesai ?? false,
        tipe: _tipe,
        nominal: menggunakanUang ? int.parse(_nominal.text.trim()) : 0,
        kategori: _tipe == Tipe.pengeluaran ? _kategori : '-',
      );

      if (_modeEdit) {
        await DbHelper.ubah(kegiatanBaru);
      } else {
        await DbHelper.tambah(kegiatanBaru);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_modeEdit ? 'Edit Kegiatan' : 'Tambah Kegiatan'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // Header halaman.
            Card(
              color: warna.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: warna.primary,
                      radius: 26,
                      child: Icon(
                        _modeEdit ? Icons.edit_note : Icons.add_task,
                        color: warna.onPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _modeEdit
                                ? 'Perbarui Catatanmu'
                                : 'Catat Aktivitas Baru',
                            style: tema.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: warna.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kelola kegiatan dan transaksi '
                            'tabunganmu dengan lebih mudah.',
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
            ),

            const SizedBox(height: 20),

            // Informasi dasar kegiatan.
            _JudulBagian(
              ikon: Icons.description_outlined,
              judul: 'Informasi Kegiatan',
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _judul,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nama kegiatan',
                        hintText: 'Contoh: Menabung uang jajan',
                        prefixIcon: Icon(Icons.edit_note),
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

                    // Pilihan tanggal.
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: warna.outline),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Icon(
                        Icons.calendar_month_outlined,
                        color: warna.primary,
                      ),
                      title: const Text('Tanggal kegiatan'),
                      subtitle: Text(tampilTanggal(_tanggal)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _pilihTanggal,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pilihan tipe transaksi.
            _JudulBagian(
              ikon: Icons.account_balance_wallet_outlined,
              judul: 'Jenis Kegiatan',
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apakah kegiatan melibatkan uang?',
                      style: tema.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 12),

                    SegmentedButton<Tipe>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: Tipe.tanpa,
                          label: Text('Tidak'),
                          icon: Icon(Icons.event_note_outlined),
                        ),
                        ButtonSegment(
                          value: Tipe.pemasukan,
                          label: Text('Masuk'),
                          icon: Icon(Icons.south_west),
                        ),
                        ButtonSegment(
                          value: Tipe.pengeluaran,
                          label: Text('Keluar'),
                          icon: Icon(Icons.north_east),
                        ),
                      ],
                      selected: {_tipe},
                      onSelectionChanged: (pilihan) {
                        setState(() {
                          _tipe = pilihan.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Input nominal untuk transaksi keuangan.
            if (_tipe != Tipe.tanpa) ...[
              const SizedBox(height: 20),

              _JudulBagian(
                ikon: Icons.payments_outlined,
                judul: 'Detail Keuangan',
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _nominal,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Nominal transaksi',
                      hintText: 'Masukkan jumlah uang',
                      prefixText: 'Rp ',
                      prefixIcon: const Icon(Icons.payments_outlined),
                      border: const OutlineInputBorder(),
                      helperText: _tipe == Tipe.pemasukan
                          ? 'Jumlah uang yang diterima'
                          : 'Jumlah uang yang dikeluarkan',
                    ),
                    validator: (nilai) {
                      final nominal = int.tryParse((nilai ?? '').trim());

                      if (nominal == null || nominal <= 0) {
                        return 'Masukkan nominal lebih dari 0';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],

            // Kategori khusus untuk pengeluaran.
            if (_tipe == Tipe.pengeluaran) ...[
              const SizedBox(height: 20),

              _JudulBagian(
                ikon: Icons.category_outlined,
                judul: 'Kategori Pengeluaran',
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
                ),
              ),
            ],

            const SizedBox(height: 28),

            // Tombol untuk menyimpan kegiatan.
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _sedangMenyimpan ? null : _simpanKegiatan,
                icon: _sedangMenyimpan
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  _sedangMenyimpan
                      ? 'Menyimpan...'
                      : _modeEdit
                      ? 'Simpan Perubahan'
                      : 'Simpan Kegiatan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget judul bagian yang digunakan pada setiap kelompok form.
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
        Icon(ikon, color: warna.primary),
        const SizedBox(width: 8),
        Text(
          judul,
          style: tema.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
