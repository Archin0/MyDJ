import 'package:flutter/material.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:provider/provider.dart';

class LihatJurnalPage extends StatefulWidget {
  const LihatJurnalPage({super.key, required this.title});
  final String title;

  @override
  State<LihatJurnalPage> createState() => _LihatJurnalPageState();
}

class _LihatJurnalPageState extends State<LihatJurnalPage> {
  @override
  Widget build(BuildContext context) {
    // Menggunakan context.watch() untuk 'mendengarkan' perubahan state
    final daftarJurnal = context.watch<DataProvider>().jurnalTersimpan;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: daftarJurnal.isEmpty
            ? const Center(
                child: Text('Belum ada jurnal yang dibuat.'),
              )
            : ListView.separated(
                itemCount: daftarJurnal.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final jurnal = daftarJurnal[index];
                  return ListTile(
                    title: Text('Kelas: ${jurnal.kelas}'),
                    subtitle: Text(jurnal.mapel),
                    trailing: Text('Jam ke-${jurnal.jam}'),
                    onTap: () {
                      // Bisa ditambahkan navigasi ke halaman detail jika diperlukan
                    },
                  );
                },
              ),
      ),
    );
  }
}
