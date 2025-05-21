import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadCourseMaterialsScreen extends StatefulWidget {
  const UploadCourseMaterialsScreen({super.key});

  @override
  _UploadCourseMaterialsScreenState createState() => _UploadCourseMaterialsScreenState();
}

class _UploadCourseMaterialsScreenState extends State<UploadCourseMaterialsScreen> {
  PlatformFile? pickedFile;
  bool isUploading = false;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> uploadFile() async {
    if (pickedFile == null) return;

    setState(() {
      isUploading = true;
    });

    // Simulate file upload delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File uploaded successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Course Materials')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: selectFile,
              icon: Icon(Icons.attach_file),
              label: Text('Select File'),
            ),
            SizedBox(height: 20),
            if (pickedFile != null)
              Text(
                'Selected File: ${pickedFile!.name}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isUploading ? null : uploadFile,
              icon: isUploading ? CircularProgressIndicator(color: Colors.white) : Icon(Icons.upload),
              label: Text('Upload File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
