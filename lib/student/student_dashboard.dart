import 'package:flutter/material.dart';
import 'package:chatgpt/student/course_materials_screen.dart';
import 'package:chatgpt/student/fee_payment.dart'; // Import FeePayment Page
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // For formatting date and time





class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  // Updated pages list with Grades as a main page
  static final List<Widget> _pages = <Widget>[
    StudentHomeScreen(),
    AnnouncementsScreen(),
    GradesScreen(),       // Grades added as main page
    StudentMoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Student Dashboard')),
      appBar: AppBar(
        title: const Text(
          ' SNUniversity ', // Modernized App Name
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true, // Centers the app name
        backgroundColor: Colors.deepPurple, // Change color for a modern look
        automaticallyImplyLeading: false, // Removes the back arrow
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black38), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement, color: Colors.black38), label: 'Announcements'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grade, color: Colors.black38), label: 'Grades'), // Grades Tab
          BottomNavigationBarItem(
              icon: Icon(Icons.more_vert, color: Colors.black38), label: 'More'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Home Screen for Students with Schedule and Student Card
void main() {
  runApp(const MaterialApp(home: StudentHomeScreen()));
}

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  // Define the weekly schedule
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
      //appBar: AppBar(title: const Text("Student Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Student Image
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/student.jpg'), // Replace with actual image
                    ),
                    const SizedBox(width: 20),
                    // Student Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Name: Yasir Mohamed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('ID: 123456', style: TextStyle(fontSize: 16)),
                        Text('Course: Computer Science', style: TextStyle(fontSize: 16)),
                        Text('Batch No.: CS2024', style: TextStyle(fontSize: 16)),
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



// Announcements Page
class AnnouncementsScreen extends StatelessWidget {
   AnnouncementsScreen({super.key});

  // List of announcements
  final List<Map<String, String>> announcements = [
    {
      'title': 'New Project Guidelines',
      'details': 'Final year project guidelines have been updated. Check the portal for more details.',
      'date': '2024-02-20'
    },
    {
      'title': 'Student Council Elections',
      'details': 'Nominations for the student council elections are now open.',
      'date': '2024-02-22'
    },
    {
      'title': 'New Faculty Member',
      'details': 'We are pleased to welcome Dr. Emily Wong to the Computer Science Department.',
      'date': '2024-02-25'
    },
    {
      'title': 'Classroom Change',
      'details': 'CS101 classes have been moved to Room 402, Block B.',
      'date': '2024-02-26'
    },
    {
      'title': 'Class Canceled',
      'details': 'Tomorrow’s Physics lecture is canceled. Stay tuned for the rescheduled date.',
      'date': '2024-02-27'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed AppBar to eliminate the blue bar
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          var announcement = announcements[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.campaign, color: Colors.orange),
              title: Text(
                announcement['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(announcement['details']!),
              trailing: Text(
                announcement['date']!,
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Optional: Add a detailed view or action
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(announcement['title']!),
                    content: Text(announcement['details']!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


// Grades Page (Updated with fl_chart)
class GradesScreen extends StatelessWidget {
  GradesScreen({super.key});

  // Mock Data for demonstration
  final List<Map<String, dynamic>> semesters = [
    {
      'semester': 'Semester 1',
      'subjects': {
        'Mathematics': 77,
        'Computer Science': 88,
        'Physics': 20,
        'English': 78,
      }
    },
    {
      'semester': 'Semester 2',
      'subjects': {
        'Mathematics': 24,
        'Computer Science': 100,
        'Physics': 90,
        'English': 98,
      }
    },
    {
      'semester': 'Semester 3',
      'subjects': {
        'Mathematics': 87,
        'Computer Science': 77,
        'Physics': 66,
        'English': 55,
      }
    },
  ];

  /// Calculate the **average grade** for a semester
  double calculateSemesterAverage(Map<String, int> subjects) {
    int total = subjects.values.reduce((a, b) => a + b);
    return total / subjects.length;
  }

  /// Calculate the **overall total average** across all semesters
  double calculateTotalAverage() {
    double total = 0;
    for (var semester in semesters) {
      total += calculateSemesterAverage(Map<String, int>.from(semester['subjects']));
    }
    return total / semesters.length;
  }

  /// **Build a bar chart** to visualize semester-wise grade distribution
  Widget buildBarChart() {
    List<BarChartGroupData> barGroups = List.generate(semesters.length, (index) {
      double avg = calculateSemesterAverage(Map<String, int>.from(semesters[index]['subjects']));
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: avg,
            color: Colors.orange,
            width: 20,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    });

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index >= 0 && index < semesters.length) {
                    return Text('Sem ${index + 1}');
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: true),
          barGroups: barGroups,
        ),
      ),
    );
  }

  /// **Build subject breakdown** for each semester
  Widget buildSubjectBreakdown() {
    return Column(
      children: semesters.map((semester) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  semester['semester'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: (semester['subjects'] as Map<String, int>).entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      trailing: Text(
                        "${entry.value}/100",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// **Grade overview section** (Total Average & Overall Average)
  Widget buildGradeOverview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Semester Average
        Card(
          elevation: 4,
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 150,
            child: Column(
              children: [
                const Text(
                  'Total Average (%)',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  calculateTotalAverage().toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Overall Average
        Card(
          elevation: 4,
          color: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 150,
            child: Column(
              children: [
                const Text(
                  'Overall Average (%)',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  calculateTotalAverage().toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades Overview'),
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildGradeOverview(), // Modernized Grade Overview
            const SizedBox(height: 20),
            const Text(
              'Subject Breakdown',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildSubjectBreakdown(),
            const SizedBox(height: 30),
            const Text(
              'Grade Distribution',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildBarChart(),
          ],
        ),
      ),
    );
  }
}









//more screen for the student
class StudentMoreScreen extends StatelessWidget {
  const StudentMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_today, color: Colors.blue),
          title: const Text('Attendance Records'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AttendanceRecordsScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.payment, color: Colors.green),
          title: const Text('Pay Fees'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeePayment()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.library_books, color: Colors.purple),
          title: const Text('Course Materials'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CourseMaterialsScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat, color: Colors.orange),
          title: const Text('Consultation'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConsultationScreen()),
            );
          },
        ),

        const Divider(), // Optional divider for better UI
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout'),
          onTap: () {
            // Simply navigate back like the top left arrow
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

// Attendance Records Page
class AttendanceRecordsScreen extends StatefulWidget {
  const AttendanceRecordsScreen({super.key});

  @override
  _AttendanceRecordsScreenState createState() =>
      _AttendanceRecordsScreenState();
}

class _AttendanceRecordsScreenState extends State<AttendanceRecordsScreen> {
  // Attendance records: Signed = Present, Not Signed = Absent
  final List<Map<String, String>> attendanceRecords = [
    {'subject': 'Mathematics', 'date': '2024-02-01', 'status': 'Signed'},
    {'subject': 'Computer Science', 'date': '2024-02-02', 'status': 'Not Signed'},
    {'subject': 'Physics', 'date': '2024-02-03', 'status': 'Signed'},
    {'subject': 'Chemistry', 'date': '2024-02-04', 'status': 'Not Signed'},
    {'subject': 'Mathematics', 'date': '2024-02-05', 'status': 'Not Signed'},
    {'subject': 'Physics', 'date': '2024-02-06', 'status': 'Not Signed'},
    {'subject': 'Computer Science', 'date': '2024-02-07', 'status': 'Signed'},
    {'subject': 'Chemistry', 'date': '2024-02-08', 'status': 'Signed'},
    {'subject': 'Mathematics', 'date': '2024-02-09', 'status': 'Signed'},
    {'subject': 'Computer Science', 'date': '2024-02-10', 'status': 'Not Signed'},
  ];

  // Maximum allowed absences before expulsion warning
  final int maxAllowedAbsences = 2;

  // State to track if analysis is shown
  bool showAnalysis = false;

  // Calculate absences per subject
  Map<String, int> calculateAbsences() {
    Map<String, int> absences = {};
    for (var record in attendanceRecords) {
      String subject = record['subject']!;
      if (record['status'] == 'Not Signed') {
        absences[subject] = (absences[subject] ?? 0) + 1;
      }
    }
    return absences;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> absences = calculateAbsences();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "Student Attendance Overview",
            //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: attendanceRecords.length,
                itemBuilder: (context, index) {
                  var record = attendanceRecords[index];
                  return _buildAttendanceCard(record);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Show Analysis Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAnalysis = !showAnalysis;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  showAnalysis ? "Hide Analysis" : "Show Attendance Analysis",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Display analysis if button is pressed
            if (showAnalysis) ...[
              const Text(
                "Attendance Analysis",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: absences.keys.map((subject) {
                    return Text(
                      "$subject: Missed ${absences[subject]} days",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: absences[subject]! > maxAllowedAbsences
                            ? Colors.red
                            : Colors.black,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // Expulsion Warning
              const Text(
                "Expulsion Warning",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: absences.keys
                      .where((subject) => absences[subject]! > maxAllowedAbsences)
                      .map((subject) {
                    return Text(
                      "⚠️ $subject: ${absences[subject]} absences (Exceeds Limit)",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Method to build each attendance card
  Widget _buildAttendanceCard(Map<String, String> record) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          record['status'] == 'Signed' ? Icons.check_circle : Icons.cancel,
          color: record['status'] == 'Signed' ? Colors.green : Colors.red,
        ),
        title: Text(
          record['subject']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Date: ${record['date']} | Status: ${record['status']}'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}




// Pay Fees Page
class PayFeesScreen extends StatelessWidget {
  const PayFeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Fees')),
      body: const Center(
        child: Text(
          'Fee payment options will be shown here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}


// consultation page for the students

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  _ConsultationScreenState createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  String? selectedTeacher;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final Map<String, List<Map<String, String>>> teacherSlots = {
    'Dr. Smith': [
      {'date': '2024-03-05', 'time': '10:00 AM'},
      {'date': '2024-03-07', 'time': '2:00 PM'},
    ],
    'Prof. Johnson': [
      {'date': '2024-03-06', 'time': '11:00 AM'},
      {'date': '2024-03-08', 'time': '3:00 PM'},
    ],
    'Ms. Lee': [
      {'date': '2024-03-09', 'time': '9:00 AM'},
      {'date': '2024-03-10', 'time': '1:00 PM'},
    ],
  };

  List<Map<String, String>> consultations = [];

  // Function to schedule a consultation
  void scheduleConsultation() {
    if (selectedTeacher == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a teacher, date, and time.')),
      );
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    String formattedTime = selectedTime!.format(context);

    setState(() {
      consultations.add({
        'teacher': selectedTeacher!,
        'date': formattedDate,
        'time': formattedTime,
      });

      selectedTeacher = null;
      selectedDate = null;
      selectedTime = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consultation scheduled successfully!')),
    );
  }

  // Function to cancel a consultation
  void cancelConsultation(int index) {
    setState(() {
      consultations.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consultation canceled.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Booking'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.schedule, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Consultation Schedule',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Select Teacher Dropdown
            DropdownButton<String>(
              value: selectedTeacher,
              hint: const Text("Select a Teacher"),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  selectedTeacher = value;
                  selectedDate = null; // Reset date & time selection when changing teacher
                  selectedTime = null;
                });
              },
              items: teacherSlots.keys.map((teacher) {
                return DropdownMenuItem(
                  value: teacher,
                  child: Text(teacher),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Show Available Slots for Selected Teacher
            if (selectedTeacher != null) ...[
              const Text(
                'Available Slots',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              for (var slot in teacherSlots[selectedTeacher] ?? [])
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.blue),
                    title: Text("Date: ${slot['date']}"),
                    subtitle: Text("Time: ${slot['time']}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime.parse(slot['date']!);
                          selectedTime = TimeOfDay(
                            hour: int.parse(slot['time']!.split(':')[0]),
                            minute: int.parse(slot['time']!.split(':')[1].split(' ')[0]),
                          );
                        });
                      },
                      child: const Text("Select"),
                    ),
                  ),
                ),
            ],

            const SizedBox(height: 20),

            // Schedule Consultation Button
            ElevatedButton.icon(
              onPressed: scheduleConsultation,
              icon: const Icon(Icons.event_available),
              label: const Text('Schedule Consultation'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),

            const SizedBox(height: 20),

            // Upcoming Consultations List
            if (consultations.isNotEmpty) ...[
              const Text(
                'Upcoming Consultations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200, // Fixed height for scrollable list
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: consultations.length,
                  itemBuilder: (context, index) {
                    var consultation = consultations[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Colors.blue),
                        title: Text('Teacher: ${consultation['teacher']}'),
                        subtitle: Text('Date: ${consultation['date']} | Time: ${consultation['time']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => cancelConsultation(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else
              const Text(
                'No consultations scheduled.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}
