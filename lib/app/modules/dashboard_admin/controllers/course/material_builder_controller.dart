import 'dart:io';
import 'package:ecocampus/app/data/models/course/material_model.dart';
import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:ecocampus/app/services/cloudinary_service.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MaterialBuilderController extends GetxController {
  final CourseRepository _courseRepo = Get.find<CourseRepository>();
  final CloudinaryService _cloudinary = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  late String courseId;
  late String moduleId;
  late String sectionId;
  MaterialModel? existingMaterial;

  final titleController = TextEditingController();
  final blocks = <ContentBlock>[].obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      courseId = args['courseId'];
      moduleId = args['moduleId'];
      sectionId = args['sectionId'];

      if (args['material'] != null) {
        existingMaterial = args['material'] as MaterialModel;
        titleController.text = existingMaterial!.title;
        blocks.assignAll(existingMaterial!.blocks);
      }
    }
  }


  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }


  // === BLOCK MANAGEMENT ===

  void addBlock(BlockType type) {
    final newBlock = ContentBlock(
      id: const Uuid().v4(),
      type: type,
      content: '',
    );
    blocks.add(newBlock);
  }

  void removeBlock(int index) {
    blocks.removeAt(index);
  }

  void reorderBlocks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, item);
  }

  void updateBlockContent(int index, String val) {
    var block = blocks[index];
    block.content = val;
    blocks[index] = block;
  }

  // === UPLOAD IMAGE PER BLOK ===

  Future<void> pickAndUploadImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        String? url = await _cloudinary.uploadImage(File(image.path));

        Get.back();

        if (url != null) {
          updateBlockContent(index, url);
          NotificationHelper.showSuccess("Berhasil", "Gambar terupload");
        } else {
          NotificationHelper.showError("Gagal", "Gagal upload ke cloud");
        }
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      NotificationHelper.showError("Error", "Terjadi kesalahan: $e");
    }
  }

  // === SAVE TO FIRESTORE ===

  Future<void> saveMaterial() async {
    if (titleController.text.isEmpty) {
      NotificationHelper.showError("Error", "Judul materi tidak boleh kosong");
      return;
    }

    if (blocks.isEmpty) {
      NotificationHelper.showWarning("Peringatan", "Isi materi masih kosong");
      return;
    }

    isSaving.value = true;

    try {
      final material = MaterialModel(
        id: existingMaterial?.id,
        title: titleController.text,
        order:
            existingMaterial?.order ??
            DateTime.now()
                .millisecondsSinceEpoch,
        blocks: blocks,
      );

      await _courseRepo.saveMaterial(courseId, moduleId, sectionId, material);

      Get.back();
      NotificationHelper.showSuccess("Tersimpan", "Materi berhasil disimpan");
    } catch (e) {
      NotificationHelper.showError("Gagal", "Gagal menyimpan materi: $e");
    } finally {
      isSaving.value = false;
    }
  }
}
