import 'package:chatgpt/teacher/teacher_login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatgpt/teacher/upload_course_materials_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // For formatting date and time

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    TeacherHomeScreen(),
    SignAttendancePage(),
    UploadGradesScreen(),
    ConsultationsScreen(),
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Colored Bar (Replacing Teacher Dashboard Text)
          Container(
            height: 80,
            color: Colors.blue, // You can change this to any color
            child: Center(
              child: Text(
                "SNU University",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor: Colors.blue.shade50,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.check_circle_outline), selectedIcon: Icon(Icons.check_circle), label: 'Attendance'),
          NavigationDestination(icon: Icon(Icons.upload_outlined), selectedIcon: Icon(Icons.upload), label: 'Grades'),
          NavigationDestination(icon: Icon(Icons.schedule_outlined), selectedIcon: Icon(Icons.schedule), label: 'Consultations'),
          NavigationDestination(icon: Icon(Icons.more_horiz), selectedIcon: Icon(Icons.more), label: 'More'),
        ],
      ),
    );
  }
}


// Home Screen
void main() {
  runApp(const MaterialApp(home: TeacherHomeScreen()));
}

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  // Weekly schedule for the teacher
  final Map<String, List<Map<String, String>>> weeklySchedule = {
    'Monday': [
      {'time': '08:00 AM - 09:30 AM', 'subject': 'Mathematics', 'room': 'Room A1'},
      {'time': '10:00 AM - 11:30 AM', 'subject': 'Computer Science', 'room': 'Room B2'},
    ],
    'Tuesday': [
      {'time': '09:00 AM - 10:30 AM', 'subject': 'Physics', 'room': 'Room C3'},
      {'time': '11:00 AM - 12:30 PM', 'subject': 'Chemistry', 'room': 'Room D4'},
    ],
    'Wednesday': [
      {'time': '08:00 AM - 09:30 AM', 'subject': 'Biology', 'room': 'Room A2'},
      {'time': '10:00 AM - 11:30 AM', 'subject': 'English', 'room': 'Room B3'},
    ],
    'Thursday': [
      {'time': '09:00 AM - 10:30 AM', 'subject': 'History', 'room': 'Room C1'},
      {'time': '11:00 AM - 12:30 PM', 'subject': 'Economics', 'room': 'Room D2'},
    ],
    'Friday': [
      {'time': '08:00 AM - 09:30 AM', 'subject': 'Art', 'room': 'Room A4'},
      {'time': '10:00 AM - 11:30 AM', 'subject': 'Music', 'room': 'Room B5'},
    ],
    'Saturday': [],
    'Sunday': [],
  };

  String selectedDay = 'Monday'; // Default selected day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher ID Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Teacher Image
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/teacher.jpg'), // Replace with actual image
                    ),
                    const SizedBox(width: 20),
                    // Teacher Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Name: Prof. Mohamed Cali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('ID: T987654', style: TextStyle(fontSize: 16)),
                        Text('Department: Computer Science', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Class Schedule Section
            const Text(
              'Class Schedule',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Days of the week (Horizontal bar)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: weeklySchedule.keys.map((day) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedDay == day ? Colors.blue : Colors.grey[300],
                        foregroundColor: selectedDay == day ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                      child: Text(day),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // Display class schedule based on selected day
            ClassSchedule(schedule: weeklySchedule[selectedDay]!),
          ],
        ),
      ),
    );
  }
}

// ClassSchedule Widget
class ClassSchedule extends StatelessWidget {
  final List<Map<String, String>> schedule;

  const ClassSchedule({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return schedule.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        var classInfo = schedule[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.schedule, color: Colors.blue),
            title: Text(
              classInfo['subject']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${classInfo['time']} | ${classInfo['room']}'),
          ),
        );
      },
    )
        : const Center(
      child: Text(
        "No Classes",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}






// Sign Attendance Page
class SignAttendancePage extends StatefulWidget {
  const SignAttendancePage({super.key});

  @override
  _SignAttendancePageState createState() => _SignAttendancePageState();
}

class _SignAttendancePageState extends State<SignAttendancePage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> classes = [];
  List<Map<String, dynamic>> students = [];
  String? selectedClassId; // UUID for class id
  Map<int, bool> attendance = {}; // student_id -> is_present (bool)

  @override
  void initState() {
    super.initState();
    fetchTeacherClasses(); // Fetch classes on page load
  }

  // ✅ Fetch only classes assigned to the logged-in teacher (auth.uid())
  Future<void> fetchTeacherClasses() async {
    try {
      final response = await supabase
          .from('classes')
          .select('id, name, teacher_id');

      setState(() {
        classes = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching teacher classes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load your classes.')),
      );
    }
  }

  // ✅ Fetch students for the selected class
  Future<void> fetchStudents(String classId) async {
    try {
      final response = await supabase
          .from('students')
          .select('id, name')
          .eq('class_id', classId); // Only students from this class

      setState(() {
        students = List<Map<String, dynamic>>.from(response);
        // Initialize attendance as all absent (false)
        attendance = {
          for (var student in students) student['id'] as int: false
        };
      });
    } catch (e) {
      print('Error fetching students: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load students.')),
      );
    }
  }

  // ✅ Submit attendance
  Future<void> submitAttendance() async {
    final todayDate = DateTime.now().toIso8601String().split('T').first;

    // Prepare attendance data
    List<Map<String, dynamic>> attendanceData = attendance.entries.map((entry) {
      return {
        'student_id': entry.key,
        'class_id': selectedClassId,
        'date': todayDate,
        'is_present': entry.value,
      };
    }).toList();

    try {
      await supabase.from('attendance').insert(attendanceData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance submitted successfully!')),
      );

      // Reset state after submission
      setState(() {
        selectedClassId = null;
        students = [];
        attendance = {};
      });
    } catch (e) {
      print('Error submitting attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit attendance.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Class selection dropdown
            DropdownButton<String>(
              hint: const Text('Select Class'),
              value: selectedClassId,
              isExpanded: true,
              items: classes.map((classData) {
                return DropdownMenuItem<String>(
                  value: classData['id'].toString(), // 🔑 Fix: ensure String
                  child: Text('${classData['name']}'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedClassId = newValue;
                  students = [];
                  attendance = {};
                });
                fetchStudents(newValue!);
              },
            ),
            const SizedBox(height: 16.0),

            // ✅ List of students and attendance checkboxes
            if (selectedClassId != null)
              Expanded(
                child: students.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  children: students.map((student) {
                    return CheckboxListTile(
                      title: Text(student['name']),
                      value: attendance[student['id']] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          attendance[student['id']] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              )
            else
              const Center(
                child: Text('Please select a class to continue.'),
              ),

            // ✅ Submit button
            if (selectedClassId != null && students.isNotEmpty)
              ElevatedButton(
                onPressed: submitAttendance,
                child: const Text('Submit Attendance'),
              ),
          ],
        ),
      ),
    );
  }
}





// Upload Grades Page
class UploadGradesScreen extends StatefulWidget {
  const UploadGradesScreen({super.key});

  @override
  _UploadGradesScreenState createState() => _UploadGradesScreenState();
}

class _UploadGradesScreenState extends State<UploadGradesScreen> {
  File? selectedFile;
  List<Map<String, String>> studentGrades = [];

  // Function to pick a file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'], // Allow CSV and Excel files
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });

      // Simulating file processing
      processFile(selectedFile!);
    }
  }

  // Function to process the uploaded file (for now, just simulate)
  void processFile(File file) {
    // Simulating reading file and extracting grades
    setState(() {
      studentGrades = [
        {'Student ID': 'S001', 'Name': 'John Doe', 'Grade': 'A'},
        {'Student ID': 'S002', 'Name': 'Jane Smith', 'Grade': 'B+'},
        {'Student ID': 'S003', 'Name': 'Mark Johnson', 'Grade': 'A-'},
      ];
    });
  }

  // Function to upload grades
  void uploadGrades() {
    if (studentGrades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No grades to upload!')),
      );
      return;
    }

    // Simulate uploading process
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades uploaded successfully!')),
    );

    setState(() {
      selectedFile = null;
      studentGrades = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          const Text('Upload Student Grades',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Upload Button
          ElevatedButton.icon(
            onPressed: pickFile,
            icon: const Icon(Icons.file_upload),
            label: const Text('Select File'),
          ),

          if (selectedFile != null) ...[
            const SizedBox(height: 20),
            Text('Selected File: ${selectedFile!.path.split('/').last}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),

            // Show uploaded grades preview
            studentGrades.isNotEmpty
                ? Column(
              children: [
                const Text('Preview:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150, // Fixed height for scrollable preview
                  child: ListView(
                    children: studentGrades.map((grade) {
                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text('${grade['Name']} (${grade['Student ID']})'),
                        subtitle: Text('Grade: ${grade['Grade']}'),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Upload Grades Button
                ElevatedButton.icon(
                  onPressed: uploadGrades,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Upload Grades'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            )
                : const SizedBox(),
          ],
        ],
      ),
    );
  }
}


// Consultations Page

class ConsultationsScreen extends StatefulWidget {
  const ConsultationsScreen({super.key});

  @override
  _ConsultationsScreenState createState() => _ConsultationsScreenState();
}

class _ConsultationsScreenState extends State<ConsultationsScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> consultations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConsultations();
  }

  // Function to fetch consultations from Supabase
  Future<void> fetchConsultations() async {
    final response = await supabase.from('consultations').select('*');
    setState(() {
      consultations = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  // Function to update the consultation status in Supabase
  Future<void> updateStatus(String id, String newStatus) async {
    await supabase
        .from('consultations')
        .update({'status': newStatus})
        .eq('id', id);

    // Refresh the consultations list
    fetchConsultations();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Consultation status updated to $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removed to hide the consultation overview banner
      // appBar: AppBar(
      //   title: const Text('Consultations Overview'),
      //   backgroundColor: Colors.deepPurple,
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : consultations.isNotEmpty
          ? ListView.builder(
        itemCount: consultations.length,
        itemBuilder: (context, index) {
          var consultation = consultations[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading:
              const Icon(Icons.person, color: Colors.blue),
              title:
              Text('Student: ${consultation['student_name']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${consultation['date']}'),
                  Text('Time: ${consultation['time']}'),
                  Text(
                    'Status: ${consultation['status']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: consultation['status'] == 'Approved'
                          ? Colors.green
                          : consultation['status'] == 'Pending'
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) =>
                    updateStatus(consultation['id'], value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                      value: 'Approved', child: Text('Approve')),
                  const PopupMenuItem(
                      value: 'Completed',
                      child: Text('Mark as Completed')),
                  const PopupMenuItem(
                      value: 'Canceled', child: Text('Cancel')),
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          'No consultations booked.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}


//more page

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TeacherLogin()),
          (route) => false,
    );
  }

  void _showAddAnnouncementDialog(BuildContext context) {
    final TextEditingController _headerController = TextEditingController();
    final TextEditingController _bodyController = TextEditingController();
    String selectedClass = 'Class A'; // Default selected class

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // Need this to update dropdown value
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Announcement'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Header:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _headerController,
                  decoration: const InputDecoration(
                    hintText: 'Enter announcement title...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Class:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedClass,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: ['Class A', 'Class B', 'Class C']
                      .map((cls) => DropdownMenuItem(
                    value: cls,
                    child: Text(cls),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedClass = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Body:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _bodyController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Type your announcement here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel button
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final header = _headerController.text.trim();
                final body = _bodyController.text.trim();

                if (header.isEmpty || body.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields.')),
                  );
                  return;
                }

                // Here you can handle saving the announcement (API call, database, etc.)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Announcement added:\nHeader: $header\nClass: $selectedClass\nBody: $body',
                    ),
                  ),
                );

                Navigator.pop(context); // Close dialog
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildOption(
          context,
          Icons.upload_file,
          Colors.purple,
          'Upload Course Materials',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadCourseMaterialsScreen()),
            );
          },
        ),
        const Divider(),
        _buildOption(
          context,
          Icons.announcement,
          Colors.orange,
          'Add Announcement',
              () => _showAddAnnouncementDialog(context),
        ),
        const Divider(),
        _buildOption(
          context,
          Icons.logout,
          Colors.red,
          'Logout',
              () => _logout(context),
        ),
      ],
    );
  }

  Widget _buildOption(
      BuildContext context, IconData icon, Color color, String text, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
