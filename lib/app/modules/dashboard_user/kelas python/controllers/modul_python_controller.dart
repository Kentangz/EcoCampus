import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../data/models/course/section_model.dart';

class PythonModuleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State Reaktif
  var isExpanded = false.obs;
  final selectedIndex = 0.obs;
  var expandedModuleIndex = (-1).obs;
  var moduleTitle = "".obs;
  // List Bab Utama (Menggunakan SectionModel)
  var sections = <SectionModel>[].obs;
  var sectionMaterials = <String, List<String>>{}.obs;
  var sectionHasContent = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      moduleTitle.value = Get.arguments['title'] ?? "";
      final String? courseId = Get.arguments['courseId']; // Ambil ID Course Utama

      if (moduleTitle.value.isNotEmpty && courseId != null) {
        fetchSectionsByTitle(courseId, moduleTitle.value);
      }
      }
    }

  // LOGIKA: Cari Modul by Title -> Ambil Sub-koleksi Sections
  Future<void> fetchSectionsByTitle(String courseId, String title) async {
    try {
      // 1. Cari dokumen modul berdasarkan Title
      final moduleQuery = await _firestore
          .collection('Courses') // Sesuaikan dengan COLLECTION di Repository
          .doc(courseId)
          .collection('modules')
          .where('title', isEqualTo: title)
          .get();

      if (moduleQuery.docs.isNotEmpty) {
        final moduleId = moduleQuery.docs.first.id;

        // 2. Ambil Sections di dalam Modul tersebut
        _firestore
            .collection('Courses')
            .doc(courseId)
            .collection('modules')
            .doc(moduleId)
            .collection('sections')
            .orderBy('order')
            .snapshots()
            .listen((snapshot) async {

          sections.value = snapshot.docs
              .map((doc) => SectionModel.fromSnapshot(doc))
              .toList();

          for (var doc in snapshot.docs) {
            final QuerySnapshot materialSnapshot = await _firestore
                .collection('Courses')
                .doc(courseId)
                .collection('modules')
                .doc(moduleId)
                .collection('sections')
                .doc(doc.id)
                .collection('materials')
                .orderBy('order')
                .get();
            sectionHasContent[doc.id] = materialSnapshot.docs.isNotEmpty;
            // Jika ada minimal 1 dokumen di materials, maka hasSubBab = true
            sectionMaterials[doc.id] = materialSnapshot.docs
                .map((m) => (m.data() as Map<String, dynamic>)['title'] as String)
                .toList();
          }
        });
      } else {
        print("Modul tidak ditemukan");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal fetching data: $e");
    }
  }

  void toggleSubModule(int index) {
    if (expandedModuleIndex.value == index) {
      expandedModuleIndex.value = -1; // Tutup jika diklik lagi
    } else {
      expandedModuleIndex.value = index; // Buka modul yang diklik
    }
  }

  void toggleExpand() => isExpanded.value = !isExpanded.value;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}