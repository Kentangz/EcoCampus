import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/user_model.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  late Rx<User?> _firebaseUser;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  Future<void> _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      final userModel = await getUserDetailsByUid(user.uid);

      if (userModel != null) {
        if (userModel.role == "admin") {
          Get.offAllNamed(Routes.DASHBOARD_ADMIN);
        } else {
          Get.offAllNamed(Routes.DASHBOARD_USER);
        }
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }
  
  Future<void> createUser(
    String email,
    String password,
    String fullName,
    String phone,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final newUser = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName,
        email: email,
        phone: phone,
        role: "user",
      );

      await _db.collection("Users").doc(newUser.id).set(newUser.toJson());
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw "Sesuatu salah. Coba lagi.";
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw "Sesuatu salah. Coba lagi.";
    }
  }

  Future<UserModel?> getUserDetailsByUid(String uid) async {
    try {
      final snapshot = await _db.collection("Users").doc(uid).get();
      if (snapshot.exists) {
        return UserModel.fromSnapshot(snapshot);
      }
    } catch (e) {
      throw "Gagal mengambil data user.";
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
