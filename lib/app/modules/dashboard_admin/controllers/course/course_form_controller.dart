import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/icon_picker_dialog.dart';
import 'package:ecocampus/app/shared/widgets/image_picker.dart';
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
  final selectedIcon = 'school'.obs;
  final isActive = false.obs;
  final isLoading = false.obs;
  final isUploading = false.obs;

  // Banner Image State
  final courseImagePath = ''.obs;
  final isCourseImageRemoved = false.obs;

  final techStackIcon = ''.obs;

  String? courseId;
  final isEditMode = false.obs;

  final modules = <ModuleModel>[].obs;
  final quizzes = <QuizModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final CourseModel? args = Get.arguments;
    if (args != null) {
      isEditMode.value = true;
      courseId = args.id;
      titleC.text = args.title;
      selectedIcon.value = args.icon;
      isActive.value = args.isActive;

      if (args.imageUrl != null) courseImagePath.value = args.imageUrl!;

      if (args.techStackIcon != null) {
        techStackIcon.value = args.techStackIcon!;
      }

      _loadModules();
      _loadQuizzes();
    } else {
      courseId = _courseRepo.newId;
    }

    tabController = TabController(
      length: isEditMode.value ? 3 : 1,
      vsync: this,
    );
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
      String? finalCourseParamsUrl;
      bool isNewCourseImage = false;

      if (isCourseImageRemoved.value) {
        finalCourseParamsUrl = null;
      } else if (courseImagePath.value.isNotEmpty &&
          !courseImagePath.value.startsWith('http')) {
        finalCourseParamsUrl = courseImagePath.value;
        isNewCourseImage = true;
      } else {
        final CourseModel? args = Get.arguments;
        finalCourseParamsUrl = args?.imageUrl;
      }

      final course = CourseModel(
        id: courseId,
        title: titleC.text,
        icon: selectedIcon.value,
        isActive: isActive.value,
        category: 'akademik_karir',
        totalModules: modules.length,
        totalQuizzes: quizzes.length,
        imageUrl: finalCourseParamsUrl,
        techStackIcon: techStackIcon.value.isEmpty ? null : techStackIcon.value,
      );

      try {
        await _courseRepo
            .saveCourseWithModules(course, modules)
            .timeout(const Duration(seconds: 3));

        if (isNewCourseImage && finalCourseParamsUrl != null) {
          _queueService.addToQueue(
            course.id!,
            'imageUrl',
            finalCourseParamsUrl,
            collection: 'Courses',
          );
        }

        final CourseModel? oldArgs = Get.arguments;
        if (oldArgs != null) {
          if (oldArgs.imageUrl != null &&
              oldArgs.imageUrl != finalCourseParamsUrl &&
              oldArgs.imageUrl!.startsWith('http')) {
            _queueService.addDeleteToQueue(oldArgs.imageUrl!);
          }
        }
      } on Exception catch (_) {}

      Get.back();
      NotificationHelper.showSuccess(
        isEditMode.value ? "Diperbarui" : "Tersimpan",
        "Data kelas berhasil disimpan",
      );
    } catch (e) {
      if (e.toString().contains("TimeoutException")) {
        Get.back();
        NotificationHelper.showSuccess(
          isEditMode.value ? "Diperbarui" : "Tersimpan",
          "Data kelas berhasil disimpan (Offline)",
        );
      } else {
        NotificationHelper.showError("Error", "Gagal menyimpan: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  final moduleTitleError = ''.obs;
  final moduleImageError = ''.obs;
  final quizTitleError = ''.obs;

  // === MODULE DIALOG ===
  void showModuleDialog({ModuleModel? existingModule}) {
    if (!isEditMode.value) return;

    final titleModuleC = TextEditingController(
      text: existingModule?.title ?? '',
    );
    final moduleImagePath = ''.obs;
    final isImageRemoved = false.obs;

    final isModuleActive = (existingModule?.isActive ?? false).obs;

    moduleTitleError.value = '';
    moduleImageError.value = '';

    final titleShakeKey = GlobalKey<ShakeWidgetState>();
    final imageShakeKey = GlobalKey<ShakeWidgetState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
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
              ShakeWidget(
                key: titleShakeKey,
                child: Obx(
                  () => TextField(
                    controller: titleModuleC,
                    onChanged: (_) => moduleTitleError.value = '',
                    decoration: InputDecoration(
                      labelText: "Nama Modul",
                      errorText: moduleTitleError.value.isNotEmpty
                          ? moduleTitleError.value
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => SwitchListTile(
                  title: const Text("Status Aktif"),
                  value: isModuleActive.value,
                  onChanged: (val) => isModuleActive.value = val,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => ShakeWidget(
                  key: imageShakeKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomImagePicker(
                        label: "Sampul Modul",
                        initialImageUrl: moduleImagePath.value.isNotEmpty
                            ? moduleImagePath.value
                            : existingModule?.imageUrl ?? '',
                        allowDelete: false,
                        onImagePicked: (file) {
                          if (file != null) {
                            moduleImagePath.value = file.path;
                            isImageRemoved.value = false;
                            moduleImageError.value = '';
                          } else {
                            moduleImagePath.value = '';
                            isImageRemoved.value = true;
                          }
                        },
                      ),
                      if (moduleImageError.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            moduleImageError.value,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
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
                      bool isValid = true;

                      if (titleModuleC.text.isEmpty) {
                        titleShakeKey.currentState?.shake();
                        moduleTitleError.value = "Nama modul wajib diisi";
                        isValid = false;
                      }

                      bool hasImage = false;
                      if (moduleImagePath.value.isNotEmpty) {
                        hasImage = true;
                      } else if (!isImageRemoved.value &&
                          existingModule?.imageUrl != null &&
                          existingModule!.imageUrl!.isNotEmpty) {
                        hasImage = true;
                      }

                      if (!hasImage) {
                        imageShakeKey.currentState?.shake();
                        moduleImageError.value = "Gambar modul wajib diisi";
                        isValid = false;
                      }

                      if (!isValid) return;

                      Get.back();

                      String? finalImageUrl;
                      bool isNewImage = false;

                      if (isImageRemoved.value) {
                        finalImageUrl = null;
                      } else if (moduleImagePath.value.isNotEmpty) {
                        finalImageUrl = moduleImagePath.value;
                        isNewImage = true;
                      } else if (existingModule?.imageUrl != null) {
                        finalImageUrl = existingModule!.imageUrl;
                      }

                      ModuleModel moduleToSave;
                      if (existingModule != null) {
                        moduleToSave = ModuleModel(
                          id: existingModule.id,
                          title: titleModuleC.text,
                          order: existingModule.order,
                          imageUrl: finalImageUrl,
                          isActive: isModuleActive.value,
                        );
                      } else {
                        moduleToSave = ModuleModel(
                          id: isEditMode.value ? _courseRepo.newId : null,
                          title: titleModuleC.text,
                          order: modules.length + 1,
                          imageUrl: finalImageUrl,
                          isActive: isModuleActive.value,
                        );
                      }

                      if (courseId != null) {
                        try {
                          await _courseRepo.saveModule(
                            courseId!,
                            moduleToSave,
                            isNew: existingModule == null,
                          );

                          if (isNewImage && finalImageUrl != null) {
                            _queueService.addToQueue(
                              moduleToSave.id!,
                              'imageUrl',
                              finalImageUrl,
                              collection: 'Courses/$courseId/modules',
                            );
                          }

                          if (existingModule != null &&
                              existingModule.imageUrl != null &&
                              existingModule.imageUrl != finalImageUrl &&
                              existingModule.imageUrl!.startsWith('http')) {
                            _queueService.addDeleteToQueue(
                              existingModule.imageUrl!,
                            );
                          }

                          NotificationHelper.showSuccess(
                            "Tersimpan",
                            "Modul berhasil disimpan",
                          );
                        } catch (e) {
                          NotificationHelper.showError(
                            "Error",
                            "Gagal menyimpan modul: $e",
                          );
                        }
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

        if (module.id != null) {
          try {
            await _courseRepo.deleteModule(courseId!, module);
          } catch (e) {
            NotificationHelper.showError("Gagal", "Gagal menghapus modul: $e");
          }
        }

        for (int i = 0; i < modules.length; i++) {
          modules[i].order = i + 1;
        }
      },
    );
  }

  // === REORDER MODULES ===
  void reorderModules(int oldIndex, int newIndex) {
    if (!isEditMode.value) return;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ModuleModel item = modules.removeAt(oldIndex);
    modules.insert(newIndex, item);

    for (int i = 0; i < modules.length; i++) {
      modules[i].order = i + 1;
    }

    if (courseId != null) {
      _courseRepo.reorderModules(courseId!, modules);
    }
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
    quizTitleError.value = '';

    final selectedIcon = (existingQuiz?.icon ?? 'quiz').obs;
    final isActive = (existingQuiz?.isActive ?? false).obs;

    Get.defaultDialog(
      title: existingQuiz == null ? "Buat Kuis Baru" : "Edit Kuis",
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 300,
        child: Column(
          children: [
            Obx(
              () => TextField(
                controller: titleQuizC,
                onChanged: (_) => quizTitleError.value = '',
                decoration: InputDecoration(
                  labelText: "Judul Kuis / Latihan",
                  errorText: quizTitleError.value.isNotEmpty
                      ? quizTitleError.value
                      : null,
                  border: const OutlineInputBorder(),
                ),
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
        if (titleQuizC.text.isEmpty) {
          quizTitleError.value = "Judul kuis wajib diisi";
          return;
        }
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

        await _courseRepo.saveQuiz(
          courseId!,
          quiz,
          isNew: existingQuiz == null,
        );
      },
    );
  }

  void confirmDeleteQuiz(QuizModel quiz) {
    Get.defaultDialog(
      title: "Hapus Kuis",
      middleText:
          "Yakin hapus '${quiz.title}'? Semua soal di dalamnya akan hilang.",
      textConfirm: "Hapus",
      textCancel: "Batal",
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
