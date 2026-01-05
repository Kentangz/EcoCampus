import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../finance/views/finance_view.dart';
import '../../project/views/project_view.dart';
import '../controllers/detail_magang_controller.dart';
import 'package:ecocampus/app/shared/utils/tech_stack_icons.dart';

class DetailMagangView extends GetView<DetailMagangController> {
  const DetailMagangView({Key? key}) : super(key: key);

  final List<Widget> _pages = const [
    DetailMagangContent(),
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

class DetailMagangContent extends GetView<DetailMagangController> {
  const DetailMagangContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
    final data = controller.internshipData.value;
      if (data == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: CircularProgressIndicator(),
          ),
        );
      }
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
                    const Positioned(
                      top: 20,
                      left: 20,
                      child: Text(
                        "Detail Lowongan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(offset: Offset(-1.0, -1.0), color: Colors.black),
                            Shadow(offset: Offset(1.0, -1.0), color: Colors.black),
                            Shadow(offset: Offset(1.0, 1.0), color: Colors.black),
                            Shadow(offset: Offset(-1.0, 1.0), color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA5DFF5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: const Color(0xFF004D40),
                              backgroundImage: NetworkImage(data.companyLogo),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.position, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                  const SizedBox(height: 5),
                                  Text(data.title, style: const TextStyle(fontSize: 12)),
                                  Text(data.location, style: const TextStyle(fontSize: 12)),
                                  Row(
                                    children: [
                                      const Icon(Icons.mail_outline, size: 12),
                                      const SizedBox(width: 5),
                                      Text(data.contacts.email, style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(FontAwesomeIcons.whatsapp, size: 12),
                                      const SizedBox(width: 5),
                                      Text(data.contacts.whatsapp, style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 25, bottom: 15),
                child: Text(
                    "Tech Stack",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemCount: data.techStacks.length,
                itemBuilder: (context, index) {
                  final techName = data.techStacks[index];
                  final IconData iconData = TechStackIcons.getIcon(techName);
                  final Color iconColor = TechStackIcons.getColor(techName);
                  return Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Center(
                          child: Icon(
                            iconData,
                            color: iconColor,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        techName,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 25, bottom: 10),
                child: Text("Kualifikasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Obx(() {
                final isExpanded = controller.isQualificationExpanded.value;
                final allQuals = data.qualifications;
                int itemCount = isExpanded ? allQuals.length : (allQuals.length > 3 ? 3 : allQuals.length);
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemCount,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(allQuals[index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (allQuals.length > 3)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => controller.toggleQualificationExpansion(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isExpanded ? 'See less' : 'See more',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 80),
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
    });
  }
}

class _BottomNavBar extends StatelessWidget {
  final DetailMagangController controller;

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
