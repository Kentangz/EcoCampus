import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/activity/activity_model.dart';
import 'package:get/get.dart';

class ActivityRepository extends GetxController {
  static ActivityRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<BaseActivity>> getActivitiesByCategory(String category) {
    return _db
        .collection('Activities')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BaseActivity.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> addActivity(BaseActivity activity) async {
    try {
      await _db
          .collection('Activities')
          .doc(activity.id)
          .set(activity.toJson());
    } catch (e) {
      throw "Gagal menyimpan data ke database.";
    }
  }

  Future<void> updateActivity(BaseActivity activity) async {
    try {
      await _db
          .collection('Activities')
          .doc(activity.id)
          .set(activity.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw "Gagal mengupdate data.";
    }
  }

  Future<void> deleteActivity(String id) async {
    try {
      await _db.collection('Activities').doc(id).delete();
    } catch (e) {
      throw "Gagal menghapus data dari database.";
    }
  }

  String getNewId() {
    return _db.collection('Activities').doc().id;
  }

  Future<void> setActivity(BaseActivity activity) async {
    await _db
        .collection('Activities')
        .doc(activity.id)
        .set(activity.toJson(), SetOptions(merge: true));
  }

  Future<EventActivity?> getActivityByTitle(String title) async {
    try {
      final snapshot = await _db
          .collection('Activities')
          .where('title', isEqualTo: title)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return EventActivity.fromSnapshot(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      print("Error fetching activity by title: $e");
      return null;
    }
  }

  Future<BaseActivity?> getActivityById(String id) async {
    try {
      var doc = await _db.collection('Activities').doc(id).get();
      if (doc.exists) {
        return BaseActivity.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
