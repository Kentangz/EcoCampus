import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'dart:async';
import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseAdminController extends GetxController {
  final CourseRepository _courseRepo = Get.put(CourseRepository());

  // === STATE VARIABLES ===
  final RxList<CourseModel> courses = <CourseModel>[].obs;

  final isLoading = true.obs;

  // === FILTER & SEARCH ===
  final searchController = TextEditingController();
  final sortOrder = 'terbaru'.obs;
  final filterStatus = 'semua'.obs;

  List<CourseModel> get visibleCourses {
    var list = List<CourseModel>.from(courses);

    if (filterStatus.value == 'aktif') {
      list = list.where((c) => c.isActive).toList();
    } else if (filterStatus.value == 'draft') {
      list = list.where((c) => !c.isActive).toList();
    }

    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      list = list.where((c) => c.title.toLowerCase().contains(query)).toList();
    }
    switch (sortOrder.value) {
      case 'terbaru':
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(0);
          final bDate = b.createdAt ?? DateTime(0);
          return bDate.compareTo(aDate);
        });
        break;
      case 'terlama':
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(0);
          final bDate = b.createdAt ?? DateTime(0);
          return aDate.compareTo(bDate);
        });
        break;
      case 'az':
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'za':
        list.sort((a, b) => b.title.compareTo(a.title));
        break;
    }

    return list;
  }

  StreamSubscription<List<CourseModel>>? _streamSub;

  // === LIFECYCLE ===
  @override
  void onInit() {
    super.onInit();
    _bindStream();
    searchController.addListener(() => courses.refresh());
  }

  @override
  void onClose() {
    searchController.dispose();
    _streamSub?.cancel();
    super.onClose();
  }

  void _bindStream() {
    isLoading.value = true;
    _streamSub = _courseRepo.getAllCourses().listen(
      (list) {
        courses.assignAll(list);
        isLoading.value = false;
      },
      onError: (e) {
        if (AuthenticationRepository.instance.currentUser == null) {
          return;
        }

        isLoading.value = false;
        NotificationHelper.showError("Error", "Gagal memuat kelas: $e");
      },
    );
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
