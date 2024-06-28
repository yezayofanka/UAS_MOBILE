import 'package:flutter/material.dart';

class StudentHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> historyData;

  StudentHistoryPage({required this.historyData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student History'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_attendance.jpg'), // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: historyData.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${historyData[index]['name']} - ${historyData[index]['subject']}'),
              subtitle: Text('Present: ${historyData[index]['isPresent'] ? 'Yes' : 'No'}'),
            );
          },
        ),
      ),
    );
  }
}
