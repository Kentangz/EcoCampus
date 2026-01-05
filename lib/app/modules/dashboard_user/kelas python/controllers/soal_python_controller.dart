import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../data/models/course/question_model.dart';
import '../../../../data/models/course/quiz_model.dart';

class PythonQuizController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // State
  var currentQuiz = Rxn<QuizModel>();
  var questions = <QuestionModel>[].obs; // Gunakan QuestionModel dari Firebase
  var selectedOptions = <int, int>{}.obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      // 1. Ambil ID Course & Quiz langsung dari Map
      final String? courseId = Get.arguments['courseId'];
      final String? quizId = Get.arguments['quizId'];

      // Simpan objek kuis untuk tampilan (opsional)
      if (Get.arguments['quiz'] is QuizModel) {
        currentQuiz.value = Get.arguments['quiz'];
      }

      // 2. Jika ID ada, langsung tembak ke Firebase
      if (courseId != null && quizId != null) {
        fetchQuestionsByTitle(courseId, quizId);
      } else {
        // print("Error: ID Course atau Quiz null");
      }
    }
  }

  Future<void> fetchQuestionsByTitle(String courseId, String quizId) async {
    try {
      final snapshot = await _db
          .collection('Courses')
          .doc(courseId)
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .get();

      if (snapshot.docs.isNotEmpty) {
        questions.value = snapshot.docs
            .map((doc) => QuestionModel.fromSnapshot(doc))
            .toList();

        questions.sort((a, b) => a.order.compareTo(b.order));
      }
    } catch (e) {
      // print("ERROR: $e");
    }
  }

  void selectOption(int quizNumber, int optionIndex) {
    selectedOptions[quizNumber] = optionIndex;
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
