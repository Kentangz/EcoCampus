import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/news/news_model.dart';
import 'package:get/get.dart';

class NewsRepository extends GetxController {
  static NewsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // STREAM semua berita (mirip Activity)
  Stream<List<NewsModel>> streamNews() {
    return _db
        .collection('News')
        .orderBy("createdAt", descending: true)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NewsModel.fromSnapshot(doc))
              .toList(),
        );
  }

  // GET semua berita (tanpa stream)
  Future<List<NewsModel>> getAllNews() async {
    final snap = await _db
        .collection("News")
        .orderBy("createdAt", descending: true)
        .get();

    return snap.docs.map((e) => NewsModel.fromSnapshot(e)).toList();
  }

  // ADD
  Future<void> addNews(NewsModel item) async {
    await _db.collection("News").doc(item.id).set(item.toJson());
  }

  // UPDATE
  Future<void> updateNews(NewsModel item) async {
    await _db
        .collection("News")
        .doc(item.id)
        .set(item.toJson(), SetOptions(merge: true));
  }

  // UPDATE STATUS PUBLISH
  Future<void> updatePublishStatus(String id, bool value) async {
    await _db.collection("News").doc(id).update({
      "isPublished": value,
      "updatedAt": DateTime.now(),
    });
  }

  // DELETE
  Future<void> deleteNews(String id) async {
    await _db.collection("News").doc(id).delete();
  }

  // GENERATE ID
  String getNewId() {
    return _db.collection("News").doc().id;
  }

  // GET BY ID
  Future<NewsModel?> getById(String id) async {
    try {
      final doc = await _db.collection("News").doc(id).get();
      if (doc.exists) {
        return NewsModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // SET (fallback mirip Activity)
  Future<void> setNews(NewsModel item) async {
    await _db
        .collection("News")
        .doc(item.id)
        .set(item.toJson(), SetOptions(merge: true));
  }
}
