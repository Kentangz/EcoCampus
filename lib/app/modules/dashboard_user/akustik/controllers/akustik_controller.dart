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
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = EventActivity.fromSnapshot(doc);
        eventActivity.value = data;
      } else {
        // print("Data klub '$clubTitle' tidak ditemukan di database.");
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