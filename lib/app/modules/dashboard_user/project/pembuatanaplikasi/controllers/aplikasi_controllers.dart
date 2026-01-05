import 'package:get/get.dart';

class PembuatanAplikasiController extends GetxController {
  late final PembuatanAplikasiModel project;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is PembuatanAplikasiModel) {
      project = args;
      return;
    }

    if (args is Map && args['project'] is PembuatanAplikasiModel) {
      project = args['project'] as PembuatanAplikasiModel;
      return;
    }

    if (args is Map &&
        (args['title'] != null ||
            args['duration'] != null ||
            args['imageAsset'] != null)) {
      project = PembuatanAplikasiModel(
        title: args['title']?.toString() ?? 'Pembuatan Aplikasi',
        duration: args['duration']?.toString() ?? '12 Minggu',
        imageAsset:
            args['imageAsset']?.toString() ?? 'assets/images/pembuatan_aplikasi.jpg',
        description: args['description']?.toString(),
      );
      return;
    }

    project = const PembuatanAplikasiModel(
      title: 'Pembuatan Aplikasi',
      duration: '12 Minggu',
      imageAsset: 'assets/images/pembuatan_aplikasi.jpg',
      description:
          'Proyek pembuatan aplikasi bertujuan mengembangkan sistem digital end-to-end mulai dari analisis kebutuhan, perancangan arsitektur, implementasi fitur, hingga deployment ke lingkungan produksi.',
    );
  }
}

class PembuatanAplikasiModel {
  final String title;
  final String duration;
  final String imageAsset;
  final String? description;

  const PembuatanAplikasiModel({
    required this.title,
    required this.duration,
    required this.imageAsset,
    this.description,
  });

  factory PembuatanAplikasiModel.fromJson(Map<String, dynamic> json) {
    return PembuatanAplikasiModel(
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      imageAsset: json['imageAsset'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'imageAsset': imageAsset,
      'description': description,
    };
  }
}
