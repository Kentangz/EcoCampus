import 'package:ecocampus/app/services/upload_queue_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:ecocampus/app/services/deep_link_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthenticationRepository());
  await DeepLinkService.instance.init();
  await GetStorage.init();
  Get.put(UploadQueueService());

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
