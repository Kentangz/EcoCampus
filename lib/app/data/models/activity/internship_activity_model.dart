import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/activity/activity_model.dart';

class InternshipActivity extends BaseActivity {
  String companyLogo;
  String position;
  String location;
  List<String> techStacks;
  List<String> qualifications;

  InternshipActivity({
    super.id,
    required super.title,
    required super.category,
    required super.isActive,
    super.isSynced,
    required super.contacts,
    required super.icon,
    this.companyLogo = '',
    this.position = '',
    this.location = '',
    this.techStacks = const [],
    this.qualifications = const [],
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
      "companyLogo": companyLogo,
      "position": position,
      "location": location,
      "techStacks": techStacks,
      "qualifications": qualifications,
    };
  }

  factory InternshipActivity.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    bool isLocalPath(String url) {
      return url.isNotEmpty && !url.startsWith('http');
    }

    String companyLogo = data["companyLogo"] ?? "";
    bool hasLocalImage = isLocalPath(companyLogo);

    return InternshipActivity(
      id: document.id,
      title: data["title"] ?? "",
      category: data["category"] ?? "",
      isActive: data["isActive"] ?? true,
      isSynced: !document.metadata.hasPendingWrites && !hasLocalImage,
      contacts: ContactModel.fromJson(data["contacts"] ?? {}),
      icon: data["icon"] ?? "work",
      companyLogo: companyLogo,
      position: data["position"] ?? "",
      location: data["location"] ?? "",
      techStacks: List<String>.from(data["techStacks"] ?? []),
      qualifications: List<String>.from(data["qualifications"] ?? []),
    );
  }
}
