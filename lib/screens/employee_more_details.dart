// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class EmployeeDetailsPage extends StatefulWidget {
//   final String employeeName;
//   final String employeeId;

//   EmployeeDetailsPage({
//     required this.employeeName,
//     required this.employeeId,
//   });

//   @override
//   _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
// }

// class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
//   late List<Map<String, dynamic>> allEmployeeData;
//   late String selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     selectedDate = DateFormat('yyyy-MMM-dd').format(DateTime.now());
//     allEmployeeData = []; // Initialize the list here

//     FirebaseFirestore.instance
//         .collection('emp_daily_activity')
//         .doc('${widget.employeeName}_${widget.employeeId}_dailyactivity')
//         .get()
//         .then((docSnapshot) {
//       if (docSnapshot.exists) {
//         var data = docSnapshot.data() as Map<String, dynamic>;
//         allEmployeeData = data['daily_activity'].cast<Map<String, dynamic>>();
//         print('Fetched employee data: $allEmployeeData');
//         setState(() {});
//       } else {
//         print('Document does not exist for employee: ${widget.employeeName}_${widget.employeeId}_dailyactivity');
//       }
//     }).catchError((error) {
//       print('Error fetching employee data: $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Employee Details - ${widget.employeeName}'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 20),
//           Text(
//             'Select a day to view details:',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           _buildDateButtons(),
//           SizedBox(height: 20),
//           _buildDetailsContainer(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateButtons() {
//   var recentDates = allEmployeeData
//       .map<String>((day) => day['date'].toString())
//       .toSet()
//       .toList()
//       ..sort((a, b) {
//         // Parse the dates before comparison
//         var dateA = DateFormat('yyyy-MMM-dd').parse(a);
//         var dateB = DateFormat('yyyy-MMM-dd').parse(b);
//         return dateB.compareTo(dateA);
//       });

//   return Container(
//     height: 40,
//     child: ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: recentDates.length > 6 ? 6 : recentDates.length,
//       itemBuilder: (context, index) {
//         var date = recentDates[index];
//         return ElevatedButton(
//           onPressed: () {
//             print('Button clicked for date: $date');
//             setState(() {
//               selectedDate = date;
//             });
//           },
//           child: Text(date),
//         );
//       },
//     ),
//   );
// }

//   Widget _buildDetailsContainer() {
//     var projectsForSelectedDate = allEmployeeData
//         .where((day) {
//           return day['date'] == selectedDate;
//         })
//         .toList();

//     print('Projects for selected date ($selectedDate): $projectsForSelectedDate');

//     return Expanded(
//       child: ListView.builder(
//         itemCount: projectsForSelectedDate.length,
//         itemBuilder: (context, index) {
//           var day = projectsForSelectedDate[index];
//           var projects = day['projects'] as List<dynamic>;

//           return Column(
//             children: [
//               Text('Date: ${day['date']}'),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: projects.length,
//                 itemBuilder: (context, index) {
//                   var project = projects[index];
//                   return ListTile(
//                     title: Text(project['name'] ?? 'Unknown Project'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Check-in Time: ${project['login'] ?? ''}'),
//                         Text('Check-out Time: ${project['logout'] ?? ''}'),
//                         Text('Check-in Location: ${project['checkin_location'] ?? ''}'),
//                         Text('Check-out Location: ${project['checkout_location'] ?? ''}'),
//                         Text('Notes: ${project['notes'] ?? ''}'),
//                         Divider(),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeDetailsPage extends StatefulWidget {
  final String employeeName;
  final String employeeId;

  EmployeeDetailsPage({
    required this.employeeName,
    required this.employeeId,
  });

  @override
  _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  late List<Map<String, dynamic>> allEmployeeData;
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MMM-dd').format(DateTime.now());
    allEmployeeData = [];

    FirebaseFirestore.instance
        .collection('emp_daily_activity')
        .doc('${widget.employeeName}_${widget.employeeId}_dailyactivity')
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        allEmployeeData = data['daily_activity'].cast<Map<String, dynamic>>();
        print('Fetched employee data: $allEmployeeData');
        setState(() {});
      } else {
        print(
            'Document does not exist for employee: ${widget.employeeName}_${widget.employeeId}_dailyactivity');
      }
    }).catchError((error) {
      print('Error fetching employee data: $error');
    });
  }

  Future<String?> getLocationString(double latitude, double longitude) async {
    final apiKey = '4103461bf25c447e8f3add63b149abbb';
    final url =
        'https://api.opencagedata.com/geocode/v1/json?key=$apiKey&q=$latitude+$longitude';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['results'] != null && decoded['results'].isNotEmpty) {
        // Extract place name from the OpenCage API response
        var placeName = decoded['results'][0]['formatted'];
        return placeName;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details - ${widget.employeeName}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Select a day to view details:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildDateButtons(),
          SizedBox(height: 20),
          _buildDetailsContainer(),
        ],
      ),
    );
  }

  Widget _buildDateButtons() {
    var recentDates = allEmployeeData
        .map<String>((day) => day['date'].toString())
        .toSet()
        .toList()
      ..sort((a, b) {
        var dateA = DateFormat('yyyy-MMM-dd').parse(a);
        var dateB = DateFormat('yyyy-MMM-dd').parse(b);
        return dateB.compareTo(dateA);
      });

    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentDates.length > 6 ? 6 : recentDates.length,
        itemBuilder: (context, index) {
          var date = recentDates[index];
          return ElevatedButton(
            onPressed: () {
              print('Button clicked for date: $date');
              setState(() {
                selectedDate = date;
              });
            },
            child: Text(date),
          );
        },
      ),
    );
  }

  Widget _buildDetailsContainer() {
    var projectsForSelectedDate = allEmployeeData.where((day) {
      return day['date'] == selectedDate;
    }).toList();

    print(
        'Projects for selected date ($selectedDate): $projectsForSelectedDate');

    return Expanded(
      child: ListView.builder(
        itemCount: projectsForSelectedDate.length,
        itemBuilder: (context, index) {
          var day = projectsForSelectedDate[index];
          var projects = day['projects'] as List<dynamic>;

          return Column(
            children: [
              Text('Date: ${day['date']}'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  var project = projects[index];
                  String checkinLocationString =
                      project['checkin_location'] ?? '';
                  String checkoutLocationString =
                      project['checkout_location'] ?? '';

                  List<String> checkinCoordinates =
                      checkinLocationString.split(', ');
                  List<String> checkoutCoordinates =
                      checkoutLocationString.split(', ');

                  double checkinLatitude =
                      double.parse(checkinCoordinates[0].split(': ')[1]);
                  double checkinLongitude =
                      double.parse(checkinCoordinates[1].split(': ')[1]);

                  double checkoutLatitude =
                      double.parse(checkoutCoordinates[0].split(': ')[1]);
                  double checkoutLongitude =
                      double.parse(checkoutCoordinates[1].split(': ')[1]);

                  return Builder(
                    builder: (BuildContext context) {
                      return FutureBuilder<String?>(
                        future: getLocationString(
                            checkinLatitude, checkinLongitude),
                        builder: (context, checkinSnapshot) {
                          if (checkinSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Or any loading indicator
                          } else if (checkinSnapshot.hasError) {
                            return Text('Error loading check-in location');
                          } else {
                            String? checkinLocation = checkinSnapshot.data;

                            return FutureBuilder<String?>(
                              future: getLocationString(
                                  checkoutLatitude, checkoutLongitude),
                              builder: (context, checkoutSnapshot) {
                                if (checkoutSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Or any loading indicator
                                } else if (checkoutSnapshot.hasError) {
                                  return Text(
                                      'Error loading checkout location');
                                } else {
                                  String? checkoutLocation =
                                      checkoutSnapshot.data;

                                  return ListTile(
                                    title: Text(
                                        project['name'] ?? 'Unknown Project'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Check-in Time: ${project['login'] ?? ''}'),
                                        Text(
                                            'Check-in Location: ${checkinLocation ?? 'Unknown Location'}'),
                                        Text(
                                            'Check-out Time: ${project['logout'] ?? ''}'),
                                        Text(
                                            'Check-out Location: ${checkoutLocation ?? 'Unknown Location'}'),
                                        Text(
                                            'Notes: ${project['notes'] ?? ''}'),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
