import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../data/models/course/section_model.dart';
import '../../../../routes/app_pages.dart';
import '../../finance/views/finance_view.dart';
import '../../project/views/project_view.dart';
import '../controllers/modul_python_controller.dart';

class PythonModuleView extends GetView<PythonModuleController> {
  const PythonModuleView({super.key});

  final List<Widget> _pages = const [
    PythonModuleContent(),
    ProjectView(),
    FinanceView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe8f6ff),

      body: Obx(() {
        return SafeArea(child: _pages[controller.selectedIndex.value]);
      }),

      bottomNavigationBar: _BottomNavBar(controller: controller),
    );
  }
}

class PythonModuleContent extends GetView<PythonModuleController> {
  const PythonModuleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          // Menampilkan loading jika data masih diambil dari Firestore
          if (controller.sections.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          // 1. Konten Utama
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "EcoCampus",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // Menjauhkan teks ke kiri dan ikon ke kanan
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Kelas ${Get.arguments['courseTitle'] ?? 'Python'}",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(-1.0, -1.0),
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(1.0, -1.0),
                            color: Colors.black,
                          ),
                          Shadow(offset: Offset(1.0, 1.0), color: Colors.black),
                          Shadow(
                            offset: Offset(-1.0, 1.0),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2D42),
                        // Warna background gelap agar ikon kuning terlihat kontras
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.python,
                        color: Colors.blue,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCourseStatus(),
                const SizedBox(height: 20),
                _buildModuleList(),
              ],
            ),
          );
        }),

        // 2. Tombol Back Melayang
        Positioned(
          top: 30,
          left: -5,
          child: IconButton(
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_circle_left_outlined),
            color: Colors.black,
          ),
        ),
      ], // Penutup Children Stack
    ); // Penutup Stack
  }

  Widget _buildCourseStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menampilkan judul dari ModuleModel secara dinamis
        Text(
          "Python Dasar",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.moduleTitle.value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "0%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ],
        ), // Penutup Row pertama
      ], // Penutup children Column
    ); // Penutup Column
  }

  Widget _buildModuleList() {
    return Obx(() {
      final allSections = controller.sections; // Menggunakan SectionModel
      final isExpanded = controller.isExpanded.value;

      // Logika penentuan jumlah item yang tampil (See More/Less)
      int itemCount = isExpanded
          ? allSections.length
          : (allSections.length > 3 ? 3 : allSections.length);

      return Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final section =
                  allSections[index]; // Mengambil objek SectionModel
              return _buildModuleWithSubSections(section, index);
            },
          ),

          if (allSections.length > 3)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => controller.toggleExpand(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isExpanded ? 'See less' : 'See more',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildModuleWithSubSections(SectionModel section, int index) {
    return Obx(() {
      bool isOpen = controller.expandedModuleIndex.value == index;
      bool hasSubBab = controller.sectionHasContent[section.id] ?? false;

      return Column(
        children: [
          GestureDetector(
            onTap: () {
              // Hanya izinkan toggle jika ada sub bab
              if (hasSubBab) {
                controller.toggleSubModule(index);
              } else {
                // Jika tidak ada sub bab, mungkin langsung navigasi ke detail?
                Get.toNamed(
                  Routes.PYTHON_DETAIL_MODULE,
                  arguments: {
                    'courseId': Get.arguments['courseId'],
                    'moduleTitle': controller.moduleTitle.value,
                    'sectionId': section.id, // ID Section (Bab Utama)
                    'sectionTitle': section.title, // Judul Materi
                  },
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF8ACEFF),
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${index + 1}. ${section.title}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (hasSubBab)
                    Icon(
                      isOpen
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
          ),
          // Sub-bab langsung muncul di bawah tanpa Padding/SizedBox
          if (isOpen && hasSubBab)
            Obx(() {
              final List<String> titles =
                  controller.sectionMaterials[section.id] ?? [];
              return Column(
                children: titles
                    .map(
                      (mTitle) => _buildSubItem(
                        icon: Icons.menu_book,
                        label: mTitle, // Judul sub-bab (Contoh: "Sub Bab 1")
                        sectionId:
                            section.id ??
                            '', // Tetap kirim section title untuk filter di halaman detail
                      ),
                    )
                    .toList(),
              );
            }),
        ],
      );
    });
  }

  Widget _buildSubItem({
    required IconData icon,
    required String label,
    required String sectionId,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.PYTHON_DETAIL_MODULE,
          arguments: {
            'courseId': Get.arguments['courseId'],
            'moduleTitle': controller.moduleTitle.value,
            'sectionId': sectionId, // Ini yang tadi error 'section' undefined
            'sectionTitle': label,
          },
        );
      },
      child: Container(
        width: 340,
        // Margin kiri agar menjorok
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF58B9FF), // Warna biru lebih gelap sedikit
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            right: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(
              27,
            ), // Hanya lengkungan di pojok kanan bawah
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final PythonModuleController controller;

  const _BottomNavBar({required this.controller});

  static const Color _selectedBgColor = Color(0xffCDEEFF);
  static const Color _primaryColor = Color(0xe4000000);
  static const Color _unselectedColor = Colors.black;
  static const Color _barBgColor = Color(0xffe8f6ff);

  Widget _navTabItem({
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
            _navTabItem(
              icon: Icons.home_outlined,
              label: "Home",
              index: 0,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(0),
            ),
            _navTabItem(
              icon: Icons.menu_book,
              label: "Project",
              index: 1,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(1),
            ),
            _navTabItem(
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
