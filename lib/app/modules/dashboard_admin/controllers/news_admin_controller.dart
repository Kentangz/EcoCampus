// lib/app/modules/news_admin/controllers/news_admin_controller.dart
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ecocampus/app/data/models/news/news_model.dart';
import 'package:ecocampus/app/data/repositories/news_repository.dart';
import 'package:ecocampus/app/services/cloudinary_service.dart';
import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';

class NewsAdminController extends GetxController {
  // repos & services
  final NewsRepository repository = NewsRepository.instance;
  final CloudinaryService cloudinary = CloudinaryService();
  final UploadQueueService queue = Get.find<UploadQueueService>();
  final ImagePicker _picker = ImagePicker();

  // === SOURCE & UI LIST ===
  final RxList<NewsModel> newsList = <NewsModel>[].obs;

  // === FORM CONTROLLERS (names expected by UI) ===
  final TextEditingController titleC = TextEditingController();
  final TextEditingController contentC = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  // === FORM STATE ===
  final RxString imageUrl = ''.obs; // existing remote url
  final Rx<XFile?> localImage = Rx<XFile?>(null); // newly picked file
  NewsModel? editingItem;

  // === FLAGS ===
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  // === FILTER / SORT (names used by the view) ===
  final RxString sortOrder = 'terbaru'.obs; // terbaru, terlama, az, za
  final RxString filterStatus = 'semua'.obs; // semua, published, draft

  // internal search observable (keuntungan reactivity)
  final RxString _searchQuery = ''.obs;

  StreamSubscription? _streamSub;

  @override
  void onInit() {
    super.onInit();
    // keep search text reactive
    searchController.addListener(() {
      _searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    titleC.dispose();
    contentC.dispose();
    searchController.dispose();
    _streamSub?.cancel();
    super.onClose();
  }

  // =========================
  // Fetch methods
  // =========================

  /// One-time fetch (used by your UI .fetchNews())
  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      final list = await repository.getAllNews();
      newsList.assignAll(list);
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal memuat berita: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Optional: listen to realtime stream (if you prefer)
  void listenNewsStream() {
    _streamSub?.cancel();
    isLoading.value = true;
    _streamSub = repository.streamNews().listen((list) {
      newsList.assignAll(list);
      isLoading.value = false;
    }, onError: (err) {
      isLoading.value = false;
      NotificationHelper.showError("Error", "$err");
    });
  }

  // =========================
  // visibleNews getter used by UI
  // =========================
  List<NewsModel> get visibleNews {
    List<NewsModel> list = List.from(newsList);

    // filter by status
    if (filterStatus.value == 'published') {
      list = list.where((n) => n.isPublished).toList();
    } else if (filterStatus.value == 'draft') {
      list = list.where((n) => !n.isPublished).toList();
    }

    // search
    final q = _searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((n) => n.title.toLowerCase().contains(q)).toList();
    }

    // sort
    switch (sortOrder.value) {
      case 'terlama':
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'az':
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'za':
        list.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case 'terbaru':
      default:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return list;
  }

  // =========================
  // helpers to set filter/sort (optional)
  // =========================
  void setSortOrder(String v) => sortOrder.value = v;
  void setFilterStatus(String v) => filterStatus.value = v;

  // =========================
  // Form helpers
  // =========================
  void resetForm() {
    editingItem = null;
    titleC.clear();
    contentC.clear();
    imageUrl.value = '';
    localImage.value = null;
    isSubmitting.value = false;
  }

  void loadEditData(NewsModel data) {
    editingItem = data;
    titleC.text = data.title;
    contentC.text = data.content;
    imageUrl.value = data.imageUrl;
    localImage.value = null;
  }

  Future<void> pickImage() async {
    try {
      final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
      if (f != null) localImage.value = f;
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal mengambil gambar");
    }
  }

  // =========================
  // Save (add or update)
  // =========================
  Future<void> saveNews() async {
    if (titleC.text.trim().isEmpty) {
      NotificationHelper.showError("Validasi", "Judul wajib diisi");
      return;
    }
    if (contentC.text.trim().isEmpty) {
      NotificationHelper.showError("Validasi", "Konten wajib diisi");
      return;
    }

    isSubmitting.value = true;

    try {
      final now = DateTime.now();
      final bool isEdit = editingItem != null;
      final id = isEdit ? editingItem!.id : repository.getNewId();

      // upload image immediately; if you prefer queueing, change to queue.addToQueue(...)
      String finalImage = imageUrl.value;
      if (localImage.value != null) {
        final uploaded = await cloudinary.uploadImage(File(localImage.value!.path));
        if (uploaded != null) finalImage = uploaded;
      }

      final item = NewsModel(
        id: id,
        title: titleC.text.trim(),
        content: contentC.text.trim(),
        imageUrl: finalImage,
        isPublished: isEdit ? editingItem!.isPublished : false,
        createdAt: isEdit ? editingItem!.createdAt : now,
        updatedAt: now,
        isSynced: true,
      );

      // save/update
      if (isEdit) {
        await repository.updateNews(item);
      } else {
        await repository.addNews(item);
      }

      // refresh list
      await fetchNews();
      resetForm();
      Get.back();
      NotificationHelper.showSuccess("Sukses", "Berita berhasil disimpan");
    } catch (e) {
      NotificationHelper.showError("Gagal", "Gagal menyimpan berita: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  // =========================
  // delete with cloudinary cleanup
  // =========================
  Future<void> deleteNews(String id) async {
    try {
      isLoading.value = true;
      final doc = await repository.getById(id);
      if (doc != null && doc.imageUrl.isNotEmpty && doc.imageUrl.startsWith('http')) {
        final ok = await cloudinary.deleteImage(doc.imageUrl);
        if (!ok) {
          queue.addDeleteToQueue(doc.imageUrl);
        }
      }
      await repository.deleteNews(id);
      await fetchNews();
      NotificationHelper.showSuccess("Dihapus", "Berita berhasil dihapus");
    } catch (e) {
      NotificationHelper.showError("Gagal", "Gagal menghapus berita: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // toggle publish (item or by id)
  // =========================
  Future<void> togglePublish(NewsModel item) async {
    try {
      final newVal = !item.isPublished;
      await repository.updatePublishStatus(item.id, newVal);
      item.isPublished = newVal;
      item.updatedAt = DateTime.now();
      item.isSynced = false;
      newsList.refresh();
    } catch (e) {
      NotificationHelper.showError("Gagal", "Gagal mengubah status publish: $e");
    }
  }

  // convenience when UI toggles by id
  Future<void> togglePublishById(String id, bool value) async {
    try {
      await repository.updatePublishStatus(id, value);
      // update local list
      final idx = newsList.indexWhere((n) => n.id == id);
      if (idx != -1) {
        newsList[idx].isPublished = value;
        newsList[idx].updatedAt = DateTime.now();
        newsList.refresh();
      }
    } catch (e) {
      NotificationHelper.showError("Gagal", "Gagal update publish: $e");
    }
  }
}
