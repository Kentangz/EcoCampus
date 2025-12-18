// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  //auth
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
  static const EMAIL_VERIFICATION = _Paths.EMAIL_VERIFICATION;

  //user
  static const DASHBOARD_USER = _Paths.DASHBOARD_USER;
  static const KALIGRAFI = _Paths.KALIGRAFI;
  static const AKUSTIK = _Paths.AKUSTIK;
  static const NONTONFILM = _Paths.NONTONFILM;
  static const KOLABORASI_KAMPUS = _Paths.KOLABORASI_KAMPUS;
  static const PROJECT_ANALISIS = _Paths.PROJECT_ANALISIS;
  static const PROJECT_UIUX = _Paths.PROJECT_UIUX;

  //admin
  static const DASHBOARD_ADMIN = _Paths.DASHBOARD_ADMIN;
  static const ADMIN_ACTIVITY = _Paths.ADMIN_ACTIVITY;
  static const ADMIN_ACTIVITY_LIST = _Paths.ADMIN_ACTIVITY_LIST;
  static const ADMIN_ACTIVITY_FORM = _Paths.ADMIN_ACTIVITY_FORM;
  static const ADMIN_COURSE_LIST = _Paths.ADMIN_COURSE_LIST;
  static const ADMIN_COURSE_FORM = _Paths.ADMIN_COURSE_FORM;
  static const ADMIN_MODULE_DETAIL = _Paths.ADMIN_MODULE_DETAIL;
  static const ADMIN_MATERIAL_BUILDER = _Paths.ADMIN_MATERIAL_BUILDER;
  static const ADMIN_QUIZ_LIST = _Paths.ADMIN_QUIZ_LIST;
  static const ADMIN_QUESTION_FORM = _Paths.ADMIN_QUESTION_FORM;
  static const ADMIN_NEWS = _Paths.ADMIN_NEWS;
  static const ADMIN_NEWS_LIST = _Paths.ADMIN_NEWS_LIST;
  static const ADMIN_NEWS_FORM = _Paths.ADMIN_NEWS_FORM;
}

abstract class _Paths {
  _Paths._();

  //auth
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const RESET_PASSWORD = '/reset-password';
  static const EMAIL_VERIFICATION = '/email-verification';

  //user
  static const DASHBOARD_USER = '/dashboard-user';
  static const KALIGRAFI = '/kaligrafi';
  static const AKUSTIK = '/akustik';
  static const NONTONFILM = '/nontonfilm';
  static const KOLABORASI_KAMPUS = '/kolaborasi-kampus';
  static const PROJECT_ANALISIS = '/project-analisis';
  static const PROJECT_UIUX = '/project-ui-ux';

  //admin
  static const DASHBOARD_ADMIN = '/dashboard-admin';
  static const ADMIN_ACTIVITY = '/admin-activity';
  static const ADMIN_ACTIVITY_LIST = '/admin-activity-list';
  static const ADMIN_ACTIVITY_FORM = '/admin-activity-form';
  static const ADMIN_COURSE_LIST = '/admin-course-list';
  static const ADMIN_COURSE_FORM = '/admin-course-form';
  static const ADMIN_MODULE_DETAIL = '/admin-module-detail';
  static const ADMIN_MATERIAL_BUILDER = '/admin-material-builder';
  static const ADMIN_QUIZ_LIST = '/admin-quiz-list';
  static const ADMIN_QUESTION_FORM = '/admin-question-form';
  static const ADMIN_NEWS = '/admin-news';
  static const ADMIN_NEWS_LIST = '/admin-news-list';
  static const ADMIN_NEWS_FORM =  '/admin-news-form';
}
