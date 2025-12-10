// ignore_for_file: constant_identifier_names

import 'package:ecocampus/app/modules/auth/bindings/auth_binding.dart';
import 'package:ecocampus/app/modules/auth/bindings/reset_password_binding.dart';
import 'package:ecocampus/app/modules/auth/views/forgot_password_view.dart';
import 'package:ecocampus/app/modules/auth/views/reset_password_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_list_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/course_form_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/course_list_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/module_detail_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/material_builder_view.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/auth/views/login_view.dart';
import 'package:ecocampus/app/modules/auth/views/register_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/dashboard_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/dashboard_admin_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/material_builder_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/course_list_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/course_form_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/module_detail_binding.dart';
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
      name: _Paths.ADMIN_COURSE_LIST,
      page: () => const CourseListView(),
      binding: CourseListBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_COURSE_FORM,
      page: () => const CourseFormView(),
      binding: CourseFormBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_MODULE_DETAIL,
      page: () => const ModuleDetailView(),
      binding: ModuleDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_MATERIAL_BUILDER,
      page: () => const MaterialBuilderView(),
      binding: MaterialBuilderBinding(),
    ),
  ];
}
