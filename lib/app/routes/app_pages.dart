// ignore_for_file: constant_identifier_names
import 'package:ecocampus/app/modules/auth/bindings/auth_binding.dart';
import 'package:ecocampus/app/modules/auth/bindings/reset_password_binding.dart';
import 'package:ecocampus/app/modules/auth/views/forgot_password_view.dart';
import 'package:ecocampus/app/modules/auth/views/reset_password_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_list_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/akustik/bindings/akustik_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/akustik/views/akustik_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/kaligrafi/bindings/kaligrafi_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/kaligrafi/views/kaligrafi_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/nonton%20film/bindings/nonton_film_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/nonton%20film/views/nonton_film_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/analisis_data_penjualan/bindings/analis_data_penjualan_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/analisis_data_penjualan/views/analisis_data_penjualan_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/bindings/project_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/views/project_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/pembuatanaplikasi/bindings/aplikasi_bindings.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/pembuatanaplikasi/views/aplikasi_views.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/project_ui_ux/bindings/project_ui_ux_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/project_ui_ux/view/project_ui_ux_view.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/auth/views/login_view.dart';
import 'package:ecocampus/app/modules/auth/views/register_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/dashboard_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/dashboard_admin_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/views/dashboard_user_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/bindings/dashboard_user_binding.dart';

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
      page: () => const ProjectView(),
      binding: KolaborasiKampusBinding(),
    ),
    GetPage(
      name: _Paths.PROJECT_ANALISIS,
      page: () => const AnalisisView(),
      binding: ProjectAnalisisDataBinding(),
    ),
    GetPage(
      name: _Paths.PROJECT_UIUX,
      page: () => const ProjectUiUxView(),
      binding: ProjectUiUxBinding(),
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
  ];
}
