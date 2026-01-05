import 'package:get/get.dart';
import 'package:ecocampus/app/data/models/project/project_model.dart';

class ProjectDetailController extends GetxController {
  late final ProjectModel project;

  @override
  void onInit() {
    super.onInit();
    project = Get.arguments as ProjectModel;
  }
}
