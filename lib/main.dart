import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

// FUNGSI BARU UNTUK MENANGANI LINK
Future<void> initDeepLinks() async {
  final appLinks = AppLinks();

  // Dengarkan link saat aplikasi berjalan
  appLinks.uriLinkStream.listen((uri) {
    // Cek apakah ini link reset password kita
    if (uri.path == '/resetPassword') {
      String? oobCode = uri.queryParameters['oobCode'];
      if (oobCode != null) {
        // Langsung navigasi ke halaman reset
        Get.toNamed(Routes.RESET_PASSWORD, arguments: oobCode);
      }
    }
  });

  // Cek jika aplikasi dibuka dari link (saat aplikasi mati)

  // INI BARIS YANG DIPERBAIKI:
  final initialUri = await appLinks
      .getInitialLink(); // <-- Bukan getInitialLinkUri

  if (initialUri != null) {
    if (initialUri.path == '/resetPassword') {
      String? oobCode = initialUri.queryParameters['oobCode'];
      if (oobCode != null) {
        // Ganti rute awal jika dibuka dari link
        // Get.offAllNamed(Routes.RESET_PASSWORD, arguments: oobCode);

        // Karena kita punya _setInitialScreen, lebih baik
        // kita navigasi biasa setelah halaman utama dimuat
        // (setelah penundaan singkat agar GetX siap)
        Future.delayed(const Duration(seconds: 1), () {
          Get.toNamed(Routes.RESET_PASSWORD, arguments: oobCode);
        });
      }
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthenticationRepository());

  await initDeepLinks();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EcoCampus',
      getPages: AppPages.routes,
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
