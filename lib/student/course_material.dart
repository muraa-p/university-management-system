// model/course_material.dart
class CourseMaterial {
  final String title;
  final String fileUrl;
  final String uploadDate;
  final List<String> reactions;

  CourseMaterial({
    required this.title,
    required this.fileUrl,
    required this.uploadDate,
    this.reactions = const [],
  });
}


