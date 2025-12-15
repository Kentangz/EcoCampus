import 'package:get/get.dart';

class KolaborasiController extends GetxController {
  // List proyek - reactive
  final projects = <ProjectModel>[].obs;

  // bottom navigation selected index
  final selectedIndex = 1.obs; // 0 Home, 1 Project, 2 Finance

  @override
  void onInit() {
    super.onInit();
    _loadDummyProjects();
  }

  void _loadDummyProjects() {
    // Ganti imageAsset dengan path asset Anda
    projects.addAll([
      ProjectModel(
        title: 'Design UI/UX',
        duration: '8 Minggu',
        imageAsset: 'assets/images/ui_ux.jpg',
      ),
      ProjectModel(
        title: 'Analisis Data Penjualan',
        duration: '16 Minggu',
        imageAsset: 'assets/images/analisis_data_penjualan.jpg',
      ),
      ProjectModel(
        title: 'Riset Pasar Produk',
        duration: '8 Minggu',
        imageAsset: 'assets/images/riset_pasar_produk.jpg',
      ),
      ProjectModel(
        title: 'Pembuatan Aplikasi',
        duration: '24 Minggu',
        imageAsset: 'assets/images/pembuatan_aplikasi.jpg',
      ),
    ]);
  }

  void onTapProject(int index) {
    final p = projects[index];
    Get.snackbar('Buka Proyek', '${p.title} — ${p.duration}',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onTapBottomNav(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.snackbar('Nav', 'Home tapped', snackPosition: SnackPosition.BOTTOM);
        break;
      case 1:
        break;
      case 2:
        Get.snackbar('Nav', 'Finance tapped', snackPosition: SnackPosition.BOTTOM);
        break;
    }
  }
}

class ProjectModel {
  final String title;
  final String duration;
  final String imageAsset;

  ProjectModel({
    required this.title,
    required this.duration,
    required this.imageAsset,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      imageAsset: json['imageAsset'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'imageAsset': imageAsset,
    };
  }
}
