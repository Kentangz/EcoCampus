import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../data/models/course/material_model.dart';
import '../../../../data/models/course/section_model.dart';

class PythonDetailModuleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State reaktif
  var selectedIndex = 0.obs;
  var materials = <MaterialModel>[].obs;
  var currentSection = Rxn<SectionModel>();
  var moduletitle = "".obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Tangkap argumen title (Nama Section/Sub-bab)
    if (Get.arguments != null && Get.arguments is Map) {
      moduletitle.value = Get.arguments['moduleTitle'] ?? "";
      final String courseId = Get.arguments['courseId'];
      final String moduleTitle = Get.arguments['moduleTitle'];
      final String sectionId = Get.arguments['sectionId']; // Kita pakai ID sekarang
      final String materialTitle = Get.arguments['sectionTitle'];

      fetchMaterials(courseId, moduleTitle, sectionId, materialTitle);
      }
    }

  // LOGIKA: Cari Section berdasarkan Title -> Stream Sub-koleksi Materials
  Future<void> fetchMaterials(String courseId, String moduleTitle, String sectionId, String materialTitle) async {
    try {
      // 1. Cari Modul ID
      final moduleQuery = await _firestore
          .collection('Courses')
          .doc(courseId)
          .collection('modules')
          .where('title', isEqualTo: moduleTitle)
          .limit(1).get();

      if (moduleQuery.docs.isEmpty) return;
      final String moduleId = moduleQuery.docs.first.id;

      // 2. Langsung ambil materi menggunakan ID Section agar tidak perlu looping
      _firestore
          .collection('Courses')
          .doc(courseId)
          .collection('modules')
          .doc(moduleId)
          .collection('sections')
          .doc(sectionId) // Menggunakan ID dokumen, bukan judul
          .collection('materials')
          .where('title', isEqualTo: materialTitle) // Filter agar hanya muncul 1 sub-bab
          .snapshots()
          .listen((snapshot) {
        materials.value = snapshot.docs
            .map((doc) => MaterialModel.fromSnapshot(doc))
            .toList();
      });

    } catch (e) {
      // Ini adalah blok catch yang tadi hilang/error
      print("Error: $e");
      Get.snackbar("Error", "Gagal memuat materi: $e");
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}