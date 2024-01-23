import 'package:attendanaceapp/screens/admin_homepage.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsPage extends StatelessWidget {
  final EmployeeData employeeData;

  EmployeeDetailsPage({required this.employeeData});

  @override
  Widget build(BuildContext context) {
    // Use the employeeData to display details on this page
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Employee Name: ${employeeData.name}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
