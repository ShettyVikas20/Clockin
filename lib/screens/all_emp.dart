import 'package:attendanaceapp/screens/add_emp.dart';
import 'package:attendanaceapp/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'emp_details.dart';

class AllEmployeesPhotosPage extends StatefulWidget {
  @override
  _AllEmployeesPhotosPageState createState() => _AllEmployeesPhotosPageState();
}

class _AllEmployeesPhotosPageState extends State<AllEmployeesPhotosPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarAdmin('All Employees'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                // Implement search functionality here
                // You may need to modify EmployeePhotosList to support filtering
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search Employees',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: EmployeePhotosList(searchQuery: searchController.text),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(),
            ),
          );
        },
        child: Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class EmployeePhotosList extends StatelessWidget {
  final String searchQuery;

  EmployeePhotosList({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Use the filtered query to fetch only relevant data
      stream: FirebaseFirestore.instance
          .collection('Employees')
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var employeeDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 2, 2, 2),
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  employeeEmail,
                  style: const TextStyle(
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
