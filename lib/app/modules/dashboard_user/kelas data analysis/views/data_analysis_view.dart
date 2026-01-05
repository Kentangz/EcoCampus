import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/course/course_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/utils/tech_stack_icons.dart';
import '../../finance/views/finance_view.dart';
import '../../project/views/project_view.dart';
import '../controllers/data_analysis_controller.dart';

class DataAnalysisClassView extends GetView<DataAnalysisClassController> {
  const DataAnalysisClassView({Key? key}) : super(key: key);

  final List<Widget> _pages = const [
    DataAnalysisClassContent(),
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

class DataAnalysisClassContent extends GetView<DataAnalysisClassController> {
  const DataAnalysisClassContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
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
              Obx(() {
                if (controller.courses.isEmpty) {
                  return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
                }
                return _buildBanner(controller.courses[0]);
              }),
              const SizedBox(height: 20),
              const Text(
                "Progress Latihanmu",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final isExpanded = controller.isProgressExpanded.value;
                final allItems = controller.modules;

                // Menentukan berapa banyak item yang ditampilkan (Default: 2)
                int itemCount = isExpanded
                    ? allItems.length
                    : (allItems.length > 2 ? 2 : allItems.length);

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemCount,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0, // Sesuaikan kembali tingginya
                      ),
                      itemBuilder: (context, index) {
                        return _buildProgressCard(allItems[index]);
                      },
                    ),

                    // Tombol See More / See Less (Hanya muncul jika total item lebih dari 2)
                    if (allItems.length > 2)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => controller.toggleProgressExpansion(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isExpanded ? 'See less' : 'See more',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 12
                                ),
                              ),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons
                                    .keyboard_arrow_down,
                                color: Colors.black,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 10),
              const Text(
                "Kategori Latihan Soal",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final isExpanded = controller.isCategoryExpanded.value;
                final allQuizzes = controller.quizzes;

                // Tampilkan 2 item di awal, atau semua jika sudah di-expand
                int itemCount = isExpanded
                    ? allQuizzes.length
                    : (allQuizzes.length > 2 ? 2 :allQuizzes.length);

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemCount,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0, // Rasio kotak kategori
                      ),
                      itemBuilder: (context, index) {
                        // PERBAIKAN 3: Ambil data kuis berdasarkan index yang benar
                        final quiz = allQuizzes[index];
                        return _buildCategoryItem(quiz);
                      },
                    ),

                    // Tombol See more / See less untuk Kategori
                    if (allQuizzes.length > 2)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => controller.toggleCategoryExpansion(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isExpanded ? 'See less' : 'See more',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 12
                                ),
                              ),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons
                                    .keyboard_arrow_down,
                                color: Colors.black,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
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
      ],
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildBanner(CourseModel item) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFA5DFF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
        image:  DecorationImage(
          image: NetworkImage(item.imageUrl?? ''),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color.fromRGBO(0, 0, 0, 0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Join Kelas\n${item.title}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(offset: Offset(-1.0, -1.0),
                      color: Colors.black),
                  Shadow(offset: Offset(1.0, -1.0),
                      color: Colors.black),
                  Shadow(offset: Offset(1.0, 1.0),
                      color: Colors.black),
                  Shadow(offset: Offset(-1.0, 1.0),
                      color: Colors.black),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white, // Warna border putih
                  width: 1.5, // Ketebalan border
                ),
              ),
              child: Icon(
                  TechStackIcons.getIcon(item.techStackIcon ?? "Pandas"),
                  color: TechStackIcons.getColor(item.techStackIcon ?? "Pandas"),
                  size: 70),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressCard(ModuleModel item) {
    // 💡 Expanded DIHAPUS karena GridView sudah otomatis mengatur lebar
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5A5A5),
        borderRadius: BorderRadius.circular(10),
        // Opsional: Tambahkan elevation sederhana
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.imageUrl ?? '', // Mengambil URL dari Firestore
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black, // Warna border putih
                      width: 1, // Ketebalan border
                    ),
                  ),
                  child: Text(
                      "0%",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Data Analysis",
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 20,
              width: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.DATA_ANALYSIS_MODULE, arguments: {
                    'title': item.title,
                    'courseId': controller.courses[0].id
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text("Detail", style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(QuizModel item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.toNamed(Routes.DATA_ANALYSIS_QUIZ, arguments: {
            "courseId": controller.courses[0].id,
            "courseTitle": controller.courses[0].title,
            "quizId": item.id,
            "quiz": item,
          },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDE7C47),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  // Jarak antara ikon dan border
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Background transparan
                    shape: BoxShape.circle, // Membuat bentuk bulat
                    border: Border.all(
                      color: Colors.white, // Warna border putih
                      width: 1, // Ketebalan border
                    ),
                  ),
                  child: Icon(
                      AppIcons.getIcon(item.icon), color: Colors.white)
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "${item.totalQuestions} Soal",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final DataAnalysisClassController controller;

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