import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mydj/config/app_config.dart';

import 'api_exception.dart';
import 'jurnal.dart';

class ApiService {
  ApiService({http.Client? httpClient, String? baseUrl, Duration? timeout})
      : _client = httpClient ?? http.Client(),
        _timeout = timeout ?? const Duration(seconds: 20),
        _baseUrl = _normalizeBaseUrl(baseUrl ?? AppConfig.apiBaseUrl);

  final http.Client _client;
  final String _baseUrl;
  final Duration _timeout;

  static String _normalizeBaseUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$_baseUrl$normalizedPath');
  }

  Future<void> uploadJurnal(Jurnal jurnal) async {
    final request = http.MultipartRequest('POST', _buildUri('/upload-jurnal'));

    request.fields['kelas'] = jurnal.kelas;
    request.fields['mapel'] = jurnal.mapel;
    request.fields['jam'] = jurnal.jam.toString();
    request.fields['tujuan_pembelajaran'] = jurnal.tujuanPembelajaran;
    request.fields['materi_topik_pembelajaran'] =
        jurnal.materiTopikPembelajaran;
    request.fields['kegiatan_pembelajaran'] = jurnal.kegiatanPembelajaran;
    request.fields['dimensi_profil_pelajar_pancasila'] =
        jurnal.dimensiProfilPelajarPancasila;
    request.fields['created_at'] = jurnal.createdAt.toIso8601String();

    if (jurnal.fotoPath != null && jurnal.fotoPath!.isNotEmpty) {
      final file = await http.MultipartFile.fromPath('image', jurnal.fotoPath!);
      request.files.add(file);
    }

    if (jurnal.videoPath != null && jurnal.videoPath!.isNotEmpty) {
      final file =
          await http.MultipartFile.fromPath('video', jurnal.videoPath!);
      request.files.add(file);
    }

    try {
      final streamedResponse = await _client.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw ApiException(
          'Gagal upload: ${response.statusCode} - ${response.body}',
        );
      }
    } on TimeoutException catch (e) {
      throw ApiException(
        'Permintaan ke server melebihi ${_timeout.inSeconds} detik. '
        'Pastikan server berjalan dan dapat dijangkau.',
        cause: e,
      );
    } on SocketException catch (e) {
      throw ApiException(
        'Tidak dapat menjangkau server di $_baseUrl. '
        'Pastikan alamat sesuai dengan jaringan perangkat.',
        cause: e,
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        'Koneksi ke server gagal: ${e.message}',
        cause: e,
      );
    }
  }
}
