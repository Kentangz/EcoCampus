import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/activity_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/activity_admin_controller.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

class ActivityListView extends GetView<ActivityAdminController> {
  const ActivityListView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String category = args['category'] ?? 'umum';
    final String pageTitle = args['title'] ?? 'Daftar Kegiatan';

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
        onPressed: () {
          Get.toNamed(Routes.ADMIN_ACTIVITY_FORM, arguments: category);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: StreamBuilder<List<ActivityModel>>(
        stream: controller.getActivitiesByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  Text(
                    "Belum ada kegiatan di $pageTitle",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final activities = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(activity);
            },
          );
        },
      ),
    );
  }

  Widget _buildActivityItem(ActivityModel activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconData(activity.icon),
            color: const Color(0xFF6C63FF),
          ),
        ),
        title: Text(
          activity.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            decoration: activity.isActive ? null : TextDecoration.lineThrough,
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
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            Get.defaultDialog(
              title: "Hapus Kegiatan",
              middleText: "Yakin ingin menghapus ${activity.title}?",
              textConfirm: "Ya, Hapus",
              textCancel: "Batal",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () async {
                bool isSuccess = await controller.deleteActivity(activity.id!);
                if (isSuccess) {
                  Get.back();
                  NotificationHelper.showSuccess("Dihapus", "Kegiatan berhasil dihapus.");
                }
              },
            );
          },
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'brush':
        return Icons.brush;
      case 'music':
        return Icons.music_note;
      case 'movie':
        return Icons.movie;
      case 'code':
        return Icons.code;
      case 'analytics':
        return Icons.analytics;
      case 'work':
        return Icons.work;
      default:
        return Icons.event;
    }
  }
}
