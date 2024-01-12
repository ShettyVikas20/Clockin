import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'EmployeeHistoryPage.dart'; // Import the EmployeeHistoryPage



class EmployeeData {
  final String name;
  final String loginTime;
  final String logoutTime;
  final String notes;
  final String phone; // Include phone in EmployeeData

  EmployeeData({
    required this.name,
    required this.loginTime,
    required this.logoutTime,
    required this.notes,
    required this.phone,
  });
}

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Admin Home Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 58, 58),
          ),
        ),
        elevation: 0,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
               
              Color.fromARGB(255, 233, 121, 46), Color.fromARGB(255, 247, 153, 14)
              // Add more colors if you want a gradient effect
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ),
      body: EmployeeCardList(),
    );
  }
}

class EmployeeCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('emp_daily_activity')
          .where('date', isEqualTo: currentDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var employeeDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

        return ListView.builder(
          itemCount: employeeDocs.length,
          itemBuilder: (context, index) {
            var data = employeeDocs[index].data() as Map<String, dynamic>;

            var employeeData = EmployeeData(
              name: data['name'] ?? '',
              loginTime: data['login'] ?? '',
              logoutTime: data['logout'] ?? '',
              notes: data['notes'] ?? '',
              phone: data['phone'] ?? '',
            );

            return EmployeeCard(employeeData: employeeData);
          },
        );
      },
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final EmployeeData employeeData;

  EmployeeCard({required this.employeeData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeHistoryPage(
              employeeName: employeeData.name,
              employeePhone: employeeData.phone,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(employeeData.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Login Time: ${employeeData.loginTime}'),
              Text('Logout Time: ${employeeData.logoutTime}'),
              Text('Notes: ${employeeData.notes}'),
            ],
          ),
        ),
      ),
    );
  }
}
