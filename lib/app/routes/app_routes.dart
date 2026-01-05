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
  static const NONTON_FILM = _Paths.NONTON_FILM;
  static const MAGANG = _Paths.MAGANG;
  static const DETAIL_MAGANG = _Paths.DETAIL_MAGANG;
  static const DATA_ANALYSIS = _Paths.DATA_ANALYSIS;
  static const DATA_ANALYSIS_QUIZ = _Paths.DATA_ANALYSIS_QUIZ;
  static const DATA_ANALYSIS_MODULE = _Paths.DATA_ANALYSIS_MODULE;
  static const DATA_ANALYSIS_DETAIL_MODULE = _Paths.DATA_ANALYSIS_DETAIL_MODULE;
  static const PYTHON = _Paths.PYTHON;
  static const PYTHON_MODULE = _Paths.PYTHON_MODULE;
  static const PYTHON_DETAIL_MODULE = _Paths.PYTHON_DETAIL_MODULE;
  static const PYTHON_QUIZ = _Paths.PYTHON_QUIZ;
  static const KOLABORASI_KAMPUS = _Paths.KOLABORASI_KAMPUS;
  static const PROJECT_DETAIL = _Paths.PROJECT_DETAIL;

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
  static const ADMIN_PROJECT = _Paths.ADMIN_PROJECT;
  static const ADMIN_PROJECT_LIST = _Paths.ADMIN_PROJECT_LIST;
  static const ADMIN_PROJECT_FORM = _Paths.ADMIN_PROJECT_FORM;
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
  static const NONTON_FILM = '/nontonfilm';
  static const MAGANG = '/infomagang';
  static const DETAIL_MAGANG = '/infodetailmagang';
  static const DATA_ANALYSIS = '/dataanalysis';
  static const DATA_ANALYSIS_MODULE = '/moduldataanalysis';
  static const DATA_ANALYSIS_DETAIL_MODULE = '/detailmoduldataanalysis';
  static const DATA_ANALYSIS_QUIZ = '/latihansoaldataanalysis';
  static const PYTHON = '/python';
  static const PYTHON_MODULE = '/modulpython';
  static const PYTHON_DETAIL_MODULE = '/detailmodulpython';
  static const PYTHON_QUIZ = '/latihansoalpython';
  static const KOLABORASI_KAMPUS = '/kolaborasi-kampus';
  static const PROJECT_DETAIL = '/project-detail';

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
  static const ADMIN_NEWS_FORM = '/admin-news-form';
  static const ADMIN_PROJECT = '/admin-project';
  static const ADMIN_PROJECT_LIST = '/admin-project-list';
  static const ADMIN_PROJECT_FORM = '/admin-project-form';
}
