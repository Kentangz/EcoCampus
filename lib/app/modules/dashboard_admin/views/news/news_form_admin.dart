import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/news_admin_controller.dart';
import 'package:image_picker/image_picker.dart';

class NewsFormAdmin extends StatelessWidget {
  final NewsAdminController c = Get.find<NewsAdminController>();

  NewsFormAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isEdit = c.editingItem != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Berita" : "Tambah Berita"),
        actions: [
          // Toggle publish hanya muncul saat edit
          if (isEdit)
            Obx(() => Switch(
                  value: c.editingItem!.isPublished,
                  onChanged: (value) async {
                    await c.togglePublishById(c.editingItem!.id, value);
                    c.editingItem!.isPublished = value;
                  },
                )),
        ],
      ),

      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================
                  // TITLE
                  // ==========================
                  TextField(
                    controller: c.titleC,
                    decoration: InputDecoration(
                      labelText: "Judul Berita",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ==========================
                  // CONTENT
                  // ==========================
                  TextField(
                    controller: c.contentC,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: "Isi Berita",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ==========================
                  // IMAGE PICKER
                  // ==========================
                  Text(
                    "Gambar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Obx(() {
                    final localImg = c.localImage.value;
                    final networkImg = c.imageUrl.value;

                    return Column(
                      children: [
                        // Preview gambar
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildImagePreview(localImg, networkImg),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => c.pickImage(),
                          child: const Text("Pilih Gambar"),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 30),

                  // ==========================
                  // SAVE BUTTON
                  // ==========================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        c.saveNews();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        isEdit ? "Simpan Perubahan" : "Tambah Berita",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading Overlay
            if (c.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildImagePreview(XFile? localImg, String networkImg) {
    if (localImg != null) {
      return Image.file(
        File(localImg.path),
        fit: BoxFit.cover,
      );
    }

    if (networkImg.isNotEmpty) {
      return Image.network(
        networkImg,
        fit: BoxFit.cover,
      );
    }

    return const Center(
      child: Text("Belum ada gambar"),
    );
  }
}
