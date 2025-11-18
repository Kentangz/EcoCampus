import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/user_model.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  String? _lastRoute;
  late Rx<User?> _firebaseUser;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  void _navigateTo(String route, {bool force = false}) {
    final currentRoute = Get.currentRoute;
    if (!force) {
      if (_lastRoute == route) {
        return;
      }
      if (currentRoute.isNotEmpty && currentRoute == route) {
        _lastRoute = route;
        return;
      }
    }
    _lastRoute = route;
    Get.offAllNamed(route);
  }

  Future<void> _setInitialScreen(User? user) async {
    if (user == null) {
      _navigateTo(Routes.LOGIN);
    } else {
      final userModel = await getUserDetailsByUid(user.uid);

      if (userModel != null) {
        if (userModel.role == "admin") {
          _navigateTo(Routes.DASHBOARD_ADMIN);
        } else {
          _navigateTo(Routes.DASHBOARD_USER);
        }
      } else {
        _navigateTo(Routes.LOGIN);
      }
    }
  }

  void navigateToLogin({bool force = false}) {
    _navigateTo(Routes.LOGIN, force: force);
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

  Future<void> sendPasswordResetEmail(String email) async {
    var acs = ActionCodeSettings(
      url: 'https://ecocampus-app.site/resetPassword',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ecocampus',
      androidPackageName: 'com.example.ecocampus',
      androidInstallApp: true,
      androidMinimumVersion: '12',
    );

    try {
      await _auth.sendPasswordResetEmail(email: email, actionCodeSettings: acs);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw "Sesuatu salah. Coba lagi.";
    }
  }

  Future<String> verifyPasswordResetCode(String code) async {
    try {
      String email = await _auth.verifyPasswordResetCode(code);
      return email;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw "Kode tidak valid atau kedaluwarsa.";
    }
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw "Gagal mereset password. Coba lagi.";
    }
  }
}
