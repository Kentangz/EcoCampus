import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../data/models/course/question_model.dart';
import '../../../../data/models/course/quiz_model.dart';

import '../../finance/views/finance_view.dart';
import '../../project/views/project_view.dart';
import '../controllers/soal_data_analysis_controller.dart';

class DataAnalysisQuizView extends GetView<DataAnalysisQuizController> {
  const DataAnalysisQuizView({super.key});

  final List<Widget> _pages = const [
    DataAnalysisQuizContent(),
    ProjectView(),
    FinanceView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe8f6ff),

      body: Obx(() {
        return SafeArea(child: _pages[controller.selectedIndex.value]);
      }),

      bottomNavigationBar: _BottomNavBar(controller: controller),
    );
  }
}

class DataAnalysisQuizContent extends GetView<DataAnalysisQuizController> {
  const DataAnalysisQuizContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "EcoCampus",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                // 1. Cek apakah list questions sudah terisi
                if (controller.questions.isEmpty) {
                  return const SizedBox.shrink(); // Jangan tampilkan apa-apa jika belum ada data
                }

                // 2. Ambil soal pertama sebagai referensi ikon tech stack (UNUSED)
                // final question = controller.questions[0];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // Menjauhkan teks ke kiri dan ikon ke kanan
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Kelas \n${Get.arguments['courseTitle'] ?? 'Data Analysis'}",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(-1.0, -1.0),
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(1.0, -1.0),
                            color: Colors.black,
                          ),
                          Shadow(offset: Offset(1.0, 1.0), color: Colors.black),
                          Shadow(
                            offset: Offset(-1.0, 1.0),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2D42),
                        // Warna background gelap agar ikon kuning terlihat kontras
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.chartSimple,
                        color: Colors.blue,
                        size: 50,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // --- BAGIAN RULES (CARD ORANGE) ---
              Obx(() {
                if (controller.currentQuiz.value == null) {
                  return const SizedBox.shrink();
                }
                return _buildRulesCard(controller.currentQuiz.value!);
              }),

              const SizedBox(height: 20),

              // --- BAGIAN DAFTAR SOAL (CARD PUTIH) ---
              Obx(() {
                if (controller.questions.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                const SizedBox(height: 20);
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    return _buildQuizCard(controller.questions[index], index);
                  },
                );
              }), // Penutup Obx
            ], // Penutup Column
          ), // Penutup SingleChildScrollView
        ), // Pen
        Positioned(
          top: 30,
          left: -5,
          child: IconButton(
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_circle_left_outlined),
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Bagian Kartu Peraturan (Warna Orange)
  Widget _buildRulesCard(QuizModel quiz) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEAA7C),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Latihan Soal ${quiz.title}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            "Peraturan dan Tata Cara Pengerjaan:",
            style: TextStyle(
              fontWeight: FontWeight.bold, // Tetap bold jika ingin menonjol
              decoration: TextDecoration.underline, // Menambahkan garis bawah
              decorationColor: Colors.black, // Warna garis bawah
              decorationThickness: 1.0, // Ketebalan garis bawah)),
            ),
          ),
          if (quiz.rules.isEmpty)
            const Text("Tidak ada peraturan khusus.")
          else
            ...quiz.rules.asMap().entries.map((entry) {
              int idx = entry.key;
              String ruleText = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "${idx + 1}. $ruleText",
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }),
        ],
      ),
    );
  }

  // Bagian Kartu Soal
  Widget _buildQuizCard(QuestionModel question, int questionIndex) {
    // Daftar label opsi
    final List<String> labels = ['A', 'B', 'C', 'D'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${question.order}. ${question.question}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (question.description != null) ...[
            Text(question.description!, style: const TextStyle(fontSize: 12)),
          ],
          const SizedBox(height: 10),
          if (question.imageUrl != null && question.imageUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                question.imageUrl!,
                width: double.infinity,
                fit: BoxFit.contain, // Agar gambar tidak terpotong
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text(
                    "Gagal memuat gambar",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),

          // --- OPSI JAWABAN ABCD ---
          Column(
            children: List.generate(question.options.length, (optionIndex) {
              return Obx(() {
                // Status apakah opsi ini yang diklik user
                bool isSelected =
                    controller.selectedOptions[questionIndex] == optionIndex;
                // Status apakah opsi ini adalah jawaban yang benar menurut database
                bool isCorrectChoice =
                    optionIndex == question.correctAnswerIndex;
                // Status apakah user sudah menjawab soal ini
                bool hasAnswered = controller.selectedOptions.containsKey(
                  questionIndex,
                );

                return GestureDetector(
                  onTap: () {
                    // Hanya izinkan klik jika belum menjawab (opsional, agar tidak ganti-ganti jawaban)
                    if (!hasAnswered) {
                      controller.selectOption(questionIndex, optionIndex);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      // --- LOGIKA WARNA BACKGROUND ---
                      color: hasAnswered
                          ? (isCorrectChoice
                                ? Colors.green.withValues(
                                    alpha: 0.1,
                                  ) // Hijau jika ini jawaban benar
                                : (isSelected
                                      ? Colors.red.withValues(alpha: 0.1)
                                      : Colors
                                            .transparent)) // Merah jika user salah pilih
                          : (isSelected
                                ? Colors.blue.withValues(alpha: 0.1)
                                : Colors.transparent),

                      // --- LOGIKA WARNA BORDER ---
                      border: Border.all(
                        color: hasAnswered
                            ? (isCorrectChoice
                                  ? Colors
                                        .green // Border hijau untuk jawaban benar
                                  : (isSelected
                                        ? Colors.red
                                        : Colors
                                              .grey
                                              .shade300)) // Border merah untuk pilihan salah
                            : (isSelected ? Colors.blue : Colors.grey.shade300),
                        width: (isSelected || (hasAnswered && isCorrectChoice))
                            ? 2
                            : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${labels[optionIndex]}.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hasAnswered
                                ? (isCorrectChoice
                                      ? Colors.green
                                      : (isSelected
                                            ? Colors.red
                                            : Colors.black))
                                : (isSelected ? Colors.blue : Colors.black),
                          ),
                        ),
                        const SizedBox(width: 10), // Jarak label ke teks
                        Expanded(
                          child: Text(
                            question.options[optionIndex],
                            style: TextStyle(
                              color: hasAnswered
                                  ? (isCorrectChoice
                                        ? Colors.green.shade900
                                        : (isSelected
                                              ? Colors.red.shade900
                                              : Colors.black))
                                  : Colors.black,
                            ),
                          ),
                        ),
                        // --- IKON STATUS ---
                        if (hasAnswered && isCorrectChoice)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        if (hasAnswered && isSelected && !isCorrectChoice)
                          const Icon(Icons.cancel, color: Colors.red, size: 20),
                      ],
                    ),
                  ),
                );
              });
            }),
          ),

          // --- KARTU PENJELASAN (Muncul Jika Sudah Dipilih) ---
          Obx(() {
            if (controller.selectedOptions.containsKey(questionIndex)) {
              return Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Penjelasan Jawaban:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      question.explanation.isEmpty
                          ? "Tidak ada penjelasan untuk soal ini."
                          : question.explanation,
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final DataAnalysisQuizController controller;

  const _BottomNavBar({required this.controller});

  static const Color _selectedBgColor = Color(0xffCDEEFF);
  static const Color _primaryColor = Color(0xe4000000);
  static const Color _unselectedColor = Colors.black;
  static const Color _barBgColor = Color(0xffe8f6ff);

  Widget _navTabItem({
    required IconData icon,
    required String label,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: isSelected ? _primaryColor : _unselectedColor,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? _primaryColor : _unselectedColor,
          ),
        ),
      ],
    );

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: isSelected
                  ? BoxDecoration(
                      color: _selectedBgColor,
                      borderRadius: BorderRadius.circular(30),
                    )
                  : null,
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        color: _barBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, -0.5),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Obx(() {
        final selectedIndex = controller.selectedIndex.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navTabItem(
              icon: Icons.home_outlined,
              label: "Home",
              index: 0,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(0),
            ),
            _navTabItem(
              icon: Icons.menu_book,
              label: "Project",
              index: 1,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(1),
            ),
            _navTabItem(
              icon: Icons.monetization_on_outlined,
              label: "Finance",
              index: 2,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(2),
            ),
          ],
        );
      }),
    );
  }
}
