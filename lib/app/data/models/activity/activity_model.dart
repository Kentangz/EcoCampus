import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/activity/event_activity_model.dart';
import 'package:ecocampus/app/data/models/activity/internship_activity_model.dart';

export 'event_activity_model.dart';
export 'internship_activity_model.dart';

abstract class BaseActivity {
  String? id;
  String title;
  String category;
  bool isActive;
  bool isSynced;
  ContactModel contacts;
  String icon;

  BaseActivity({
    this.id,
    required this.title,
    required this.category,
    required this.isActive,
    this.isSynced = true,
    required this.contacts,
    required this.icon,
  });

  Map<String, dynamic> toJson();

  factory BaseActivity.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    final category = data['category'] ?? '';

    if (category == 'magang') {
      return InternshipActivity.fromSnapshot(document);
    } else {
      return EventActivity.fromSnapshot(document);
    }
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
