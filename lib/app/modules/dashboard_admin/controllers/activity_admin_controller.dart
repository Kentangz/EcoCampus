import 'dart:async';
import 'package:ecocampus/app/data/models/activity_model.dart';
import 'package:ecocampus/app/data/repositories/activity_repository.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_form_view.dart';
import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SaveStatus { success, offline, failed }

class ActivityAdminController extends GetxController {
  final ActivityRepository _activityRepo = ActivityRepository.instance;

  final isLoadingData = false.obs;
  final isSubmitting = false.obs;

  late TextEditingController titleController;
  final selectedIcon = 'brush'.obs;
  final isActive = false.obs;

  late TextEditingController searchController;
  final searchQuery = ''.obs;
  final filterStatus = 'semua'.obs;
  final sortOrder = 'terbaru'.obs;

  final RxList<ActivityModel> _sourceActivities = <ActivityModel>[].obs;
  StreamSubscription? _activitySubscription;
  String _currentCategory = '';

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    searchController = TextEditingController();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    searchController.dispose();
    _activitySubscription?.cancel();
    super.onClose();
  }

  void initActivities(String category) {
    if (_currentCategory == category && _sourceActivities.isNotEmpty) return;

    _currentCategory = category;
    _activitySubscription?.cancel();

    isLoadingData.value = true;
    _activitySubscription = _activityRepo
        .getActivitiesByCategory(category)
        .listen((data) {
          _sourceActivities.assignAll(data);
          isLoadingData.value = false;
        });
  }

  List<ActivityModel> get visibleActivities {
    List<ActivityModel> list = List.from(_sourceActivities);
    if (filterStatus.value == 'aktif') {
      list = list.where((item) => item.isActive).toList();
    } else if (filterStatus.value == 'tidak_aktif') {
      list = list.where((item) => !item.isActive).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (item) => item.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList();
    }
    switch (sortOrder.value) {
      case 'terlama':
        list = list.reversed.toList();
        break;
      case 'az':
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'za':
        list.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'terbaru':
      default:
        break;
    }
    return list;
  }

  Future<SaveStatus> addActivity({
    required String title,
    required String icon,
    required String category,
    required bool isActive,
  }) async {
    try {
      final newActivity = ActivityModel(
        title: title,
        icon: icon,
        category: category,
        isActive: isActive,
      );
      await _activityRepo
          .addActivity(newActivity)
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw TimeoutException("Simpan Offline");
            },
          );
      return SaveStatus.success;
    } on TimeoutException catch (_) {
      return SaveStatus.offline;
    } catch (e) {
      NotificationHelper.showError("Gagal", "Terjadi kesalahan: $e");
      return SaveStatus.failed;
    }
  }

  Future<bool> deleteActivity(String id) async {
    try {
      await _activityRepo
          .deleteActivity(id)
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw TimeoutException("Delete Offline");
            },
          );
      return true;
    } on TimeoutException catch (_) {
      return true;
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal menghapus data.");
      return false;
    }
  }

  void navigateToAddActivity(String category) {
    titleController.clear();
    selectedIcon.value = 'brush';
    isActive.value = false;
    isSubmitting.value = false;
    Get.dialog(
      const ActivityFormView(),
      arguments: {'category': category},
      barrierDismissible: false,
    );
  }

  Future<void> saveActivity({
    required GlobalKey<FormState> formKey,
    required GlobalKey<ShakeWidgetState> shakeKey,
    required String category,
  }) async {
    if (!formKey.currentState!.validate()) {
      shakeKey.currentState?.shake();
      return;
    }
    isSubmitting.value = true;

    SaveStatus result = await addActivity(
      title: titleController.text,
      icon: selectedIcon.value,
      category: category,
      isActive: isActive.value,
    );
    if (result == SaveStatus.success) {
      Get.back();
      NotificationHelper.showSuccess(
        "Berhasil",
        "Kegiatan berhasil ditambahkan!",
      );
      await Future.delayed(const Duration(milliseconds: 300));
      isSubmitting.value = false;
    } 
    else if (result == SaveStatus.offline) {
      Get.back();
      NotificationHelper.showWarning(
        "Berhasil",
        "Disimpan di lokal. Akan diupload saat ada internet.",
      );
      await Future.delayed(const Duration(milliseconds: 300));
      isSubmitting.value = false;
    } else {
      NotificationHelper.showError(
        "Gagal",
        "Gagal menambahkan kegiatan!",
      );
      isSubmitting.value = false;
    }
  }

  void confirmDeleteActivity(ActivityModel activity) {
    Get.defaultDialog(
      title: "Hapus Kegiatan",
      middleText: "Yakin ingin menghapus ${activity.title}?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        if (Get.overlayContext != null) {
          Navigator.of(Get.overlayContext!).pop();
        } else {
          Get.back();
        }
        await deleteActivity(activity.id!);
      },
    );
  }

  IconData getIconData(String iconName) {
    return AppIcons.map[iconName] ?? Icons.event;
  }
}
