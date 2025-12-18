import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  String? _lastProcessedUri;
  DateTime? _lastProcessedTime;

  Future<void> init() async {
    _subscription?.cancel();
    _subscription = _appLinks.uriLinkStream.listen(_handleUri);

    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      Future.delayed(const Duration(seconds: 2), () {
        _handleUri(initialUri);
      });
    }
  }

  void _handleUri(Uri uri) {
    final uriString = uri.toString();
    final now = DateTime.now();
    if (_lastProcessedUri == uriString && _lastProcessedTime != null) {
      final diff = now.difference(_lastProcessedTime!);
      if (diff.inSeconds < 5) {
        return;
      }
    }
    _lastProcessedUri = uriString;
    _lastProcessedTime = now;

    String? oobCode;
    String? mode;

    _parseFirebaseLink(uri, (extractedMode, extractedCode) {
      mode = extractedMode;
      oobCode = extractedCode;
    });

    if (oobCode == null || mode == null) {
      return;
    }

    switch (mode) {
      case 'resetPassword':
        Get.toNamed(Routes.RESET_PASSWORD, arguments: oobCode);
        break;
      case 'verifyEmail':
        _handleEmailVerification(oobCode!);
        break;
      default:
        break;
    }
  }

  void _parseFirebaseLink(Uri uri, Function(String?, String?) callback) {
    String? mode;
    String? oobCode;

    if (uri.path.contains('auth/action')) {
      mode = uri.queryParameters['mode'];
      oobCode = uri.queryParameters['oobCode'];
    }

    callback(mode, oobCode);
  }

  Future<void> _handleEmailVerification(String oobCode) async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final authRepo = AuthenticationRepository.instance;
      await authRepo.applyActionCode(oobCode);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed(Routes.DASHBOARD_USER);
      });
    } catch (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed(Routes.LOGIN);
      });
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
