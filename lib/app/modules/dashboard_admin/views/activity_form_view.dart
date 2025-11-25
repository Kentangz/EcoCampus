import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/activity_admin_controller.dart';

class ActivityFormView extends GetView<ActivityAdminController> {
  const ActivityFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final String category = Get.arguments ?? 'umum';

    final titleC = TextEditingController();

    final selectedIcon = 'brush'.obs;
    final isActive = true.obs;

    final Map<String, IconData> iconOptions = {
      'brush': Icons.brush,
      'music': Icons.music_note,
      'movie': Icons.movie,
      'code': Icons.code,
      'analytics': Icons.analytics,
      'work': Icons.work,
      'event': Icons.event,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Kegiatan',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nama Kegiatan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleC,
              decoration: InputDecoration(
                hintText: "Contoh: Belajar Gitar Dasar",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Pilih Ikon",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedIcon.value,
                    isExpanded: true,
                    items: iconOptions.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          children: [
                            Icon(entry.value, color: const Color(0xFF6C63FF)),
                            const SizedBox(width: 10),
                            Text(entry.key.toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) selectedIcon.value = value;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Obx(
              () => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SwitchListTile(
                  title: const Text(
                    "Status Kegiatan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    isActive.value
                        ? "Sedang Berjalan (Aktif)"
                        : "Sudah Selesai (Tidak Aktif)",
                    style: TextStyle(
                      color: isActive.value ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: isActive.value,
                  onChanged: (val) => isActive.value = val,
                  activeColor: const Color(0xFF6C63FF),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          // Validasi
                          if (titleC.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Nama kegiatan wajib diisi!",
                              backgroundColor: Colors.red.withOpacity(0.2),
                              colorText: Colors.red,
                            );
                            return;
                          }

                          bool isSuccess = await controller.addActivity(
                            title: titleC.text,
                            icon: selectedIcon.value,
                            category: category,
                            isActive: isActive.value,
                          );

                          if (isSuccess) {
                            Get.back();
                            NotificationHelper.showSuccess("Berhasil", "Kegiatan berhasil ditambahkan!");
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "SIMPAN KEGIATAN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
