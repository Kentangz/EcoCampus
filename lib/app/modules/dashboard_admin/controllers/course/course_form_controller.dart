import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CourseFormController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final CourseRepository _courseRepo = Get.find<CourseRepository>();
  final UploadQueueService _queueService = Get.find<UploadQueueService>();
  final ImagePicker _picker = ImagePicker();

  late TabController tabController;
  final formKey = GlobalKey<FormState>();
  final titleShakeKey = GlobalKey<ShakeWidgetState>();

  // === FORM CONTROLLERS ===
  final titleC = TextEditingController();

  // === STATE VARIABLES ===
  final heroImageUrl = ''.obs;
  final isActive = true.obs;
  final isLoading = false.obs;
  final isUploading = false.obs;

  String? courseId;
  final isEditMode = false.obs;

  final modules = <ModuleModel>[].obs;
  final deletedModuleIds = <String>[];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    final CourseModel? args = Get.arguments;
    if (args != null) {
      isEditMode.value = true;
      courseId = args.id;
      titleC.text = args.title;
      heroImageUrl.value = args.heroImage;
      isActive.value = args.isActive;
      _loadModules();
    } else {
      courseId = FirebaseFirestore.instance.collection('Courses').doc().id;
    }
  }

  void _loadModules() {
    if (courseId == null) return;
    _courseRepo.getModules(courseId!).listen((data) {
      if (isEditMode.value) {
        modules.assignAll(data);
      }
    });
  }

  @override
  void onClose() {
    titleC.dispose();
    tabController.dispose();
    super.onClose();
  }

  // === IMAGE PICKER ===
  Future<void> pickHeroImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        heroImageUrl.value = image.path;
      }
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal memilih gambar");
    }
  }

  // === SAVE DATA ===
  Future<void> saveCourse() async {
    if (!formKey.currentState!.validate()) {
      if (titleC.text.isEmpty) titleShakeKey.currentState?.shake();
      tabController.animateTo(0);
      return;
    }

    isLoading.value = true;
    try {
      String finalHeroUrl = heroImageUrl.value;
      if (finalHeroUrl.isNotEmpty && !finalHeroUrl.startsWith('http')) {}

      final course = CourseModel(
        id: courseId,
        title: titleC.text,
        heroImage: finalHeroUrl,
        isActive: isActive.value,
        category: 'akademik_karir',
        totalModules: modules.length,
      );

      if (isEditMode.value && deletedModuleIds.isNotEmpty) {
        for (var id in deletedModuleIds) {
          await _courseRepo.deleteModule(courseId!, id);
        }
      }

      await _courseRepo.saveCourseWithModules(course, modules);

      if (finalHeroUrl.isNotEmpty && !finalHeroUrl.startsWith('http')) {
        _queueService.addToQueue(
          courseId!,
          'heroImage',
          finalHeroUrl,
          collection: 'Courses',
        );
      }

      Get.back();
      NotificationHelper.showSuccess(
        isEditMode.value ? "Diperbarui" : "Tersimpan",
        "Data kelas berhasil disimpan",
      );
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal menyimpan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // === MODULE DIALOG ===
  void showModuleDialog({ModuleModel? existingModule}) {
    final titleModuleC = TextEditingController(
      text: existingModule?.title ?? '',
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                existingModule == null ? "Tambah Modul" : "Edit Modul",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleModuleC,
                decoration: InputDecoration(
                  labelText: "Nama Modul",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (titleModuleC.text.isEmpty) return;
                      Get.back();

                      if (existingModule != null) {
                        int index = modules.indexOf(existingModule);
                        if (index != -1) {
                          modules[index] = ModuleModel(
                            id: existingModule.id,
                            title: titleModuleC.text,
                            order: existingModule.order,
                          );
                          if (isEditMode.value) {}
                        }
                      } else {
                        final newModule = ModuleModel(
                          id: null,
                          title: titleModuleC.text,
                          order: modules.length + 1,
                        );
                        modules.add(newModule);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === DELETE MODULE ===
  void confirmDeleteModule(ModuleModel module) {
    Get.defaultDialog(
      title: "Hapus Modul",
      middleText: "Yakin hapus modul ini? Aksi ini tidak dapat dibatalkan.",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();

        if (isEditMode.value && module.id != null) {
          try {
            await _courseRepo.deleteModule(courseId!, module.id!);
            modules.remove(module);
          } catch (e) {
            //
          }
        } else {
          modules.remove(module);
        }

        for (int i = 0; i < modules.length; i++) {
          modules[i].order = i + 1;
        }
      },
    );
  }

  // === NAVIGATION ===
  void navigateToModuleDetail(ModuleModel module) {
    if (courseId == null) return;

    if (!isEditMode.value && module.id == null) {
      NotificationHelper.showWarning(
        "Info",
        "Simpan kelas terlebih dahulu untuk mengelola materi.",
      );
      return;
    }

    Get.toNamed(
      Routes.ADMIN_MODULE_DETAIL,
      arguments: {'courseId': courseId, 'module': module},
    );
  }
}
