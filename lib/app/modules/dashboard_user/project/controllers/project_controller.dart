import 'dart:async';

import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/project/project_model.dart';
import 'package:ecocampus/app/data/repositories/project_repository.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

class ProjectController extends GetxController {
  // ==========================
  // DEPENDENCY
  // ==========================
  final ProjectRepository repository = ProjectRepository.instance;

  // ==========================
  // STATE
  // ==========================
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt selectedIndex = 1.obs;

  StreamSubscription<List<ProjectModel>>? _streamSub;

  // ==========================
  // LIFECYCLE
  // ==========================
  @override
  void onInit() {
    super.onInit();
    _bindActiveProjects();
  }

  @override
  void onClose() {
    _streamSub?.cancel();
    super.onClose();
  }

  // ==========================
  // FIRESTORE STREAM (USER)
  // ==========================
  void _bindActiveProjects() {
    isLoading.value = true;

    _streamSub = repository.streamActiveProjects().listen(
      (list) {
        projects.assignAll(list);
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        NotificationHelper.showError(
          'Error',
          'Gagal memuat proyek: $e',
        );
      },
    );
  }

  // ==========================
  // NAVIGATION (MODEL BASED ✅)
  // ==========================
  void onTapProject(int index) {
    Get.toNamed(
      Routes.PROJECT_DETAIL,
      arguments: projects[index],
    );
  }


  void onTapBottomNav(int index) {
    selectedIndex.value = index;
  }
}
