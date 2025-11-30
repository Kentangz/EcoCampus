import 'package:ecocampus/app/data/models/activity_model.dart';
import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/widgets/icon_picker_dialog.dart';
import 'package:ecocampus/app/shared/widgets/image_picker.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/activity_admin_controller.dart';

class SeniBudayaFormView extends GetView<ActivityAdminController> {
  final ActivityModel? existingActivity;
  final String category;

  const SeniBudayaFormView({
    super.key,
    this.existingActivity,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final isEditMode = existingActivity != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(15),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditMode ? 'Edit Kegiatan' : 'Tambah Kegiatan',
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
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Informasi Dasar"),
                      const SizedBox(height: 10),

                      ShakeWidget(
                        key: controller.titleShakeKey,
                        child: TextFormField(
                          controller: controller.titleController,
                          decoration: _inputDecoration("Nama Kegiatan"),
                          validator: (val) =>
                              val!.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: _buildIconPicker()),
                          const SizedBox(width: 10),
                          Expanded(child: _buildStatusSwitch()),
                        ],
                      ),
                      const SizedBox(height: 25),

                      ShakeWidget(
                        key: controller.contactShakeKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("Kontak"),
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
                              decoration: _inputDecoration(
                                "Email",
                                icon: Icons.email_outlined,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.waController,
                              decoration: _inputDecoration(
                                "WhatsApp",
                                icon: Icons.phone_outlined,
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.igController,
                              decoration: _inputDecoration(
                                "Instagram (Username)",
                                icon: Icons.camera_alt_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      _buildSectionTitle("Detail & Foto Sampul"),
                      const SizedBox(height: 10),

                      ShakeWidget(
                        key: controller.descShakeKey,
                        child: TextFormField(
                          controller: controller.descController,
                          decoration: _inputDecoration(
                            "Tentang Kami / Deskripsi",
                          ),
                          maxLines: 3,
                          validator: (val) => val!.isEmpty
                              ? 'Wajib diisi'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 15),

                      Obx(
                        () => CustomImagePicker(
                          label: "Foto Sampul (Hero Image)",
                          initialImageUrl:
                              controller.heroImageUrl.value.isNotEmpty
                              ? controller.heroImageUrl.value
                              : null,
                          onImagePicked: (file) {
                            if (file != null) {
                              controller.heroImageUrl.value = file.path;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 25),

                      _buildSectionTitle("Aktivitas Rutin"),
                      const SizedBox(height: 10),
                      Obx(
                        () => Column(
                          children: [
                            ...controller.routineForms.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final form = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rutinitas #${index + 1}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          onPressed: () =>
                                              controller.removeRoutine(index),
                                        ),
                                      ],
                                    ),
                                    CustomImagePicker(
                                      label: "Foto Rutinitas",
                                      initialImageUrl:
                                          form.imageUrl.value.isNotEmpty
                                          ? form.imageUrl.value
                                          : null,
                                      onImagePicked: (file) {
                                        if (file != null) {
                                          form.imageUrl.value = file.path;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: form.nameC,
                                      decoration: _inputDecoration(
                                        "Nama Aktivitas",
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            OutlinedButton.icon(
                              onPressed: controller.addRoutine,
                              icon: const Icon(Icons.add),
                              label: const Text("Tambah Rutinitas"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF6C63FF),
                                side: const BorderSide(
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      _buildSectionTitle("Gallery"),
                      const SizedBox(height: 10),

                      Obx(
                        () => controller.isUploadingGallery.value
                            ? const Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 8),
                                    Text("Sedang mengupload..."),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: controller.pickGalleryImages,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 30,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Tambah Foto",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),

                      Obx(
                        () => controller.galleryUrls.isEmpty
                            ? const SizedBox.shrink()
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                itemCount: controller.galleryUrls.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      SmartImage(
                                        controller.galleryUrls[index],
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),

                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: InkWell(
                                          onTap: () => controller
                                              .removeGalleryImage(index),
                                          child: Container(
                                            color: Colors.black54,
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                            category: category,
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
                            "SIMPAN",
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

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Divider(),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null
          ? Icon(icon, size: 20, color: Colors.grey)
          : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildIconPicker() {
    return Obx(
      () => InkWell(
        onTap: () => Get.dialog(
          IconPickerDialog(
            onIconSelected: (val) => controller.selectedIcon.value = val,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Icon(
                AppIcons.getIcon(controller.selectedIcon.value),
                color: const Color(0xFF6C63FF),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.selectedIcon.value.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSwitch() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.isActive.value ? "Aktif" : "Nonaktif",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: controller.isActive.value ? Colors.green : Colors.red,
              ),
            ),
            Switch(
              value: controller.isActive.value,
              onChanged: (val) => controller.isActive.value = val,
              activeThumbColor: const Color(0xFF6C63FF),
            ),
          ],
        ),
      ),
    );
  }
}
