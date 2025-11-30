import 'package:ecocampus/app/shared/widgets/filter_chip.dart';
import 'package:ecocampus/app/shared/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/activity/activity_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/activity_admin_controller.dart';

class ActivityListView extends GetView<ActivityAdminController> {
  const ActivityListView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String category = args['category'] ?? 'umum';
    final String pageTitle = args['title'] ?? 'Daftar Kegiatan';

    controller.initActivities(category);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: () => controller.navigateToForm(category: category),
        child: const Icon(Icons.add, color: Colors.white),
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
                  hintText: "Cari nama kegiatan...",
                ),
                const SizedBox(height: 12),
                _buildFilterAndSortBar(),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingData.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final activities = controller.visibleActivities;

              if (activities.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(
                        "Tidak ada kegiatan ditemukan",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return _buildActivityItem(activity);
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
                  label: 'Tidak Aktif',
                  isSelected: controller.filterStatus.value == 'tidak_aktif',
                  onTap: () => controller.filterStatus.value = 'tidak_aktif',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BaseActivity activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.getIconData(activity.icon),
                  color: const Color(0xFF6C63FF),
                ),
              ),
              title: Text(
                activity.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: activity.isActive ? Colors.black : Colors.grey,
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: activity.isActive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    activity.isActive ? "Aktif" : "Tidak Aktif",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.blue,
                    ),
                    onPressed: () =>
                        controller.navigateToForm(activity: activity),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => controller.confirmDeleteActivity(activity),
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
                color: activity.isSynced ? Colors.green : Colors.orange,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    activity.isSynced ? Icons.cloud_done : Icons.cloud_upload,
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
}
