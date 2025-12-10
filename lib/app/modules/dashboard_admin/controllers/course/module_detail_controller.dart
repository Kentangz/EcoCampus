import 'package:ecocampus/app/data/models/course/course_model.dart';

import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart' hide MaterialType;
import 'package:get/get.dart';

class ModuleDetailController extends GetxController {
  final CourseRepository _courseRepo = Get.find<CourseRepository>();

  late String courseId;
  late ModuleModel module;

  // === STATE VARIABLES ===
  final sections = <SectionModel>[].obs;
  final isLoading = true.obs;

  final isPreviewMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      courseId = args['courseId'];
      module = args['module'];
      sections.bindStream(_courseRepo.getSections(courseId, module.id!));
    }
  }

  void togglePreview() {
    isPreviewMode.value = !isPreviewMode.value;
  }

  // === SECTION MANAGEMENT ===

  void showSectionDialog({SectionModel? existingSection}) {
    final titleC = TextEditingController(text: existingSection?.title ?? '');

    Get.defaultDialog(
      title: existingSection == null ? "Tambah Section" : "Edit Section",
      content: Column(
        children: [
          TextField(
            controller: titleC,
            decoration: const InputDecoration(
              labelText: "Judul Section (Misal: Pengenalan)",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF6C63FF),
      onConfirm: () async {
        if (titleC.text.isEmpty) return;
        Get.back();

        final section = SectionModel(
          id: existingSection?.id,
          title: titleC.text,
          order: existingSection?.order ?? (sections.length + 1),
        );

        await _courseRepo.saveSection(courseId, module.id!, section);
      },
    );
  }

  void deleteSection(String sectionId) {
    Get.defaultDialog(
      title: "Hapus Section",
      middleText: "Semua materi di dalam section ini akan terhapus permanen.",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _courseRepo.deleteSection(courseId, module.id!, sectionId);
      },
    );
  }

  // === MATERIAL (TOPIC) MANAGEMENT ===

  Stream<List<MaterialModel>> getMaterialsStream(String sectionId) {
    return _courseRepo.getMaterials(courseId, module.id!, sectionId).map((
      materials,
    ) {
      materials.sort((a, b) => a.order.compareTo(b.order));
      return materials;
    });
  }

  void showAddMaterialDialog(String sectionId, int nextOrder) {
    final titleC = TextEditingController();

    Get.defaultDialog(
      title: "Tambah Materi Baru",
      content: Column(
        children: [
          TextField(
            controller: titleC,
            decoration: const InputDecoration(
              labelText: "Judul Materi (Misal: Sejarah Python)",
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
      textConfirm: "Buat",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF6C63FF),
      onConfirm: () async {
        if (titleC.text.isEmpty) return;
        Get.back();

        final newMaterial = MaterialModel(
          title: titleC.text,
          order: nextOrder,
          blocks: [],
        );

        try {
          await _courseRepo.saveMaterial(
            courseId,
            module.id!,
            sectionId,
            newMaterial,
          );
          NotificationHelper.showSuccess("Berhasil", "Materi berhasil dibuat");
        } catch (e) {
          NotificationHelper.showError("Gagal", "Gagal membuat materi: $e");
        }
      },
    );
  }

  void deleteMaterial(String sectionId, String materialId) {
    Get.defaultDialog(
      title: "Hapus Materi",
      middleText: "Yakin hapus materi ini beserta seluruh isinya?",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _courseRepo.deleteMaterial(
          courseId,
          module.id!,
          sectionId,
          materialId,
        );
      },
    );
  }

  // === REORDER MATERIAL ===
  Future<void> reorderMaterials(
    String sectionId,
    int oldIndex,
    int newIndex,
    List<MaterialModel> materials,
  ) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = materials.removeAt(oldIndex);
    materials.insert(newIndex, item);

    for (int i = 0; i < materials.length; i++) {
      if (materials[i].order != i + 1) {
        materials[i].order = i + 1;
        await _courseRepo.saveMaterial(
          courseId,
          module.id!,
          sectionId,
          materials[i],
        );
      }
    }
  }

  void navigateToBuilder(String sectionId, MaterialModel material) {
    Get.toNamed(
      Routes.ADMIN_MATERIAL_BUILDER,
      arguments: {
        'courseId': courseId,
        'moduleId': module.id,
        'sectionId': sectionId,
        'material': material,
      },
    );
  }
}
