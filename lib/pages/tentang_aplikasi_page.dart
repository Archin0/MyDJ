import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TentangAplikasiPage extends StatefulWidget {
  const TentangAplikasiPage({super.key, required this.title});
  final String title;

  @override
  State<TentangAplikasiPage> createState() => _TentangAplikasiPageState();
}

class _TentangAplikasiPageState extends State<TentangAplikasiPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top decorative banner
            Container(
              height: 240,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Stack(
                children: [
                  // optional decorative shapes
                  Positioned(
                    left: -40,
                    top: -40,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content area
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'MyDJ',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aplikasi Jurnal Harian Guru',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Version: 1.0.0',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dibuat oleh:',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  // Author name as a clickable link
                  InkWell(
                    onTap: () async {
                      final uri =
                          Uri.parse('https://dwikk-portfolio.vercel.app');
                      final messenger = ScaffoldMessenger.of(context);
                      final ok = await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                      if (!ok) {
                        messenger.showSnackBar(
                          const SnackBar(
                              content: Text('Tidak dapat membuka tautan')),
                        );
                      }
                    },
                    child: Text(
                      'Dwi Ahmad Khairy',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        // color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                        // decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // URL (clickable)
                  GestureDetector(
                    onTap: () async {
                      final uri =
                          Uri.parse('https://dwikk-portfolio.vercel.app');
                      final messenger = ScaffoldMessenger.of(context);
                      final ok = await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                      if (!ok) {
                        messenger.showSnackBar(
                          const SnackBar(
                              content: Text('Tidak dapat membuka tautan')),
                        );
                      }
                    },
                    child: Text(
                      'https://dwikk-portfolio.vercel.app',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
