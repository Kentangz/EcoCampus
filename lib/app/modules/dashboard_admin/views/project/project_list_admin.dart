import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/shared/widgets/admin_sidebar.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/project_admin_controller.dart';

class ProjectListAdminView extends GetView<ProjectAdminController> {
  const ProjectListAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Kelola Project',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AdminSidebar(),

      // Tombol tambah project
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          controller.resetForm(); // supaya tidak membawa data edit
          Get.toNamed(Routes.ADMIN_PROJECT_FORM);
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Kategori Project',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.projectList.isEmpty) {
                  return const Center(child: Text('Belum ada project.'));
                }

                return GridView.builder(
                  itemCount: controller.projectList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.90,
                  ),
                  itemBuilder: (context, index) {
                    final p = controller.projectList[index];
                    return _buildCategoryCard(
                      title: p.title,
                      icon: Icons.work_outline,
                      color: p.isActive ? Colors.green : Colors.grey,
                      onEdit: () {
                        controller.loadEditData(p);
                        Get.toNamed(Routes.ADMIN_PROJECT_FORM);
                      },
                      onDelete: () async {
                        final confirm = await Get.defaultDialog<bool>(
                          title: 'Hapus Project?',
                          middleText: 'Apakah kamu yakin ingin menghapus project ini?',
                          textConfirm: 'Ya',
                          textCancel: 'Batal',
                          onConfirm: () => Get.back(result: true),
                          onCancel: () => Get.back(result: false),
                        );

                        if (confirm == true) {
                          controller.deleteProject(p.id);
                        }
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // beri padding agar konten tidak nempel
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
