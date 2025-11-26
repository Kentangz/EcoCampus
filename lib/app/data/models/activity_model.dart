import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String? id;
  String title;
  String icon;
  String category;
  bool isActive;
  bool isSynced;

  String description;
  String heroImage;
  ContactModel contacts;
  List<RoutineModel> routines;
  List<String> gallery;

  ActivityModel({
    this.id,
    required this.title,
    required this.icon,
    required this.category,
    required this.isActive,
    this.isSynced = true,
    this.description = '',
    this.heroImage = '',
    required this.contacts,
    this.routines = const [],
    this.gallery = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "icon": icon,
      "category": category,
      "isActive": isActive,
      "createdAt": FieldValue.serverTimestamp(),
      "description": description,
      "heroImage": heroImage,
      "contacts": contacts.toJson(),
      "routines": routines.map((e) => e.toJson()).toList(),
      "gallery": gallery,
    };
  }

  factory ActivityModel.fromSnapshot(
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

    return ActivityModel(
      id: document.id,
      title: data["title"] ?? "",
      icon: data["icon"] ?? "help",
      category: data["category"] ?? "",
      isActive: data["isActive"] ?? true,
      isSynced: !document.metadata.hasPendingWrites && !hasLocalImage,

      description: data["description"] ?? "",
      heroImage: hero,
      contacts: ContactModel.fromJson(data["contacts"] ?? {}),
      routines:
          (data["routines"] as List<dynamic>?)
              ?.map((e) => RoutineModel.fromJson(e))
              .toList() ??
          [],
      gallery: gall,
    );
  }
}

class ContactModel {
  String email;
  String whatsapp;
  String instagram;

  ContactModel({this.email = '', this.whatsapp = '', this.instagram = ''});

  Map<String, dynamic> toJson() => {
    "email": email,
    "whatsapp": whatsapp,
    "instagram": instagram,
  };

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    email: json['email'] ?? '',
    whatsapp: json['whatsapp'] ?? '',
    instagram: json['instagram'] ?? '',
  );
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
