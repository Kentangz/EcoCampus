import 'package:ecocampus/app/data/models/course/course_model.dart';

import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:flutter/material.dart' hide MaterialType;
import 'package:get/get.dart';

class ModuleDetailController extends GetxController {
  final CourseRepository _courseRepo = Get.find<CourseRepository>();

  late String courseId;
  late ModuleModel module;

  // === STATE VARIABLES ===
  final sections = <SectionModel>[].obs;
  final isLoading = true.obs;

  // === LIFECYCLE ===
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

  // === SECTION DIALOG ===
  void showSectionDialog({SectionModel? existingSection}) {
    final titleC = TextEditingController(text: existingSection?.title ?? '');
    final orderC = TextEditingController(
      text: existingSection?.order.toString() ?? '${sections.length + 1}',
    );

    Get.defaultDialog(
      title: existingSection == null ? "Tambah Section" : "Edit Section",
      content: Column(
        children: [
          TextField(
            controller: titleC,
            decoration: const InputDecoration(
              labelText: "Judul Section (Misal: Pengenalan)",
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: orderC,
            decoration: const InputDecoration(labelText: "Urutan"),
            keyboardType: TextInputType.number,
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
          order: int.tryParse(orderC.text) ?? (sections.length + 1),
        );

        await _courseRepo.saveSection(courseId, module.id!, section);
      },
    );
  }

  // === DELETE SECTION ===
  void deleteSection(String sectionId) {
    Get.defaultDialog(
      title: "Hapus Section",
      middleText:
          "Semua materi di dalam section ini akan terhapus. Yakin hapus?",
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

  // === MATERIAL STREAM ===
  Stream<List<MaterialModel>> getMaterialsStream(String sectionId) {
    return _courseRepo.getMaterials(courseId, module.id!, sectionId);
  }

  // === MATERIAL DIALOG ===
  void showMaterialDialog(
    String sectionId, {
    MaterialModel? existingMaterial,
    int? nextOrder,
  }) {
    final titleC = TextEditingController(text: existingMaterial?.title ?? '');
    final contentC = TextEditingController(
      text: existingMaterial?.content ?? '',
    );

    final initialOrder = existingMaterial?.order ?? nextOrder ?? 1;

    final orderC = TextEditingController(text: initialOrder.toString());
    var selectedType = existingMaterial?.type ?? MaterialType.text;

    Get.defaultDialog(
      title: existingMaterial == null ? "Tambah Materi" : "Edit Materi",
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              TextField(
                controller: titleC,
                decoration: const InputDecoration(labelText: "Judul Materi"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<MaterialType>(
                initialValue: selectedType,
                decoration: const InputDecoration(labelText: "Tipe Konten"),
                items: MaterialType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedType = val);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentC,
                maxLines: selectedType == MaterialType.text ? 5 : 2,
                decoration: InputDecoration(
                  labelText: selectedType == MaterialType.text
                      ? "Isi Teks (Markdown/HTML)"
                      : "URL Video / Gambar",
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: orderC,
                decoration: const InputDecoration(labelText: "Urutan"),
                keyboardType: TextInputType.number,
              ),
            ],
          );
        },
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF6C63FF),
      onConfirm: () async {
        if (titleC.text.isEmpty) return;
        Get.back();

        final material = MaterialModel(
          id: existingMaterial?.id,
          title: titleC.text,
          type: selectedType,
          content: contentC.text,
          order: int.tryParse(orderC.text) ?? 1,
        );

        await _courseRepo.saveMaterial(
          courseId,
          module.id!,
          sectionId,
          material,
        );
      },
    );
  }

  // === DELETE MATERIAL ===
  void deleteMaterial(String sectionId, String materialId) {
    Get.defaultDialog(
      title: "Hapus Materi",
      middleText: "Yakin hapus materi ini?",
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
}
