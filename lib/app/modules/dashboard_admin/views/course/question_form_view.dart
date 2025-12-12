import 'dart:io';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/question_form_controller.dart';
import 'package:ecocampus/app/shared/widgets/markdown_toolbar.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionFormView extends GetView<QuestionFormController> {
  const QuestionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          controller.isEditing.value ? "Edit Soal" : "Tambah Soal",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel("Pertanyaan"),
            ShakeWidget(
              key: controller.questionShakeKey,
              child: Obx(
                () => TextField(
                  controller: controller.questionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Tulis pertanyaan utama...",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: controller.questionError.value,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionLabel("Detail Pertanyaan"),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  const Divider(height: 1),
                  TextField(
                    controller: controller.descriptionController,
                    maxLines: 5,
                    focusNode: controller.descriptionFocusNode,
                    decoration: const InputDecoration(
                      hintText: "Deskripsi tambahan, kode, atau cerita...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                  MarkdownToolbar(
                    onFormat: (format) => controller.applyFormat(format),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionLabel("Gambar"),
            Obx(() {
              final imagePath = controller.tempImagePath.value;
              final isLocal = controller.isImageLocal.value;

              return GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 150,
                    maxHeight: 400,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: imagePath.isEmpty
                      ? const SizedBox(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey,
                              ),
                              Text("Tap untuk upload gambar"),
                            ],
                          ),
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: isLocal
                                  ? Image.file(
                                      File(imagePath),
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    )
                                  : SmartImage(
                                      imagePath,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: controller.removeImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              );
            }),
            const SizedBox(height: 20),

            _buildSectionLabel("Opsi Jawaban & Kunci"),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(
                () => RadioGroup<int>(
                  groupValue: controller.correctAnswerIndex.value,
                  onChanged: (val) {
                    if (val != null) controller.correctAnswerIndex.value = val;
                  },
                  child: Column(
                    children: [
                      _buildOptionInput(
                        "A",
                        controller.optionA,
                        0,
                        shakeKey: controller.optionAShakeKey,
                        errorText: controller.optionAError,
                      ),
                      _buildOptionInput(
                        "B",
                        controller.optionB,
                        1,
                        shakeKey: controller.optionBShakeKey,
                        errorText: controller.optionBError,
                      ),
                      _buildOptionInput("C", controller.optionC, 2),
                      _buildOptionInput("D", controller.optionD, 3),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionLabel("Penjelasan"),
            TextField(
              controller: controller.explanationController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Penjelasan jawaban benar...",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                  ),
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.saveQuestion,
                  child: controller.isSaving.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SIMPAN SOAL",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildOptionInput(
    String label,
    TextEditingController textController,
    int index, {
    GlobalKey<ShakeWidgetState>? shakeKey,
    RxnString? errorText,
  }) {
    Widget inputField;
    if (errorText != null) {
      inputField = Obx(
        () => TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: "Opsi $label",
            isDense: true,
            border: const OutlineInputBorder(),
            errorText: errorText.value,
          ),
        ),
      );
    } else {
      inputField = TextField(
        controller: textController,
        decoration: InputDecoration(
          labelText: "Opsi $label",
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      );
    }

    if (shakeKey != null) {
      inputField = ShakeWidget(key: shakeKey, child: inputField);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Radio<int>(value: index, activeColor: Colors.green),
          Expanded(child: inputField),
        ],
      ),
    );
  }
}
