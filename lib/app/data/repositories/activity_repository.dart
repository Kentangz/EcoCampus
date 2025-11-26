import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/activity_model.dart';
import 'package:get/get.dart';

class ActivityRepository extends GetxController {
  static ActivityRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ActivityModel>> getActivitiesByCategory(String category) {
    return _db
        .collection('Activities')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ActivityModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> addActivity(ActivityModel activity) async {
    try {
      await _db.collection('Activities').add(activity.toJson());
    } catch (e) {
      throw "Gagal menyimpan data ke database.";
    }
  }

  Future<void> updateActivity(ActivityModel activity) async {
    try {
      await _db.collection('Activities').doc(activity.id).set(
        activity.toJson(), 
        SetOptions(merge: true),
      );
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

  Future<void> setActivity(ActivityModel activity) async {
    await _db
        .collection('Activities')
        .doc(activity.id)
        .set(activity.toJson(), SetOptions(merge: true));
  }


  Future<ActivityModel?> getActivityById(String id) async {
    try {
      var doc = await _db.collection('Activities').doc(id).get();
      if (doc.exists) {
        return ActivityModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
