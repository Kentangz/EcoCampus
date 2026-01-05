import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/activity/internship_activity_model.dart';

class MagangController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var lowonganList = <InternshipActivity>[].obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMagangData();
  }

  Future<void> fetchMagangData() async {
    try {
      final snapshot = await _db.collection('Activities')
          .where('category', isEqualTo: 'magang')
          .orderBy('createdAt', descending: true)
          .get();

      lowonganList.value = snapshot.docs
          .map((doc) => InternshipActivity.fromSnapshot(doc))
          .where((activity) => activity.isActive == true)
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data magang: $e");
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}