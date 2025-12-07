import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/course_model.dart';

import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:get/get.dart';

class CourseRepository extends GetxController {
  static CourseRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UploadQueueService _queueService = Get.find<UploadQueueService>();

  Stream<List<CourseModel>> getAllCourses() {
    return _db
        .collection('Courses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CourseModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> saveCourse(CourseModel course) async {
    String docId = course.id ?? _db.collection('Courses').doc().id;
    course.id = docId;

    await _db
        .collection('Courses')
        .doc(docId)
        .set(course.toJson(), SetOptions(merge: true));
  }

  Future<void> saveCourseWithModules(
    CourseModel course,
    List<ModuleModel> modules,
  ) async {
    WriteBatch batch = _db.batch();

    String courseId = course.id ?? _db.collection('Courses').doc().id;
    course.id = courseId;
    DocumentReference courseRef = _db.collection('Courses').doc(courseId);
    batch.set(courseRef, course.toJson(), SetOptions(merge: true));

    CollectionReference modulesRef = courseRef.collection('modules');
    for (int i = 0; i < modules.length; i++) {
      var module = modules[i];
      String modId = module.id ?? modulesRef.doc().id;
      module.order = i + 1;

      DocumentReference modRef = modulesRef.doc(modId);
      batch.set(modRef, module.toJson(), SetOptions(merge: true));
    }

    await batch.commit();
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      DocumentSnapshot courseDoc = await _db
          .collection('Courses')
          .doc(courseId)
          .get();
      if (courseDoc.exists) {
        String? heroImage = courseDoc['heroImage'];
        if (heroImage != null && heroImage.isNotEmpty) {
          _queueService.addDeleteToQueue(heroImage);
        }
      }

      final modulesSnapshot = await _db
          .collection('Courses')
          .doc(courseId)
          .collection('modules')
          .get();

      for (var moduleDoc in modulesSnapshot.docs) {
        final sectionsSnapshot = await moduleDoc.reference
            .collection('sections')
            .get();

        for (var sectionDoc in sectionsSnapshot.docs) {
          final materialsSnapshot = await sectionDoc.reference
              .collection('materials')
              .get();
          WriteBatch batch = _db.batch();
          for (var materialDoc in materialsSnapshot.docs) {
            batch.delete(materialDoc.reference);
          }
          await batch.commit();

          await sectionDoc.reference.delete();
        }

        await moduleDoc.reference.delete();
      }

      await _db.collection('Courses').doc(courseId).delete();
    } catch (e) {
      throw "Gagal menghapus kelas beserta isinya: $e";
    }
  }

  Stream<List<ModuleModel>> getModules(String courseId) {
    return _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .orderBy('order', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ModuleModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> saveModule(String courseId, ModuleModel module) async {
    String docId =
        module.id ??
        _db.collection('Courses').doc(courseId).collection('modules').doc().id;

    await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(docId)
        .set(module.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteModule(String courseId, String moduleId) async {
    WriteBatch batch = _db.batch();

    DocumentReference moduleRef = _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId);

    DocumentReference courseRef = _db.collection('Courses').doc(courseId);

    batch.delete(moduleRef);
    batch.update(courseRef, {'totalModules': FieldValue.increment(-1)});

    await batch.commit();
  }

  Stream<List<SectionModel>> getSections(String courseId, String moduleId) {
    return _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .orderBy('order', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SectionModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> saveSection(
    String courseId,
    String moduleId,
    SectionModel section,
  ) async {
    String docId =
        section.id ??
        _db
            .collection('Courses')
            .doc(courseId)
            .collection('modules')
            .doc(moduleId)
            .collection('sections')
            .doc()
            .id;

    await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .doc(docId)
        .set(section.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteSection(
    String courseId,
    String moduleId,
    String sectionId,
  ) async {
    await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .doc(sectionId)
        .delete();
  }

  Stream<List<MaterialModel>> getMaterials(
    String courseId,
    String moduleId,
    String sectionId,
  ) {
    return _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .doc(sectionId)
        .collection('materials')
        .orderBy('order', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MaterialModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> saveMaterial(
    String courseId,
    String moduleId,
    String sectionId,
    MaterialModel material,
  ) async {
    String docId =
        material.id ??
        _db
            .collection('Courses')
            .doc(courseId)
            .collection('modules')
            .doc(moduleId)
            .collection('sections')
            .doc(sectionId)
            .collection('materials')
            .doc()
            .id;

    await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .doc(sectionId)
        .collection('materials')
        .doc(docId)
        .set(material.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteMaterial(
    String courseId,
    String moduleId,
    String sectionId,
    String materialId,
  ) async {
    await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .doc(sectionId)
        .collection('materials')
        .doc(materialId)
        .delete();
  }
}
