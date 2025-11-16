// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:ecocampus/app/modules/login/views/login_view.dart';
import 'package:ecocampus/app/modules/login/bindings/login_binding.dart';
import 'package:ecocampus/app/modules/register/views/register_view.dart';
import 'package:ecocampus/app/modules/register/bindings/register_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/dashboard_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/dashboard_admin_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/views/dashboard_user_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/bindings/dashboard_user_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = <GetPage>[
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: _Paths.DASHBOARD_ADMIN,
      page: () => const DashboardAdminView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_USER,
      page: () => const DashboardUserView(),
      binding: DashboardUserBinding(),
    ),
  ];
}
