import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project_controller.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectController controller =
        Get.put(ProjectController());

    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F7),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Text(
                    'EcoCampus',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),

            // ================= BANNER =================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF71B4AD),
                borderRadius: BorderRadius.circular(1),
              ),
              child: const Text(
                'Proyek Kolaborasi',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 25),

            // ================= TITLE =================
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Rekomendasi Proyek',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= GRID =================
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.projects.isEmpty) {
                  return const Center(
                    child: Text('Belum ada proyek tersedia'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: GridView.builder(
                    itemCount: controller.projects.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 190,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      final p = controller.projects[index];

                      return GestureDetector(
                        onTap: () => controller.onTapProject(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              // ================= IMAGE =================
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                                child: SizedBox(
                                  height: 100,
                                  width: double.infinity,
                                  child: Image.network(
                                    p.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.image, size: 36),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // ================= CONTENT =================
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF71B4AD),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(14),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        p.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${p.deliverables.length} Deliverables',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
