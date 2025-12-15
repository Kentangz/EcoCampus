import 'package:ecocampus/app/data/models/course/quiz_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/course_form_controller.dart';
import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/widgets/icon_picker_dialog.dart';
import 'package:ecocampus/app/shared/widgets/image_picker.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:ecocampus/app/shared/widgets/tech_stack_picker_dialog.dart';
import 'package:ecocampus/app/shared/utils/tech_stack_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseFormView extends GetView<CourseFormController> {
  const CourseFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditMode.value ? 'Edit Kelas' : 'Buat Kelas Baru',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Obx(
              () => TabBar(
                controller: controller.tabController,
                labelColor: const Color(0xFF6C63FF),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF6C63FF),
                tabs: [
                  const Tab(text: "Info Umum"),
                  if (controller.isEditMode.value) ...[
                    const Tab(text: "Kurikulum (Modul)"),
                    const Tab(text: "Kuis & Latihan"),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildGeneralInfoTab(controller),
                if (controller.isEditMode.value) ...[
                  _buildCurriculumTab(controller),
                  _buildQuizTab(controller),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoTab(CourseFormController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ikon Kelas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => InkWell(
                onTap: () {
                  Get.dialog(
                    IconPickerDialog(
                      onIconSelected: (iconName) {
                        controller.selectedIcon.value = iconName;
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            AppIcons.getIcon(controller.selectedIcon.value),
                            color: const Color(0xFF6C63FF),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            controller.selectedIcon.value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ShakeWidget(
              key: controller.titleShakeKey,
              child: TextFormField(
                controller: controller.titleC,
                decoration: _inputDeco("Nama Kelas", Icons.title),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
            ),
            const SizedBox(height: 24),

            Obx(
              () => Stack(
                children: [
                  CustomImagePicker(
                    label: "Upload Banner Kelas",
                    showLabel: false,
                    initialImageUrl: controller.courseImagePath.value.isNotEmpty
                        ? controller.courseImagePath.value
                        : null,
                    onImagePicked: (file) {
                      if (file != null) {
                        controller.courseImagePath.value = file.path;
                        controller.isCourseImageRemoved.value = false;
                      } else {
                        controller.courseImagePath.value = '';
                        controller.isCourseImageRemoved.value = true;
                      }
                    },
                  ),
                  Positioned(
                    top: 80,
                    right: 20,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        final iconKey = controller.techStackIcon.value;
                        return InkWell(
                          onTap: () {
                            Get.dialog(
                              TechStackPickerDialog(
                                onIconSelected: (iconName) {
                                  controller.techStackIcon.value = iconName;
                                },
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Center(
                            child: iconKey.isEmpty
                                ? Icon(
                                    Icons.code,
                                    size: 24,
                                    color: Colors.grey[400],
                                  )
                                : Icon(
                                    TechStackIcons.getIcon(iconKey),
                                    size: 28,
                                    color: TechStackIcons.getColor(iconKey),
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "* Upload banner dan pilih icon teknologi (opsional)",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 24),

            Obx(
              () => SwitchListTile(
                title: const Text("Status Kelas"),
                subtitle: Text(
                  controller.isActive.value
                      ? "Publik (Aktif)"
                      : "Draft (Sembunyi)",
                ),
                value: controller.isActive.value,
                activeThumbColor: const Color(0xFF6C63FF),
                onChanged: (val) => controller.isActive.value = val,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          controller.isEditMode.value
                              ? "SIMPAN PERUBAHAN"
                              : "BUAT KELAS",
                          style: const TextStyle(
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

  Widget _buildCurriculumTab(CourseFormController controller) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showModuleDialog(),
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add_task, color: Colors.white),
        label: const Text(
          "Tambah Modul",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.modules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 10),
                const Text(
                  "Belum ada modul",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                const Text("Tap tombol + untuk membuat modul pertama"),
              ],
            ),
          );
        }

        return ReorderableListView.builder(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 80,
            left: 10,
            right: 10,
          ),
          itemCount: controller.modules.length,
          onReorder: controller.reorderModules,
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Material(
                  elevation: 5.0,
                  color: Colors.transparent,
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  child: child,
                );
              },
              child: child,
            );
          },
          itemBuilder: (context, index) {
            final module = controller.modules[index];
            return Card(
              key: ValueKey(module.id ?? module.order),
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => controller.navigateToModuleDetail(module),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          module.imageUrl != null && module.imageUrl!.isNotEmpty
                              ? SmartImage(module.imageUrl!, fit: BoxFit.cover)
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${module.order}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    module.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStatusChip(module.isActive),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                                onPressed: () => controller.showModuleDialog(
                                  existingModule: module,
                                ),
                                tooltip: "Edit",
                              ),
                              if (module.isSynced)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      controller.confirmDeleteModule(module),
                                  tooltip: "Hapus",
                                ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          const CircleAvatar(
                            backgroundColor: Color(0xFF6C63FF),
                            radius: 16,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildQuizTab(CourseFormController controller) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showQuizDialog(),
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.quiz, color: Colors.white),
        label: const Text("Buat Kuis", style: TextStyle(color: Colors.white)),
      ),
      body: Obx(() {
        if (!controller.isEditMode.value) {
          return Center(
            child: Text(
              "Simpan kelas terlebih dahulu untuk mengelola kuis.",
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        if (controller.quizzes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 10),
                Text(
                  "Belum ada kuis/latihan",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 80,
            left: 10,
            right: 10,
          ),
          itemCount: controller.quizzes.length,
          itemBuilder: (context, index) {
            final quiz = controller.quizzes[index];
            return _buildQuizItem(quiz);
          },
        );
      }),
    );
  }

  Widget _buildQuizItem(QuizModel quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.withValues(alpha: 0.1),
                child: Icon(
                  controller.getIcon(quiz.icon),
                  color: Colors.orange,
                ),
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      quiz.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(quiz.isActive),
                ],
              ),
              subtitle: Text("${quiz.totalQuestions} Soal"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () =>
                        controller.showQuizDialog(existingQuiz: quiz),
                  ),
                  if (quiz.isSynced)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.confirmDeleteQuiz(quiz),
                    ),
                ],
              ),
              onTap: () => controller.navigateToQuizDetail(quiz),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey,
          width: 0.5,
        ),
      ),
      child: Text(
        isActive ? "Aktif" : "Draft",
        style: TextStyle(
          fontSize: 10,
          color: isActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
