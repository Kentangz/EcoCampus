import 'package:ecocampus/app/data/models/course/question_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/question_form_controller.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizListView extends GetView<QuestionFormController> {
  const QuizListView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final String quizTitle = args['quizTitle'];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kelola Soal", style: TextStyle(fontSize: 12)),
            Text(
              quizTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: Obx(() {
        if (controller.isLoadingQuiz.value) {
          return FloatingActionButton(
            heroTag: "add_question_btn",
            onPressed: () => controller.goToAddQuestion(),
            backgroundColor: const Color(0xFF6C63FF),
            child: const Icon(Icons.add, color: Colors.white),
          );
        }

        final rules = controller.currentQuiz.value?.rules ?? [];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (rules.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FloatingActionButton(
                  heroTag: "add_rules_btn",
                  onPressed: () => _showAddRuleDialog(context, controller),
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.rule, color: Colors.white),
                ),
              ),
            FloatingActionButton(
              heroTag: "add_question_btn",
              onPressed: () => controller.goToAddQuestion(),
              backgroundColor: const Color(0xFF6C63FF),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        );
      }),
      body: Obx(() {
        if (controller.isLoadingQuiz.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final quiz = controller.currentQuiz.value;
        final rules = quiz?.rules ?? [];
        final questions = controller.questions;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (rules.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.rule,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Aturan Kuis",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => _showAddRuleDialog(
                                context,
                                controller,
                                existingRules: rules,
                              ),
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Colors.grey,
                              ),
                              tooltip: "Edit Aturan",
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        ...rules.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "• ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    r,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // === QUESTIONS LIST ===
            if (questions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "Belum ada soal. Tambahkan sekarang!",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...List.generate(questions.length, (index) {
                return _buildQuestionCard(questions[index], index + 1);
              }),
          ],
        );
      }),
    );
  }

  Widget _buildQuestionCard(QuestionModel question, int number) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Text(
            "$number",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        title: Text(
          question.question,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.description != null && question.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                question.description!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ),

          if (question.imageUrl != null && question.imageUrl!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 400),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SmartImage(question.imageUrl!, fit: BoxFit.contain),
              ),
            ),

          ...List.generate(question.options.length, (i) {
            final isCorrect = i == question.correctAnswerIndex;
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green[50] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCorrect ? Colors.green : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    String.fromCharCode(65 + i),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      question.options[i],
                      style: TextStyle(
                        fontWeight: isCorrect
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCorrect ? Colors.green[800] : Colors.black87,
                      ),
                    ),
                  ),
                  if (isCorrect)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                ],
              ),
            );
          }),

          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => controller.deleteQuestion(question.id!),
                icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                label: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => controller.goToEditQuestion(question),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Edit"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddRuleDialog(
    BuildContext context,
    QuestionFormController controller, {
    List<String>? existingRules,
  }) {
    final rules = <TextEditingController>[].obs;

    if (existingRules != null && existingRules.isNotEmpty) {
      for (var rule in existingRules) {
        rules.add(TextEditingController(text: rule));
      }
    } else {
      rules.add(TextEditingController());
    }

    void addRule() {
      rules.add(TextEditingController());
    }

    void removeRule(int index) {
      rules[index].dispose();
      rules.removeAt(index);
    }

    Get.defaultDialog(
      title: "Aturan Kuis",
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Daftar Aturan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: addRule,
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                  ),
                ],
              ),
              Obx(
                () => Column(
                  children: List.generate(rules.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text("${index + 1}."),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: rules[index],
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () => removeRule(index),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF6C63FF),
      onConfirm: () {
        Get.back();
        controller.saveRules(
          rules.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
        );
      },
    );
  }
}
