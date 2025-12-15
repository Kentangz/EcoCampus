import 'dart:io';
import 'package:ecocampus/app/data/models/course/material_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/material_builder_controller.dart';
import 'package:ecocampus/app/shared/widgets/smart_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecocampus/app/shared/widgets/markdown_toolbar.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/component/material_builder_components.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';

class MaterialBuilderView extends GetView<MaterialBuilderController> {
  const MaterialBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    final isPreview = false.obs;
    final showAddPanel = true.obs;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (controller.isSaving.value) return;

        final shouldPop = await Get.dialog<bool>(
          AlertDialog(
            title: const Text("Batal Edit?"),
            content: const Text(
              "Perubahan yang belum disimpan akan hilang. Yakin ingin keluar?",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text("Lanjut Edit"),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        if (shouldPop == true) {
          Get.back();
        }
      },
      child: Scaffold(
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
                child: Obx(() {
                  String? error = controller.fieldErrors['title'];
                  return ShakeWidget(
                    key: controller.titleShakeKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: controller.titleController,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            labelText: "Judul Topik (Misal: Sejarah Python)",
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            errorText: error,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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
                  scrollController: controller.scrollController,
                  padding: const EdgeInsets.only(bottom: 100, top: 10),
                  itemCount: controller.blocks.length,
                  onReorder: controller.reorderBlocks,
                  onReorderStart: (_) => FocusScope.of(context).unfocus(),
                  itemBuilder: (context, index) {
                    final block = controller.blocks[index];
                    return _buildEditorBlock(
                      key: ValueKey(block.id),
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
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isPreview.value) ...[
                  Obx(
                    () => AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: showAddPanel.value
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                      () =>
                                          controller.addBlock(BlockType.image),
                                    ),
                                    _addBtn(
                                      "Video",
                                      Icons.play_circle,
                                      Colors.red,
                                      () =>
                                          controller.addBlock(BlockType.video),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(height: 1),
                                const SizedBox(height: 12),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],

                Row(
                  children: [
                    if (!isPreview.value)
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: IconButton(
                          onPressed: () => showAddPanel.toggle(),
                          icon: Obx(
                            () => Icon(
                              showAddPanel.value
                                  ? Icons.keyboard_arrow_down
                                  : Icons.add,
                              color: const Color(0xFF6C63FF),
                            ),
                          ),
                          tooltip: "Toggle Menu Tambah",
                        ),
                      ),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          isPreview.value = !isPreview.value;
                        },
                        icon: Icon(
                          isPreview.value ? Icons.edit : Icons.remove_red_eye,
                        ),
                        label: Text(
                          isPreview.value ? "Kembali Edit" : "Preview",
                        ),
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
      ),
    );
  }

  Widget _buildEditorBlock({
    required Key key,
    required int index,
    required ContentBlock block,
    required MaterialBuilderController controller,
  }) {
    return AnimatedBlockWrapper(
      key: key,
      onRemove: () => controller.removeBlockById(block.id),
      child: ShakeWidget(
        key: controller.getBlockShakeKey(block.id),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
                    Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () {
                            context
                                .findAncestorStateOfType<
                                  AnimatedBlockWrapperState
                                >()
                                ?.animateDelete();
                          },
                          child: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.drag_handle, color: Colors.grey),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBlockInput(index, block, controller),
                    Obx(() {
                      final error = controller.fieldErrors[block.id];
                      if (error != null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            error,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
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
        return Column(
          children: [
            TextFormField(
              controller: controller.getTextController(block.id, block.content),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: "Tulis materi di sini (Support Markdown)...",
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const Divider(height: 1),
            MarkdownToolbar(
              onFormat: (format) =>
                  controller.applyTextFormat(block.id, format),
            ),
          ],
        );
      case BlockType.image:
        return Column(
          children: [
            GestureDetector(
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
                          child:
                              (block.attributes['isLocal'] == true &&
                                  !block.content.startsWith('http'))
                              ? Image.file(
                                  File(block.content),
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : SmartImage(
                                  block.content,
                                  width: double.infinity,
                                  height: 200,
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
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: block.attributes['caption'] ?? '',
              onChanged: (val) =>
                  controller.updateBlockAttribute(index, 'caption', val),
              decoration: const InputDecoration(
                labelText: "Caption Gambar",
                isDense: true,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.short_text),
              ),
            ),
          ],
        );

      case BlockType.video:
        String source = block.attributes['source'] ?? 'link';
        bool isLocal = block.attributes['isLocal'] == true;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'link',
                      label: Text('Link URL'),
                      icon: Icon(Icons.link),
                    ),
                    ButtonSegment<String>(
                      value: 'upload',
                      label: Text('Upload File'),
                      icon: Icon(Icons.upload_file),
                    ),
                  ],
                  selected: {source},
                  onSelectionChanged: (Set<String> newSelection) {
                    controller.setVideoSource(index, newSelection.first);
                  },
                ),
              ),
            ),
            if (source == 'upload')
              GestureDetector(
                onTap: () => controller.pickAndUploadVideo(index),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 150),
                  width: double.infinity,
                  color: Colors.grey[100],
                  alignment: Alignment.center,
                  child: block.content.isNotEmpty
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  (isLocal && !block.content.startsWith('http'))
                                  ? SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: VideoPreview(
                                        path: block.content,
                                        isUrl: false,
                                      ),
                                    )
                                  : (block.content.startsWith('http'))
                                  ? SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: VideoPreview(
                                        path: block.content,
                                        isUrl: true,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text("Video terupload"),
                                        Text(
                                          block.content.split('/').last,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: () =>
                                    controller.clearBlockContent(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_call,
                              size: 40,
                              color: Colors.grey,
                            ),
                            Text(
                              "Tap untuk pilih video dari galeri",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              )
            else
              TextFormField(
                controller: controller.getTextController(
                  block.id,
                  block.content,
                ),
                decoration: InputDecoration(
                  hintText: "Tempel URL Video (YouTube/Drive)...",
                  prefixIcon: const Icon(Icons.link),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller
                          .getTextController(block.id, block.content)
                          .text
                          .isEmpty)
                        IconButton(
                          icon: const Icon(Icons.paste),
                          tooltip: "Tempel Link",
                          onPressed: () => controller.pasteFromClipboard(index),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: "Hapus Link",
                          onPressed: () => controller.clearBlockContent(index),
                        ),
                    ],
                  ),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),

            const SizedBox(height: 12),
            TextFormField(
              initialValue: block.attributes['description'] ?? '',
              onChanged: (val) =>
                  controller.updateBlockAttribute(index, 'description', val),
              decoration: const InputDecoration(
                labelText: "Deskripsi Video (Tampil di atas player)",
                isDense: true,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
          ],
        );
    }
  }

  Widget _renderPreviewBlock(ContentBlock block) {
    switch (block.type) {
      case BlockType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: MarkdownBody(
            data: block.content,
            selectable: true,
            onTapLink: (text, href, title) {
              if (href != null) launchUrl(Uri.parse(href));
            },
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF333333),
                fontFamily: 'Montserrat',
              ),
              h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              code: TextStyle(
                backgroundColor: Colors.grey[200],
                fontFamily: 'monospace',
              ),
            ),
          ),
        );
      case BlockType.image:
        if (block.content.isEmpty) return const SizedBox.shrink();
        final caption = block.attributes['caption'] ?? '';

        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    (block.attributes['isLocal'] == true &&
                        !block.content.startsWith('http'))
                    ? Image.file(
                        File(block.content),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : SmartImage(
                        block.content,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              if (caption.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  caption,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        );
      case BlockType.video:
        final description = block.attributes['description'] ?? '';
        final isLocal = block.attributes['isLocal'] == true;
        final source = block.attributes['source'];

        Widget videoWidget = Container(
          height: 200,
          color: Colors.black,
          child: const Center(child: Icon(Icons.error, color: Colors.white)),
        );

        if (isLocal && block.content.isNotEmpty) {
          videoWidget = Container(
            constraints: const BoxConstraints(minHeight: 200),
            color: Colors.black,
            child: VideoPreview(
              path: block.content,
              isUrl: block.content.startsWith('http'),
            ),
          );
        } else if (source == 'youtube' ||
            (block.content.contains('youtube.com') ||
                block.content.contains('youtu.be'))) {
          final videoId = YoutubePlayer.convertUrlToId(block.content);
          if (videoId != null) {
            videoWidget = ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://img.youtube.com/vi/$videoId/0.jpg',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.play_arrow_rounded,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 70,
                  ),
                ],
              ),
            );
          }
        } else if (block.content.contains('drive.google.com')) {
          videoWidget = Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4285F4), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_to_drive,
                  size: 50,
                  color: Color(0xFF4285F4),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Video Google Drive",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4285F4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Text(
                    block.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => launchUrl(Uri.parse(block.content)),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text("Buka di Drive"),
                ),
              ],
            ),
          );
        } else if (block.content.isNotEmpty) {
          videoWidget = Container(
            height: 200,
            width: double.infinity,
            color: Colors.black,
            alignment: Alignment.center,
            child: const Icon(
              Icons.video_library,
              color: Colors.white,
              size: 70,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description.isNotEmpty) ...[
                Text(
                  description,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
              videoWidget,
            ],
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
