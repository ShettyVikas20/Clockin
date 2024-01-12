import 'package:attendanaceapp/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EmployeeHistoryPage.dart';

class AllEmployeesPhotosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Employees',
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
               
               Color.fromARGB(255, 39, 179, 235), Color.fromARGB(255, 182, 215, 247),
              // Add more colors if you want a gradient effect
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ),
      body:  EmployeePhotosList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(),
            ),
          );
        },
        child: Icon(Icons.add, color: Color.fromARGB(255, 59, 58, 58),),
        backgroundColor:Color.fromARGB(255, 39, 179, 235),
      ),
    );
  }
}

class EmployeePhotosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Employees').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var employeeDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: employeeDocs.length,
          itemBuilder: (context, index) {
            var data = employeeDocs[index].data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeHistoryPage(
                      employeeName: data['name'],
                      employeePhone: data['phone'],
                    ),
                  ),
                );
              },
              child: EmployeePhotoCard(
                photoUrl: data['photo_url'],
                employeeName: data['name'],
                employeeEmail: data['email'],
              ),
            );
          },
        );
      },
    );
  }
}

class EmployeePhotoCard extends StatelessWidget {
  final String photoUrl;
  final String employeeName;
  final String employeeEmail;

  EmployeePhotoCard({
    required this.photoUrl,
    required this.employeeName,
    required this.employeeEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employeeName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 2, 2, 2),
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  employeeEmail,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
