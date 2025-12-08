// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  // AUTH
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;

  // USER
  static const DASHBOARD_USER = _Paths.DASHBOARD_USER;
  static const KOLABORASI_KAMPUS = _Paths.KOLABORASI_KAMPUS;

  // ADMIN
  static const DASHBOARD_ADMIN = _Paths.DASHBOARD_ADMIN;
  static const ADMIN_ACTIVITY = _Paths.ADMIN_ACTIVITY;
  static const ADMIN_ACTIVITY_LIST = _Paths.ADMIN_ACTIVITY_LIST;
  static const ADMIN_ACTIVITY_FORM = _Paths.ADMIN_ACTIVITY_FORM;
}

abstract class _Paths {
  _Paths._();

  // AUTH
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const RESET_PASSWORD = '/reset-password';

  // USER
  static const DASHBOARD_USER = '/dashboard-user';
  static const KOLABORASI_KAMPUS = '/kolaborasi-kampus';

  // ADMIN
  static const DASHBOARD_ADMIN = '/dashboard-admin';
  static const ADMIN_ACTIVITY = '/admin-activity';
  static const ADMIN_ACTIVITY_LIST = '/admin-activity-list';
  static const ADMIN_ACTIVITY_FORM = '/admin-activity-form';
}
