import 'package:flutter/material.dart';
import '../student/course_material.dart';

class TeacherCourseMaterialsScreen extends StatefulWidget {
  const TeacherCourseMaterialsScreen({super.key});

  @override
  _TeacherCourseMaterialsScreenState createState() => _TeacherCourseMaterialsScreenState();
}

class _TeacherCourseMaterialsScreenState extends State<TeacherCourseMaterialsScreen> {
  final List<CourseMaterial> courseMaterials = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  void _uploadMaterial() {
    final String title = _titleController.text;
    final String url = _urlController.text;
    if (title.isNotEmpty && url.isNotEmpty) {
      setState(() {
        courseMaterials.add(CourseMaterial(
          title: title,
          fileUrl: url,
          uploadDate: DateTime.now().toString().split(' ')[0],
        ));
      });
      _titleController.clear();
      _urlController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Course Materials')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Material Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'File URL'),
            ),
          ),
          ElevatedButton(
            onPressed: _uploadMaterial,
            child: Text('Upload'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courseMaterials.length,
              itemBuilder: (context, index) {
                final material = courseMaterials[index];
                return ListTile(
                  title: Text(material.title),
                  subtitle: Text('Uploaded on: ${material.uploadDate}'),
                  trailing: IconButton(
                    icon: Icon(Icons.download),
                    onPressed: () {
                      // Handle download logic
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
