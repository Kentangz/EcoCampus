// ignore_for_file: constant_identifier_names

import 'package:ecocampus/app/modules/auth/bindings/auth_binding.dart';
import 'package:ecocampus/app/modules/auth/bindings/reset_password_binding.dart';
import 'package:ecocampus/app/modules/auth/views/forgot_password_view.dart';
import 'package:ecocampus/app/modules/auth/views/reset_password_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_list_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/news/news_form_admin.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/news/news_list_admin.dart';
import 'package:ecocampus/app/modules/dashboard_user/akustik/bindings/akustik_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/akustik/views/akustik_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/kaligrafi/bindings/kaligrafi_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/kaligrafi/views/kaligrafi_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/nonton%20film/bindings/nonton_film_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/nonton%20film/views/nonton_film_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/page_kolaborasi_kampus/bindings/kolaborasi_kampus_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/page_kolaborasi_kampus/views/kolaborasi_kampus_view.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/auth/views/login_view.dart';
import 'package:ecocampus/app/modules/auth/views/register_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/dashboard_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/dashboard_admin_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/views/dashboard_user_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/bindings/dashboard_user_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/news/news_admin_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  //auth
  static const INITIAL = Routes.LOGIN;

  static final routes = <GetPage>[
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),

    //user
    GetPage(
      name: _Paths.DASHBOARD_USER,
      page: () => const DashboardUserView(),
      binding: DashboardUserBinding(),
    ),
    GetPage(
      name: _Paths.KALIGRAFI,
      page: () => const KaligrafiView(),
      binding: KaligrafiBinding(),
    ),
    GetPage(
      name: _Paths.AKUSTIK,
      page: () => const AkustikView(),
      binding: AkustikBinding(),
    ),
    GetPage(
      name: _Paths.NONTONFILM,
      page: () => const NontonFilmView(),
      binding: NontonFilmBinding(),
    ),
    GetPage(
      name: _Paths.KOLABORASI_KAMPUS,
      page: () => const KolaborasiKampusView(),
      binding: KolaborasiKampusBinding(),
    ),

    //admin
    GetPage(
      name: _Paths.DASHBOARD_ADMIN,
      page: () => const DashboardAdminView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_ACTIVITY,
      page: () => const ActivityAdminView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_ACTIVITY_LIST,
      page: () => const ActivityListView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_NEWS,
      page: () => const NewsAdminView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_NEWS_LIST,
      page: () => const NewsListAdminView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_NEWS_FORM,
      page: () => NewsFormAdmin(),
      binding: DashboardAdminBinding(),
    ),
  ];
}
