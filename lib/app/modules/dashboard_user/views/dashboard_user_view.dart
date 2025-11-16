import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/controllers/dashboard_user_controller.dart';

class DashboardUserView extends GetView<DashboardUserController> {
  const DashboardUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard User'),
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Ini adalah Halaman USER BIASA',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
