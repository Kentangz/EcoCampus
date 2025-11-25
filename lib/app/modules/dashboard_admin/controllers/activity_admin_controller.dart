import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/activity_model.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:get/get.dart';

class ActivityAdminController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final isLoading = false.obs;

  Stream<List<ActivityModel>> getActivitiesByCategory(String category) {
    return _db
        .collection('activities')
        .where(
          'category',
          isEqualTo: category,
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ActivityModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<bool> addActivity({
    required String title,
    required String icon,
    required String category,
    required bool isActive,
  }) async {
    try {
      isLoading.value = true;

      final newActivity = ActivityModel(
        title: title,
        icon: icon,
        category: category,
        isActive: isActive,
      );

      await _db.collection('activities').add(newActivity.toJson());
      return true;
    } catch (e) {
      NotificationHelper.showError("Gagal", "Terjadi kesalahan: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteActivity(String id) async {
    try {
      await _db.collection('activities').doc(id).delete();
      return true;
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal menghapus data.");
      return false;
    }
  }
}
