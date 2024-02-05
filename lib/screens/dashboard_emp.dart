// import 'package:attendanaceapp/components/app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class DashBoard extends StatefulWidget {
//   final String id;
//   final String name;
//   final String imageUrl;

//   DashBoard({
//     required this.id,
//     required this.imageUrl,
//     required this.name,
//   });

//   @override
//   State<DashBoard> createState() => _DashBoardState();
// }

// class _DashBoardState extends State<DashBoard> {
//   final List<Map<String, dynamic>> dailyAttendanceData = [
//     // Replace with your actual data
//     // ... more entries
//   ];

//   Widget _buildCircularProgress(double percentage, String projectName) {
//     // TODO: Add your logic for circular progress here
//     return Container(); // Placeholder
//   }

//   Color _getProgressColor(double percentage) {
//     // TODO: Add your logic for progress color here
//     return Colors.grey; // Placeholder
//   }

//   Future<double> calculateTotalAttendance() async {
//     DateTime parseDate(String date) {
//       try {
//         return DateFormat('yyyy-MMM-dd').parse(date, true);
//       } catch (e) {
//         print('Error parsing date: $e');
//         return DateTime.now(); // Provide a default value or handle the error
//       }
//     }

//     Future<int> fetchHolidays() async {
//       try {
//         String collectionName = 'holidays';
//         String documentId =
//             'month_${DateTime.now().month}_${DateTime.now().year}';

//         CollectionReference<Map<String, dynamic>> collection =
//             FirebaseFirestore.instance.collection(collectionName);

//         DocumentSnapshot<Map<String, dynamic>> document =
//             await collection.doc(documentId).get();

//         if (document.exists && document.data() != null) {
//           List<dynamic> holidays = document.data()!['holidays'];
//           DateTime today = DateTime.now();
//           int totalHolidaysTillToday = 0;

//           for (dynamic holiday in holidays) {
//             DateTime holidayDate = (holiday['date'] as Timestamp).toDate();
//             if (holidayDate.isBefore(today) ||
//                 holidayDate.isAtSameMomentAs(today)) {
//               totalHolidaysTillToday++;
//             }
//           }

//           print('Total holidays till today: $totalHolidaysTillToday');
//           return totalHolidaysTillToday;
//         } else {
//           print('Document does not exist or has no data.');
//         }
//       } catch (e) {
//         print('Error fetching holidays data: $e');
//       }
//       return 0;
//     }

//     Future<int> calculateTotalWorkingDays() async {
//       try {
//         // Replace 'emp_daily_activity' with your actual collection name
//         String collectionName = 'emp_daily_activity';
//         String documentId = '${widget.name}_${widget.id}_dailyactivity';

//         // Inline Firestore query
//         CollectionReference<Map<String, dynamic>> collection =
//             FirebaseFirestore.instance.collection(collectionName);

//         DocumentSnapshot<Map<String, dynamic>> document =
//             await collection.doc(documentId).get();

//         if (document.exists &&
//             document.data() != null &&
//             document.data()!.containsKey('daily_activity')) {
//           List<String> workingDays = List<String>.from(document
//               .data()!['daily_activity']
//               .where((activity) {
//                 DateTime date = parseDate(activity['date']);
//                 return date.month == DateTime.now().month &&
//                     date.day <= DateTime.now().day;
//               })
//               .map<String>((activity) => activity['date'] as String)
//               .toSet());

//           // Calculate total working days till today
//           int totalWorkingDays = workingDays.length;

//           print('Total Working Days: $totalWorkingDays');

//           return totalWorkingDays;
//         }
//       } catch (e) {
//         print('Error fetching employee data: $e');
//       }

//       return 0;
//     }

//     // Call the function
//     int totalHolidaysTillToday = await fetchHolidays();
//     int totalWorkingDays = await calculateTotalWorkingDays();
//     int totalDaysTillToday = DateTime.now().day;
//     print(totalDaysTillToday);
//     double totalAttendance =
//         totalWorkingDays / (totalDaysTillToday - totalHolidaysTillToday);
//     print('Total Attendance: $totalAttendance');

//     // Placeholder return, you need to replace this with your actual logic
//     return totalAttendance;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppbarEmp('DashBoard'),
//       body:SingleChildScrollView(child:    Center(
//         child: Column(
//           children: [
//             Container(
//               width: 150,
//               height: 150,
//               margin: EdgeInsets.only(top: 60),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                     color: const Color.fromARGB(255, 243, 181, 89), width: 4),
//                 image: DecorationImage(
//                   image: NetworkImage(widget.imageUrl),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               widget.name,
//               style: TextStyle(
//                 fontSize: 25,
//                 fontFamily: 'Kanit-Bold',
//               ),
//             ),
//             const SizedBox(height: 66),
//             FutureBuilder<double>(
//               future: calculateTotalAttendance(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   // Display a loading indicator while waiting for the result
//                   return CircularProgressIndicator(
//                     strokeWidth: 10,
//                     color: Colors.blue,
//                   );
//                 } else if (snapshot.hasError) {
//                   // Handle error scenario
//                   print('Error: ${snapshot.error}');
//                   return Text('Error'); // Replace with your error UI
//                 } else {
//                   // Display the result when available
//                   double totalAttendance = snapshot.data ?? 0.0;
//                   return Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: 110,
//                         height: 110,
//                         child: CircularProgressIndicator(
//                           value: totalAttendance,
//                           strokeWidth: 10,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       Text(
//                         '${(totalAttendance * 100).toInt()}%',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'TOTAL ATTENDANCE IN THIS MONTH',
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 134, 134, 134)),
//             ),
//             SizedBox(height: 70),
//             FutureBuilder<double>(
//               future: calculateTotalAttendance(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   // Display a loading indicator while waiting for the result
//                   return CircularProgressIndicator(
//                     strokeWidth: 10,
//                     color: const Color.fromARGB(255, 243, 33, 33),
//                   );
//                 } else if (snapshot.hasError) {
//                   // Handle error scenario
//                   print('Error: ${snapshot.error}');
//                   return Text('Error'); // Replace with your error UI
//                 } else {
//                   // Display the result when available
//                   double totalAttendance = snapshot.data ?? 0.0;
//                   return Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: 110,
//                         height: 110,
//                         child: CircularProgressIndicator(
//                           value: totalAttendance,
//                           strokeWidth: 10,
//                           color: const Color.fromARGB(255, 243, 40, 33),
//                         ),
//                       ),
//                       Text(
//                         '${((1-totalAttendance) * 100).toInt()}%',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//              const SizedBox(height: 16),
//             Text(
//               'ON LEAVE',
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,

//                   color: const Color.fromARGB(255, 134, 134, 134)),
//             ),
//             const SizedBox(height: 55),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildCircularProgress(0.75, 'Work From Home'),
//                 const SizedBox(width: 16),
//                 _buildCircularProgress(0.60, 'In Office'),
//                 const SizedBox(width: 16),
//                 _buildCircularProgress(0.90, 'On Leave'),
//               ],
//             ),
//           ],
//         ),
//       ),
//       ),
//     );
//   }
// }
import 'package:attendanaceapp/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashBoard extends StatefulWidget {
  final String id;
  final String name;
  final String imageUrl;
  late List<Map<String, dynamic>> allEmployeeData;

  DashBoard({
    required this.id,
    required this.imageUrl,
    required this.name,
  }) {
    fetchData();
  }

  @override
  State<DashBoard> createState() => _DashBoardState();

  void fetchData() {
    FirebaseFirestore.instance
        .collection('emp_daily_activity')
        .doc('${name}_${id}_dailyactivity')
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        allEmployeeData = data['daily_activity'].cast<Map<String, dynamic>>();
        print('Fetched employee data: $allEmployeeData');
        print("First Phase done ");
      }
    });
  }
}

class _DashBoardState extends State<DashBoard> {
  final List<Map<String, dynamic>> dailyAttendanceData = [];

  Widget _buildCircularProgress(double percentage, String projectName) {
    return Container(); // Placeholder
  }

  Color _getProgressColor(double percentage) {
    return Color.fromARGB(255, 107, 219, 245); // Placeholder
  }

  Future<double> calculateTotalAttendance() async {
    DateTime parseDate(String date) {
      try {
        return DateFormat('yyyy-MMM-dd').parse(date, true);
      } catch (e) {
        print('Error parsing date: $e');
        return DateTime.now(); // Provide a default value or handle the error
      }
    }

    Future<int> fetchHolidays() async {
      try {
        String collectionName = 'holidays';
        String documentId =
            'month_${DateTime.now().month}_${DateTime.now().year}';

        CollectionReference<Map<String, dynamic>> collection =
            FirebaseFirestore.instance.collection(collectionName);

        DocumentSnapshot<Map<String, dynamic>> document =
            await collection.doc(documentId).get();

        if (document.exists && document.data() != null) {
          List<dynamic> holidays = document.data()!['holidays'];
          DateTime today = DateTime.now();
          int totalHolidaysTillToday = 0;

          for (dynamic holiday in holidays) {
            DateTime holidayDate = (holiday['date'] as Timestamp).toDate();
            if (holidayDate.isBefore(today) ||
                holidayDate.isAtSameMomentAs(today)) {
              totalHolidaysTillToday++;
            }
          }

          print('Total holidays till today: $totalHolidaysTillToday');
          return totalHolidaysTillToday;
        } else {
          print('Document does not exist or has no data.');
        }
      } catch (e) {
        print('Error fetching holidays data: $e');
      }
      return 0;
    }

    Future<int> calculateTotalWorkingDays() async {
      try {
        String collectionName = 'emp_daily_activity';
        String documentId = '${widget.name}_${widget.id}_dailyactivity';

        CollectionReference<Map<String, dynamic>> collection =
            FirebaseFirestore.instance.collection(collectionName);

        DocumentSnapshot<Map<String, dynamic>> document =
            await collection.doc(documentId).get();

        if (document.exists &&
            document.data() != null &&
            document.data()!.containsKey('daily_activity')) {
          List<String> workingDays = List<String>.from(document
              .data()!['daily_activity']
              .where((activity) {
                DateTime date = parseDate(activity['date']);
                return date.month == DateTime.now().month &&
                    date.day <= DateTime.now().day;
              })
              .map<String>((activity) => activity['date'] as String)
              .toSet());

          int totalWorkingDays = workingDays.length;

          print('Total Working Days: $totalWorkingDays');

          return totalWorkingDays;
        }
      } catch (e) {
        print('Error fetching employee data: $e');
      }

      return 0;
    }

    try {
      int totalHolidaysTillToday = await fetchHolidays();
      int totalWorkingDays = await calculateTotalWorkingDays();
      int totalDaysTillToday = DateTime.now().day;
      // int thisMonthDays = getNumberOfDaysInMonth();

      print('Total Days Till Today: $totalDaysTillToday');
      print('Total Working days till today: $totalWorkingDays');
      print('total Holidays till today :$totalHolidaysTillToday');

      double totalAttendance =
          totalWorkingDays / (totalDaysTillToday - totalHolidaysTillToday);

      print('Total Attendance: $totalAttendance');
      if (totalAttendance > 1) {
        totalAttendance = 1;
      } else if (totalAttendance < 0) {
        totalAttendance = 0;
      } else {
        totalAttendance = totalAttendance;
      }

      return totalAttendance;
    } catch (e) {
      print('Error calculating total attendance: $e');
    }

    return 0; // Return a default value in case of errors
  }

  Future<Map<String, Duration>> calculateProjectWiseHours() async {
    Map<String, Duration> projectDurationMap = {};

    try {
      // Replace 'emp_daily_activity' with your actual collection name
      String collectionName = 'emp_daily_activity';
      String documentId = '${widget.name}_${widget.id}_dailyactivity';

      // Inline Firestore query
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection(collectionName);

      DocumentSnapshot<Map<String, dynamic>> document =
          await collection.doc(documentId).get();

      if (document.exists &&
          document.data() != null &&
          document.data()!.containsKey('daily_activity')) {
        List<dynamic> dailyActivities = document.data()!['daily_activity'];

        for (var dayData in dailyActivities) {
          for (var project in dayData['projects']) {
            String projectName = project['name'];
            String checkinTime = project['login'] ?? '';
            String checkoutTime = project['logout'] ?? '';

            if (checkinTime.isNotEmpty && checkoutTime.isNotEmpty) {
              DateTime checkin = DateTime.parse('2022-01-01 $checkinTime');
              DateTime checkout = DateTime.parse('2022-01-01 $checkoutTime');

              Duration durationWorked = checkout.difference(checkin);

              projectDurationMap[projectName] =
                  (projectDurationMap[projectName] ?? Duration.zero) +
                      durationWorked;
            }
          }
        }
      }
    } catch (e) {
      print('Error calculating project-wise hours: $e');
    }

    return projectDurationMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarAdmin('DashBoard'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.only(left: 20, top: 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Color.fromARGB(255, 79, 224, 243), width: 4),
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 26),
                  Padding(
                    padding: EdgeInsets.only(top: 68.0),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Kanit-Bold',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 66),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Widget 1 (Total Attendance)
                  Column(
                    children: [
                      FutureBuilder<double>(
                        future: calculateTotalAttendance(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              strokeWidth: 10,
                              color: Colors.blue,
                            );
                          } else if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                            return Text('Error');
                          } else {
                            double totalAttendance = snapshot.data ?? 0.0;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: CircularProgressIndicator(
                                    value: totalAttendance,
                                    strokeWidth: 10,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  '${(totalAttendance * 100).toInt()}%',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'TOTAL ATTENDANCE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 134, 134, 134)),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                  // Widget 2 (On Leave)
                  Column(
                    children: [
                      FutureBuilder<double>(
                        future: calculateTotalAttendance(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              strokeWidth: 10,
                              color: const Color.fromARGB(255, 243, 33, 33),
                            );
                          } else if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                            return Text('Error');
                          } else {
                            double invertedAttendance = 1.0 - (snapshot.data ?? 0.0);
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: CircularProgressIndicator(
                                    value:invertedAttendance,
                                    strokeWidth: 10,
                                    color:
                                        const Color.fromARGB(255, 243, 40, 33),
                                  ),
                                ),
                                Text(
                                  '${((invertedAttendance) * 100).toInt()}%',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ON LEAVE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 134, 134, 134)),
                      ),
                      const SizedBox(height: 55),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Time Worked on Each Project:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanti-Bold'),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Adjust the radius as needed
                ),
                // Adjust the elevation as needed
                // color: Color.fromARGB(255, 56, 215, 233)
                // .withOpacity(0.1), // Adjust the background color as needed
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<Map<String, Duration>>(
                    future: calculateProjectWiseHours(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          strokeWidth: 10,
                          color: Colors.green, // You can change the color
                        );
                      } else if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Text('Error');
                      } else {
                        Map<String, Duration> projectDurationMap =
                            snapshot.data ?? {};
                        return Column(
                          children: projectDurationMap.entries
                              .map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ' ${entry.key}: ${entry.value.inHours} hours ${entry.value.inMinutes.remainder(60)} minutes',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
