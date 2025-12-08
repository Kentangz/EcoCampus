import 'dart:io';
import 'package:ecocampus/app/data/models/activity/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:ecocampus/app/modules/dashboard_user/nonton film/controllers/nonton_film_controller.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/views/project_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/finance/views/finance_view.dart';

class NontonFilmView extends GetView<NontonFilmController> {
  const NontonFilmView({super.key});

  final List<Widget> _pages = const [
    _NontonFilmContent(),
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

class _NontonFilmContent extends GetView<NontonFilmController> {
  const _NontonFilmContent();

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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),
              Obx(() {
                // Deklarasi variabel sekarang VALID di dalam blok kode Obx
                final clubData = controller.clubData.value;
                // Menggunakan ContactModel() sebagai fallback dengan field wajib
                final contacts = controller.eventActivity.value?.contacts ?? ContactModel(email: '', whatsapp: '', instagram: '');

                // Mengembalikan widget Column sebagai hasil dari Obx
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    BannerCard(
                      imageUrl: clubData.bannerUrl,
                      title: 'Join ${clubData.title} Club',
                      buttonText: 'Gabung Sekarang',
                      onTap: controller.joinClub,
                      contacts: contacts,
                    ),
                    const SizedBox(height: 20),
                    // Akses data dari clubData yang sudah di-cache
                    AboutUsSection(
                      title: 'Tentang Kami',
                      content: clubData.aboutUsContent,
                    ),
                    const SizedBox(height: 20),
                    RoutineActivitiesSection(
                      title: 'Aktivitas Rutin',
                      activities: clubData.routineActivities,
                    ),
                    const SizedBox(height: 20),
                    GallerySection(
                      title: 'Gallery',
                      images: clubData.galleryImages,
                    ),
                  ],
                );
              }), //
            ],
          ),
        ),

        // Tombol Kembali (Positioned)
        Positioned(
          // Sesuaikan posisi: topSafeArea + sedikit margin
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
}

class BannerCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String buttonText;
  final VoidCallback onTap;
  final ContactModel contacts;

  const BannerCard({
    required this.imageUrl,
    required this.title,
    required this.buttonText,
    required this.onTap,
    required this.contacts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration combinedDecoration = _cardDecoration(
        const Color(0xffa5dff5)
    ).copyWith(
      image: DecorationImage(
        image: FileImage(File(imageUrl)),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
      ),
    );

    return Container(
      height: 200,
      decoration: combinedDecoration,

      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

          Positioned(
            bottom: 5,
            right: 7,
            child: ElevatedButton(
              onPressed: () {
                onTap();
                showContactDialog(context, contacts);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA5C2F5),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration(Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(20),
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

void showContactDialog(BuildContext context, ContactModel contacts) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),

              topRight: Radius.circular(15.0),

              bottomLeft: Radius.circular(50.0),

              bottomRight: Radius.circular(50.0),
            ),
          ),

          backgroundColor: const Color(0xFFA6DEFF),

          child: Container(
            padding: const EdgeInsets.only(bottom: 50),
            width: MediaQuery.of(context).size.width * 0.85,

            child: Stack(
              children: [
                Positioned(
                  top: -11,
                  right: -11,
                  child: IconButton(
                    icon: const Icon(Icons.cancel_outlined, color: Color(0xFFA40000)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        "Kontak Kami",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _buildContactRow(
                        icon: Icons.mail_outline,
                        text: contacts.email
                    ),
                    const SizedBox(height: 15),
                    _buildContactRow(
                        icon: FontAwesomeIcons.whatsapp,
                        text: contacts.whatsapp
                    ),
                    const SizedBox(height: 15),
                    _buildContactRow(
                        icon: FontAwesomeIcons.instagram,
                        text: contacts.instagram
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildContactRow({required IconData icon, required String text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 20),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

class AboutUsSection extends StatelessWidget {
  final String title;
  final String content;

  const AboutUsSection({required this.title, required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class RoutineActivitiesSection extends GetView<NontonFilmController> {
  final String title;
  final List<RoutineModel> activities;

  const RoutineActivitiesSection({required this.title, required this.activities, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Tombol 'See More' hanya muncul jika total aktivitas lebih dari 3
    final bool showSeeMoreButton = activities.length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        Obx(() {
          int itemCount = 0;

          if (controller.isActivitiesExpanded.value) {
            // 💡 PERBAIKAN UNTUK INFINITY (TIDAK TERBATAS):
            // Jika Expanded, tampilkan semua item.
            itemCount = activities.length;
          } else {
            // Jika tidak Expanded, tampilkan maksimal 3 item.
            itemCount = activities.length > 3 ? 3 : activities.length;
          }

          if (itemCount == 0) return const SizedBox.shrink();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: itemCount, // Menggunakan itemCount yang sudah disesuaikan
            itemBuilder: (context, index) {
              return ActivityCard(activity: activities[index]);
            },
          );
        }),

        if (showSeeMoreButton)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.toggleActivitiesExpansion,
              child: Obx(() {
                final bool isExpanded = controller.isActivitiesExpanded.value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isExpanded ? 'See less' : 'See more',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                );
              }),
            ),
          ),
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  final RoutineModel activity;

  const ActivityCard({required this.activity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Menggunakan Card untuk shadow dan border
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 1.0),
      ),
      margin: EdgeInsets.zero, // Biarkan GridView mengatur jarak

      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(

          child: LayoutBuilder(
              builder: (context, constraints) {
                final double cardWidth = constraints.maxWidth;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Gambar (Ditempatkan di 80px bagian atas)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.file(
                        File(activity.imageUrl),
                        width: cardWidth,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: cardWidth,
                          color: Colors.grey,
                          child: const Center(child: Text("Img", style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    ),

                    // 2. Label Overlay (Ditempatkan di 20px bagian bawah)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: cardWidth,
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        color: Colors.white, // Background label PUTIH
                        child: Text(
                          activity.activityName,
                          style: const TextStyle(
                            fontSize: 10, // Ukuran teks diperkecil agar pas
                            color: Colors.black, // Warna teks HITAM
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}

class GallerySection extends StatelessWidget {
  final String title;
  final List<String> images;

  const GallerySection({required this.title, required this.images, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll GridView
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              child: Image.file(
                File(images[index]),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.green[200], child: const Center(child: Text("Gallery Image")),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final NontonFilmController controller;
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