
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
      title: json['title']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      imageAsset: json['imageAsset']?.toString() ?? '',
      description: json['description']?.toString(),
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

  ProjectModel copyWith({
    String? title,
    String? duration,
    String? imageAsset,
    String? description,
  }) {
    return ProjectModel(
      title: title ?? this.title,
      duration: duration ?? this.duration,
      imageAsset: imageAsset ?? this.imageAsset,
      description: description ?? this.description,
    );
  }

  @override
  String toString() =>
      'ProjectModel(title: $title, duration: $duration, imageAsset: $imageAsset)';
}
