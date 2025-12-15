import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/activity/activity_model.dart';
import 'package:ecocampus/app/data/repositories/activity_repository.dart';

class ClubData {
  final String title;
  final String bannerUrl;
  final String aboutUsContent;
  final List<RoutineModel> routineActivities;
  final List<String> galleryImages;

  ClubData({
    required this.title,
    required this.bannerUrl,
    required this.aboutUsContent,
    required this.routineActivities,
    required this.galleryImages,
  });
}

class KaligrafiController extends GetxController {
  final _activityRepo = ActivityRepository.instance;
  final eventActivity = Rx<EventActivity?>(null);
  final clubData = ClubData(
      title:'',
      bannerUrl: '',
      aboutUsContent: 'Memuat...',
      routineActivities: const [],
      galleryImages: const []
  ).obs;

  final isLoading = true.obs;
  final isActivitiesExpanded = false.obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchClubData('AVtW1SB9Yp8NIhlKX3pk');
  }

  Future<void> fetchClubData(String activityId) async {
    try {
      isLoading.value = true;
      final data = await _activityRepo.getActivityById(activityId);

      if (data != null && data is EventActivity) {
        eventActivity.value = data;
        clubData.value = ClubData(
          title: data.title,
          bannerUrl: data.heroImage,
          aboutUsContent: data.description,
          routineActivities: data.routines,
          galleryImages: data.gallery,
        );
      } else {
        clubData.value = ClubData(
          title:'',
          bannerUrl: '',
          aboutUsContent: 'Data klub tidak ditemukan.',
          routineActivities: const [],
          galleryImages: const [],
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data klub: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleActivitiesExpansion() {
    isActivitiesExpanded.value = !isActivitiesExpanded.value;
  }

  void joinClub() {
    final contacts = eventActivity.value?.contacts;
    if (contacts != null) {
      print('Kontak klub: ${contacts.whatsapp}, ${contacts.email}');
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}