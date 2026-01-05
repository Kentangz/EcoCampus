import 'dart:async';
import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/data/repositories/authentication_repository.dart';

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

  // === REORDER SECTION ===
  Future<void> reorderSections(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = sections.removeAt(oldIndex);
    sections.insert(newIndex, item);

    for (int i = 0; i < sections.length; i++) {
      sections[i].order = i + 1;
    }

    await _courseRepo.reorderSections(courseId, module.id!, sections);
  }

  StreamSubscription<List<SectionModel>>? _sectionSub;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      courseId = args['courseId'];
      module = args['module'];
      if (module.id == null) {
        NotificationHelper.showError("Error", "ID Modul tidak ditemukan");
        Get.back();
        return;
      }
      _bindSectionStream();
    }
  }

  @override
  void onClose() {
    _sectionSub?.cancel();
    super.onClose();
  }

  void _bindSectionStream() {
    isLoading.value = true;
    _sectionSub = _courseRepo
        .getSections(courseId, module.id!)
        .listen(
          (data) {
            sections.assignAll(data);
            isLoading.value = false;
          },
          onError: (e) {
            if (AuthenticationRepository.instance.currentUser == null) return;
            isLoading.value = false;
            NotificationHelper.showError("Error", "Gagal memuat section: $e");
          },
        );
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
        tileControllers.remove(sectionId);
        _materialStreams.remove(sectionId);
      },
    );
  }

  // === MATERIAL (TOPIC) MANAGEMENT ===
  final Map<String, Stream<List<MaterialModel>>> _materialStreams = {};

  Stream<List<MaterialModel>> getMaterialsStream(String sectionId) {
    if (_materialStreams.containsKey(sectionId)) {
      return _materialStreams[sectionId]!;
    }

    final stream = _courseRepo
        .getMaterials(courseId, module.id!, sectionId)
        .map((materials) {
          materials.sort((a, b) => a.order.compareTo(b.order));
          return materials;
        });

    _materialStreams[sectionId] = stream;
    return stream;
  }

  void addMaterialDirectly(String sectionId, int nextOrder) {
    Get.toNamed(
      Routes.ADMIN_MATERIAL_BUILDER,
      arguments: {
        'courseId': courseId,
        'moduleId': module.id,
        'sectionId': sectionId,
        'nextOrder': nextOrder,
      },
    );
  }

  void deleteMaterial(String sectionId, String materialId) {
    Get.defaultDialog(
      title: "Hapus Materi",
      middleText: "Yakin hapus materi ini beserta seluruh isinya?",
      textConfirm: "Hapus",
      textCancel: "Batal",
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

  // === EXPANSION LOGIC ===
  final Map<String, ExpansibleController> tileControllers = {};

  ExpansibleController getTileController(String sectionId) {
    return tileControllers.putIfAbsent(sectionId, () => ExpansibleController());
  }

  void onSectionExpanded(String sectionId) {
    tileControllers.forEach((key, controller) {
      if (key != sectionId) {
        controller.collapse();
      }
    });
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
      materials[i].order = i + 1;
    }

    await _courseRepo.reorderMaterials(
      courseId,
      module.id!,
      sectionId,
      materials,
    );
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
