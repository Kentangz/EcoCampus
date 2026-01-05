import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ecocampus/app/modules/dashboard_admin/controllers/project_admin_controller.dart';

class ProjectFormAdmin extends StatelessWidget {
  final ProjectAdminController c = Get.find<ProjectAdminController>();

  ProjectFormAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isEdit = c.editingItem != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Project" : "Tambah Project"),
        actions: [
          if (isEdit)
            Obx(() => Switch(
                  value: c.isPublished.value,
                  onChanged: (value) async {
                    c.isPublished.value = value;
                    await c.togglePublishById(c.editingItem!.id, value);
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
                    decoration: const InputDecoration(
                      labelText: "Judul Project",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ==========================
                  // DESCRIPTION
                  // ==========================
                  TextField(
                    controller: c.descriptionC,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Deskripsi Project",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ==========================
                  // DELIVERABLES
                  // ==========================
                  const Text(
                    "Deliverables",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: c.deliverablesC,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          "Contoh:\n- Laporan PDF\n- Aplikasi Mobile\n- Dashboard Admin",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==========================
                  // CONTACT
                  // ==========================
                  const Text(
                    "Kontak",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: c.emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: c.phoneC,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "No HP / WhatsApp",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==========================
                  // IMAGE PICKER
                  // ==========================
                  const Text(
                    "Gambar Project",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Obx(() {
                    final localImg = c.localImage.value;
                    final networkImg = c.imageUrl.value;

                    return Column(
                      children: [
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
                            child:
                                _buildImagePreview(localImg, networkImg),
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
                      onPressed: c.saveProject,
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        isEdit
                            ? "Simpan Perubahan"
                            : "Tambah Project",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================
            // LOADING OVERLAY
            // ==========================
            if (c.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.2),
                child:
                    const Center(child: CircularProgressIndicator()),
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

    return const Center(child: Text("Belum ada gambar"));
  }
}
