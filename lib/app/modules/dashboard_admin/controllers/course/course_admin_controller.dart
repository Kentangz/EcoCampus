import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseAdminController extends GetxController {
  final CourseRepository _courseRepo = Get.put(CourseRepository());

  // === STATE VARIABLES ===
  final RxList<CourseModel> courses = <CourseModel>[].obs;

  final isLoading = true.obs;

  // === LIFECYCLE ===
  @override
  void onInit() {
    super.onInit();
    courses.bindStream(_courseRepo.getAllCourses());
  }

  // === NAVIGATION ===
  void navigateToCourseForm({CourseModel? course}) {
    Get.toNamed(Routes.ADMIN_COURSE_FORM, arguments: course);
  }

  // === DELETION ===
  void confirmDeleteCourse(CourseModel course) {
    Get.defaultDialog(
      title: "Hapus Kelas",
      middleText:
          "Yakin ingin menghapus kelas '${course.title}'?\nData modul dan materi di dalamnya juga akan terhapus.",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _deleteCourse(course.id!);
      },
    );
  }

  Future<void> _deleteCourse(String id) async {
    try {
      await _courseRepo.deleteCourse(id);
      NotificationHelper.showSuccess("Berhasil", "Kelas berhasil dihapus");
    } catch (e) {
      NotificationHelper.showError("Gagal", "Gagal menghapus kelas: $e");
    }
  }
}
