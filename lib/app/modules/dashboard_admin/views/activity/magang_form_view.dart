import 'package:ecocampus/app/data/models/activity/activity_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/activity_admin_controller.dart';
import 'package:ecocampus/app/shared/utils/tech_stack_icons.dart';
import 'package:ecocampus/app/shared/widgets/tech_stack_picker_dialog.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MagangFormView extends GetView<ActivityAdminController> {
  final InternshipActivity? existingActivity;

  const MagangFormView({super.key, this.existingActivity});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final isEditMode = existingActivity != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(15),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 800),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditMode ? 'Edit Magang' : 'Info Magang Baru',
                    style: const TextStyle(
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
            ),
            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Info Perusahaan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Obx(
                                () => InkWell(
                                  onTap: controller.pickCompanyLogo,
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      color: Colors.grey[100],
                                    ),
                                    child: ClipOval(
                                      child:
                                          controller
                                              .companyLogoUrl
                                              .value
                                              .isNotEmpty
                                          ? SmartImage(
                                              controller.companyLogoUrl.value,
                                              fit: BoxFit.cover,
                                              width: 90,
                                              height: 90,
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.grey[400],
                                                  size: 30,
                                                ),
                                                const Text(
                                                  "Upload",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Logo",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              children: [
                                ShakeWidget(
                                  key: controller.titleShakeKey,
                                  child: TextFormField(
                                    controller: controller.titleController,
                                    decoration: _deco(
                                      "Nama Perusahaan",
                                      Icons.business,
                                    ),
                                    validator: (val) =>
                                        val!.isEmpty ? 'Wajib diisi' : null,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ShakeWidget(
                                  key: controller.positionShakeKey,
                                  child: TextFormField(
                                    controller: controller.positionController,
                                    decoration: _deco(
                                      "Posisi Magang",
                                      Icons.work,
                                    ),
                                    validator: (val) =>
                                        val!.isEmpty ? 'Wajib diisi' : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      ShakeWidget(
                        key: controller.locationShakeKey,
                        child: TextFormField(
                          controller: controller.locationController,
                          decoration: _deco("Lokasi", Icons.location_on),
                          validator: (val) =>
                              val!.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ShakeWidget(
                        key: controller.contactShakeKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kontak HR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Obx(
                              () => controller.contactError.value.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Text(
                                        controller.contactError.value,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.emailController,
                              decoration: _deco("Email", Icons.email_outlined),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.waController,
                              decoration: _deco(
                                "No Telp/WA",
                                Icons.phone_outlined,
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      ShakeWidget(
                        key: controller.techStackShakeKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tech Stack",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            Obx(
                              () => controller.techStackError.value.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Text(
                                        controller.techStackError.value,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 5),
                            OutlinedButton.icon(
                              onPressed: () => Get.dialog(
                                TechStackPickerDialog(
                                  onIconSelected: controller.toggleTechStack,
                                ),
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text("Tambah Tech Stack"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF6C63FF),
                                side: const BorderSide(
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: controller.techStacks
                                    .map(
                                      (iconName) => Chip(
                                        avatar: Icon(
                                          TechStackIcons.getIcon(iconName),
                                          size: 16,
                                          color: TechStackIcons.getColor(
                                            iconName,
                                          ),
                                        ),
                                        label: Text(iconName),
                                        backgroundColor: const Color(
                                          0xFF6C63FF,
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        deleteIcon: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        onDeleted: () => controller
                                            .toggleTechStack(iconName),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      ShakeWidget(
                        key: controller.qualificationShakeKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Kualifikasi",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  onPressed: controller.addQualification,
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Color(0xFF6C63FF),
                                  ),
                                ),
                              ],
                            ),

                            Obx(
                              () =>
                                  controller.qualificationError.value.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Text(
                                        controller.qualificationError.value,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Obx(
                              () => Column(
                                children: controller.qualificationForms
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle_outline,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                controller: entry.value.textC,
                                                decoration: const InputDecoration(
                                                  hintText:
                                                      "Contoh: Mahasiswa semester 5",
                                                  border:
                                                      UnderlineInputBorder(),
                                                  isDense: true,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red,
                                              ),
                                              onPressed: () => controller
                                                  .removeQualification(
                                                    entry.key,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Obx(
                        () => SwitchListTile(
                          title: const Text(
                            "Status Lowongan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            controller.isActive.value
                                ? "Dibuka (Aktif)"
                                : "Ditutup",
                            style: TextStyle(
                              color: controller.isActive.value
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: controller.isActive.value,
                          onChanged: (v) => controller.isActive.value = v,
                          activeThumbColor: const Color(0xFF6C63FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
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
                            category: 'magang',
                            existingActivity: existingActivity,
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
                            "SIMPAN MAGANG",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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

  InputDecoration _deco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
