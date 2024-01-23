//

import 'package:attendanaceapp/screens/all_emp.dart';
import 'package:attendanaceapp/screens/add_emp.dart';
import 'package:attendanaceapp/components/app_bar.dart';
import 'package:attendanaceapp/screens/employee_more_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmployeeData {
  final String name;
  final String loginTime;
  final String logoutTime;
  final String notes;
  final LatLng checkInLocation;
  final LatLng checkOutLocation;

  EmployeeData({
    required this.name,
    required this.loginTime,
    required this.logoutTime,
    required this.notes,
    required this.checkInLocation,
    required this.checkOutLocation,
  });
}

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarAdmin('Home-Page'),
      body: EmployeeCardList(),
      bottomNavigationBar: BottomAppBar(
        elevation: 9,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_rounded,
                  color: Color.fromARGB(255, 5, 62, 136),
                ),
                onPressed: () {
                  // Perform actions specific to this page
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.people_alt_rounded,
                  color: Color.fromARGB(255, 5, 62, 136),
                ),
                onPressed: () {
                  // Navigate to the next page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllEmployeesPhotosPage()));
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 9,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserProfilePage()));
          // Perform action when the floating action button is pressed
        },
      ),
    );
  }
}

class EmployeeCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('emp_daily_activity')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var employeeDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

        // Group projects by employee
        var groupedProjects = <String, List<Map<String, dynamic>>>{};

        for (var doc in employeeDocs) {
          var data = doc.data() as Map<String, dynamic>;
          var employeeName = doc.id.split('_')[0];

          if (data.containsKey('daily_activity')) {
            var dailyActivityList = data['daily_activity'] as List<dynamic>?;

            if (dailyActivityList != null && dailyActivityList.isNotEmpty) {
              var projects = dailyActivityList[0]['projects'] as List<dynamic>;

              if (!groupedProjects.containsKey(employeeName)) {
                groupedProjects[employeeName] = [];
              }

              // Add only unique projects by checking their names
              for (var project in projects) {
                var projectName = project['name'];
                if (!groupedProjects[employeeName]!
                    .any((p) => p['name'] == projectName)) {
                  groupedProjects[employeeName]!.add(project);
                }
              }
            }
          }
        }

        if (groupedProjects.isEmpty) {
          return Center(child: Text('No records found for the present day.'));
        }

        return ListView(
          children: groupedProjects.entries.map((entry) {
            var employeeName = entry.key;
            var projects = entry.value;

            return EmployeeCard(
              employeeName: employeeName,
              projects: projects,
            );
          }).toList(),
        );
      },
    );
  }
}

class EmployeeCard extends StatefulWidget {
  final String employeeName;
  final List<Map<String, dynamic>> projects;

  EmployeeCard({
    required this.employeeName,
    required this.projects,
  });
  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  late Map<String, dynamic> selectedProject;

  @override
  void initState() {
    super.initState();
    selectedProject = widget.projects.first;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the details page and pass the necessary data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDetailsPage(employeeName: widget.employeeName,
              employeeId: widget.projects.first['id'], // Assuming employee ID is stored in the first project
              presentDayData: widget.projects,),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(9.0),
        elevation: 9,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            _buildDropDown(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.employeeName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Login Time: ${selectedProject['login'] ?? ''}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          'Logout Time: ${selectedProject['logout'] ?? ''}',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Notes: ${selectedProject['notes'] ?? ''}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                SizedBox(height: 10),
                // Display Google Map with Check-in and Check-out locations
                Container(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target:
                          _parseLocation(selectedProject['checkin_location']),
                      zoom: 15,
                    ),
                    markers: Set.from([
                      Marker(
                        markerId: MarkerId('checkIn'),
                        position:
                            _parseLocation(selectedProject['checkin_location']),
                        infoWindow: InfoWindow(title: 'Check-in Location'),
                      ),
                      Marker(
                        markerId: MarkerId('checkOut'),
                        position: _parseLocation(
                            selectedProject['checkout_location']),
                        infoWindow: InfoWindow(title: 'Check-out Location'),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

   Widget _buildDropDown() {
    return DropdownButton<Map<String, dynamic>>(
      value: selectedProject,
      onChanged: (value) {
        setState(() {
          selectedProject = value!;
        });
      },
      items: widget.projects.map<DropdownMenuItem<Map<String, dynamic>>>((project) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: project,
          child: Text(project['name'] ?? 'Unknown Project'),
        );
      }).toList(),
    );
  }


  LatLng _parseLocation(String locationString) {
    var coordinates = locationString
        .replaceAll('Latitude: ', '')
        .replaceAll('Longitude: ', '')
        .split(', ');
    return LatLng(double.parse(coordinates[0]), double.parse(coordinates[1]));
  }
}

//nothing
