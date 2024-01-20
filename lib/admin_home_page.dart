// import 'package:attendanaceapp/AllEmployeesPhotosPage.dart';
// import 'package:attendanaceapp/add_employee.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'EmployeeHistoryPage.dart'; // Import the EmployeeHistoryPage

// class EmployeeData {
//   final String name;
//   final String loginTime;
//   final String logoutTime;
//   final String notes;
//   final String phone;
//   String photo_url; // Add photoUrl

//   EmployeeData({
//     required this.name,
//     required this.loginTime,
//     required this.logoutTime,
//     required this.notes,
//     required this.phone,
//     required this.photo_url, // Initialize photoUrl
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
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Home-Page',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color.fromARGB(255, 59, 58, 58),
//           ),
//         ),
//         elevation: 0,
//         shape: ContinuousRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 39, 179, 235),
//                 Color.fromARGB(255, 182, 215, 247),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: EmployeeCardList(),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 9,
//         shape: CircularNotchedRectangle(), // This is what makes it rounded
//         child: Container(
         
//           height: 60.0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.home_rounded,
//                 color:  Color.fromARGB(255, 5, 62, 136),),
//                 onPressed: () {
//                   // Perform actions specific to this page
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.people_alt_rounded,
//                 color:  Color.fromARGB(255, 5, 62, 136),),
//                 onPressed: () {
//                   // Navigate to the next page
//                   // For demonstration purposes, let's assume the next page is 'NextPage'
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => AllEmployeesPhotosPage()));
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
//             Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
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

//         var currentDate = DateFormat('yyyy-MMM-dd').format(DateTime.now());
//         var presentDayEmployeeDocs = employeeDocs.where((doc) {
//           var docIdComponents = doc.id.split('_');
//           return docIdComponents.length == 3 &&
//               docIdComponents[2] == currentDate;
//         }).toList();

//         if (presentDayEmployeeDocs.isEmpty) {
//           return Center(child: Text('No records found for the present day.'));
//         }

//         return ListView.builder(
//           itemCount: presentDayEmployeeDocs.length,
//           itemBuilder: (context, index) {
//             var data =
//                 presentDayEmployeeDocs[index].data() as Map<String, dynamic>;

//             var employeeData = EmployeeData(
//               name: data['name'] ?? '',
//               loginTime: data['login'] ?? '',
//               logoutTime: data['logout'] ?? '',
//               notes: data['notes'] ?? '',
//               phone: data['phone'] ?? '',
//               photo_url: '', // Initialize to an empty string for now
//             );
//             return EmployeeCard(employeeData: employeeData);
//           },
//         );
//       },
//     );
//   }
// }

// class EmployeeCard extends StatelessWidget {
//   final EmployeeData employeeData;

//   EmployeeCard({required this.employeeData});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => EmployeeHistoryPage(
//               employeeName: employeeData.name,
//               employeePhone: employeeData.phone,
//             ),
//           ),
//         );
//       },
//       child: SingleChildScrollView(
//         child: Card(
//           margin: EdgeInsets.all(9.0),
//           elevation: 9,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25.0),
//           ),
//           child: ListTile(
//             contentPadding: EdgeInsets.symmetric(vertical: 15.0),
//             title: 
//               Padding(
//               padding: const EdgeInsets.only(left: 10.0), // Add left padding
//               child:Text(
//               employeeData.name,
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                 // fontFamily: 'lemon',
//                 fontSize: 22,
//               ),
//             ),
//               ),
//             subtitle:
//              Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0), // Top padding for login time
//                   child:
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                     child:Text(
//                       'Login Time: ${employeeData.loginTime}',
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     ),
//                      Padding(
//                       padding: const EdgeInsets.only(right: 10.0),
//                     child:
//                     Text(
//                       'Logout Time: ${employeeData.logoutTime}',
//                       textAlign: TextAlign.end,
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     ),
//                   ],
//                 ),
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: Text(
//                     'Notes: ${employeeData.notes}',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'package:attendanaceapp/AllEmployeesPhotosPage.dart';
import 'package:attendanaceapp/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'EmployeeHistoryPage.dart'; // Import the EmployeeHistoryPage

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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home-Page',
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
                Color.fromARGB(255, 39, 179, 235),
                Color.fromARGB(255, 182, 215, 247),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: EmployeeCardList(),
      bottomNavigationBar: BottomAppBar(
        elevation: 9,
        shape: CircularNotchedRectangle(), // This is what makes it rounded
        child: Container(
         
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home_rounded,
                color:  Color.fromARGB(255, 5, 62, 136),),
                onPressed: () {
                  // Perform actions specific to this page
                },
              ),
              IconButton(
                icon: Icon(Icons.people_alt_rounded,
                color:  Color.fromARGB(255, 5, 62, 136),),
                onPressed: () {
                  // Navigate to the next page
                  // For demonstration purposes, let's assume the next page is 'NextPage'
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllEmployeesPhotosPage()));
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
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
      stream: FirebaseFirestore.instance.collection('emp_daily_activity').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var employeeDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

        var currentDate = DateFormat('yyyy-MMM-dd').format(DateTime.now());
        var presentDayEmployeeDocs = employeeDocs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;

          // Check if the "daily_activity" field exists
          if (data.containsKey('daily_activity')) {
            var dailyActivities = data['daily_activity'] as List<dynamic>?;
            
            // Check if there are daily activities and at least one project
            if (dailyActivities != null && dailyActivities.isNotEmpty) {
              return dailyActivities.any((activity) {
                var date = activity['date'] as String;
                return date == currentDate;
              });
            }
          }
          return false;
        }).toList();

        if (presentDayEmployeeDocs.isEmpty) {
          return Center(child: Text('No records found for the present day.'));
        }

        return ListView.builder(
          itemCount: presentDayEmployeeDocs.length,
          itemBuilder: (context, index) {
            var data = presentDayEmployeeDocs[index].data() as Map<String, dynamic>;

            // Extracting employee name from the document ID
            var docIdComponents = presentDayEmployeeDocs[index].id.split('_');
            var employeeName = docIdComponents[0];

            // Extracting and processing daily activities for the current day
            var dailyActivities = data['daily_activity'] as List<dynamic>?;

            if (dailyActivities != null && dailyActivities.isNotEmpty) {
              var todayProjects = dailyActivities[0]['projects'] as List<dynamic>;

              var employeeDataList = todayProjects.map((project) {
                return EmployeeData(
                  name: employeeName,
                  loginTime: project['login'] ?? '',
                  logoutTime: project['logout'] ?? '',
                  notes: project['notes'] ?? '',
                  checkInLocation: _parseLocation(project['checkin_location']),
                  checkOutLocation: _parseLocation(project['checkout_location']),
                );
              }).toList();

              // Assuming each project corresponds to an employee entry
              return Column(
                children: employeeDataList.map((employeeData) {
                  return EmployeeCard(employeeData: employeeData);
                }).toList(),
              );
            } else {
              return Center(child: Text('No records found for the present day.'));
            }
          },
        );
      },
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


class EmployeeCard extends StatelessWidget {
  final EmployeeData employeeData;

  EmployeeCard({required this.employeeData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(9.0),
      elevation: 9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            employeeData.name,
            textAlign: TextAlign.start,
            style: TextStyle(
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
                      'Login Time: ${employeeData.loginTime}',
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
                      'Logout Time: ${employeeData.logoutTime}',
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
                'Notes: ${employeeData.notes}',
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
                  target: employeeData.checkInLocation,
                  zoom: 15,
                ),
                markers: Set.from([
                Marker(
                  markerId: MarkerId('checkIn'),
                  position: employeeData.checkInLocation,
                  infoWindow: InfoWindow(title: 'Check-in Location'),
                ),
                Marker(
                  markerId: MarkerId('checkOut'),
                  position: employeeData.checkOutLocation,
                  infoWindow: InfoWindow(title: 'Check-out Location'),
                ),
              ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
