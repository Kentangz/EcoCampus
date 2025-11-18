import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/controllers/dashboard_user_controller.dart';

class DashboardUserView extends GetView<DashboardUserController> {
  const DashboardUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              const Text(
                "EcoCampus",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffCDEEFF),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selamat Siang!",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: const [
                        Icon(Icons.person, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Halo Fufufafa!",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: const [
                        Icon(Icons.calendar_month, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Selasa, 11 November 2025",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: const [
                        Icon(Icons.access_time, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "11:00",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),

                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffA18AFF),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: controller.logout,
                        child: const Text ("Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // SECTION TITLE
              const Text(
                "Kegiatan Kampus",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 20),

              // SUBTITLE
              const Text(
                "Seni & Budaya",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,

                children: [
                  _activityCard(
                    icon: Icons.brush,
                    title: "Kaligrafi",
                    color: const Color(0xffDCE6FF),
                  ),
                  _activityCard(
                    icon: Icons.music_note,
                    title: "Akustik",
                    color: const Color(0xffDCE6FF),
                  ),
                  _activityCard(
                    icon: Icons.movie,
                    title: "Nonton Film",
                    color: const Color(0xffDCE6FF),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  _activityCard(
                    icon: Icons.code,
                    title: "Kelas Python",
                    color: const Color(0xffFFD4D4),
                  ),
                  _activityCard(
                    icon: Icons.bar_chart,
                    title: "Kelas Data Analyst",
                    color: const Color(0xffFFD4D4),
                  ),
                  _activityCard(
                    icon: Icons.work,
                    title: "Info Magang Startup",
                    color: const Color(0xffFFD4D4),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder_open), label: "Project"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: "Finance"),
        ],
      ),
    );
  }

  Widget _activityCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Colors.black,     // warna border
            width: 1
        ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
      ),
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
    );
  }
}
