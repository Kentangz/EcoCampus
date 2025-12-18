import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/user_model.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  String? _lastRoute;
  late Rx<User?> _firebaseUser;

  User? get currentUser {
    return _auth.currentUser;
  }

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

    if (WidgetsBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      Get.offAllNamed(route);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(route);
      });
    }
  }

  Future<void> _setInitialScreen(User? user) async {
    if (user == null) {
      _navigateTo(Routes.LOGIN);
    } else {
      // Check if email is verified first
      if (!user.emailVerified) {
        _navigateTo(Routes.EMAIL_VERIFICATION, force: true);
        return; // Important: return here to prevent further navigation
      }

      // Email is verified, check user data
      final userModel = await getUserDetailsByUid(user.uid);

      if (userModel != null) {
        if (userModel.role == "admin") {
          _navigateTo(Routes.DASHBOARD_ADMIN);
        } else {
          _navigateTo(Routes.DASHBOARD_USER);
        }
      } else {
        // User might be in PendingUsers (just verified), try to move them
        await movePendingUserToVerified(user.uid);
        // Check again after moving
        final movedUser = await getUserDetailsByUid(user.uid);
        if (movedUser != null) {
          _navigateTo(Routes.DASHBOARD_USER);
        } else {
          // Still no user data, something is wrong
          _navigateTo(Routes.LOGIN);
        }
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
    UserCredential? userCredential;
    try {
      // Step 1: Create Firebase Auth user
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final newUser = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName,
        email: email,
        phone: phone,
        role: "user",
      );

      // Step 2: Store in PendingUsers collection
      try {
        await _db
            .collection("PendingUsers")
            .doc(newUser.id)
            .set(newUser.toJson());
      } catch (firestoreError) {
        // Rollback: Delete Firebase Auth user if Firestore write fails
        await userCredential.user?.delete();
        throw "Gagal menyimpan data. Silakan coba lagi.";
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      // If we have a user credential but got here, clean it up
      if (userCredential?.user != null) {
        try {
          await userCredential!.user!.delete();
        } catch (_) {
          // Ignore cleanup errors
        }
      }
      rethrow;
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
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (_) {
      throw "Kode tidak valid atau kedaluwarsa.";
    }
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (_) {
      throw "Gagal mereset password. Coba lagi.";
    }
  }

  /// Send email verification to current user
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw "User tidak ditemukan. Silakan login terlebih dahulu.";
      }

      var acs = ActionCodeSettings(
        url: 'https://ecocampus-app.site/emailVerified',
        handleCodeInApp: true,
        iOSBundleId: 'com.example.ecocampus',
        androidPackageName: 'com.example.ecocampus',
        androidInstallApp: true,
        androidMinimumVersion: '12',
      );

      await user.sendEmailVerification(acs);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw "Gagal mengirim email verifikasi. Coba lagi.";
    }
  }

  /// Apply action code (for email verification)
  Future<void> applyActionCode(String code) async {
    try {
      await _auth.applyActionCode(code);
      // Reload user to get updated emailVerified status
      await _auth.currentUser?.reload();

      // Move user data from PendingUsers to Users after verification
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await movePendingUserToVerified(uid);
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (_) {
      throw "Gagal memverifikasi email. Coba lagi.";
    }
  }

  /// Move user data from PendingUsers to Users collection (called after email verification)
  Future<void> movePendingUserToVerified(String uid) async {
    try {
      final pendingDoc = await _db.collection("PendingUsers").doc(uid).get();
      if (pendingDoc.exists) {
        // Copy to Users collection
        await _db.collection("Users").doc(uid).set(pendingDoc.data()!);
        // Delete from PendingUsers
        await _db.collection("PendingUsers").doc(uid).delete();
      }
    } catch (_) {
      // Silently handle errors during migration
    }
  }

  /// Check if current user's email is verified
  bool get isEmailVerified {
    return _auth.currentUser?.emailVerified ?? false;
  }
}
