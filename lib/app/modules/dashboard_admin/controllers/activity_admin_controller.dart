import 'dart:async';
import 'package:ecocampus/app/data/models/activity_model.dart';
import 'package:ecocampus/app/data/repositories/activity_repository.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/seni_budaya_form_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/magang_form_view.dart';
import 'package:ecocampus/app/services/cloudinary_service.dart';
import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum SaveStatus { success, offline, failed }

class RoutineFormState {
  TextEditingController nameC = TextEditingController();
  RxString imageUrl = ''.obs;
}

class QualificationState {
  TextEditingController textC = TextEditingController();
}

class ActivityAdminController extends GetxController {
  final ActivityRepository _activityRepo = ActivityRepository.instance;
  final UploadQueueService _queueService = Get.find<UploadQueueService>();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  final isLoadingData = false.obs;
  final isSubmitting = false.obs;
  final isUploadingGallery = false.obs;

  // === General Form Controllers ===
  late TextEditingController titleController; // Nama Kegiatan / Nama Perusahaan
  late TextEditingController descController;
  late TextEditingController emailController;
  late TextEditingController waController;
  late TextEditingController igController;
  late TextEditingController searchController;

  // === Magang Form Controllers ===
  late TextEditingController positionController;
  late TextEditingController locationController;

  // === STATE VARIABLES ===
  final selectedIcon = 'brush'.obs;
  final isActive = false.obs;
  final heroImageUrl = ''.obs;
  final companyLogoUrl = ''.obs;

  // === VALIDATION ERROR MESSAGES ===
  final contactError = ''.obs;
  final techStackError = ''.obs;
  final qualificationError = ''.obs;

  // === DYNAMIC LISTS ===
  final routineForms = <RoutineFormState>[].obs;
  final galleryUrls = <String>[].obs;
  final techStacks = <String>[].obs;
  final qualificationForms = <QualificationState>[].obs;

  // === FILTER & SORT ===
  final searchQuery = ''.obs;
  final filterStatus = 'semua'.obs;
  final sortOrder = 'terbaru'.obs;

  final RxList<ActivityModel> _sourceActivities = <ActivityModel>[].obs;
  StreamSubscription? _activitySubscription;
  String _currentCategory = '';

  final Map<String, IconData> iconOptions = AppIcons.map;

  // === SCROLL & SHAKE KEYS ===
  final ScrollController scrollController = ScrollController();

  final GlobalKey<ShakeWidgetState> titleShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> descShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> contactShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> positionShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> locationShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> techStackShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> qualificationShakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    descController = TextEditingController();
    emailController = TextEditingController();
    waController = TextEditingController();
    igController = TextEditingController();
    igController = TextEditingController();
    positionController = TextEditingController();
    locationController = TextEditingController();
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
    positionController.dispose();
    locationController.dispose();
    searchController.dispose();
    scrollController.dispose();

    for (var form in routineForms) { form.nameC.dispose(); }
    for (var q in qualificationForms) { q.textC.dispose(); }

    _activitySubscription?.cancel();
    super.onClose();
  }

  // === HELPERS ===
  void addRoutine() => routineForms.add(RoutineFormState());
  void removeRoutine(int index) {
    routineForms[index].nameC.dispose();
    routineForms.removeAt(index);
  }

  void addGalleryImage(String url) => galleryUrls.add(url);
  void removeGalleryImage(int index) => galleryUrls.removeAt(index);

  void addQualification() => qualificationForms.add(QualificationState());
  void removeQualification(int index) {
    qualificationForms[index].textC.dispose();
    qualificationForms.removeAt(index);
  }

  void toggleTechStack(String iconName) {
    if (techStacks.contains(iconName)) {
      techStacks.remove(iconName);
    } else {
      techStacks.add(iconName);
    }
  }

  // === HELPER: AMAN HAPUS GAMBAR ===
  Future<void> _safeDeleteImage(String url) async {
    if (url.isEmpty || !url.startsWith('http')) return;
    bool success = await _cloudinaryService.deleteImage(url);
    if (!success) {
      _queueService.addDeleteToQueue(url);
    }
  }

  IconData getIconData(String iconName) =>
      AppIcons.map[iconName] ?? Icons.event;

  // === IMAGE PICKER (GALLERY MULTI) ===
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

  // === PICK SINGLE IMAGE (LOGO PERUSAHAAN) ===
  Future<void> pickCompanyLogo() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) { companyLogoUrl.value = image.path; }
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal mengambil gambar");
    }
  }

  // === NAVIGASI (ROUTER) ===
  void navigateToForm({String? category, ActivityModel? activity}) {
    titleController.clear();
    selectedIcon.value = 'brush';
    isActive.value = true;
    descController.clear();
    heroImageUrl.value = '';
    emailController.clear();
    waController.clear();
    igController.clear();
    positionController.clear();
    locationController.clear();
    companyLogoUrl.value = '';

    contactError.value = '';
    techStackError.value = '';
    qualificationError.value = '';

    for (var form in routineForms) { form.nameC.dispose(); }
    routineForms.clear();
    galleryUrls.clear();
    techStacks.clear();
    for (var q in qualificationForms) { q.textC.dispose(); }
    qualificationForms.clear();

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

      positionController.text = activity.position;
      locationController.text = activity.location;
      companyLogoUrl.value = activity.companyLogo;
      techStacks.assignAll(activity.techStacks);
      for (var q in activity.qualifications) {
        var form = QualificationState();
        form.textC.text = q;
        qualificationForms.add(form);
      }
    }

    isSubmitting.value = false;
    String targetCategory = category ?? activity?.category ?? 'umum';

    if (targetCategory == 'magang') {
      Get.dialog(
        MagangFormView(existingActivity: activity),
        barrierDismissible: false,
      );
    } else {
      Get.dialog(
        SeniBudayaFormView(
          existingActivity: activity,
          category: targetCategory,
        ),
        barrierDismissible: false,
      );
    }
  }

  // === SAVE DATA ===
  Future<void> saveActivity({
    required GlobalKey<FormState> formKey,
    required String category,
    ActivityModel? existingActivity,
  }) async {
    contactError.value = '';
    techStackError.value = '';
    qualificationError.value = '';

    bool isValid = true;

    if (!formKey.currentState!.validate()) {
      isValid = false;
      if (titleController.text.isEmpty) titleShakeKey.currentState?.shake();
      if (category == 'magang') {
        if (positionController.text.isEmpty) positionShakeKey.currentState?.shake();
        if (locationController.text.isEmpty) locationShakeKey.currentState?.shake();
      } else {
        if (descController.text.isEmpty) descShakeKey.currentState?.shake();
      }
    }

    if (emailController.text.isEmpty &&
        waController.text.isEmpty &&
        igController.text.isEmpty) {
      isValid = false;
      contactError.value = "Harap isi minimal satu kontak";
      contactShakeKey.currentState?.shake();
    }

    if (category == 'magang') {
      if (techStacks.isEmpty) {
        isValid = false;
        techStackError.value = "Pilih minimal satu tech stack";
        techStackShakeKey.currentState?.shake();
      }

      bool hasQualification = qualificationForms.any(
        (q) => q.textC.text.isNotEmpty,
      );
      if (!hasQualification) {
        isValid = false;
        qualificationError.value = "Isi minimal satu kualifikasi";
        qualificationShakeKey.currentState?.shake();
      }
    }

    if (!isValid) {
      _scrollToFirstError(category);
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

      final qualifications = qualificationForms
          .map((q) => q.textC.text)
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
        position: positionController.text,
        location: locationController.text,
        companyLogo: companyLogoUrl.value,
        techStacks: techStacks,
        qualifications: qualifications,
        isSynced: false,
      );

      if (existingActivity != null) {
        _cleanupReplacedImages(existingActivity, activityData);
      }

      await _activityRepo
          .setActivity(activityData)
          .timeout(const Duration(seconds: 2), onTimeout: () => null);

      // === QUEUE UPLOAD ===
      if (heroImageUrl.value.isNotEmpty &&
          !heroImageUrl.value.startsWith('http')) {
        _queueService.addToQueue(docId, 'heroImage', heroImageUrl.value);
      }

      if (companyLogoUrl.value.isNotEmpty &&
          !companyLogoUrl.value.startsWith('http')) {
        _queueService.addToQueue(docId, 'companyLogo', companyLogoUrl.value);
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
        "Data disimpan",
      );
    } catch (e) {
      NotificationHelper.showError("Gagal", "Gagal menyimpan data: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  void _cleanupReplacedImages(ActivityModel oldData, ActivityModel newData) {
    if (oldData.heroImage.startsWith('http') &&
        oldData.heroImage != newData.heroImage) {
      _safeDeleteImage(oldData.heroImage);
    }
    if (oldData.companyLogo.startsWith('http') &&
        oldData.companyLogo != newData.companyLogo) {
      _safeDeleteImage(oldData.companyLogo);
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

  Future<bool> deleteActivity(String id) async {
    try {
      var doc = await _activityRepo.getActivityById(id);

      if (doc != null) {
        List<Future> deleteTasks = [];

        if (doc.heroImage.isNotEmpty) { deleteTasks.add(_safeDeleteImage(doc.heroImage)); }
        if (doc.companyLogo.isNotEmpty) { deleteTasks.add(_safeDeleteImage(doc.companyLogo)); }

        for (var url in doc.gallery) { deleteTasks.add(_safeDeleteImage(url)); }
        for (var r in doc.routines) { deleteTasks.add(_safeDeleteImage(r.imageUrl)); }

        if (deleteTasks.isNotEmpty) { await Future.wait(deleteTasks); }
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
      title: "Hapus Data",
      middleText: "Yakin ingin menghapus data ini?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        if (Get.overlayContext != null) { Navigator.of(Get.overlayContext!).pop(); }
        else 
        { 
          Get.back();
        }
        await deleteActivity(activity.id!);
        NotificationHelper.showSuccess("Dihapus", "Data berhasil dihapus.");
      },
    );
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
    if (sortOrder.value == 'terlama') { list = list.reversed.toList(); }
    else if (sortOrder.value == 'az') { list.sort((a, b) => a.title.compareTo(b.title)); }
    else if (sortOrder.value == 'za') { list.sort((a, b) => b.title.compareTo(a.title)); }
    return list;
  }

  void _scrollToFirstError(String category) {
    if (titleController.text.isEmpty) {
      _scrollToKey(titleShakeKey);
    } else if (category == 'magang' && companyLogoUrl.value.isEmpty) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else if (category == 'magang' && positionController.text.isEmpty) {
      _scrollToKey(positionShakeKey);
    } else if (category == 'magang' && locationController.text.isEmpty) {
      _scrollToKey(locationShakeKey);
    } else if (contactError.value.isNotEmpty) {
      _scrollToKey(contactShakeKey);
    } else if (category == 'magang' && techStackError.value.isNotEmpty) {
      _scrollToKey(techStackShakeKey);
    } else if (category == 'magang' && qualificationError.value.isNotEmpty) {
      _scrollToKey(qualificationShakeKey);
    } else if (descController.text.isEmpty) {
      _scrollToKey(descShakeKey);
    }
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }
}
