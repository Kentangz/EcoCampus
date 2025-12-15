import 'package:get/get.dart';

// lib/app/models/project_model.dart

class ProjectModel {
  final String id;
  final String title;
  final String duration;
  final String imageAsset;
  final String? description;
  final String? datasetPath; // path lokal atau URL ke CSV / dataset
  final String? ownerId;
  final String? status; // contoh: 'open', 'closed', 'in-progress'
  final List<String>? members; // list of userIds

  const ProjectModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.imageAsset,
    this.description,
    this.datasetPath,
    this.ownerId,
    this.status,
    this.members,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final membersRaw = json['members'];
    List<String>? members;
    if (membersRaw is List) {
      members = membersRaw.map((e) => e.toString()).toList();
    }

    return ProjectModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      imageAsset: json['imageAsset']?.toString() ?? '',
      description: json['description']?.toString(),
      datasetPath: json['datasetPath']?.toString(),
      ownerId: json['ownerId']?.toString(),
      status: json['status']?.toString(),
      members: members,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'imageAsset': imageAsset,
      'description': description,
      'datasetPath': datasetPath,
      'ownerId': ownerId,
      'status': status,
      'members': members,
    };
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? duration,
    String? imageAsset,
    String? description,
    String? datasetPath,
    String? ownerId,
    String? status,
    List<String>? members,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      imageAsset: imageAsset ?? this.imageAsset,
      description: description ?? this.description,
      datasetPath: datasetPath ?? this.datasetPath,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      members: members ?? this.members,
    );
  }

  @override
  String toString() {
    return 'ProjectModel(id: $id, title: $title, duration: $duration)';
  }
}

class ProjectAnalisisDataController extends GetxController {
  // safer: nullable reactive project
  final project = Rxn<ProjectModel>();

  final isLoading = false.obs;
  final error = RxnString();

  final description = ''.obs;
  final steps = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is ProjectModel) {
      project.value = args;
    } else if (args is Map && args['project'] is ProjectModel) {
      project.value = args['project'] as ProjectModel;
    } else {
      // fallback default
      project.value = const ProjectModel(
        id: 'sales-1',
        title: 'Analisis Data Penjualan',
        duration: '16 Minggu',
        imageAsset: 'assets/images/analisis_data_penjualan.jpg',
        description: 'Analisis dataset penjualan untuk menemukan pola, tren, dan rekomendasi bisnis.',
        datasetPath: 'assets/datasets/sales_data.csv',
      );
    }

    _initContent();
  }

  void _initContent() {
    description.value = project.value?.description ??
        'Proyek Analisis Data Penjualan ini berfokus pada pengolahan dataset penjualan untuk menemukan pola, tren, dan rekomendasi bisnis.';

    steps.assignAll([
      'Memahami struktur dataset (date, product, quantity, price, region)',
      'Membersihkan data (missing, tipe data)',
      'Eksplorasi & visualisasi (trend, seasonality)',
      'Modeling / clustering / forecasting (opsional)',
      'Interpretasi hasil & rekomendasi bisnis',
      'Menyusun laporan dan deliverable',
    ]);
  }

  // contoh aksi: mulai analisis (stub -> bisa diganti dengan parsing CSV)
  Future<void> startWork() async {
    try {
      isLoading.value = true;
      error.value = null;

      // placeholder: nanti isi parsing dataset atau inisiasi job
      await Future.delayed(const Duration(milliseconds: 700));

      Get.snackbar('Mulai', 'Sesi analisis dimulai untuk "${project.value?.title ?? ''}".',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // contoh aksi: download dataset (stub)
  Future<void> downloadDataset() async {
    final path = project.value?.datasetPath;
    if (path == null || path.isEmpty) {
      Get.snackbar('Dataset', 'Dataset tidak tersedia.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // untuk local asset: kalau mau simpan ke storage, implement logic; untuk URL gunakan http
    Get.snackbar('Download', 'Mengunduh dataset dari: $path', snackPosition: SnackPosition.BOTTOM);

    // TODO: implement actual download (http or file system)
  }

  // contoh aksi: join project
  void joinProject() {
    Get.snackbar('Gabung Proyek', 'Permintaan bergabung untuk "${project.value?.title ?? ''}" dikirim.',
        snackPosition: SnackPosition.BOTTOM);
  }
}
