import 'package:flutter/material.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:provider/provider.dart';

class BuatJurnalPage extends StatefulWidget {
  const BuatJurnalPage({super.key, required this.title});
  final String title;

  @override
  State<BuatJurnalPage> createState() => _BuatJurnalPageState();
}

class _BuatJurnalPageState extends State<BuatJurnalPage> {
  // State lokal untuk menampung nilai dari setiap input
  String _kelas = '';
  String _mapel = '';
  String? _jamKe;
  String _tujuanPembelajaran = '';
  String _materiTopikPembelajaran = '';
  String _kegiatanPembelajaran = '';
  String _dimensiProfilPelajarPancasila = '';

  // Fungsi helper untuk membuat text area
  Widget _textArea(
      String label, String hint, void Function(String text) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: hint,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _saveJurnal(BuildContext context) {
    if (_kelas.isEmpty || _mapel.isEmpty || _jamKe == null) {
      // Tambahkan validasi sederhana jika diperlukan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kelas, Mapel, dan Jam Ke harus diisi!')),
      );
      return;
    }

    final jurnal = Jurnal(
      kelas: _kelas,
      mapel: _mapel,
      jam: int.tryParse(_jamKe ?? '0') ?? 0,
      tujuanPembelajaran: _tujuanPembelajaran,
      materiTopikPembelajaran: _materiTopikPembelajaran,
      kegiatanPembelajaran: _kegiatanPembelajaran,
      dimensiProfilPelajarPancasila: _dimensiProfilPelajarPancasila,
    );

    // Menyimpan data ke state global menggunakan context.read()
    context.read<DataProvider>().addNew(jurnal);

    // Kembali ke halaman sebelumnya setelah menyimpan
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kelas:'),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Kelas',
                ),
                onChanged: (value) => setState(() => _kelas = value),
              ),
              const SizedBox(height: 10),
              const Text('Nama Mapel:'),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Nama Mapel',
                ),
                onChanged: (value) => setState(() => _mapel = value),
              ),
              const SizedBox(height: 10),
              const Text('Jam Ke-:'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pilih Jam',
                ),
                initialValue: _jamKe,
                items: List.generate(8, (index) => (index + 1).toString())
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _jamKe = value),
              ),
              const SizedBox(height: 10),
              _textArea('Tujuan Pembelajaran', 'Masukkan Tujuan Pembelajaran',
                  (text) {
                setState(() => _tujuanPembelajaran = text);
              }),
              const SizedBox(height: 10),
              _textArea('Materi/Topik Pembelajaran', 'Masukkan Materi/Topik',
                  (text) {
                setState(() => _materiTopikPembelajaran = text);
              }),
              const SizedBox(height: 10),
              _textArea(
                  'Kegiatan Pembelajaran', 'Masukkan Kegiatan Pembelajaran',
                  (text) {
                setState(() => _kegiatanPembelajaran = text);
              }),
              const SizedBox(height: 10),
              _textArea(
                  'Dimensi Profil Pelajar Pancasila', 'Tuliskan Dimensi Profil',
                  (text) {
                setState(() => _dimensiProfilPelajarPancasila = text);
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveJurnal(context),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
