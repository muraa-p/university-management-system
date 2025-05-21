import 'package:flutter/material.dart';
import 'course_material.dart';

class StudentCourseMaterialsScreen extends StatefulWidget {
  const StudentCourseMaterialsScreen({super.key});

  @override
  _StudentCourseMaterialsScreenState createState() => _StudentCourseMaterialsScreenState();
}

class _StudentCourseMaterialsScreenState extends State<StudentCourseMaterialsScreen> {
  final List<CourseMaterial> courseMaterials = [
    CourseMaterial(title: 'Lecture 1 Notes', fileUrl: 'https://example.com/lecture1.pdf', uploadDate: '2024-02-01'),
    CourseMaterial(title: 'Assignment 1', fileUrl: 'https://example.com/assignment1.pdf', uploadDate: '2024-02-02'),
  ];

  final List<String> emojis = ['👍', '❤️', '😂'];

  void _addReaction(int index, String emoji) {
    setState(() {
      courseMaterials[index].reactions.add(emoji);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Materials')),
      body: ListView.builder(
        itemCount: courseMaterials.length,
        itemBuilder: (context, index) {
          final material = courseMaterials[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(material.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Uploaded on: ${material.uploadDate}'),
                  Wrap(
                    children: emojis.map((emoji) {
                      return IconButton(
                        onPressed: () => _addReaction(index, emoji),
                        icon: Text(emoji),
                      );
                    }).toList(),
                  ),
                  Wrap(
                    children: material.reactions.map((reaction) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(reaction),
                      );
                    }).toList(),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.download),
                onPressed: () {
                  // Handle download logic
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
