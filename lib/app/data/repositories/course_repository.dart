import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/course_model.dart';

import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:get/get.dart';

class CourseRepository extends GetxController {
  static CourseRepository get instance => Get.find();

  // ignore: constant_identifier_names
  static const String COLLECTION = 'Courses';
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UploadQueueService _queueService = Get.find<UploadQueueService>();

  String get newId => _db.collection(COLLECTION).doc().id;

  // ==== COURSE MANAGEMENT ====

  Stream<List<CourseModel>> getAllCourses() {
    return _db
        .collection('Courses')
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true)
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
      // 1. Queue Course Image for Deletion
      final courseDoc = await _db.collection('Courses').doc(courseId).get();
      if (courseDoc.exists) {
        final data = courseDoc.data();
        if (data != null && data.containsKey('imageUrl')) {
          String? imageUrl = data['imageUrl'];
          if (imageUrl != null &&
              imageUrl.isNotEmpty &&
              imageUrl.startsWith('http')) {
            _queueService.addDeleteToQueue(imageUrl);
          }
        }
      }

      final quizzesSnapshot = await _db
          .collection('Courses')
          .doc(courseId)
          .collection('quizzes')
          .get();

      for (var quizDoc in quizzesSnapshot.docs) {
        await deleteQuiz(courseId, quizDoc.id);
      }

      final modulesSnapshot = await _db
          .collection('Courses')
          .doc(courseId)
          .collection('modules')
          .get();

      for (var moduleDoc in modulesSnapshot.docs) {
        final module = ModuleModel.fromSnapshot(moduleDoc);
        await deleteModule(courseId, module);
      }

      await _db.collection('Courses').doc(courseId).delete();
    } catch (e) {
      throw "Gagal menghapus kelas beserta isinya: $e";
    }
  }

  // ==== MODULE MANAGEMENT ====

  Stream<List<ModuleModel>> getModules(String courseId) {
    return _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .orderBy('order', descending: false)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ModuleModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> saveModule(
    String courseId,
    ModuleModel module, {
    bool isNew = false,
  }) async {
    String docId =
        module.id ??
        _db.collection('Courses').doc(courseId).collection('modules').doc().id;

    WriteBatch batch = _db.batch();

    if (isNew) {
      DocumentReference courseRef = _db.collection('Courses').doc(courseId);
      batch.update(courseRef, {'totalModules': FieldValue.increment(1)});
    }

    DocumentReference moduleRef = _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(docId);

    batch.set(moduleRef, module.toJson(), SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> deleteModule(String courseId, ModuleModel module) async {
    final sectionsSnapshot = await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(module.id)
        .collection('sections')
        .get();

    for (var sectionDoc in sectionsSnapshot.docs) {
      await deleteSection(courseId, module.id!, sectionDoc.id);
    }

    WriteBatch batch = _db.batch();

    DocumentReference moduleRef = _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(module.id);

    DocumentReference courseRef = _db.collection('Courses').doc(courseId);

    if (module.imageUrl != null && module.imageUrl!.startsWith('http')) {
      _queueService.addDeleteToQueue(module.imageUrl!);
    }

    batch.delete(moduleRef);
    batch.update(courseRef, {'totalModules': FieldValue.increment(-1)});

    await batch.commit();

    final remainingModulesSnapshot = await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .orderBy('order')
        .get();

    final remainingModules = remainingModulesSnapshot.docs
        .map((doc) => ModuleModel.fromSnapshot(doc))
        .toList();

    if (remainingModules.isNotEmpty) {
      await reorderModules(courseId, remainingModules);
    }
  }

  Future<void> reorderModules(
    String courseId,
    List<ModuleModel> modules,
  ) async {
    WriteBatch batch = _db.batch();
    for (int i = 0; i < modules.length; i++) {
      DocumentReference docRef = _db
          .collection('Courses')
          .doc(courseId)
          .collection('modules')
          .doc(modules[i].id);
      batch.update(docRef, {'order': i + 1});
    }
    await batch.commit();
  }

  // ==== SECTION MANAGEMENT ====

  Stream<List<SectionModel>> getSections(String courseId, String moduleId) {
    return _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .orderBy('order', descending: false)
        .snapshots(includeMetadataChanges: true)
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
    final materialsSnapshot = await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .doc(sectionId)
        .collection('materials')
        .get();

    for (var doc in materialsSnapshot.docs) {
      if (doc.exists) {
        List<dynamic> blocks = doc.get('blocks') ?? [];
        for (var block in blocks) {
          String content = block['content'] ?? '';
          if (content.startsWith('http')) {
            _queueService.addDeleteToQueue(content);
          }
        }
      }
    }

    WriteBatch batch = _db.batch();
    for (var doc in materialsSnapshot.docs) {
      batch.delete(doc.reference);
    }
    DocumentReference sectionRef = _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .doc(sectionId);

    batch.delete(sectionRef);

    await batch.commit();
  }

  Future<void> reorderSections(
    String courseId,
    String moduleId,
    List<SectionModel> sections,
  ) async {
    WriteBatch batch = _db.batch();
    for (int i = 0; i < sections.length; i++) {
      DocumentReference docRef = _db
          .collection('Courses')
          .doc(courseId)
          .collection('modules')
          .doc(moduleId)
          .collection('sections')
          .doc(sections[i].id);
      batch.update(docRef, {'order': i + 1});
    }
    await batch.commit();
  }

  // ==== MATERIAL MANAGEMENT (Materi)====

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
        .snapshots(includeMetadataChanges: true)
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
    DocumentSnapshot materialDoc = await _db
        .collection('Courses')
        .doc(courseId)
        .collection('modules')
        .doc(moduleId)
        .collection('sections')
        .doc(sectionId)
        .collection('materials')
        .doc(materialId)
        .get();

    if (materialDoc.exists) {
      List<dynamic> blocks = materialDoc.get('blocks') ?? [];
      for (var block in blocks) {
        String content = block['content'] ?? '';
        if (content.startsWith('http')) {
          _queueService.addDeleteToQueue(content);
        }
      }
    }

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

  Future<void> reorderMaterials(
    String courseId,
    String moduleId,
    String sectionId,
    List<MaterialModel> materials,
  ) async {
    WriteBatch batch = _db.batch();
    for (int i = 0; i < materials.length; i++) {
      DocumentReference docRef = _db
          .collection('Courses')
          .doc(courseId)
          .collection('modules')
          .doc(moduleId)
          .collection('sections')
          .doc(sectionId)
          .collection('materials')
          .doc(materials[i].id);
      batch.update(docRef, {'order': i + 1});
    }
    await batch.commit();
  }

  // ==== QUIZ MANAGEMENT ====

  Future<QuizModel?> getQuiz(String courseId, String quizId) async {
    final doc = await _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId)
        .get();

    if (doc.exists) {
      return QuizModel.fromSnapshot(doc);
    }
    return null;
  }

  Stream<List<QuizModel>> getQuizzes(String courseId) {
    return _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .orderBy('order', descending: false)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => QuizModel.fromSnapshot(doc)).toList(),
        );
  }

  Future<void> saveQuiz(
    String courseId,
    QuizModel quiz, {
    bool isNew = false,
  }) async {
    String docId =
        quiz.id ??
        _db.collection('Courses').doc(courseId).collection('quizzes').doc().id;

    WriteBatch batch = _db.batch();

    if (isNew) {
      DocumentReference courseRef = _db.collection('Courses').doc(courseId);
      batch.update(courseRef, {'totalQuizzes': FieldValue.increment(1)});
    }

    DocumentReference quizRef = _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(docId);

    batch.set(quizRef, quiz.toJson(), SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> deleteQuiz(String courseId, String quizId) async {
    final questionsSnapshot = await _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .get();

    WriteBatch batch = _db.batch();
    for (var doc in questionsSnapshot.docs) {
      String? imageUrl = doc.data().containsKey('imageUrl')
          ? doc['imageUrl']
          : null;
      if (imageUrl != null && imageUrl.startsWith('http')) {
        _queueService.addDeleteToQueue(imageUrl);
      }
      batch.delete(doc.reference);
    }

    DocumentReference quizRef = _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId);
    batch.delete(quizRef);

    DocumentReference courseRef = _db.collection('Courses').doc(courseId);
    batch.update(courseRef, {'totalQuizzes': FieldValue.increment(-1)});

    await batch.commit();
  }

  // ==== QUESTION MANAGEMENT (SOAL) ====

  Stream<List<QuestionModel>> getQuestions(String courseId, String quizId) {
    return _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .orderBy('order', descending: false)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => QuestionModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> saveQuestion(
    String courseId,
    String quizId,
    QuestionModel question, {
    bool isNew = false,
  }) async {
    String docId =
        question.id ??
        _db
            .collection('Courses')
            .doc(courseId)
            .collection('quizzes')
            .doc(quizId)
            .collection('questions')
            .doc()
            .id;

    WriteBatch batch = _db.batch();

    if (isNew || question.id == null) {
      DocumentReference quizRef = _db
          .collection('Courses')
          .doc(courseId)
          .collection('quizzes')
          .doc(quizId);
      batch.update(quizRef, {'totalQuestions': FieldValue.increment(1)});
    }

    // Ensure ID is set in the model to be saved
    question.id ??= docId;

    DocumentReference questionRef = _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .doc(docId);

    batch.set(questionRef, question.toJson(), SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> deleteQuestion(
    String courseId,
    String quizId,
    String questionId,
  ) async {
    DocumentSnapshot questionDoc = await _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .doc(questionId)
        .get();

    if (questionDoc.exists) {
      final data = questionDoc.data() as Map<String, dynamic>?;
      String? imageUrl = data?['imageUrl'];
      if (imageUrl != null && imageUrl.startsWith('http')) {
        _queueService.addDeleteToQueue(imageUrl);
      }
    }

    WriteBatch batch = _db.batch();

    batch.delete(
      _db
          .collection('Courses')
          .doc(courseId)
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .doc(questionId),
    );

    DocumentReference quizRef = _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId);

    batch.update(quizRef, {'totalQuestions': FieldValue.increment(-1)});

    await batch.commit();
  }

  String newQuestionId(String courseId, String quizId) {
    return _db
        .collection('Courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .doc()
        .id;
  }

  Future<void> reorderQuestions(
    String courseId,
    String quizId,
    List<QuestionModel> questions,
  ) async {
    WriteBatch batch = _db.batch();
    for (int i = 0; i < questions.length; i++) {
      DocumentReference docRef = _db
          .collection('Courses')
          .doc(courseId)
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .doc(questions[i].id);
      batch.update(docRef, {'order': i + 1});
    }
    await batch.commit();
  }
}
