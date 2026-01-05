import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/activity/activity_model.dart';

class AkustikController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final eventActivity = Rx<EventActivity?>(null);

  final isActivitiesExpanded = false.obs;
  final selectedIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    fetchClubDataByTitle('Akustik');
  }

  Future<void> fetchClubDataByTitle(String clubTitle) async {
    try {
      final snapshot = await _db
          .collection('Activities')
          .where('title', isEqualTo: clubTitle)
          .get();

      final result = snapshot.docs
          .map((doc) => EventActivity.fromSnapshot(doc))
          .where((activity) => activity.isActive == true)
          .toList();

      if (result.isNotEmpty) {
        eventActivity.value = result.first;
        print("Data ditemukan dan aktif");
      } else {
        eventActivity.value = null;
        print("Data tidak ditemukan atau status isActive = false");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data klub: $e");
    }
  }

  void toggleActivitiesExpansion() {
    isActivitiesExpanded.value = !isActivitiesExpanded.value;
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}