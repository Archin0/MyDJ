class Jurnal {
  final DateTime _createdAt;
  String kelas;
  String mapel;
  int jam;
  String tujuanPembelajaran;
  String materiTopikPembelajaran;
  String kegiatanPembelajaran;
  String dimensiProfilPelajarPancasila;
  String? fotoPath;
  String? videoPath;

  Jurnal({
    this.kelas = '',
    this.mapel = '',
    this.jam = 0,
    this.tujuanPembelajaran = '',
    this.materiTopikPembelajaran = '',
    this.kegiatanPembelajaran = '',
    this.dimensiProfilPelajarPancasila = '',
    this.fotoPath,
    this.videoPath,
  }) : _createdAt = DateTime.now();

  DateTime get createdAt => _createdAt;
}
