// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const DASHBOARD_USER = _Paths.DASHBOARD_USER;
  static const DASHBOARD_ADMIN = _Paths.DASHBOARD_ADMIN;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
}

abstract class _Paths {
  _Paths._();

  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const RESET_PASSWORD = '/reset-password';
  static const DASHBOARD_USER = '/dashboard-user';
  static const DASHBOARD_ADMIN = '/dashboard-admin';
}
