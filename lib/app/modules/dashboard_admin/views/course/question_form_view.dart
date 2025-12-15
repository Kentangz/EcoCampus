import 'dart:io';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/question_form_controller.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionFormView extends GetView<QuestionFormController> {
  const QuestionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (controller.isSaving.value) return;
        final shouldPop = await Get.dialog<bool>(
          AlertDialog(
            title: const Text("Batal Edit?"),
            content: const Text(
              "Perubahan yang belum disimpan akan hilang. Yakin ingin keluar?",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text("Lanjut Edit"),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        if (shouldPop == true) {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.isEditing.value ? "Edit Soal" : "Tambah Soal",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isSaving.value
                  ? null
                  : () => controller.saveQuestion(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: controller.isSaving.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text(
                      "Simpan Soal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionCard(
                title: "Pertanyaan",
                icon: Icons.help_outline_rounded,
                child: Column(
                  children: [
                    ShakeWidget(
                      key: controller.questionShakeKey,
                      child: Obx(
                        () => TextField(
                          controller: controller.questionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[50],
                            hintText: "Tulis pertanyaan di sini...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                            errorText: controller.questionError.value,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Deskripsi Tambahan (Opsional)",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _formatButton(
                                    icon: Icons.format_bold,
                                    tooltip: "Bold",
                                    onTap: () => controller.applyFormat('bold'),
                                  ),
                                  _formatButton(
                                    icon: Icons.format_italic,
                                    tooltip: "Italic",
                                    onTap: () =>
                                        controller.applyFormat('italic'),
                                  ),
                                  _formatButton(
                                    icon: Icons.code,
                                    tooltip: "Code",
                                    onTap: () => controller.applyFormat('code'),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                  ),
                                  _formatButton(
                                    icon: Icons.list,
                                    tooltip: "List",
                                    onTap: () => controller.applyFormat('list'),
                                  ),
                                  _formatButton(
                                    icon: Icons.format_quote,
                                    tooltip: "Quote",
                                    onTap: () =>
                                        controller.applyFormat('quote'),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                  ),
                                  _formatButton(
                                    icon: Icons.link,
                                    tooltip: "Link",
                                    onTap: () => controller.applyFormat('link'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextField(
                            controller: controller.descriptionController,
                            focusNode: controller.descriptionFocusNode,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: "Contoh: Perhatikan gambar berikut...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSectionCard(
                title: "Gambar (Opsional)",
                icon: Icons.image_outlined,
                child: Obx(() {
                  final hasImage = controller.tempImagePath.value.isNotEmpty;
                  return InkWell(
                    onTap: () => controller.pickImage(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasImage
                              ? Colors.transparent
                              : Colors.grey.shade300,
                          style: hasImage ? BorderStyle.solid : BorderStyle.solid,
                        ),
                      ),
                      child: hasImage
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: controller.isImageLocal.value
                                      ? Image.file(
                                          File(controller.tempImagePath.value),
                                          fit: BoxFit.cover,
                                        )
                                      : SmartImage(
                                          controller.tempImagePath.value,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => controller.removeImage(),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Tap untuk upload gambar",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              _buildSectionCard(
                title: "Pilihan Jawaban",
                icon: Icons.list_alt_rounded,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.blue[800],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Tap pada huruf (A/B/C/D) untuk memilih jawaban yang benar.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOptionInput(
                      "A",
                      controller.optionA,
                      controller.correctAnswerIndex,
                      0,
                      controller.optionAShakeKey,
                      controller.optionAError,
                    ),
                    _buildOptionInput(
                      "B",
                      controller.optionB,
                      controller.correctAnswerIndex,
                      1,
                      controller.optionBShakeKey,
                      controller.optionBError,
                    ),
                    _buildOptionInput(
                      "C",
                      controller.optionC,
                      controller.correctAnswerIndex,
                      2,
                      null,
                      null,
                    ),
                    _buildOptionInput(
                      "D",
                      controller.optionD,
                      controller.correctAnswerIndex,
                      3,
                      null,
                      null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // === EXPLANATION SECTION ===
              _buildSectionCard(
                title: "Penjelasan Jawaban",
                icon: Icons.lightbulb_outline_rounded,
                child: TextField(
                  controller: controller.explanationController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: "Jelaskan kenapa jawaban tersebut benar...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF6C63FF), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 24),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionInput(
    String label,
    TextEditingController textController,
    RxInt correctIndex,
    int index,
    GlobalKey<ShakeWidgetState>? shakeKey,
    RxnString? errorText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShakeWidget(
        key: shakeKey ?? GlobalKey<ShakeWidgetState>(),
        child: Obx(() {
          final isCorrect = correctIndex.value == index;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => correctIndex.value = index,
                child: Container(
                  width: 42,
                  height: 42,
                  margin: const EdgeInsets.only(
                    top: 2,
                  ), // visual alignment with text field
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isCorrect
                        ? [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isCorrect ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: isCorrect
                        ? Colors.green.withValues(alpha: 0.05)
                        : Colors.grey[50],
                    hintText: "Isi jawaban opsi $label",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isCorrect
                            ? Colors.green.withValues(alpha: 0.5)
                            : Colors.grey.shade300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isCorrect
                            ? Colors.green.withValues(alpha: 0.5)
                            : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isCorrect
                            ? Colors.green
                            : const Color(0xFF6C63FF),
                      ),
                    ),
                    errorText: errorText?.value,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _formatButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20, color: Colors.grey[700]),
      tooltip: tooltip,
      onPressed: onTap,
      splashRadius: 20,
      visualDensity: VisualDensity.compact,
    );
  }
}
