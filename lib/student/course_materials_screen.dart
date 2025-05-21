import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'course_material.dart';

class CourseMaterialsScreen extends StatefulWidget {
  const CourseMaterialsScreen({super.key});

  @override
  _CourseMaterialsScreenState createState() => _CourseMaterialsScreenState();
}

class _CourseMaterialsScreenState extends State<CourseMaterialsScreen> {
  // Dummy data using the CourseMaterial model
  List<CourseMaterial> materials = [
    CourseMaterial(
      title: 'Lecture 1 - Introduction',
      fileUrl: 'https://example.com/lecture1.pdf',
      uploadDate: '2024-02-01',
      reactions: ['👍', '❤️', '😂'],
    ),
    CourseMaterial(
      title: 'Lecture 2 - Advanced Topics',
      fileUrl: 'https://example.com/lecture2.pdf',
      uploadDate: '2024-02-05',
      reactions: ['👍', '❤️'],
    ),
  ];

  // Method to handle emoji reaction
  void _handleReaction(int index, String emoji) {
    setState(() {
      materials[index].reactions.add(emoji);
    });
  }

  // Method to launch URL for download
  Future<void> _downloadFile(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Materials')),
      body: ListView.builder(
        itemCount: materials.length,
        itemBuilder: (context, index) {
          var material = materials[index];
          var reactionCount = _countReactions(material.reactions);

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Uploaded on: ${material.uploadDate}'),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _downloadFile(material.fileUrl),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      _emojiButton(index, '👍', reactionCount['👍'] ?? 0),
                      _emojiButton(index, '❤️', reactionCount['❤️'] ?? 0),
                      _emojiButton(index, '😂', reactionCount['😂'] ?? 0),
                      _emojiButton(index, '😮', reactionCount['😮'] ?? 0),
                      _emojiButton(index, '😢', reactionCount['😢'] ?? 0),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget for the emoji buttons
  Widget _emojiButton(int index, String emoji, int count) {
    return TextButton(
      onPressed: () => _handleReaction(index, emoji),
      child: Text('$emoji $count'),
    );
  }

  // Method to count reactions
  Map<String, int> _countReactions(List<String> reactions) {
    Map<String, int> reactionCount = {};
    for (var emoji in reactions) {
      reactionCount[emoji] = (reactionCount[emoji] ?? 0) + 1;
    }
    return reactionCount;
  }
}
