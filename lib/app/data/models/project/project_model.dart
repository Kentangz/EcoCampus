import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> deliverables;

  // =====================
  // CONTACT
  // =====================
  final String email;
  final String phone;

  final String imageUrl;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// apakah project tampil ke publik
  final bool isActive;

  /// status sinkronisasi (offline / queue)
  final bool isSynced;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deliverables,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.isSynced = true,
  });

  // =====================
  // alias untuk UI
  // =====================
  bool get isPublished => isActive;

  // =====================
  // fromMap (Firestore-safe)
  // =====================
  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      deliverables:
          List<String>.from(map['deliverables'] ?? []),

      // backward compatible:
      email: map['email'] ?? '',
      phone: map['phone'] ??
          map['contact'] ??
          '',

      imageUrl: map['imageUrl'] ?? '',
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
      isActive: map['isActive'] ?? true,
      isSynced: map['isSynced'] ?? true,
    );
  }

  // =====================
  // toMap (Firestore-safe)
  // =====================
  Map<String, dynamic> toMap(
      {bool useServerTimestamp = false}) {
    return {
      'title': title,
      'description': description,
      'deliverables': deliverables,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'createdAt': useServerTimestamp
          ? FieldValue.serverTimestamp()
          : createdAt,
      'updatedAt': useServerTimestamp
          ? FieldValue.serverTimestamp()
          : updatedAt,
      'isActive': isActive,
      'isSynced': isSynced,
    };
  }

  // =====================
  // copyWith
  // =====================
  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? deliverables,
    String? email,
    String? phone,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isSynced,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deliverables: deliverables ?? this.deliverables,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  // =====================
  // helpers
  // =====================
  static DateTime _parseDate(dynamic val) {
    if (val == null) return DateTime.now();
    if (val is Timestamp) return val.toDate();
    if (val is DateTime) return val;
    if (val is String) {
      return DateTime.tryParse(val) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
