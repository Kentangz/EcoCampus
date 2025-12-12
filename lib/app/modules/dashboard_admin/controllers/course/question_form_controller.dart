import 'package:ecocampus/app/data/models/course/question_model.dart';
import 'package:ecocampus/app/data/models/course/quiz_model.dart';
import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/question_form_view.dart';
import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class QuestionFormController extends GetxController {
  final CourseRepository _courseRepo = Get.find<CourseRepository>();
  final UploadQueueService _queueService = Get.find<UploadQueueService>();

  late String courseId;
  late String quizId;

  // === STATE LISTS ===
  final questions = <QuestionModel>[].obs;

  // === LOADING STATES ===
  final isLoading = false.obs;
  final isSaving = false.obs;

  // === QUESTION FORM VARIABLES ===
  final questionController = TextEditingController();
  final descriptionController = TextEditingController();
  final explanationController = TextEditingController();
  final descriptionFocusNode = FocusNode();

  final questionShakeKey = GlobalKey<ShakeWidgetState>();
  final optionAShakeKey = GlobalKey<ShakeWidgetState>();
  final optionBShakeKey = GlobalKey<ShakeWidgetState>();

  final tempImagePath = ''.obs;
  final isImageLocal = false.obs;

  final optionA = TextEditingController();
  final optionB = TextEditingController();
  final optionC = TextEditingController();
  final optionD = TextEditingController();

  final correctAnswerIndex = 0.obs;
  final isEditing = false.obs;
  String? _editingQuestionId;

  // === PREVIEW VARIABLES ===
  final previewQuestion = ''.obs;
  final previewDescription = ''.obs;
  final previewOptionA = ''.obs;
  final previewOptionB = ''.obs;
  final previewOptionC = ''.obs;
  final previewOptionD = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args == null) return;

    if (args != null) {
      courseId = args['courseId'];
      quizId = args['quizId'];
      _loadQuestions();

      questionController.addListener(
        () => previewQuestion.value = questionController.text,
      );
      descriptionController.addListener(
        () => previewDescription.value = descriptionController.text,
      );
      optionA.addListener(() => previewOptionA.value = optionA.text);
      optionB.addListener(() => previewOptionB.value = optionB.text);
      optionC.addListener(() => previewOptionC.value = optionC.text);
      optionD.addListener(() => previewOptionD.value = optionD.text);

      questionController.addListener(() {
        if (questionController.text.isNotEmpty) questionError.value = null;
      });
      optionA.addListener(() {
        if (optionA.text.isNotEmpty) optionAError.value = null;
      });
      optionB.addListener(() {
        if (optionB.text.isNotEmpty) optionBError.value = null;
      });
    }
  }

  final questionError = RxnString();
  final optionAError = RxnString();
  final optionBError = RxnString();

  @override
  void onClose() {
    questionController.dispose();
    descriptionController.dispose();
    explanationController.dispose();
    descriptionFocusNode.dispose();
    optionA.dispose();
    optionB.dispose();
    optionC.dispose();
    optionD.dispose();
    super.onClose();
  }

  // === QUIZ SETTINGS ===
  final currentQuiz = Rxn<QuizModel>();
  final isLoadingQuiz = true.obs;

  void _loadQuestions() {
    questions.bindStream(_courseRepo.getQuestions(courseId, quizId));
    _loadQuizTags();
  }

  void _loadQuizTags() async {
    isLoadingQuiz.value = true;
    try {
      final quiz = await _courseRepo.getQuiz(courseId, quizId);
      currentQuiz.value = quiz;
    } catch (e) {
      //
    } finally {
      isLoadingQuiz.value = false;
    }
  }

  Future<void> saveRules(List<String> rules) async {
    if (currentQuiz.value == null) return;

    final updatedQuiz = currentQuiz.value!;
    updatedQuiz.rules = rules;

    try {
      await _courseRepo
          .saveQuiz(courseId, updatedQuiz)
          .timeout(const Duration(seconds: 2), onTimeout: () => null);
      currentQuiz.value = updatedQuiz;
      currentQuiz.refresh();
      // NotificationHelper.showSuccess("Berhasil", "Aturan kuis berhasil disimpan");
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal menyimpan aturan: $e");
    }
  }

  // === NAVIGATION & RESET ===
  void goToAddQuestion() {
    _resetForm();
    isEditing.value = false;
    _editingQuestionId = null;
    Get.to(() => const QuestionFormView());
  }

  void goToEditQuestion(QuestionModel question) {
    _resetForm();
    isEditing.value = true;
    _editingQuestionId = question.id;

    questionController.text = question.question;
    descriptionController.text = question.description ?? '';
    explanationController.text = question.explanation;

    if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
      tempImagePath.value = question.imageUrl!;
      isImageLocal.value = false;
    }

    if (question.options.length >= 4) {
      optionA.text = question.options[0];
      optionB.text = question.options[1];
      optionC.text = question.options[2];
      optionD.text = question.options[3];
      correctAnswerIndex.value = question.correctAnswerIndex;
    }

    Get.to(() => const QuestionFormView());
  }

  void _resetForm() {
    questionController.clear();
    descriptionController.clear();
    explanationController.clear();
    optionA.clear();
    optionB.clear();
    optionC.clear();
    optionD.clear();
    correctAnswerIndex.value = 0;
    tempImagePath.value = '';
    isImageLocal.value = false;
  }

  // === IMAGE HANDLING ===
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      tempImagePath.value = image.path;
      isImageLocal.value = true;
    }
  }

  void removeImage() {
    tempImagePath.value = '';
    isImageLocal.value = false;
  }

  // === FORMATTING ===
  void applyFormat(String format) {
    if (!descriptionFocusNode.hasFocus) {
      descriptionFocusNode.requestFocus();
    }

    final controller = descriptionController;
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) {
      final newText = "$text$format";
      controller.text = newText;
      return;
    }

    final start = selection.start;
    final end = selection.end;
    final selectedText = text.substring(start, end);

    String newText;
    int newSelectionStart;
    int newSelectionEnd;

    String prefix = '';
    String suffix = '';

    switch (format) {
      case 'bold':
        prefix = '**';
        suffix = '**';
        break;
      case 'italic':
        prefix = '_';
        suffix = '_';
        break;
      case 'code':
        prefix = '`';
        suffix = '`';
        break;
      case 'list':
        prefix = '\n- ';
        break;
      case 'quote':
        prefix = '\n> ';
        break;
      case 'h1':
        prefix = '\n# ';
        break;
      case 'h2':
        prefix = '\n## ';
        break;
      case 'link':
        prefix = '[';
        suffix = '](url)';
        break;
      case 'separator':
        newText = text.replaceRange(start, end, "\n---\n");
        controller.text = newText;
        controller.selection = TextSelection.collapsed(offset: start + 5);
        return;
    }

    if (selectedText.isNotEmpty) {
      if (['list', 'quote', 'h1', 'h2'].contains(format)) {
        newText = text.replaceRange(
          start,
          end,
          "$prefix${selectedText.trim()}",
        );
        newSelectionStart = start + prefix.length;
        newSelectionEnd = start + prefix.length + selectedText.trim().length;
      } else {
        newText = text.replaceRange(start, end, "$prefix$selectedText$suffix");
        newSelectionStart = start + prefix.length;
        newSelectionEnd = end + prefix.length;
      }
    } else {
      if (format == 'link') {
        newText = text.replaceRange(start, end, "[Link](url)");
        newSelectionStart = start + 1;
        newSelectionEnd = start + 5;
      } else {
        newText = text.replaceRange(start, end, "$prefix$suffix");
        newSelectionStart = start + prefix.length;
        newSelectionEnd = start + prefix.length;
      }
    }

    controller.text = newText;
    controller.selection = TextSelection(
      baseOffset: newSelectionStart,
      extentOffset: newSelectionEnd,
    );
  }

  // === SAVE ===
  Future<void> saveQuestion() async {
    if (questionController.text.isEmpty) {
      questionError.value = "Pertanyaan wajib diisi";
      questionShakeKey.currentState?.shake();
      if (questionShakeKey.currentContext != null) {
        Scrollable.ensureVisible(
          questionShakeKey.currentContext!,
          alignment: 0.1,
          duration: const Duration(milliseconds: 300),
        );
      }
      return;
    }

    if (optionA.text.isEmpty) {
      optionAError.value = "Opsi A wajib diisi";
      optionAShakeKey.currentState?.shake();
      if (optionAShakeKey.currentContext != null) {
        Scrollable.ensureVisible(
          optionAShakeKey.currentContext!,
          alignment: 0.1,
          duration: const Duration(milliseconds: 300),
        );
      }
      return;
    }

    if (optionB.text.isEmpty) {
      optionBError.value = "Opsi B wajib diisi";
      optionBShakeKey.currentState?.shake();
      if (optionBShakeKey.currentContext != null) {
        Scrollable.ensureVisible(
          optionBShakeKey.currentContext!,
          alignment: 0.1,
          duration: const Duration(milliseconds: 300),
        );
      }
      return;
    }

    isSaving.value = true;
    try {
      final bool isNew = _editingQuestionId == null;
      final String docId = isNew
          ? _courseRepo.newQuestionId(courseId, quizId)
          : _editingQuestionId!;

      final newQuestion = QuestionModel(
        id: docId,
        question: questionController.text,
        description: descriptionController.text.isEmpty
            ? null
            : descriptionController.text,
        imageUrl: null,
        options: [optionA.text, optionB.text, optionC.text, optionD.text],
        correctAnswerIndex: correctAnswerIndex.value,
        explanation: explanationController.text,
        order: !isNew
            ? (questions.firstWhereOrNull((q) => q.id == docId)?.order ?? 0)
            : questions.length + 1,
      );

      if (isImageLocal.value && tempImagePath.value.isNotEmpty) {
        _queueService.addToQueue(
          docId,
          'imageUrl',
          tempImagePath.value,
          collection: 'Courses/$courseId/quizzes/$quizId/questions',
        );
        newQuestion.imageUrl = tempImagePath.value;
      } else if (tempImagePath.value.isNotEmpty) {
        newQuestion.imageUrl = tempImagePath.value;
      } else {
        if (!isNew) {
          var oldQ = questions.firstWhereOrNull((q) => q.id == docId);
          if (oldQ?.imageUrl != null && oldQ!.imageUrl!.isNotEmpty) {
            _queueService.addDeleteToQueue(oldQ.imageUrl!);
          }
        }
        newQuestion.imageUrl = null;
      }

      await _courseRepo
          .saveQuestion(courseId, quizId, newQuestion, isNew: isNew)
          .timeout(const Duration(seconds: 2), onTimeout: () => null);

      Get.back();
      NotificationHelper.showSuccess("Tersimpan", "Soal berhasil disimpan");
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal menyimpan soal: $e");
    } finally {
      isSaving.value = false;
    }
  }

  void deleteQuestion(String questionId) {
    Get.defaultDialog(
      title: "Hapus Soal",
      middleText: "Yakin hapus soal ini?",
      textConfirm: "Ya",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _courseRepo.deleteQuestion(courseId, quizId, questionId);
      },
    );
  }
}
