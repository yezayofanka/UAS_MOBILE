import 'package:flutter/material.dart';
import 'student_history.dart'; // Import file student_history.dart

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Map<String, dynamic>> attendees = [
    {'name': 'Alice', 'isPresent': false, 'subject': 'Math'},
    {'name': 'Bob', 'isPresent': false, 'subject': 'Science'},
    {'name': 'Charlie', 'isPresent': false, 'subject': 'History'},
    {'name': 'David', 'isPresent': false, 'subject': 'Math'},
  ];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _toggleAttendance(int index) {
    setState(() {
      attendees[index]['isPresent'] = !attendees[index]['isPresent'];
    });
  }

  void _editName(int index) {
    TextEditingController nameController = TextEditingController();
    TextEditingController subjectController = TextEditingController();
    nameController.text = attendees[index]['name'];
    subjectController.text = attendees[index]['subject'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Name and Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  attendees[index]['name'] = nameController.text;
                  attendees[index]['subject'] = subjectController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addStudent(String name, String subject) {
    if (name.isNotEmpty && subject.isNotEmpty) {
      setState(() {
        attendees.add({
          'name': name,
          'isPresent': false,
          'subject': subject,
        });
      });
      _listKey.currentState!.insertItem(attendees.length - 1);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Name and subject cannot be empty.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteStudent(int index) {
    setState(() {
      attendees.removeAt(index);
    });
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildItem(context, index, animation),
    );
  }

  void _deleteAllStudents() {
  if (attendees.isNotEmpty) {
    int length = attendees.length;
    for (int i = length - 1; i >= 0; i--) {
      _deleteStudent(i);
    }
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('No students to delete.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


  void _viewHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentHistoryPage(historyData: attendees.toList()),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, Animation<double>? animation) {
    return SizeTransition(
      sizeFactor: animation!,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.5), // Adjust border color and transparency
            ),
          ),
        ),
        child: ListTile(
          title: Text('${attendees[index]['name']} - ${attendees[index]['subject']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: Icon(
                    attendees[index]['isPresent'] ? Icons.check_circle : Icons.cancel,
                    key: ValueKey<bool>(attendees[index]['isPresent']),
                    color: attendees[index]['isPresent'] ? Colors.green : Colors.red,
                  ),
                ),
                onPressed: () => _toggleAttendance(index),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editName(index),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteStudent(index), // Delete student
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance App'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController nameController = TextEditingController();
                  TextEditingController subjectController = TextEditingController();
                  return AlertDialog(
                    title: Text('Add Student'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: subjectController,
                          decoration: InputDecoration(labelText: 'Subject'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _addStudent(nameController.text, subjectController.text);
                          Navigator.of(context).pop();
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _deleteAllStudents, // Delete all students
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _viewHistory, // Navigate to student history page
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_attendance.jpg'), // Path to the new background image
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: attendees.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(context, index, animation);
          },
        ),
      ),
    );
  }
}
