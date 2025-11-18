import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationHelper {
  static const Duration _animationDuration = Duration(milliseconds: 400);
  static const Duration _displayDuration = Duration(seconds: 2);

  static String? _currentMessage;

  static void showSuccess(String title, String message) {
    if (Get.isSnackbarOpen && _currentMessage == message) {
      return;
    }
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    _currentMessage = message;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: _displayDuration,
      animationDuration: _animationDuration,

      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          _currentMessage = null;
        }
      },
    );
  }

  static void showError(String title, String message) {
    if (Get.isSnackbarOpen && _currentMessage == message) {
      return;
    }
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    _currentMessage = message;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: _displayDuration,
      animationDuration: _animationDuration,

      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          _currentMessage = null;
        }
      },
    );
  }

  static void showInfo(String title, String message) {
    if (Get.isSnackbarOpen && _currentMessage == message) {
      return;
    }
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    _currentMessage = message;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: _displayDuration,
      animationDuration: _animationDuration,

      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED) {
          _currentMessage = null;
        }
      },
    );
  }
}
