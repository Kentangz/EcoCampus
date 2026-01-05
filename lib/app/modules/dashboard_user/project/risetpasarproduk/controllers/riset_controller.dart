import 'package:get/get.dart';

class RisetPasarProdukController extends GetxController {
  late final RisetPasarProdukModel project;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is RisetPasarProdukModel) {
      project = args;
      return;
    }

    if (args is Map && args['project'] is RisetPasarProdukModel) {
      project = args['project'] as RisetPasarProdukModel;
      return;
    }

    if (args is Map &&
        (args['title'] != null ||
            args['duration'] != null ||
            args['imageAsset'] != null)) {
      project = RisetPasarProdukModel(
        title: args['title']?.toString() ?? 'Riset Pasar Produk',
        duration: args['duration']?.toString() ?? '6 Minggu',
        imageAsset:
            args['imageAsset']?.toString() ?? 'assets/images/riset_pasar.jpg',
        description: args['description']?.toString(),
      );
      return;
    }

    project = const RisetPasarProdukModel(
      title: 'Riset Pasar Produk',
      duration: '6 Minggu',
      imageAsset: 'assets/images/riset_pasar_produk.jpg',
      description:
          'Proyek riset pasar bertujuan mengidentifikasi kebutuhan pengguna, tren pasar, serta peluang pengembangan produk berbasis data.',
    );
  }

  void joinProject() {
    Get.snackbar(
      'Gabung Proyek',
      'Permintaan bergabung untuk "${project.title}" dikirim.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class RisetPasarProdukModel {
  final String title;
  final String duration;
  final String imageAsset;
  final String? description;

  const RisetPasarProdukModel({
    required this.title,
    required this.duration,
    required this.imageAsset,
    this.description,
  });

  factory RisetPasarProdukModel.fromJson(Map<String, dynamic> json) {
    return RisetPasarProdukModel(
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
