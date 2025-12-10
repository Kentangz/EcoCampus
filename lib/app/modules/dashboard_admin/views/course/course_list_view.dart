import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/course_admin_controller.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseListView extends GetView<CourseAdminController> {
  const CourseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Daftar Kelas & Course',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: () => controller.navigateToCourseForm(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Buat Kelas", style: TextStyle(color: Colors.white)),
      ),

      body: Obx(() {
        if (controller.courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.class_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "Belum ada kelas dibuat",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.courses.length,
          itemBuilder: (context, index) {
            final course = controller.courses[index];
            return _buildCourseCard(course);
          },
        );
      }),
    );
  }

  Widget _buildCourseCard(CourseModel course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                course.heroImage.isNotEmpty
                    ? SmartImage(course.heroImage, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),

                Positioned(
                  top: 12,
                  right: 12,
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
                      course.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        course.title,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: course.isActive
                            ? Colors.green[50]
                            : Colors.red[50],
                        border: Border.all(
                          color: course.isActive ? Colors.green : Colors.red,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        course.isActive ? "Aktif" : "Draft",
                        style: TextStyle(
                          fontSize: 10,
                          color: course.isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 24),

                Row(
                  children: [
                    const Icon(
                      Icons.view_module_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${course.totalModules} Modul",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),

                    OutlinedButton.icon(
                      onPressed: () =>
                          controller.navigateToCourseForm(course: course),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text("Kelola"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63FF),
                        side: const BorderSide(color: Color(0xFF6C63FF)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const SizedBox(width: 8),

                    IconButton(
                      onPressed: () => controller.confirmDeleteCourse(course),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: "Hapus Kelas",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
