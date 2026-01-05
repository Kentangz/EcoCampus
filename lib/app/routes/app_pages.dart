// ignore_for_file: constant_identifier_names
import 'package:ecocampus/app/modules/auth/bindings/auth_binding.dart';
import 'package:ecocampus/app/modules/auth/bindings/reset_password_binding.dart';
import 'package:ecocampus/app/modules/auth/views/forgot_password_view.dart';
import 'package:ecocampus/app/modules/auth/views/reset_password_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/question_form_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/activity/activity_list_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/course_form_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/course_list_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/module_detail_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/material_builder_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/question_form_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/course/quiz_list_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/news/news_form_admin.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/news/news_list_admin.dart';
import 'package:ecocampus/app/modules/dashboard_user/akustik/bindings/akustik_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/akustik/views/akustik_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/kaligrafi/bindings/kaligrafi_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/kaligrafi/views/kaligrafi_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/nonton%20film/bindings/nonton_film_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/nonton%20film/views/nonton_film_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/bindings/project_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/project/views/project_view.dart';
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
import 'package:ecocampus/app/modules/dashboard_admin/views/news/news_admin_view.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/project/project_form_admin.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/project/project_list_admin.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/project/project_admin_view.dart';
import 'package:ecocampus/app/modules/project_detail/bindings/project_detail_bindings.dart';
import 'package:ecocampus/app/modules/project_detail/views/project_detail_views.dart';

import '../modules/dashboard_user/magang/bindings/detail_magang_binding.dart';
import '../modules/dashboard_user/magang/bindings/magang_binding.dart';
import '../modules/dashboard_user/magang/views/detail_magang_view.dart';
import '../modules/dashboard_user/magang/views/magang_view.dart';

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
      name: _Paths.MAGANG,
      page: () => const MagangView(),
      binding: MagangBinding(),
    ),
    GetPage(
      name: _Paths.DETAILMAGANG,
      page: () => const DetailMagangView(),
      binding: DetailMagangBinding(),
    ),

    GetPage(
      name: _Paths.KOLABORASI_KAMPUS,
      page: () => const ProjectView(),
      binding: KolaborasiKampusBinding(),
    ),
    GetPage(
      name: Routes.PROJECT_DETAIL,
      page: () => const ProjectDetailView(),
      binding: ProjectDetailBinding(),
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
    GetPage(
      name: _Paths.ADMIN_QUIZ_LIST,
      page: () => const QuizListView(),
      binding: QuestionFormBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_QUESTION_FORM,
      page: () => const QuestionFormView(),
      binding: QuestionFormBinding(),
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
    GetPage(
      name: _Paths.ADMIN_PROJECT,
      page: () => const ProjectAdminView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PROJECT_LIST,
      page: () => const ProjectListAdminView(),
      binding: DashboardAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PROJECT_FORM,
      page: () => ProjectFormAdmin(),
      binding: DashboardAdminBinding(),
    ),
  ];
}
