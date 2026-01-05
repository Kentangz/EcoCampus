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
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/material_builder_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/course_list_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/course_form_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/bindings/course/module_detail_binding.dart';
import 'package:ecocampus/app/modules/dashboard_user/views/dashboard_user_view.dart';
import 'package:ecocampus/app/modules/dashboard_user/bindings/dashboard_user_binding.dart';
import 'package:ecocampus/app/modules/dashboard_admin/views/news/news_admin_view.dart';

import '../modules/dashboard_user/kelas data analysis/bindings/data_analysis_binding.dart';
import '../modules/dashboard_user/kelas data analysis/bindings/detail_modul_data_analysis_binding.dart';
import '../modules/dashboard_user/kelas data analysis/bindings/modul_data_analysis_binding.dart';
import '../modules/dashboard_user/kelas data analysis/bindings/soal_data_analysis_binding.dart';
import '../modules/dashboard_user/kelas data analysis/views/data_analysis_view.dart';
import '../modules/dashboard_user/kelas data analysis/views/detail_modul_data_analysis_view.dart';
import '../modules/dashboard_user/kelas data analysis/views/modul_data_analysis_view.dart';
import '../modules/dashboard_user/kelas data analysis/views/soal_data_analysis_view.dart';
import '../modules/dashboard_user/kelas python/bindings/detail_modul_python_binding.dart';
import '../modules/dashboard_user/kelas python/bindings/modul_python_binding.dart';
import '../modules/dashboard_user/kelas python/bindings/python_binding.dart';
import '../modules/dashboard_user/kelas python/bindings/soal_python_binding.dart';
import '../modules/dashboard_user/kelas python/views/detail_modul_python_view.dart';
import '../modules/dashboard_user/kelas python/views/modul_python_view.dart';
import '../modules/dashboard_user/kelas python/views/python_views.dart';
import '../modules/dashboard_user/kelas python/views/soal_python_view.dart';
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
      name: _Paths.NONTON_FILM,
      page: () => const NontonFilmView(),
      binding: NontonFilmBinding(),
    ),
    GetPage(
      name: _Paths.MAGANG,
      page: () => const MagangView(),
      binding: MagangBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MAGANG,
      page: () => const DetailMagangView(),
      binding: DetailMagangBinding(),
    ),
    GetPage(
      name: _Paths.DATA_ANALYSIS,
      page: () => const DataAnalysisClassView(),
      binding: DataAnalysisClassBinding(),
    ),
    GetPage(
      name: _Paths.DATA_ANALYSIS_MODULE,
      page: () => const DataAnalysisModuleView(),
      binding: DataAnalysisModuleBinding(),
    ),
    GetPage(
      name: _Paths.DATA_ANALYSIS_DETAIL_MODULE,
      page: () => const DataAnalysisDetailModuleView(),
      binding: DataAnalysisDetailModuleBinding(),
    ),
    GetPage(
      name: _Paths.DATA_ANALYSIS_QUIZ,
      page: () => const DataAnalysisQuizView(),
      binding: DataAnalysisQuizBinding(),
    ),
    GetPage(
      name: _Paths.PYTHON,
      page: () => const PythonClassView(),
      binding: PythonClassBinding(),
    ),
    GetPage(
      name: _Paths.PYTHON_MODULE,
      page: () => const PythonModuleView(),
      binding: PythonModuleBinding(),
    ),
    GetPage(
      name: _Paths.PYTHON_DETAIL_MODULE,
      page: () => const PythonDetailModuleView(),
      binding: PythonDetailModuleBinding(),
    ),
    GetPage(
      name: _Paths.PYTHON_QUIZ,
      page: () => const PythonQuizView(),
      binding: PythonQuizBinding(),
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
  ];
}
