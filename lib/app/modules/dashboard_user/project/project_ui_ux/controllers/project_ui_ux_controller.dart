import 'package:get/get.dart';

class ProjectUiUxController extends GetxController {
  late final ProjectModel project;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    // Jika argumen langsung berupa ProjectModel
    if (args is ProjectModel) {
      project = args;
      return;
    }

    // Jika argumen berupa Map dengan key 'project'
    if (args is Map && args['project'] is ProjectModel) {
      project = args['project'] as ProjectModel;
      return;
    }

    // Jika argumen berupa Map dengan data primitive (title/duration/imageAsset)
    if (args is Map &&
        (args['title'] != null || args['duration'] != null || args['imageAsset'] != null)) {
      project = ProjectModel(
        title: args['title']?.toString() ?? 'Design UI/UX',
        duration: args['duration']?.toString() ?? '8 Minggu',
        imageAsset: args['imageAsset']?.toString() ?? 'assets/images/ui_ux.jpg',
        description: args['description']?.toString(),
      );
      return;
    }

    // fallback default jika tidak ada argumen
    project = const ProjectModel(
      title: 'Design UI/UX',
      duration: '8 Minggu',
      imageAsset: 'assets/images/ui_ux.jpg',
      description:
      'Proyek "Design UI/UX" bertujuan merancang antarmuka pengguna yang intuitif dan estetik untuk aplikasi EcoCampus.',
    );
  }
}

class ProjectModel {
  final String title;
  final String duration;
  final String imageAsset;
  final String? description;

  const ProjectModel({
    required this.title,
    required this.duration,
    required this.imageAsset,
    this.description,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      imageAsset: json['imageAsset'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'imageAsset': imageAsset,
      'description': description,
    };
  }
}
