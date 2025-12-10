import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/base_course_model.dart';

enum BlockType { text, image, video }

class ContentBlock {
  String id;
  BlockType type;
  String content;

  ContentBlock({required this.id, required this.type, required this.content});

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type.name,
    "content": content,
  };

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: BlockType.values.firstWhere(
        (e) => e.name == (json['type'] ?? 'text'),
        orElse: () => BlockType.text,
      ),
      content: json['content'] ?? '',
    );
  }
}

class MaterialModel extends BaseOrderedCourseModel {
  List<ContentBlock> blocks;

  MaterialModel({
    super.id,
    required super.title,
    required super.order,
    this.blocks = const [],
  });

  @override
  Map<String, dynamic> toJson() => {
    "title": title,
    "order": order,
    "blocks": blocks.map((b) => b.toJson()).toList(),
  };

  factory MaterialModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    List<ContentBlock> loadedBlocks = [];
    if (data['blocks'] != null) {
      loadedBlocks = (data['blocks'] as List)
          .map((item) => ContentBlock.fromJson(item))
          .toList();
    }

    return MaterialModel(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      blocks: loadedBlocks,
    );
  }
}
