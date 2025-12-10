import 'package:ecocampus/app/data/models/course/material_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/material_builder_controller.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaterialBuilderView extends GetView<MaterialBuilderController> {
  const MaterialBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    final isPreview = false.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          controller.existingMaterial?.title ?? "Edit Konten",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Obx(() {
            if (isPreview.value) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[50],
              child: TextField(
                controller: controller.titleController,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  labelText: "Judul Topik (Misal: Sejarah Python)",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            );
          }),

          Expanded(
            child: Obx(() {
              if (isPreview.value) {
                return Container(
                  color: const Color(0xFFE8F6FF),
                  padding: const EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      Text(
                        controller.titleController.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 20),

                      ...controller.blocks.map(
                        (block) => _renderPreviewBlock(block),
                      ),
                    ],
                  ),
                );
              }

              if (controller.blocks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard_customize,
                        size: 60,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Belum ada konten. Tambahkan di bawah!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ReorderableListView.builder(
                padding: const EdgeInsets.only(bottom: 100, top: 10),
                itemCount: controller.blocks.length,
                onReorder: controller.reorderBlocks,
                itemBuilder: (context, index) {
                  final block = controller.blocks[index];
                  return _buildEditorBlock(
                    key: ValueKey(
                      block.id,
                    ),
                    index: index,
                    block: block,
                    controller: controller,
                  );
                },
              );
            }),
          ),
        ],
      ),

      bottomNavigationBar: Obx(
        () => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, -2),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isPreview.value) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _addBtn(
                      "Teks",
                      Icons.notes,
                      Colors.blue,
                      () => controller.addBlock(BlockType.text),
                    ),
                    _addBtn(
                      "Gambar",
                      Icons.image,
                      Colors.orange,
                      () => controller.addBlock(BlockType.image),
                    ),
                    _addBtn(
                      "Video",
                      Icons.play_circle,
                      Colors.red,
                      () => controller.addBlock(BlockType.video),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
              ],

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        isPreview.value = !isPreview.value;
                      },
                      icon: Icon(
                        isPreview.value ? Icons.edit : Icons.remove_red_eye,
                      ),
                      label: Text(isPreview.value ? "Kembali Edit" : "Preview"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63FF),
                        side: const BorderSide(color: Color(0xFF6C63FF)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.isSaving.value
                          ? null
                          : controller.saveMaterial,
                      icon: controller.isSaving.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        controller.isSaving.value ? "Menyimpan..." : "Simpan",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditorBlock({
    required Key key,
    required int index,
    required ContentBlock block,
    required MaterialBuilderController controller,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getIconByType(block.type),
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  block.type.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => controller.removeBlock(index),
                  child: const Icon(Icons.delete, size: 18, color: Colors.red),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.drag_handle, color: Colors.grey),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildBlockInput(index, block, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockInput(
    int index,
    ContentBlock block,
    MaterialBuilderController controller,
  ) {
    switch (block.type) {
      case BlockType.text:
        return TextFormField(
          initialValue: block.content,
          onChanged: (val) => controller.updateBlockContent(index, val),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: "Tulis materi di sini...",
            border: InputBorder.none,
            isDense: true,
          ),
        );
      case BlockType.image:
        return GestureDetector(
          onTap: () => controller.pickAndUploadImage(index),
          child: block.content.isEmpty
              ? Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: Colors.grey,
                      ),
                      Text(
                        "Tap untuk upload gambar",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SmartImage(
                        block.content,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      case BlockType.video:
        return TextFormField(
          initialValue: block.content,
          onChanged: (val) => controller.updateBlockContent(index, val),
          decoration: const InputDecoration(
            hintText: "Tempel URL Video (YouTube/MP4)",
            prefixIcon: Icon(Icons.link),
            border: OutlineInputBorder(),
            isDense: true,
          ),
        );
    }
  }

  Widget _renderPreviewBlock(ContentBlock block) {
    switch (block.type) {
      case BlockType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            block.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF333333),
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.justify,
          ),
        );
      case BlockType.image:
        if (block.content.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SmartImage(
              block.content,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        );
      case BlockType.video:
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
          ),
        );
    }
  }

  Widget _addBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  IconData _getIconByType(BlockType type) {
    switch (type) {
      case BlockType.text:
        return Icons.text_fields;
      case BlockType.image:
        return Icons.image;
      case BlockType.video:
        return Icons.play_circle;
    }
  }
}
