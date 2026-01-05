import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/analisis_data_penjualan_controller.dart';

class AnalisisView extends GetView<ProjectAnalisisDataController> {
  const AnalisisView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F7),
      appBar: AppBar(
        title: Obx(() => Text(ctrl.project.value?.title ?? 'Analisis Data Penjualan')),
        backgroundColor: const Color(0xFF71B4AD),
        elevation: 0,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.error.value != null) {
          return Center(child: Text('Error: ${ctrl.error.value}'));
        }

        final project = ctrl.project.value;
        if (project == null) {
          return const Center(child: Text('Project tidak tersedia.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: width > 600 ? 300 : 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      project.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.image, size: 48)),
                        );
                      },
                    ),

                    // overlay gelap tipis agar teks kontras
                    Container(
                      color: Colors.black.withOpacity(0.2),
                    ),

                    // teks dari controller
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          project.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 6,
                                color: Colors.black54,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(project.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4AB8B6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Deskripsi Proyek',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                SizedBox(height: 8),
                Text(
                  'Proyek ini berfokus pada analisis data penjualan untuk menemukan pola, tren, dan insight bisnis yang dapat digunakan dalam pengambilan keputusan.',
                  style: TextStyle(fontSize: 14, height: 1.4, color: Colors.black),
                ),
                SizedBox(height: 16),
                Text('Deliverables',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                SizedBox(height: 8),
                _Bullet(text: 'Dataset cleaning & preprocessing'),
                _Bullet(text: 'Exploratory Data Analysis (EDA)'),
                _Bullet(text: 'Dashboard visualisasi penjualan'),
                _Bullet(text: 'Insight & rekomendasi bisnis'),
                SizedBox(height: 16),
                Text('Kontak',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                SizedBox(height: 8),
                Text('Email : data@company.id', style: TextStyle(fontSize: 14, color: Colors.black)),
              ]),
            ),

            const SizedBox(height: 32),

            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF7F7),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.black, // warna garis
                    width: 1.5,          // tebal garis
                  ),
                ),
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
                  child: const Text('Kembali',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ]),
        );
      }),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black))),
        ],
      ),
    );
  }
}
