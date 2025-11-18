import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_project_colaborasi_controllers.dart';

class ProjectView extends GetView<ProjectController> {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe9f1ff),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== TITLE =====
              const Text(
                "EcoCampus",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 15),

              /// ===== HEADER BAR =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff7db2a5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Proyek Kolaborasi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// ===== SUBTITLE =====
              const Text(
                "Rekomendasi Proyek",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              /// ===== 4 PROJECT CARDS =====
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  _projectCard(
                    "Design UI/UX",
                    "8 Minggu",
                    "https://images.unsplash.com/photo-1593642532973-d31b6557fa68",
                  ),
                  _projectCard(
                    "Analisis Data Penjualan",
                    "16 Minggu",
                    "https://images.unsplash.com/photo-1517148815978-75f6acaaf32c",
                  ),
                  _projectCard(
                    "Riset Pasar Produk",
                    "8 Minggu",
                    "https://images.unsplash.com/photo-1518770660439-4636190af475",
                  ),
                  _projectCard(
                    "Pembuatan Aplikasi",
                    "24 Minggu",
                    "https://images.unsplash.com/photo-1555066931-4365d14bab8c",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _projectCard(String title, String duration, String imageURL) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(2, 2),
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              imageURL,
              height: 90,
              width: 160,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                Text(duration,
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
