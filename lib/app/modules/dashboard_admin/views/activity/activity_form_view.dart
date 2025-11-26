import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/widgets/icon_picker_dialog.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/activity_admin_controller.dart';

class ActivityFormView extends GetView<ActivityAdminController> {
  const ActivityFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String category = args['category'] ?? 'umum';

    final formKey = GlobalKey<FormState>();
    final shakeKey = GlobalKey<ShakeWidgetState>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tambah Kegiatan',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const Divider(height: 30),

                const Text(
                  "Nama Kegiatan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                ShakeWidget(
                  key: shakeKey,
                  child: TextFormField(
                    controller: controller.titleController,
                    decoration: InputDecoration(
                      hintText: "Contoh: Belajar Gitar",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama kegiatan wajib diisi';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Pilih Ikon",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => InkWell(
                    onTap: () {
                      Get.dialog(
                        IconPickerDialog(
                          onIconSelected: (iconName) {
                            controller.selectedIcon.value = iconName;
                          },
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF6C63FF,
                              ).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              AppIcons.getIcon(controller.selectedIcon.value),
                              color: const Color(0xFF6C63FF),
                            ),
                          ),
                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.selectedIcon.value.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  "Ketuk untuk mengganti",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
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
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        controller.isActive.value ? "Aktif" : "Tidak Aktif",
                        style: TextStyle(
                          color: controller.isActive.value
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: controller.isActive.value,
                      onChanged: (val) => controller.isActive.value = val,
                      activeThumbColor: const Color(0xFF6C63FF),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

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
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () => controller.saveActivity(
                              formKey: formKey,
                              shakeKey: shakeKey,
                              category: category,
                            ),
                      child: controller.isSubmitting.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              "SIMPAN",
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
        ),
      ),
    );
  }
}
