import 'package:ecocampus/app/data/models/course/question_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/question_form_controller.dart';
import 'package:ecocampus/app/shared/widgets/search_bar.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Kelola Soal",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: Obx(() {
        if (controller.isLoadingQuiz.value) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          heroTag: "add_question_btn",
          onPressed: () => controller.goToAddQuestion(),
          backgroundColor: const Color(0xFF6C63FF),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            "Tambah Soal",
            style: TextStyle(color: Colors.white),
          ),
        );
      }),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                CustomSearchBar(
                  controller: controller.searchController,
                  hintText: "Cari soal...",
                ),
              ],
            ),
          ),
          _buildRulesSection(context, controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingQuiz.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final questions = controller.visibleQuestions;
              final isDefaultView = controller.searchController.text.isEmpty;

              if (questions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Belum ada soal",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              if (isDefaultView) {
                return ReorderableListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  onReorder: controller.reorderQuestions,
                  children: [
                    for (int i = 0; i < questions.length; i++)
                      Container(
                        key: ValueKey(questions[i].id),
                        child: _buildQuestionCard(questions[i], i + 1),
                      ),
                  ],
                );
              } else {
                return ListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  children: [
                    ...questions.asMap().entries.map((entry) {
                      return _buildQuestionCard(entry.value, entry.value.order);
                    }),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesSection(
    BuildContext context,
    QuestionFormController controller,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Aturan Kuis",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
              ),
              Obx(() {
                if (controller.isLoadingQuiz.value) {
                  return SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  );
                }
                final hasRules =
                    (controller.currentQuiz.value?.rules ?? []).isNotEmpty;
                return TextButton.icon(
                  onPressed: () => _showAddRuleDialog(
                    context,
                    controller,
                    existingRules: controller.currentQuiz.value?.rules,
                  ),
                  icon: Icon(
                    hasRules ? Icons.edit_note : Icons.add_circle_outline,
                    size: 20,
                    color: Colors.black,
                  ),
                  label: Text(
                    hasRules ? "Edit" : "Tambah",
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isLoadingQuiz.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final rules = controller.currentQuiz.value?.rules ?? [];
            if (rules.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber[800],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Belum ada aturan khusus.",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rules
                  .map(
                    (rule) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "• ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              rule,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel question, int number) {
    bool isImageUploaded = true;
    if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
      if (!question.imageUrl!.startsWith('http')) {
        isImageUploaded = false;
      }
    }
    final isReallySynced = question.isSynced && isImageUploaded;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Theme(
                data: Theme.of(
                  Get.context!,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "$number",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    question.question,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    if (question.description != null &&
                        question.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          question.description!,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],

                    if (question.imageUrl != null &&
                        question.imageUrl!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 250),
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: SmartImage(
                            question.imageUrl!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    ...List.generate(question.options.length, (i) {
                      final isCorrect = i == question.correctAnswerIndex;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isCorrect ? Colors.green[50] : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCorrect
                                ? Colors.green.shade300
                                : Colors.grey.shade200,
                            width: isCorrect ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Colors.green
                                    : Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + i),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isCorrect
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                question.options[i],
                                style: TextStyle(
                                  fontWeight: isCorrect
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isCorrect
                                      ? Colors.green[900]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (isCorrect)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                                size: 20,
                              ),
                          ],
                        ),
                      );
                    }),

                    if (question.explanation.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 18,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Penjelasan: ${question.explanation}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[900],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () =>
                              controller.deleteQuestion(question.id!),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red.shade200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text("Hapus"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.goToEditQuestion(question),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: const Text("Edit"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isReallySynced ? Colors.green : Colors.orange,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isReallySynced ? Icons.cloud_done : Icons.cloud_upload,
                      size: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Aturan Kuis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      children: List.generate(rules.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                alignment: Alignment.center,
                                child: Text(
                                  "${index + 1}.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: rules[index],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    hintText:
                                        "Contoh: Waktu pengerjaan 30 menit",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => removeRule(index),
                                tooltip: "Hapus aturan",
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: addRule,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Tambah Aturan"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.grey[700],
                      ),
                      child: const Text("Batal"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.saveRules(
                          rules
                              .map((c) => c.text)
                              .where((t) => t.isNotEmpty)
                              .toList(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text("Simpan"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
