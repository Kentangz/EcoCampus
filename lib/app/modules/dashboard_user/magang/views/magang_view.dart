import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/views/project_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/finance/views/finance_view.dart';
import '../../../../data/models/activity/internship_activity_model.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/magang_controller.dart';

class MagangView extends GetView<MagangController> {
  const MagangView({Key? key}) : super(key: key);

  final List<Widget> _pages = const [
    MagangContent(),
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

class MagangContent extends GetView<MagangController> {
  const MagangContent({Key? key}) : super(key: key);

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
              Container(
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
                  image: const DecorationImage(
                    image: AssetImage("assets/images/banner_magang.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color.fromRGBO(0, 0, 0, 0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10,
                      bottom: 0,
                      child: Image.asset(
                        "assets/images/ikon_magang.png",
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lowongan\nMagang\ninternship",
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  "Lowongan yang tersedia",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Obx(() {
                int totalData = controller.lowonganList.length;
                int totalPages = (totalData / controller.itemsPerPage).ceil();
                int startIndex = (controller.currentPage.value - 1) * controller.itemsPerPage;
                int endIndex = startIndex + controller.itemsPerPage;
                if (endIndex > totalData) endIndex = totalData;
                final listToShow = controller.lowonganList.sublist(startIndex, endIndex);
                return Column(
                  children: [
                    ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: controller.itemsPerPage * 135.0,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listToShow.length,
                          itemBuilder: (context, index) {
                            final item = listToShow[index];
                            return _buildJobCard(
                              id: item.id ?? "",
                              companyLogo: item.companyLogo,
                              posisi: item.position,
                              perusahaan: item.title,
                              lokasi: item.location,
                              item: item,
                            );
                          },
                        ),
                    ),
                    const SizedBox(height: 10),
                    if (totalPages > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(totalPages, (index) {
                          int pageNum = index + 1;
                          bool isActive = controller.currentPage.value == pageNum;
                          return GestureDetector(
                            onTap: () => controller.goToPage(pageNum),
                            child: Container(
                              width: 35,
                              height: 35,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isActive ? const Color(0xFF4AB8B6) : Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "$pageNum",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isActive ? Colors.white : Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                );
              })
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
  Widget _buildJobCard({
    required String id,
    required String companyLogo,
    required String posisi,
    required String perusahaan,
    required String lokasi,
    required InternshipActivity item
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF4AB8B6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF004D40),
            backgroundImage: NetworkImage(companyLogo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text("Posisi : $posisi", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                Text("Perusahaan : $perusahaan", style: const TextStyle(fontSize: 13)),
                Text("Lokasi : $lokasi", style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 25,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(Routes.DETAIL_MAGANG, arguments: item.title);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text("Lihat Detail", style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final MagangController controller;

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