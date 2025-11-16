import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/dashboard_admin_controller.dart';

class DashboardAdminView extends GetView<DashboardAdminController> {
  const DashboardAdminView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Halaman ADMIN', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
