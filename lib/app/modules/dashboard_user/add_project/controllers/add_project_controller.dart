import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/page_kolaborasi_kampus/controllers/kolaborasi_kampus_controller.dart';
import 'package:ecocampus/app/project_model.dart';

class AddProjectController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text controllers untuk form
  final titleCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final imageAssetCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final isSaving = false.obs;

  // jika ingin pra-fill dari argument
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProjectModel) {
      // isi form dengan data bila ada
      titleCtrl.text = args.title;
      durationCtrl.text = args.duration;
      imageAssetCtrl.text = args.imageAsset;
      descriptionCtrl.text = args.description ?? '';
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    durationCtrl.dispose();
    imageAssetCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }

  // Validasi sederhana
  bool _validate() {
    final f = formKey.currentState;
    if (f == null) return false;
    return f.validate();
  }

  // Simpan project: buat ProjectModel dan tambahkan ke KolaborasiController
  Future<void> saveProject() async {
    if (!_validate()) return;

    isSaving.value = true;
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final newProject = ProjectModel(
        // jika model versi ringkas (tanpa id) gunakan title/duration/image/desc
        title: titleCtrl.text.trim(),
        duration: durationCtrl.text.trim(),
        imageAsset: imageAssetCtrl.text.trim().isEmpty
            ? 'assets/images/default_project.jpg'
            : imageAssetCtrl.text.trim(),
        description: descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim(),
      );

      // coba cari KolaborasiController dan tambahkan
      try {
        final kolab = Get.find<KolaborasiController>();
        kolab.addProject(newProject);
      } catch (e) {
        // fallback: jika KolaborasiController tidak ada, simpan di local storage atau log
        // untuk saat ini: tampilkan warning
        Get.snackbar('Warning', 'KolaborasiController tidak ditemukan — project ditambahkan secara lokal.');
      }

      Get.back(result: newProject); // kembali ke halaman sebelumnya (opsional kirim hasil)
      Get.snackbar('Sukses', 'Project "${newProject.title}" berhasil ditambahkan.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan project: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }
}
