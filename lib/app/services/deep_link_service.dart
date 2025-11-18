import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  Future<void> init() async {
    _subscription?.cancel();
    _subscription = _appLinks.uriLinkStream.listen(_handleUri);

    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      Future.delayed(const Duration(seconds: 1), () {
        _handleUri(initialUri);
      });
    }
  }

  void _handleUri(Uri uri) {
    if (uri.path != '/resetPassword') return;
    final oobCode = uri.queryParameters['oobCode'];
    if (oobCode == null) return;

    Get.toNamed(Routes.RESET_PASSWORD, arguments: oobCode);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
