import 'dart:async';
import 'package:ecocampus/app/data/models/activity_model.dart';
import 'package:ecocampus/app/data/repositories/activity_repository.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_form_view.dart';
import 'package:ecocampus/app/services/cloudinary_service.dart';
import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RoutineFormState {
  TextEditingController nameC = TextEditingController();
  RxString imageUrl = ''.obs;
}

class ActivityAdminController extends GetxController {
  final ActivityRepository _activityRepo = ActivityRepository.instance;
  final UploadQueueService _queueService = Get.find<UploadQueueService>();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  final isLoadingData = false.obs;
  final isSubmitting = false.obs;
  final isUploadingGallery = false.obs;

  // Form Controllers
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController emailController;
  late TextEditingController waController;
  late TextEditingController igController;
  late TextEditingController searchController;

  // State Variables
  final selectedIcon = 'brush'.obs;
  final isActive = false.obs;
  final heroImageUrl = ''.obs;

  // Lists
  final routineForms = <RoutineFormState>[].obs;
  final galleryUrls = <String>[].obs;

  // Filter & Sort
  final searchQuery = ''.obs;
  final filterStatus = 'semua'.obs;
  final sortOrder = 'terbaru'.obs;

  final RxList<ActivityModel> _sourceActivities = <ActivityModel>[].obs;
  StreamSubscription? _activitySubscription;
  String _currentCategory = '';

  final Map<String, IconData> iconOptions = AppIcons.map;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    descController = TextEditingController();
    emailController = TextEditingController();
    waController = TextEditingController();
    igController = TextEditingController();
    searchController = TextEditingController();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    emailController.dispose();
    waController.dispose();
    igController.dispose();
    searchController.dispose();
    for (var form in routineForms) {
      form.nameC.dispose();
    }
    _activitySubscription?.cancel();
    super.onClose();
  }

  void addRoutine() => routineForms.add(RoutineFormState());

  void removeRoutine(int index) {
    routineForms[index].nameC.dispose();
    routineForms.removeAt(index);
  }

  void addGalleryImage(String url) => galleryUrls.add(url);
  void removeGalleryImage(int index) => galleryUrls.removeAt(index);

  IconData getIconData(String iconName) =>
      AppIcons.map[iconName] ?? Icons.event;

  Future<void> pickGalleryImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        for (var img in images) {
          galleryUrls.add(img.path);
        }
      }
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal mengambil gambar");
    }
  }

  void navigateToForm({String? category, ActivityModel? activity}) {
    titleController.clear();
    selectedIcon.value = 'brush';
    isActive.value = false;
    descController.clear();
    heroImageUrl.value = '';
    emailController.clear();
    waController.clear();
    igController.clear();

    for (var form in routineForms) {
      form.nameC.dispose();
    }
    routineForms.clear();
    galleryUrls.clear();

    if (activity != null) {
      titleController.text = activity.title;
      selectedIcon.value = activity.icon;
      isActive.value = activity.isActive;
      descController.text = activity.description;
      heroImageUrl.value = activity.heroImage;
      emailController.text = activity.contacts.email;
      waController.text = activity.contacts.whatsapp;
      igController.text = activity.contacts.instagram;

      for (var r in activity.routines) {
        var form = RoutineFormState();
        form.nameC.text = r.activityName;
        form.imageUrl.value = r.imageUrl;
        routineForms.add(form);
      }
      galleryUrls.assignAll(activity.gallery);
    }

    isSubmitting.value = false;
    Get.dialog(
      ActivityFormView(
        existingActivity: activity,
        category: category ?? activity?.category ?? 'umum',
      ),
      barrierDismissible: false,
    );
  }

  Future<void> saveActivity({
    required GlobalKey<FormState> formKey,
    required GlobalKey<ShakeWidgetState> shakeKey,
    required String category,
    ActivityModel? existingActivity,
  }) async {
    if (!formKey.currentState!.validate()) {
      shakeKey.currentState?.shake();
      return;
    }

    isSubmitting.value = true;

    try {
      String docId = existingActivity?.id ?? _activityRepo.getNewId();

      final contacts = ContactModel(
        email: emailController.text,
        whatsapp: waController.text,
        instagram: igController.text,
      );

      final routines = routineForms
          .map(
            (form) => RoutineModel(
              activityName: form.nameC.text,
              imageUrl: form.imageUrl.value,
            ),
          )
          .toList();

      final activityData = ActivityModel(
        id: docId,
        title: titleController.text,
        icon: selectedIcon.value,
        category: category,
        isActive: isActive.value,
        description: descController.text,
        heroImage: heroImageUrl.value,
        contacts: contacts,
        routines: routines,
        gallery: galleryUrls,
        isSynced: false,
      );

      if (existingActivity != null) {
        _cleanupReplacedImages(existingActivity, activityData);
      }

      await _activityRepo
          .setActivity(activityData)
          .timeout(const Duration(seconds: 2), onTimeout: () => null);

      if (heroImageUrl.value.isNotEmpty &&
          !heroImageUrl.value.startsWith('http')) {
        _queueService.addToQueue(docId, 'heroImage', heroImageUrl.value);
      }

      for (int i = 0; i < galleryUrls.length; i++) {
        String path = galleryUrls[i];
        if (path.isNotEmpty && !path.startsWith('http')) {
          _queueService.addToQueue(docId, 'gallery', path, index: i);
        }
      }

      for (int i = 0; i < routineForms.length; i++) {
        String path = routineForms[i].imageUrl.value;
        if (path.isNotEmpty && !path.startsWith('http')) {
          _queueService.addToQueue(docId, 'routines', path, index: i);
        }
      }

      Get.back();
      NotificationHelper.showSuccess(
        "Disimpan",
        "Data disimpan. Gambar akan diupload di background.",
      );
    } catch (e) {
      NotificationHelper.showError("Gagal", "Gagal menyimpan data: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _safeDeleteImage(String url) async {
    if (url.isEmpty || !url.startsWith('http')) return;

    bool success = await _cloudinaryService.deleteImage(url);

    if (!success) {
      _queueService.addDeleteToQueue(url);
    }
  }

  Future<bool> deleteActivity(String id) async {
    try {
      var doc = await _activityRepo.getActivityById(id);

      if (doc != null) {
        List<Future> deleteTasks = [];
        if (doc.heroImage.isNotEmpty) {
          deleteTasks.add(_safeDeleteImage(doc.heroImage));
        }

        for (var url in doc.gallery) {
          deleteTasks.add(_safeDeleteImage(url));
        }

        for (var r in doc.routines) {
          deleteTasks.add(_safeDeleteImage(r.imageUrl));
        }

        if (deleteTasks.isNotEmpty) {
          await Future.wait(deleteTasks);
        }
      }

      await _activityRepo.deleteActivity(id);
      return true;
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal menghapus data.");
      return false;
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
        NotificationHelper.showSuccess("Dihapus", "Kegiatan berhasil dihapus.");
      },
    );
  }

  void _cleanupReplacedImages(ActivityModel oldData, ActivityModel newData) {
    if (oldData.heroImage.startsWith('http') &&
        oldData.heroImage != newData.heroImage) {
      _safeDeleteImage(oldData.heroImage);
    }
    for (var oldUrl in oldData.gallery) {
      if (oldUrl.startsWith('http') && !newData.gallery.contains(oldUrl)) {
        _safeDeleteImage(oldUrl);
      }
    }
    Set<String> newRoutineUrls = newData.routines
        .map((e) => e.imageUrl)
        .toSet();
    for (var r in oldData.routines) {
      if (r.imageUrl.startsWith('http') &&
          !newRoutineUrls.contains(r.imageUrl)) {
        _safeDeleteImage(r.imageUrl);
      }
    }
  }

  Stream<List<ActivityModel>> getActivitiesByCategory(String category) {
    return _activityRepo.getActivitiesByCategory(category);
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
    if (sortOrder.value == 'terlama') {
      list = list.reversed.toList();
    } else if (sortOrder.value == 'az') {
      list.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortOrder.value == 'za') {
      list.sort((a, b) => b.title.compareTo(a.title));
    }
    return list;
  }
}
