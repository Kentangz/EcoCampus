import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/dashboard_admin_controller.dart';

class AdminSidebar extends GetView<DashboardAdminController> {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C63FF);
    const String fontFamily = 'Montserrat';

    return Drawer(
      child: Column(
        children: [
          // Header Sidebar
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: primaryPurple,
              image: DecorationImage(
                image: AssetImage('assets/images/auth_logo_ecocampus.png'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            accountName: const Text(
              "Administrator",
              style: TextStyle(
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: const Text(
              "admin@ecocampus.id",
              style: TextStyle(fontFamily: fontFamily),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: primaryPurple,
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard_outlined,
                  text: 'Overview',
                  onTap: () {
                    if (Get.currentRoute == Routes.DASHBOARD_ADMIN) {
                      Get.back();
                    } else {
                      Get.toNamed(Routes.DASHBOARD_ADMIN);
                    }
                  },
                  isActive: Get.currentRoute == Routes.DASHBOARD_ADMIN,
                  primaryColor: primaryPurple,
                ),
                _buildDrawerItem(
                  icon: Icons.home,
                  text: 'Activity',
                  onTap: () {
                    if (Get.currentRoute == Routes.ADMIN_ACTIVITY) {
                      Get.back();
                    } else {
                      Get.toNamed(Routes.ADMIN_ACTIVITY);
                    }
                  },
                  isActive: Get.currentRoute == Routes.ADMIN_ACTIVITY,
                  primaryColor: primaryPurple,
                ),
                _buildDrawerItem(
                  icon: Icons.newspaper,
                  text: 'News',
                  onTap: () {
                    if (Get.currentRoute == Routes.ADMIN_NEWS) {
                      Get.back();
                    } else {
                      Get.toNamed(Routes.ADMIN_NEWS);
                    }
                  },
                  isActive: Get.currentRoute == Routes.ADMIN_NEWS,
                  primaryColor: primaryPurple,
                ),
                _buildDrawerItem(
                  icon: Icons.book,
                  text: 'Project',
                  onTap: () {
                    if (Get.currentRoute == Routes.ADMIN_PROJECT) {
                      Get.back();
                    } else {
                      Get.toNamed(Routes.ADMIN_PROJECT);
                    }
                  },
                  isActive: Get.currentRoute == Routes.ADMIN_PROJECT,
                  primaryColor: primaryPurple,
                ),
              ],
            ),
          ),

          // Tombol Logout
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: fontFamily,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Get.back();
                _showLogoutDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color primaryColor,
    bool isActive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isActive ? primaryColor : Colors.grey[700]),
      title: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: isActive ? primaryColor : Colors.grey[800],
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      selectedTileColor: primaryColor.withValues(alpha: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Konfirmasi Logout",
      titleStyle: const TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
      ),
      middleText: "Apakah Anda yakin ingin keluar dari aplikasi?",
      middleTextStyle: const TextStyle(fontFamily: 'Montserrat'),
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black,
      onConfirm: () {
        controller.logout();
      },
    );
  }
}
