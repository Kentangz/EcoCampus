import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phone;
  final String role;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {"fullName": fullName, "email": email, "phone": phone, "role": role};
  }

  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return UserModel(
      id: document.id,
      fullName: data["fullName"],
      email: data["email"],
      phone: data["phone"],
      role: data["role"],
    );
  }
}
