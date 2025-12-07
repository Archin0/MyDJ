import 'package:flutter/material.dart';
import 'package:mydj/pages/akun_page.dart';
import 'package:mydj/pages/buat_jurnal_page.dart';
import 'package:mydj/pages/lihat_jurnal_page.dart';
import 'package:mydj/pages/tentang_aplikasi_page.dart';

class SimpleHomePage extends StatefulWidget {
  const SimpleHomePage({super.key, required this.title});
  final String title;

  @override
  State<SimpleHomePage> createState() => _SimpleHomePageState();
}

class _SimpleHomePageState extends State<SimpleHomePage> {
  // Navigator untuk ke Halaman Lihat Jurnal
  void _openLihatJurnalPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LihatJurnalPage(title: 'Lihat Jurnal'),
      ),
    );
  }

  // Navigator untuk ke Halaman Buat Jurnal
  void _openBuatJurnalPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BuatJurnalPage(title: 'Buat Jurnal Baru'),
      ),
    );
  }

  // Navigator untuk ke Halaman Akun
  void _openAkunPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AkunPage(title: 'Akun Saya'),
      ),
    );
  }

  // Navigator untuk ke Halaman Tentang Aplikasi
  void _openTentangAplikasiPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const TentangAplikasiPage(title: 'Tentang Aplikasi'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Widget untuk menampilkan logo
            Image.asset(
              'assets/images/logo_kemdikbud.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(
                height:
                    30), // Spasi vertikal antara logo dan baris tombol pertama

            // Baris tombol pertama
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _openLihatJurnalPage(context),
                  child: const Text('Lihat Jurnal'),
                ),
                const SizedBox(width: 20), // Spasi horizontal
                ElevatedButton(
                  onPressed: () => _openBuatJurnalPage(context),
                  child: const Text('Buat Jurnal'),
                ),
              ],
            ),
            const SizedBox(
                height: 20), // Spasi vertikal antara dua baris tombol

            // Baris tombol kedua
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _openAkunPage(context),
                  child: const Text('Akun'),
                ),
                const SizedBox(width: 20), // Spasi horizontal
                ElevatedButton(
                  onPressed: () => _openTentangAplikasiPage(context),
                  child: const Text('Tentang Aplikasi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
