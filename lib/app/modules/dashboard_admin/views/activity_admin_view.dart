import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/shared/widgets/admin_sidebar.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/overview_admin_controller.dart';

class ActivityAdminView extends GetView<DashboardAdminController> {
  const ActivityAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Kelola Kegiatan',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Kategori Kegiatan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.1,
                children: [
                  _buildCategoryCard(
                    'Seni & Budaya',
                    Icons.palette_outlined,
                    Colors.orange,
                    () {
                      Get.toNamed(
                        Routes.ADMIN_ACTIVITY_LIST,
                        arguments: {
                          'category': 'seni_budaya',
                          'title': 'Seni & Budaya',
                        },
                      );
                    },
                  ),
                  _buildCategoryCard(
                    'Akademik & Karir',
                    Icons.school_outlined,
                    Colors.blue,
                    () {
                      Get.toNamed(
                        Routes.ADMIN_ACTIVITY_LIST,
                        arguments: {
                          'category': 'akademik_karir',
                          'title': 'Akademik & Karir',
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
