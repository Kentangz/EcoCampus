import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/controllers/dashboard_user_controller.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/views/project_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/finance/views/finance_view.dart';

class DashboardUserView extends GetView<DashboardUserController> {
  const DashboardUserView({super.key});

  final List<Widget> _pages = const [
    _DashboardHomeContent(),
    ProjectView(),
    FinanceView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe8f6ff),

      body: Obx(() {
        return SafeArea(
          child: _pages[controller.selectedIndex.value],
        );
      }),

      bottomNavigationBar: _BottomNavBar(controller: controller),
    );
  }
}

class _DashboardHomeContent extends GetView<DashboardUserController> {
  const _DashboardHomeContent();

  final List<Map<String, dynamic>> _seniBudayaActivities = const [
    {'icon': Icons.brush, 'title': "Kaligrafi"},
    {'icon': Icons.music_note, 'title': "Akustik"},
    {'icon': Icons.movie, 'title': "Nonton Film"},
  ];

  final List<Map<String, dynamic>> _akademikKarirActivities = const [
    {'icon': Icons.code, 'title': "Kelas Python"},
    {'icon': Icons.bar_chart, 'title': "Kelas Data Analisis"},
    {'icon': Icons.work, 'title': "Info Magang Startup"},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          const Text("EcoCampus", style: TextStyle(fontFamily: "poppins", fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(const Color(0xffa5dff5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Selamat Siang!", style: TextStyle(fontFamily: "poppins", fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),

                Obx(() => _infoRow(Icons.person, controller.userName.value)),
                const SizedBox(height: 6),
                Obx(() => _infoRow(Icons.calendar_month, controller.currentDate.value)),
                const SizedBox(height: 6),
                Obx(() => _infoRow(Icons.access_time, controller.currentTime.value)),
                const SizedBox(height: 14),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6c63ff),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: controller.logout,
                    child: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 30),
          const Text("Kegiatan Kampus", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),

          const Text("Seni & Budaya", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _buildActivityGrid(activities: _seniBudayaActivities, color: const Color(
              0xffa5c2f5)),

          const SizedBox(height: 30),

          const Text("Akademik & Karir", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _buildActivityGrid(activities: _akademikKarirActivities, color: const Color(
              0xfff5a5a5)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildActivityGrid({
    required List<Map<String, dynamic>> activities,
    required Color color,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1,
      children: activities.map((activity) {
        return _activityCard(
          icon: activity['icon'] as IconData,
          title: activity['title'] as String,
          color: color,
          onTap: null,
        );
      }).toList(),
    );
  }

  Widget _activityCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: _cardDecoration(color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.black, width: 1),
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final DashboardUserController controller;
  const _BottomNavBar({required this.controller});

  static const Color _selectedBgColor = Color(0xffCDEEFF);
  static const Color _primaryColor = Color(0xe4000000);
  static const Color _unselectedColor = Colors.black;
  static const Color _barBgColor = Color(0xffe8f6ff);

  Widget _NavTabItem({
    required IconData icon,
    required String label,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: isSelected ? _primaryColor : _unselectedColor,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? _primaryColor : _unselectedColor,
          ),
        ),
      ],
    );

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: isSelected
                  ? BoxDecoration(
                color: _selectedBgColor,
                borderRadius: BorderRadius.circular(30),
              )
                  : null,
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        color: _barBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, -0.5),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Obx(() {
        final selectedIndex = controller.selectedIndex.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            _NavTabItem(
              icon: Icons.home_outlined,
              label: "Home",
              index: 0,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(0),
            ),

            _NavTabItem(
              icon: Icons.menu_book,
              label: "Project",
              index: 1,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(1),
            ),

            _NavTabItem(
              icon: Icons.monetization_on_outlined,
              label: "Finance",
              index: 2,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(2),
            ),
          ],
        );
      }),
    );
  }
}