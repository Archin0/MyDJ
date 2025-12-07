import 'package:flutter/material.dart';
import 'package:mydj/data/api_exception.dart';
import 'package:mydj/data/api_service.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:mydj/pages/media_selector.dart';
import 'package:provider/provider.dart';

class BuatJurnalPage extends StatefulWidget {
  const BuatJurnalPage({super.key, required this.title});
  final String title;

  @override
  State<BuatJurnalPage> createState() => _BuatJurnalPageState();
}

class _BuatJurnalPageState extends State<BuatJurnalPage> {
  final ApiService _apiService = ApiService();
  String _kelas = '';
  String _mapel = '';
  String? _jamKe;
  String _tujuanPembelajaran = '';
  String _materiTopikPembelajaran = '';
  String _kegiatanPembelajaran = '';
  String _dimensiProfilPelajarPancasila = '';
  String _fotoKegiatanPath = '';
  String _videoKegiatanPath = '';
  bool _isLoading = false;

  Widget _textArea(
      String label, String hint, void Function(String text) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hint,
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Future<void> _saveJurnal(BuildContext context) async {
    if (_kelas.isEmpty || _mapel.isEmpty || _jamKe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kelas, Mapel, dan Jam Ke harus diisi!')),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final dataProvider = context.read<DataProvider>();
    setState(() => _isLoading = true);

    final jurnal = Jurnal(
      kelas: _kelas,
      mapel: _mapel,
      jam: int.tryParse(_jamKe ?? '0') ?? 0,
      tujuanPembelajaran: _tujuanPembelajaran,
      materiTopikPembelajaran: _materiTopikPembelajaran,
      kegiatanPembelajaran: _kegiatanPembelajaran,
      dimensiProfilPelajarPancasila: _dimensiProfilPelajarPancasila,
      fotoPath: _fotoKegiatanPath.isEmpty ? null : _fotoKegiatanPath,
      videoPath: _videoKegiatanPath.isEmpty ? null : _videoKegiatanPath,
    );
    try {
      await _apiService.uploadJurnal(jurnal);
      if (!mounted) return;
      dataProvider.addNew(jurnal);
      setState(() => _isLoading = false);
      await navigator.push<void>(_SuccessDialogRoute());
      if (mounted) {
        navigator.pop();
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan tak terduga: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Kelas',
                      ),
                      onChanged: (value) => setState(() => _kelas = value),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mapel',
                      ),
                      onChanged: (value) => setState(() => _mapel = value),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Jam Ke',
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
                    const SizedBox(height: 15),
                    _textArea(
                        'Tujuan Pembelajaran', 'Masukkan tujuan pembelajaran',
                        (text) {
                      setState(() => _tujuanPembelajaran = text);
                    }),
                    _textArea('Materi/Topik', 'Masukkan materi/topik', (text) {
                      setState(() => _materiTopikPembelajaran = text);
                    }),
                    _textArea('Kegiatan', 'Masukkan kegiatan', (text) {
                      setState(() => _kegiatanPembelajaran = text);
                    }),
                    _textArea(
                        'Profil Pelajar Pancasila', 'Tuliskan dimensi profil',
                        (text) {
                      setState(() => _dimensiProfilPelajarPancasila = text);
                    }),
                    const SizedBox(height: 10),
                    const Text('Foto Kegiatan',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    MediaSelector(
                      mediaType: MediaType.photo,
                      onMediaChanged: (path) => setState(() {
                        _fotoKegiatanPath = path;
                      }),
                    ),
                    const SizedBox(height: 20),
                    const Text('Video Kegiatan',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    MediaSelector(
                      mediaType: MediaType.video,
                      onMediaChanged: (path) => setState(() {
                        _videoKegiatanPath = path;
                      }),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _saveJurnal(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('SIMPAN'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _SuccessDialogRoute extends PopupRoute<void> {
  _SuccessDialogRoute();

  @override
  Color? get barrierColor => const Color.fromRGBO(0, 0, 0, 0.3);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Sukses';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: Center(
        child: AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Data jurnal berhasil disubmit!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
