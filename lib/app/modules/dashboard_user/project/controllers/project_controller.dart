import 'package:get/get.dart';
import 'package:ecocampus/app/project_model.dart';

class ProjectController extends GetxController {
  final projects = <ProjectModel>[].obs;
  final selectedIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyProjects();
  }

  void _loadDummyProjects() {
    projects.assignAll([
      const ProjectModel(
        title: 'Design UI/UX',
        duration: '8 Minggu',
        imageAsset: 'assets/images/ui_ux.jpg',
        description: 'Proyek perancangan UI/UX untuk EcoCampus.',
      ),
      const ProjectModel(
        title: 'Analisis Data Penjualan',
        duration: '16 Minggu',
        imageAsset: 'assets/images/analisis_data_penjualan.jpg',
      ),
      const ProjectModel(
        title: 'Riset Pasar Produk',
        duration: '8 Minggu',
        imageAsset: 'assets/images/riset_pasar_produk.jpg',
      ),
      const ProjectModel(
        title: 'Pembuatan Aplikasi',
        duration: '24 Minggu',
        imageAsset: 'assets/images/pembuatan_aplikasi.jpg',
      ),
    ]);
  }

  /// Tambah project baru. Menghindari duplikat berdasarkan title (case-insensitive).
  void addProject(ProjectModel project) {
    final exists = projects.any((p) => p.title.toLowerCase() == project.title.toLowerCase());
    if (!exists) {
      projects.add(project);
    } else {
      // jika mau izinkan duplicate, hilangkan blok ini
      Get.snackbar('Info', 'Project dengan judul yang sama sudah ada.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Navigasi ke halaman detail sesuai title (case-insensitive).
  void onTapProject(int index) {
    if (index < 0 || index >= projects.length) return;
    final p = projects[index];
    final key = p.title.toLowerCase();

    if (key.contains('design ui/ux') || key.contains('ui/ux')) {
      Get.toNamed('/project-ui-ux', arguments: p);
      return;
    }

    if (key.contains('analisis data penjualan') || key.contains('analisis data')) {
      Get.toNamed('/project-analisis', arguments: p);
      return;
    }

    if (key.contains('riset pasar produk') || key.contains('riset pasar')) {
      Get.toNamed('/dashboard/project-riset-pasar', arguments: p);
      return;
    }

    if (key.contains('pembuatan aplikasi') || key.contains('pembuatan app')) {
      Get.toNamed('/dashboard/project-pembuatan-aplikasi', arguments: p);
      return;
    }

    Get.snackbar('Info', 'Halaman detail untuk "${p.title}" belum tersedia.',
        snackPosition: SnackPosition.BOTTOM);
  }

  void onTapBottomNav(int index) {
    selectedIndex.value = index;
  }
}
