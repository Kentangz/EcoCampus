import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/course_admin_controller.dart';
import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/widgets/filter_chip.dart';
import 'package:ecocampus/app/shared/widgets/search_bar.dart';
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

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                CustomSearchBar(
                  controller: controller.searchController,
                  hintText: "Cari kelas...",
                ),
                const SizedBox(height: 12),
                _buildFilterAndSortBar(),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final courses = controller.visibleCourses;

              if (courses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "Tidak ada kelas ditemukan",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return _buildCourseCard(course);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndSortBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.sortOrder.value,
                  icon: const Icon(Icons.sort, size: 20),
                  items: const [
                    DropdownMenuItem(value: 'terbaru', child: Text("Terbaru")),
                    DropdownMenuItem(value: 'terlama', child: Text("Terlama")),
                    DropdownMenuItem(value: 'az', child: Text("A-Z")),
                    DropdownMenuItem(value: 'za', child: Text("Z-A")),
                  ],
                  onChanged: (val) {
                    if (val != null) controller.sortOrder.value = val;
                  },
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => Row(
              children: [
                CustomFilterChip(
                  label: 'Semua',
                  isSelected: controller.filterStatus.value == 'semua',
                  onTap: () => controller.filterStatus.value = 'semua',
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: 'Aktif',
                  isSelected: controller.filterStatus.value == 'aktif',
                  onTap: () => controller.filterStatus.value = 'aktif',
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: 'Draft',
                  isSelected: controller.filterStatus.value == 'draft',
                  onTap: () => controller.filterStatus.value = 'draft',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => controller.navigateToCourseForm(course: course),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  AppIcons.getIcon(course.icon),
                  color: const Color(0xFF6C63FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            course.title,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: course.isActive
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: course.isActive
                                  ? Colors.green.withValues(alpha: 0.5)
                                  : Colors.grey.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            course.isActive ? "Aktif" : "Draft",
                            style: TextStyle(
                              color: course.isActive
                                  ? Colors.green
                                  : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${course.totalModules} Modul • ${course.totalQuizzes} Quiz",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Colors.blue,
                    ),
                    onPressed: () =>
                        controller.navigateToCourseForm(course: course),
                    tooltip: "Kelola",
                  ),
                  if (!course.isSynced)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 16,
                      height: 16,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.orange,
                      ),
                    )
                  else
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () => controller.confirmDeleteCourse(course),
                      tooltip: "Hapus",
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
