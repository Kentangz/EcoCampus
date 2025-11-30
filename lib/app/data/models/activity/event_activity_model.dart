import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/activity/activity_model.dart';

class EventActivity extends BaseActivity {
  String description;
  String heroImage;
  List<RoutineModel> routines;
  List<String> gallery;

  EventActivity({
    super.id,
    required super.title,
    required super.category,
    required super.isActive,
    super.isSynced,
    required super.contacts,
    required super.icon,
    this.description = '',
    this.heroImage = '',
    this.routines = const [],
    this.gallery = const [],
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "category": category,
      "isActive": isActive,
      "createdAt": FieldValue.serverTimestamp(),
      "contacts": contacts.toJson(),
      "icon": icon,
      "description": description,
      "heroImage": heroImage,
      "routines": routines.map((e) => e.toJson()).toList(),
      "gallery": gallery,
    };
  }

  factory EventActivity.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    bool isLocalPath(String url) {
      return url.isNotEmpty && !url.startsWith('http');
    }

    String hero = data["heroImage"] ?? "";
    List<String> gall = List<String>.from(data["gallery"] ?? []);
    List<dynamic> routsRaw = data["routines"] ?? [];

    bool hasLocalImage = false;
    if (isLocalPath(hero)) hasLocalImage = true;

    if (!hasLocalImage) {
      for (String url in gall) {
        if (isLocalPath(url)) {
          hasLocalImage = true;
          break;
        }
      }
    }

    if (!hasLocalImage) {
      for (var r in routsRaw) {
        String rUrl = r['imageUrl'] ?? "";
        if (isLocalPath(rUrl)) {
          hasLocalImage = true;
          break;
        }
      }
    }

    return EventActivity(
      id: document.id,
      title: data["title"] ?? "",
      category: data["category"] ?? "",
      isActive: data["isActive"] ?? true,
      isSynced: !document.metadata.hasPendingWrites && !hasLocalImage,
      contacts: ContactModel.fromJson(data["contacts"] ?? {}),
      icon: data["icon"] ?? "help",
      description: data["description"] ?? "",
      heroImage: hero,
      routines:
          (data["routines"] as List<dynamic>?)
              ?.map((e) => RoutineModel.fromJson(e))
              .toList() ??
          [],
      gallery: gall,
    );
  }
}

class RoutineModel {
  String activityName;
  String imageUrl;

  RoutineModel({required this.activityName, required this.imageUrl});

  Map<String, dynamic> toJson() => {
    "activityName": activityName,
    "imageUrl": imageUrl,
  };

  factory RoutineModel.fromJson(Map<String, dynamic> json) => RoutineModel(
    activityName: json['activityName'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
  );
}
