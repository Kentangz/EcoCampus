// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  //auth
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;

  //user
  static const DASHBOARD_USER = _Paths.DASHBOARD_USER;


  //admin
  static const DASHBOARD_ADMIN = _Paths.DASHBOARD_ADMIN;
  static const ADMIN_ACTIVITY = _Paths.ADMIN_ACTIVITY;
  static const ADMIN_ACTIVITY_LIST = _Paths.ADMIN_ACTIVITY_LIST;
  static const ADMIN_ACTIVITY_FORM = _Paths.ADMIN_ACTIVITY_FORM;
  static const ADMIN_NEWS = _Paths.ADMIN_NEWS;
  static const ADMIN_NEWS_LIST = _Paths.ADMIN_NEWS_LIST;
  static const ADMIN_NEWS_FORM = _Paths.ADMIN_NEWS_FORM;
}

abstract class _Paths {
  _Paths._();

  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const RESET_PASSWORD = '/reset-password';

  //user
  static const DASHBOARD_USER = '/dashboard-user';

  //admin
  static const DASHBOARD_ADMIN = '/dashboard-admin';
  static const ADMIN_ACTIVITY = '/admin-activity';
  static const ADMIN_ACTIVITY_LIST = '/admin-activity-list';
  static const ADMIN_ACTIVITY_FORM = '/admin-activity-form';
  static const ADMIN_NEWS = '/admin-news';
  static const ADMIN_NEWS_LIST = '/admin-news-list';
  static const ADMIN_NEWS_FORM =  '/admin-news-form';
}
