import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/project/project_model.dart';

class ProjectRepository {
  ProjectRepository._();
  static final ProjectRepository instance = ProjectRepository._();

  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('projects');

  // ===================== ID =====================
  String getNewId() => _col.doc().id;

  // ===================== CREATE =====================
  Future<void> addProject(ProjectModel project) async {
    await _col.doc(project.id).set(
          project.toMap(useServerTimestamp: true),
        );
  }

  // ===================== UPDATE =====================
  Future<void> updateProject(ProjectModel project) async {
    await _col.doc(project.id).update(
      project.copyWith(updatedAt: DateTime.now())
          .toMap(useServerTimestamp: true),
    );
  }
  
  // ===================== DELETE =====================
  Future<void> deleteProject(String id) async {
    await _col.doc(id).delete();
  }

  // ===================== GET ONE =====================
  Future<ProjectModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProjectModel.fromMap(doc.data()!, doc.id);
  }

  // ===================== GET ALL (ADMIN) =====================
  Future<List<ProjectModel>> getAllProjects() async {
    final snap = await _col.orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => ProjectModel.fromMap(d.data(), d.id)).toList();
  }

  // ===================== STREAM ALL (ADMIN) =====================
  Stream<List<ProjectModel>> streamProjects() {
    return _col.orderBy('createdAt', descending: true).snapshots().map(
          (snap) =>
              snap.docs.map((d) => ProjectModel.fromMap(d.data(), d.id)).toList(),
        );
  }

  // ===================== STREAM ACTIVE (USER) =====================
  Stream<List<ProjectModel>> streamActiveProjects() {
    return _col
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => ProjectModel.fromMap(d.data(), d.id)).toList(),
        );
  }

  // ===================== TOGGLE ACTIVE =====================
  Future<void> updateActiveStatus(String id, bool value) async {
    await _col.doc(id).update({
      'isActive': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ===================== SYNC FLAG =====================
  Future<void> updateSyncStatus(String id, bool value) async {
    await _col.doc(id).update({'isSynced': value});
  }

  // ===================== BATCH =====================
  Future<void> batchUpdate(List<ProjectModel> list) async {
    final batch = FirebaseFirestore.instance.batch();

    for (final p in list) {
      batch.update(
        _col.doc(p.id),
        p.copyWith(updatedAt: DateTime.now()).toMap(),
      );
    }

    await batch.commit();
  }
}
