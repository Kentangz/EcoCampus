import 'package:ecocampus/app/data/models/course/quiz_model.dart';
import 'package:ecocampus/app/shared/widgets/image_picker.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/course_form_controller.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
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
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: const Color(0xFF6C63FF),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF6C63FF),
          tabs: const [
            Tab(text: "Info Umum"),
            Tab(text: "Kurikulum (Modul)"),
            Tab(text: "Kuis & Latihan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildGeneralInfoTab(controller),
          _buildCurriculumTab(controller),
          _buildQuizTab(controller),
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
            Obx(
              () => CustomImagePicker(
                label: "Upload Hero Image",
                initialImageUrl: controller.heroImageUrl.value,
                onImagePicked: (file) {
                  if (file != null) {
                    controller.heroImageUrl.value = file.path;
                  }
                },
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
            const SizedBox(height: 15),

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

        return ListView.builder(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 80,
            left: 10,
            right: 10,
          ),
          itemCount: controller.modules.length,
          itemBuilder: (context, index) {
            final module = controller.modules[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(
                    0xFF6C63FF,
                  ).withValues(alpha: 0.1),
                  child: Text(
                    "${module.order}",
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  module.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Tap untuk kelola materi"),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      controller.showModuleDialog(existingModule: module);
                    }
                    if (value == 'delete') {
                      controller.confirmDeleteModule(module);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text("Edit Nama"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text("Hapus", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => controller.navigateToModuleDetail(module),
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
              title: Text(
                quiz.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => controller.confirmDeleteQuiz(quiz),
                  ),
                ],
              ),
              onTap: () => controller.navigateToQuizDetail(quiz),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: quiz.isSynced ? Colors.green : Colors.orange,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    quiz.isSynced ? Icons.cloud_done : Icons.cloud_upload,
                    size: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
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
