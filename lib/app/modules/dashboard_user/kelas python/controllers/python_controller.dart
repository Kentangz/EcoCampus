import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/course/course_model.dart';

class PythonClassController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- State UI ---
  final selectedIndex = 0.obs;
  var isProgressExpanded = false.obs;
  var isCategoryExpanded = false.obs;

  // --- Data List dari Firebase ---
  // Kita mengganti data statis categories/progress dengan list course dari DB
  var courses = <CourseModel>[].obs;
  var modules = <ModuleModel>[].obs;
  var quizzes = <QuizModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoursesByTitle("Python");
  }

  Future<void> fetchCoursesByTitle(String courseTitle) async {
    try {
      final courseSnapshot = await _db
          .collection('Courses')
          .where('title', isEqualTo: courseTitle)
          .get();

      if (courseSnapshot.docs.isNotEmpty) {
        courses.value = courseSnapshot.docs
            .map((doc) => CourseModel.fromSnapshot(doc))
            .toList();

        String courseId = courseSnapshot.docs.first.id;
        await Future.wait([fetchQuizzes(courseId), fetchModules(courseId)]);
      } else {
        // print("Course dengan judul $courseTitle tidak ditemukan");
      }
    } catch (e) {
      // print("Error Load Data: $e");
    }
  }

  Future<void> fetchModules(String courseId) async {
    try {
      final snapshot = await _db
          .collection('Courses')
          .doc(courseId)
          .collection('modules')
          .orderBy('order')
          .get();

      modules.value = snapshot.docs
          .map((doc) => ModuleModel.fromSnapshot(doc))
          .where((activity) => activity.isActive == true)
          .toList();
    } catch (e) {
      // print("Error Fetching Modules: $e");
    }
  }

  Future<void> fetchQuizzes(String courseId) async {
    try {
      final snapshot = await _db
          .collection('Courses')
          .doc(courseId)
          .collection('quizzes')
          .orderBy('order')
          .get();

      quizzes.value = snapshot.docs
          .map((doc) => QuizModel.fromSnapshot(doc))
          .where((activity) => activity.isActive == true)
          .toList();
    } catch (e) {
      Get.snackbar("Error Fetching", "Gagal memuat data: $e");
    }
  }

  void toggleProgressExpansion() {
    isProgressExpanded.value = !isProgressExpanded.value;
  }

  void toggleCategoryExpansion() {
    isCategoryExpanded.value = !isCategoryExpanded.value;
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
