// import 'package:attendanaceapp/screens/all_emp.dart';
// import 'package:attendanaceapp/screens/add_emp.dart';
// import 'package:attendanaceapp/components/app_bar.dart';
// import 'package:attendanaceapp/screens/employee_more_details.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class EmployeeData {
//   final String name;
//   final String loginTime;
//   final String logoutTime;
//   final String notes;
//   final LatLng checkInLocation;
//   final LatLng checkOutLocation;

//   EmployeeData({
//     required this.name,
//     required this.loginTime,
//     required this.logoutTime,
//     required this.notes,
//     required this.checkInLocation,
//     required this.checkOutLocation,
//   });
// }

// class AdminHomePage extends StatefulWidget {
//   @override
//   _AdminHomePageState createState() => _AdminHomePageState();
// }

// class _AdminHomePageState extends State<AdminHomePage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppbarAdminHome('Home-Page'),
//       body: EmployeeCardList(),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 9,
//         shape: CircularNotchedRectangle(),
//         child: Container(
//           height: 60.0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.home_rounded,
//                   color: Color.fromARGB(255, 5, 62, 136),
//                 ),
//                 onPressed: () {
//                   // Perform actions specific to this page
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.people_alt_rounded,
//                   color: Color.fromARGB(255, 5, 62, 136),
//                 ),
//                 onPressed: () {
//                   // Navigate to the next page
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AllEmployeesPhotosPage()));
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         elevation: 9,
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => UserProfilePage()));
//           // Perform action when the floating action button is pressed
//         },
//       ),
//     );
//   }
// }

// class EmployeeCardList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('emp_daily_activity')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         var employeeDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

//         // Group projects by employee
//         var groupedProjects = <String, List<Map<String, dynamic>>>{};

//         for (var doc in employeeDocs) {
//           var data = doc.data() as Map<String, dynamic>;
//           var employeeName = doc.id.split('_')[0];

//           if (data.containsKey('daily_activity')) {
//             var dailyActivityList = data['daily_activity'] as List<dynamic>?;

//             if (dailyActivityList != null && dailyActivityList.isNotEmpty) {
//               var projects = dailyActivityList[0]['projects'] as List<dynamic>;

//               if (!groupedProjects.containsKey(employeeName)) {
//                 groupedProjects[employeeName] = [];
//               }

//               // Add only unique projects by checking their names
//               for (var project in projects) {
//                 var projectName = project['name'];
//                 if (!groupedProjects[employeeName]!
//                     .any((p) => p['name'] == projectName)) {
//                   groupedProjects[employeeName]!.add(project);
//                 }
//               }
//             }
//           }
//         }

//         if (groupedProjects.isEmpty) {
//           return Center(child: Text('No records found for the present day.'));
//         }

//          return
//         ListView(
//             children: groupedProjects.entries.map((entry) {
//               var employeeName = entry.key;
//               var projects = entry.value;
//               return EmployeeCard(
//                 employeeName: employeeName,
//                 projects: projects,
//               );
//             }).toList(),
//           );
//       },
//     );
//   }
// }

// class EmployeeCard extends StatefulWidget {
//   final String employeeName;
//   final List<Map<String, dynamic>> projects;

//   EmployeeCard({
//     required this.employeeName,
//     required this.projects,
//   });
//   @override
//   _EmployeeCardState createState() => _EmployeeCardState();
// }

// class _EmployeeCardState extends State<EmployeeCard> {
//   late Map<String, dynamic> selectedProject;

//   @override
//   void initState() {
//     super.initState();
//     selectedProject = widget.projects.first;
//   }
// @override
// Widget build(BuildContext context) {
//   return GestureDetector(
//     onTap: () {
//       // Navigate to the details page and pass the necessary data
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => EmployeeDetailsPage(
//             employeeName: widget.employeeName,
//             employeeId: widget.projects.first['id'], // Assuming employee ID is stored in the first project
//           ),
//         ),
//       );
//     },
//     child: Card(
//       margin: EdgeInsets.all(9.0),
//       elevation: 9,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//   padding: const EdgeInsets.only(left: 25.0),
//                 // Align employee name to the left
//                child: Text(
//                   widget.employeeName,
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 25,
//                   ),
//                 ),
//                 ),
//                 // Align dropdown to the right
//                 Padding(
//   padding: const EdgeInsets.only(right: 25.0),
//              child:   Container(

//                   height: 40,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: const Color.fromARGB(255, 182, 216, 245).withOpacity(0.2),
//                   ),
//                   child: DropdownButton<Map<String, dynamic>>(
//                     value: selectedProject,
//                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                     underline: Container(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedProject = value!;
//                       });
//                     },
//                     items: widget.projects.map<DropdownMenuItem<Map<String, dynamic>>>((project) {
//                       return DropdownMenuItem<Map<String, dynamic>>(
//                         value: project,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0), // Add padding inside the dropdown items
//                           child: Text(project['name'] ?? 'Unknown Project'),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             contentPadding: EdgeInsets.symmetric(vertical:15.0),
//             title: Padding(
//               padding: const EdgeInsets.only(top: 5.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                          Container(
//                           height: 60,
//                           width: 150,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
//     color: Color.fromARGB(255, 114, 161, 248).withOpacity(0.2), // Adjust the color as needed
//   ),
//              child: Center(
//     child: Align(
//       alignment: Alignment.center,
//        child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.lock_clock_rounded,
//             color: Color.fromARGB(255, 13, 105, 243),
//             size: 24.0,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//           ),

//                      Text(
//                             'Login Time: ${selectedProject['login'] ?? ''}',
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//         ],
//                         ),
//                       ),
//                      ),
//                     ),
//                     Container(

//               padding: const EdgeInsets.only(right: 2.0),
//                         height: 60,
//                          width: 150,
//               decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
//               color: Colors.orange.withOpacity(0.2), // Adjust the color as needed
//   ),
//   child: Center(
//     child: Align(
//       alignment: Alignment.center,
//        child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.lock_clock,
//             color: Color.fromARGB(255, 243, 59, 13),
//             size: 24.0,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//           ),
//        Text(
//           'Logout Time: ${selectedProject['logout'] ?? ''}',
//           textAlign: TextAlign.end,
//           style: TextStyle(
//             color: Colors.orange,
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//         ),
//         ],
//     ),
//     ),
//   ),
// ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Center(
//                     child: Text(
//                       'Notes: ${selectedProject['notes'] ?? ''}',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.grey),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   // Display Google Map with Check-in and Check-out locations

//               Container(

//                     height: 200,
//                     child: GoogleMap(
//                       initialCameraPosition: CameraPosition(
//                         target:
//                             _parseLocation(selectedProject['checkin_location']),
//                         zoom: 15,
//                       ),
//                       markers: Set.from([
//                         Marker(
//                           markerId: MarkerId('checkIn'),
//                           position:
//                               _parseLocation(selectedProject['checkin_location']),
//                           infoWindow: InfoWindow(title: 'Check-in Location'),
//                         ),
//                         Marker(
//                           markerId: MarkerId('checkOut'),
//                           position: _parseLocation(
//                               selectedProject['checkout_location']),
//                           infoWindow: InfoWindow(title: 'Check-out Location'),
//                         ),
//                       ]),
//                     ),
//                   ),

//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

//   LatLng _parseLocation(String locationString) {
//     var coordinates = locationString
//         .replaceAll('Latitude: ', '')
//         .replaceAll('Longitude: ', '')
//         .split(', ');
//     return LatLng(double.parse(coordinates[0]), double.parse(coordinates[1]));
//   }
// }

import 'package:attendanaceapp/screens/all_emp.dart';
import 'package:attendanaceapp/screens/add_emp.dart';
import 'package:attendanaceapp/components/app_bar.dart';
import 'package:attendanaceapp/screens/employee_more_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

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
      appBar: AppbarAdminHome('Home-Page'),
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
    String formattedDate = DateFormat('yyyy-MMM-dd').format(DateTime.now());

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

        print('Formatted Date: $formattedDate');

        // Filter documents for the current date
        var todayEmployeeDocs = employeeDocs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('daily_activity')) {
            var dailyActivityList = data['daily_activity'] as List<dynamic>;

            print('Doc ID: ${doc.id}');

            // Check if any of the daily activities have today's date
            var todayActivity = dailyActivityList.firstWhere(
              (activity) => activity['date'] == formattedDate,
              orElse: () => null,
            );

            if (todayActivity != null) {
              print('Today\'s Date: $formattedDate');
            }

            return todayActivity != null;
          }
          return false;
        }).toList();

        print('Number of Documents for Today: ${todayEmployeeDocs.length}');

        if (todayEmployeeDocs.isEmpty) {
          return Center(child: Text('No records found for the present day.'));
        }

        // Group projects by employee
        var groupedProjects = <String, List<Map<String, dynamic>>>{};

        for (var doc in todayEmployeeDocs) {
          var data = doc.data() as Map<String, dynamic>;
          var employeeName = doc.id.split('_')[0];

          var dailyActivityList = data['daily_activity'] as List<dynamic>;

          var todayActivity = dailyActivityList.firstWhere(
            (activity) => activity['date'] == formattedDate,
            orElse: () => null,
          );

          if (todayActivity != null) {
            var projects = todayActivity['projects'] as List<dynamic>;

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
            builder: (context) => EmployeeDetailsPage(
              employeeName: widget.employeeName,
              employeeId: widget.projects.first[
                  'id'], // Assuming employee ID is stored in the first project
            ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    // Align employee name to the left
                    child: Text(
                      widget.employeeName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  // Align dropdown to the right
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 182, 216, 245)
                            .withOpacity(0.2),
                      ),
                      child: DropdownButton<Map<String, dynamic>>(
                        value: selectedProject,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        underline: Container(),
                        onChanged: (value) {
                          setState(() {
                            selectedProject = value!;
                          });
                        },
                        items: widget.projects
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (project) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: project,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Add padding inside the dropdown items
                              child: Text(project['name'] ?? 'Unknown Project'),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              title: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 60,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Adjust the radius as needed
                              color: Color.fromARGB(255, 114, 161, 248)
                                  .withOpacity(
                                      0.2), // Adjust the color as needed
                            ),
                            child: Center(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock_clock_rounded,
                                      color: Color.fromARGB(255, 13, 105, 243),
                                      size: 24.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                    ),
                                    Text(
                                      'Login Time: ${selectedProject['login'] ?? ''}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 2.0),
                            height: 60,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Adjust the radius as needed
                              color: Colors.orange.withOpacity(
                                  0.2), // Adjust the color as needed
                            ),
                            child: Center(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock_clock,
                                      color: Color.fromARGB(255, 243, 59, 13),
                                      size: 24.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                    ),
                                    Text(
                                      'Logout Time: ${selectedProject['logout'] ?? ''}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Display Google Map with Check-in and Check-out locations

                    Container(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _parseLocation(
                              selectedProject['checkin_location']),
                          zoom: 15,
                        ),
                        markers: Set.from([
                          Marker(
                            markerId: MarkerId('checkIn'),
                            position: _parseLocation(
                                selectedProject['checkin_location']),
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
            ),
          ],
        ),
      ),
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
