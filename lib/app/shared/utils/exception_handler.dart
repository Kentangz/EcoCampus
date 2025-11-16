import 'package:firebase_auth/firebase_auth.dart';

class ExceptionHandler {
  static String handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'invalid-credential':
        message = 'Email atau password yang Anda masukkan salah.';
        break;
      case 'user-not-found':
        message = 'Akun dengan email ini tidak ditemukan.';
        break;
      case 'wrong-password':
        message = 'Password yang Anda masukkan salah.';
        break;
      case 'invalid-email':
        message = 'Format email tidak valid. Silakan periksa kembali.';
        break;
      case 'email-already-in-use':
        message = 'Email ini sudah terdaftar. Silakan login.';
        break;
      case 'weak-password':
        message = 'Password terlalu lemah (minimal 6 karakter).';
        break;
      case 'too-many-requests':
        message = 'Terlalu banyak percobaan. Akun Anda terkunci sementara selama 15 menit.';
        break;
      case 'network-request-failed':
        message = 'Koneksi internet terputus. Silakan periksa koneksi Anda.';
        break;
      default:
        message = 'Terjadi kesalahan. Silakan coba lagi nanti.';
    }
    return message;
  }
}
