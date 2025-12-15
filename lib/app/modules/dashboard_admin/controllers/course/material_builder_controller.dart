import 'package:ecocampus/app/data/models/course/material_model.dart';
import 'package:ecocampus/app/data/repositories/course_repository.dart';
import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:uuid/uuid.dart';

class MaterialBuilderController extends GetxController {
  final CourseRepository _courseRepo = Get.find<CourseRepository>();
  final UploadQueueService _queueService = Get.find<UploadQueueService>();
  final ImagePicker _picker = ImagePicker();

  late String courseId;
  late String? moduleId;
  String? sectionId;
  MaterialModel? existingMaterial;
  int? nextOrder;

  final titleController = TextEditingController();
  final blocks = <ContentBlock>[].obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();

    titleController.addListener(() {
      if (fieldErrors.containsKey('title')) {
        fieldErrors.remove('title');
      }
    });

    final args = Get.arguments;
    if (args != null) {
      courseId = args['courseId'];
      moduleId = args['moduleId'];
      sectionId = args['sectionId'];
      nextOrder = args['nextOrder'];

      if (args['material'] != null) {
        existingMaterial = args['material'] as MaterialModel;
        titleController.text = existingMaterial!.title;
        blocks.assignAll(existingMaterial!.blocks);
      }
    }
  }

  @override
  void onClose() {
    for (var c in _textControllers.values) {
      c.dispose();
    }
    titleController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  final List<String> _deletedUrls = [];
  final Map<String, TextEditingController> _textControllers = {};

  // === TEXT CONTROLLER MANAGEMENT ===
  TextEditingController getTextController(String blockId, String initialText) {
    if (!_textControllers.containsKey(blockId)) {
      _textControllers[blockId] = TextEditingController(text: initialText)
        ..addListener(() {
          if (fieldErrors.containsKey(blockId)) {
            fieldErrors.remove(blockId);
          }

          int index = blocks.indexWhere((b) => b.id == blockId);
          if (index != -1) {
            var block = blocks[index];
            if (block.content != _textControllers[blockId]!.text) {
              block.content = _textControllers[blockId]!.text;
              blocks[index] = block;
            }
          }
        });
    }
    return _textControllers[blockId]!;
  }

  void removeTextController(String blockId) {
    if (_textControllers.containsKey(blockId)) {
      _textControllers[blockId]!.dispose();
      _textControllers.remove(blockId);
    }
  }

  void applyTextFormat(String blockId, String format) {
    if (!_textControllers.containsKey(blockId)) return;

    final controller = _textControllers[blockId]!;
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) {
      final newText = "$text$format";
      controller.text = newText;
      return;
    }

    final start = selection.start;
    final end = selection.end;
    final selectedText = text.substring(start, end);

    String newText;
    int newSelectionStart;
    int newSelectionEnd;

    String prefix = '';
    String suffix = '';

    switch (format) {
      case 'bold':
        prefix = '**';
        suffix = '**';
        break;
      case 'italic':
        prefix = '_';
        suffix = '_';
        break;
      case 'code':
        prefix = '`';
        suffix = '`';
        break;
      case 'list':
        prefix = '\n- ';
        break;
      case 'quote':
        prefix = '\n> ';
        break;
      case 'h1':
        prefix = '\n# ';
        break;
      case 'h2':
        prefix = '\n## ';
        break;
      case 'link':
        prefix = '[';
        suffix = '](url)';
        break;
      case 'separator':
        newText = text.replaceRange(start, end, "\n---\n");
        controller.text = newText;
        controller.selection = TextSelection.collapsed(offset: start + 5);
        return;
    }

    if (selectedText.isNotEmpty) {
      if (['list', 'quote', 'h1', 'h2'].contains(format)) {
        newText = text.replaceRange(
          start,
          end,
          "$prefix${selectedText.trim()}",
        );
        newSelectionStart = start + prefix.length;
        newSelectionEnd = start + prefix.length + selectedText.trim().length;
      } else {
        newText = text.replaceRange(start, end, "$prefix$selectedText$suffix");
        newSelectionStart = start + prefix.length;
        newSelectionEnd = end + prefix.length;
      }
    } else {
      if (format == 'link') {
        newText = text.replaceRange(start, end, "[Link](url)");
        newSelectionStart = start + 1;
        newSelectionEnd = start + 5;
      } else {
        newText = text.replaceRange(start, end, "$prefix$suffix");
        newSelectionStart = start + prefix.length;
        newSelectionEnd = start + prefix.length;
      }
    }

    controller.text = newText;
    controller.selection = TextSelection(
      baseOffset: newSelectionStart,
      extentOffset: newSelectionEnd,
    );
  }

  final scrollController = ScrollController();

  // === BLOCK MANAGEMENT ===

  void addBlock(BlockType type) {
    final newBlock = ContentBlock(
      id: const Uuid().v4(),
      type: type,
      content: '',
    );
    blocks.add(newBlock);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void removeBlock(int index) {
    if (index >= 0 && index < blocks.length) {
      removeBlockById(blocks[index].id);
    }
  }

  void removeBlockById(String id) {
    final index = blocks.indexWhere((b) => b.id == id);
    if (index == -1) return;

    var block = blocks[index];
    if (block.type == BlockType.text) {
      removeTextController(block.id);
    }
    if (block.content.startsWith('http')) {
      _deletedUrls.add(block.content);
    }
    blocks.removeAt(index);
  }

  void reorderBlocks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, item);
  }

  void updateBlockContent(int index, String val) {
    var block = blocks[index];
    block.content = val;
    blocks[index] = block;
  }

  // === UPLOAD IMAGE PER BLOK ===

  Future<void> pickAndUploadImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String localPath = image.path;

        if (blocks[index].content.startsWith('http')) {
          _deletedUrls.add(blocks[index].content);
        }

        updateBlockContent(index, localPath);
        updateBlockAttribute(index, 'isLocal', true);

        fieldErrors.remove(blocks[index].id);
      }
    } catch (e) {
      NotificationHelper.showError("Error", "Terjadi kesalahan: $e");
    }
  }

  // === ACTION HELPERS ===
  void clearBlockContent(int index) {
    updateBlockContent(index, '');
    final blockId = blocks[index].id;
    if (_textControllers.containsKey(blockId)) {
      _textControllers[blockId]!.clear();
    }
    if (fieldErrors.containsKey(blockId)) {
      fieldErrors.remove(blockId);
    }
  }

  Future<void> pasteFromClipboard(int index) async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      final blockId = blocks[index].id;
      getTextController(blockId, "").text = data.text!;
    }
  }

  void setVideoSource(int index, String newSource) {
    final block = blocks[index];
    if (block.content.isNotEmpty) {
      getBlockShakeKey(block.id).currentState?.shake();
      fieldErrors[block.id] =
          "Hapus konten video/link saat ini sebelum mengganti jenis input.";
      return;
    }

    updateBlockAttribute(index, 'source', newSource);
  }

  // === ATTRIBUTE UPDATE ===
  void updateBlockAttribute(int index, String key, dynamic value) {
    var block = blocks[index];
    Map<String, dynamic> newAttrs = Map.from(block.attributes);
    newAttrs[key] = value;
    block.attributes = newAttrs;
    blocks[index] = block;
  }

  // === UPLOAD VIDEO ===
  Future<void> pickAndUploadVideo(int index) async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        String localPath = video.path;

        if (blocks[index].content.startsWith('http')) {
          _deletedUrls.add(blocks[index].content);
        }

        updateBlockContent(index, localPath);
        updateBlockAttribute(index, 'source', 'upload');
        updateBlockAttribute(index, 'isLocal', true);

        fieldErrors.remove(blocks[index].id);
      }
    } catch (e) {
      NotificationHelper.showError("Error", "Gagal mengambil video: $e");
    }
  }

  // === VALIDATION & SHAKE KEYS ===
  final fieldErrors = <String, String>{}.obs;
  final titleShakeKey = GlobalKey<ShakeWidgetState>();
  // Map blockId -> key
  final blockShakeKeys = <String, GlobalKey<ShakeWidgetState>>{}.obs;

  GlobalKey<ShakeWidgetState> getBlockShakeKey(String blockId) {
    if (!blockShakeKeys.containsKey(blockId)) {
      blockShakeKeys[blockId] = GlobalKey<ShakeWidgetState>();
    }
    return blockShakeKeys[blockId]!;
  }

  // === SAVE TO FIRESTORE ===
  Future<void> saveMaterial() async {
    fieldErrors.clear();
    bool isValid = true;
    String? firstErrorKey;
    BuildContext? scrollContext;

    if (titleController.text.trim().isEmpty) {
      fieldErrors['title'] = "Judul topik tidak boleh kosong";
      titleShakeKey.currentState?.shake();
      isValid = false;
      firstErrorKey ??= 'title';
      scrollContext ??= titleShakeKey.currentContext;
    }

    if (blocks.isEmpty) {
      NotificationHelper.showWarning("Peringatan", "Isi materi masih kosong");
      return;
    }

    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final shakeKey = getBlockShakeKey(block.id);

      if (block.type == BlockType.text) {
        if (block.content.trim().isEmpty) {
          fieldErrors[block.id] = "Konten teks tidak boleh kosong";
          shakeKey.currentState?.shake();
          isValid = false;
          firstErrorKey ??= block.id;
          scrollContext ??= shakeKey.currentContext;
        }
      } else if (block.type == BlockType.image) {
        if (block.content.isEmpty) {
          fieldErrors[block.id] = "Gambar belum dipilih";
          shakeKey.currentState?.shake();
          isValid = false;
          firstErrorKey ??= block.id;
          scrollContext ??= shakeKey.currentContext;
        }
      } else if (block.type == BlockType.video) {
        String source = block.attributes['source'] ?? 'link';
        if (source == 'upload') {
          if (block.content.isEmpty) {
            fieldErrors[block.id] = "Video belum dipilih";
            shakeKey.currentState?.shake();
            isValid = false;
            firstErrorKey ??= block.id;
            scrollContext ??= shakeKey.currentContext;
          }
        } else {
          if (block.content.trim().isEmpty) {
            fieldErrors[block.id] = "Link video tidak boleh kosong";
            shakeKey.currentState?.shake();
            isValid = false;
            firstErrorKey ??= block.id;
            scrollContext ??= shakeKey.currentContext;
          }
        }
      }
    }

    if (!isValid) {
      if (scrollContext != null) {
        Scrollable.ensureVisible(
          scrollContext,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
      return;
    }

    isSaving.value = true;

    try {
      final materialId = existingMaterial?.id ?? const Uuid().v4();

      final material = MaterialModel(
        id: materialId,
        title: titleController.text,
        order:
            existingMaterial?.order ??
            nextOrder ??
            DateTime.now().millisecondsSinceEpoch,
        blocks: blocks,
      );

      if (moduleId != null && sectionId != null) {
        await _courseRepo
            .saveMaterial(courseId, moduleId!, sectionId!, material)
            .timeout(const Duration(seconds: 2), onTimeout: () => null);
      } else {
        throw "Module ID or Section ID is null";
      }

      for (var url in _deletedUrls) {
        _queueService.addDeleteToQueue(url);
      }
      _deletedUrls.clear();

      for (var block in blocks) {
        if (block.type == BlockType.image || block.type == BlockType.video) {
          String content = block.content;
          bool isLocal =
              block.attributes['isLocal'] == true ||
              !content.startsWith('http');

          if (isLocal && content.isNotEmpty) {
            _queueService.addToQueue(
              materialId,
              'blocks',
              content,
              collection:
                  'Courses/$courseId/modules/$moduleId/sections/$sectionId/materials',
            );
          }
        }
      }

      Get.back();
      NotificationHelper.showSuccess("Tersimpan", "Materi berhasil disimpan");
    } catch (e) {
      isSaving.value = false;
      NotificationHelper.showError("Gagal", "Gagal menyimpan materi: $e");
    } finally {
      isSaving.value = false;
    }
  }
}
