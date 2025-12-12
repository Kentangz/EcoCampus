import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/icon_picker_dialog.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseFormController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final CourseRepository _courseRepo = Get.find<CourseRepository>();
  final UploadQueueService _queueService = Get.find<UploadQueueService>();

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
  final quizzes = <QuizModel>[].obs;
  final deletedModuleIds = <String>[];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);

    final CourseModel? args = Get.arguments;
    if (args != null) {
      isEditMode.value = true;
      courseId = args.id;
      titleC.text = args.title;
      heroImageUrl.value = args.heroImage;
      isActive.value = args.isActive;
      _loadModules();
      _loadQuizzes();
    } else {
      courseId = _courseRepo.newId;
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

  void _loadQuizzes() {
    if (courseId == null) return;
    _courseRepo.getQuizzes(courseId!).listen((data) {
      if (isEditMode.value) {
        quizzes.assignAll(data);
      }
    });
  }

  @override
  void onClose() {
    titleC.dispose();
    tabController.dispose();
    super.onClose();
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
          collection: CourseRepository.COLLECTION,
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


  // === QUIZ MANAGEMENT ===

  IconData getIcon(String name) => AppIcons.getIcon(name);

  void showQuizDialog({QuizModel? existingQuiz}) {
    if (!isEditMode.value) {
      NotificationHelper.showWarning("Info", "Simpan kelas terlebih dahulu.");
      return;
    }

    final titleQuizC = TextEditingController(text: existingQuiz?.title ?? '');

    final selectedIcon = (existingQuiz?.icon ?? 'quiz').obs;
    final isActive = (existingQuiz?.isActive ?? false).obs;

    Get.defaultDialog(
      title: existingQuiz == null ? "Buat Kuis Baru" : "Edit Kuis",
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 300,
        child: Column(
          children: [
            TextField(
              controller: titleQuizC,
              decoration: const InputDecoration(
                labelText: "Judul Kuis / Latihan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => SwitchListTile(
                title: const Text("Status Aktif"),
                value: isActive.value,
                onChanged: (val) => isActive.value = val,
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pilih Ikon:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => InkWell(
                onTap: () {
                  Get.dialog(
                    IconPickerDialog(
                      onIconSelected: (iconName) {
                        selectedIcon.value = iconName;
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            AppIcons.getIcon(selectedIcon.value),
                            color: const Color(0xFF6C63FF),
                          ),
                          const SizedBox(width: 12),
                          Text(selectedIcon.value),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF6C63FF),
      onConfirm: () async {
        if (titleQuizC.text.isEmpty) return;
        Get.back();

        final quiz = QuizModel(
          id: existingQuiz?.id,
          title: titleQuizC.text,
          order: existingQuiz?.order ?? (quizzes.length + 1),
          icon: selectedIcon.value,
          rules: existingQuiz?.rules ?? [],
          isActive: isActive.value,
          totalQuestions: existingQuiz?.totalQuestions ?? 0,
        );

        await _courseRepo.saveQuiz(courseId!, quiz);
        quizzes.bindStream(_courseRepo.getQuizzes(courseId!));
      },
    );
  }

  void confirmDeleteQuiz(QuizModel quiz) {
    Get.defaultDialog(
      title: "Hapus Kuis",
      middleText:
          "Yakin hapus '${quiz.title}'? Semua soal di dalamnya akan hilang.",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _courseRepo.deleteQuiz(courseId!, quiz.id!);
      },
    );
  }

  void navigateToQuizDetail(QuizModel quiz) {
    Get.toNamed(
      Routes.ADMIN_QUIZ_LIST,
      arguments: {
        'quizTitle': quiz.title,
        'quizId': quiz.id,
        'courseId': courseId,
      },
    );
  }
}
