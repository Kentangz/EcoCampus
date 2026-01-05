import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ecocampus/app/data/models/project/project_model.dart';
import 'package:ecocampus/app/data/repositories/project_repository.dart';
import 'package:ecocampus/app/services/cloudinary_service.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';

class ProjectAdminController extends GetxController {
  // ==========================
  // DEPENDENCIES
  // ==========================
  final ProjectRepository repository = ProjectRepository.instance;
  final CloudinaryService cloudinary = CloudinaryService();
  final ImagePicker _picker = ImagePicker();

  // ==========================
  // STATE
  // ==========================
  final RxList<ProjectModel> projectList = <ProjectModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isPublished = true.obs;

  final RxString sortOrder = 'terbaru'.obs;
  final RxString _searchQuery = ''.obs;

  StreamSubscription<List<ProjectModel>>? _streamSub;

  // ==========================
  // FORM CONTROLLERS
  // ==========================
  final titleC = TextEditingController();
  final descriptionC = TextEditingController();
  final deliverablesC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final searchController = TextEditingController();

  final RxString imageUrl = ''.obs;
  final Rx<XFile?> localImage = Rx<XFile?>(null);

  ProjectModel? editingItem;

  // ==========================
  // LIFECYCLE
  // ==========================
  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      _searchQuery.value = searchController.text;
    });

    _bindProjectStream();
  }

  @override
  void onClose() {
    titleC.dispose();
    descriptionC.dispose();
    deliverablesC.dispose();
    emailC.dispose();
    phoneC.dispose();
    searchController.dispose();
    _streamSub?.cancel();
    super.onClose();
  }

  // ==========================
  // STREAM BINDING (ADMIN)
  // ==========================
  void _bindProjectStream() {
    isLoading.value = true;

    _streamSub = repository.streamProjects().listen(
      (list) {
        projectList.assignAll(list);
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        NotificationHelper.showError(
          "Error",
          "Gagal memuat proyek: $e",
        );
      },
    );
  }

  // ==========================
  // FILTER + SORT
  // ==========================
  List<ProjectModel> get visibleProjects {
    List<ProjectModel> list = List.from(projectList);

    final q = _searchQuery.value.toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((p) => p.title.toLowerCase().contains(q))
          .toList();
    }

    switch (sortOrder.value) {
      case 'az':
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'za':
        list.sort((a, b) => b.title.compareTo(a.title));
        break;
      default:
        list.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );
    }

    return list;
  }

  // ==========================
  // FORM STATE
  // ==========================
  void resetForm() {
    editingItem = null;
    titleC.clear();
    descriptionC.clear();
    deliverablesC.clear();
    emailC.clear();
    phoneC.clear();
    imageUrl.value = '';
    localImage.value = null;
    isPublished.value = true;
  }

  void loadEditData(ProjectModel data) {
    editingItem = data;
    titleC.text = data.title;
    descriptionC.text = data.description;
    deliverablesC.text = data.deliverables.join(', ');
    emailC.text = data.email;
    phoneC.text = data.phone;
    imageUrl.value = data.imageUrl;
    isPublished.value = data.isActive;
    localImage.value = null;
  }

  // ==========================
  // IMAGE
  // ==========================
  Future<void> pickImage() async {
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) localImage.value = f;
  }

  // ==========================
  // SAVE (CREATE / UPDATE)
  // ==========================
  Future<void> saveProject() async {
    if (titleC.text.trim().isEmpty ||
        descriptionC.text.trim().isEmpty) {
      NotificationHelper.showError(
        "Validasi",
        "Judul dan deskripsi wajib diisi",
      );
      return;
    }

    if (emailC.text.trim().isEmpty ||
        phoneC.text.trim().isEmpty) {
      NotificationHelper.showError(
        "Validasi",
        "Email dan No HP wajib diisi",
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final now = DateTime.now();
      final bool isEdit = editingItem != null;
      final String id =
          isEdit ? editingItem!.id : repository.getNewId();

      String finalImage = imageUrl.value;

      if (localImage.value != null) {
        final uploaded = await cloudinary.uploadImage(
          File(localImage.value!.path),
        );
        if (uploaded != null) finalImage = uploaded;
      }

      final project = ProjectModel(
        id: id,
        title: titleC.text.trim(),
        description: descriptionC.text.trim(),
        deliverables: deliverablesC.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        email: emailC.text.trim(),
        phone: phoneC.text.trim(),
        imageUrl: finalImage,
        isActive: isPublished.value,
        createdAt:
            isEdit ? editingItem!.createdAt : now,
        updatedAt: now,
      );

      if (isEdit) {
        await repository.updateProject(project);
      } else {
        await repository.addProject(project);
      }

      resetForm();
      Get.back();
      NotificationHelper.showSuccess(
        "Sukses",
        "Proyek berhasil disimpan",
      );
    } catch (e) {
      NotificationHelper.showError("Gagal", "$e");
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==========================
  // DELETE
  // ==========================
  Future<void> deleteProject(String id) async {
    try {
      isLoading.value = true;

      final doc = await repository.getById(id);
      if (doc != null && doc.imageUrl.isNotEmpty) {
        await cloudinary.deleteImage(doc.imageUrl);
      }

      await repository.deleteProject(id);

      NotificationHelper.showSuccess(
        "Dihapus",
        "Proyek berhasil dihapus",
      );
    } catch (e) {
      NotificationHelper.showError("Gagal", "$e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================
  // PUBLISH TOGGLE
  // ==========================
  Future<void> togglePublishById(
    String id,
    bool value,
  ) async {
    try {
      await repository.updateActiveStatus(id, value);

      final index =
          projectList.indexWhere((e) => e.id == id);
      if (index != -1) {
        projectList[index] =
            projectList[index].copyWith(isActive: value);
        projectList.refresh();
      }

      NotificationHelper.showSuccess(
        "Sukses",
        "Status publish diperbarui",
      );
    } catch (e) {
      NotificationHelper.showError(
        "Gagal",
        "Gagal update status publish: $e",
      );
    }
  }
}
