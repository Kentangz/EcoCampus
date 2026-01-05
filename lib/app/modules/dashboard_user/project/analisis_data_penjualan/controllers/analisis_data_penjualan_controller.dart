import 'package:get/get.dart';

class ProjectModel {
  final String id;
  final String title;
  final String imageAsset;
  final String? description;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.imageAsset,
    this.description,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageAsset: json['imageAsset']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageAsset': imageAsset,
        'description': description,
      };
}

class ProjectAnalisisDataController extends GetxController {
  final project = Rxn<ProjectModel>();
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is ProjectModel) {
      project.value = args;
    } else if (args is Map && args['project'] is ProjectModel) {
      project.value = args['project'] as ProjectModel;
    } else {
      project.value = const ProjectModel(
        id: 'sales-1',
        title: 'Analisis Data Penjualan',
        imageAsset: 'assets/images/analisis_data_penjualan.jpg',
        description:
            'Proyek ini berfokus pada analisis data penjualan untuk menemukan pola, tren, dan insight bisnis.',
      );
    }
  }
}
