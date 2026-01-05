import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../../data/models/activity/internship_activity_model.dart';

class DetailMagangController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final internshipData = Rxn<InternshipActivity>();

  final selectedIndex = 0.obs;
  final isQualificationExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    String? title = Get.arguments;
    if (title != null) {
      fetchDetailByTitle(title);
    }
  }

  Future<void> fetchDetailByTitle(String title) async {
    try {
      final snapshot = await _db
          .collection('Activities')
          .where('title', isEqualTo: title)
          .get();

      if (snapshot.docs.isNotEmpty) {
        internshipData.value = InternshipActivity.fromSnapshot(snapshot.docs.first);
      } else {
        // print("Data dengan title $title tidak ditemukan.");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat detail: $e");
    }
  }

  void toggleQualificationExpansion() {
    isQualificationExpanded.value = !isQualificationExpanded.value;
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}