import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_project_controller.dart';

class AddProjectView extends GetView<AddProjectController> {
  const AddProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Project'),
        elevation: 0,
        backgroundColor: const Color(0xFF2B7A78),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: ctrl.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Judul Project'),
              TextFormField(
                controller: ctrl.titleCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Contoh: Analisis Data Penjualan'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _label('Durasi'),
              TextFormField(
                controller: ctrl.durationCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Contoh: 16 Minggu'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Durasi wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _label('Path Gambar (assets)'),
              TextFormField(
                controller: ctrl.imageAssetCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'assets/images/my_project.jpg'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Jika kosong akan memakai gambar default.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 12),

              _label('Deskripsi (opsional)'),
              TextFormField(
                controller: ctrl.descriptionCtrl,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Deskripsi singkat project'),
              ),
              const SizedBox(height: 20),

              Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: ctrl.isSaving.value ? null : ctrl.saveProject,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2B7A78)),
                        child: ctrl.isSaving.value
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Simpan Project'),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Batal'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
