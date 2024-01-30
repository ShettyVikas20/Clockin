// import 'package:flutter/material.dart';

// class ViewMore extends StatelessWidget {
//   final List<Map<String, dynamic>> allEmployeeData;

//   ViewMore({required this.allEmployeeData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('View More Page'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'All Employee Data:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             for (var dayData in allEmployeeData) ...[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Date: ${dayData['date']}',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               for (var project in dayData['projects']) ...[
//                 ListTile(
//                   title: Text(project['name'] ?? 'Unknown Project'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Check-in Time: ${project['login'] ?? ''}'),
//                       Text('Check-out Time: ${project['logout'] ?? ''}'),
//                       Text('Notes: ${project['notes'] ?? ''}'),
//                       Divider(),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:attendanaceapp/components/app_bar.dart';
// import 'package:flutter/material.dart';

// class AnalyticsDashboard extends StatelessWidget {
// final List<Map<String, dynamic>> allEmployeeData;

//   AnalyticsDashboard({required this.allEmployeeData});

//   @override
//   Widget build(BuildContext context) {
//     Map<String, Duration> projectDurationMap = {};

//     // Calculate total hours for each project
//     for (var dayData in allEmployeeData) {
//       for (var project in dayData['projects']) {
//         String projectName = project['name'];
//         String checkinTime = project['login'] ?? '';
//         String checkoutTime = project['logout'] ?? '';

//         if (checkinTime.isNotEmpty && checkoutTime.isNotEmpty) {
//           // Print debug information
//           print('Project Name: $projectName');
//           print('Checkin Time: $checkinTime');
//           print('Checkout Time: $checkoutTime');

//           DateTime checkin = DateTime.parse('2022-01-01 $checkinTime');
//           DateTime checkout = DateTime.parse('2022-01-01 $checkoutTime');

//           // Print debug information
//           print('Parsed Checkin Time: $checkin');
//           print('Parsed Checkout Time: $checkout');

//           // Calculate time difference
//           Duration durationWorked = checkout.difference(checkin);

//           // Print debug information
//           print('Duration Worked: $durationWorked');

//           // Update total duration for the project
//           projectDurationMap[projectName] =
//               (projectDurationMap[projectName] ?? Duration.zero) + durationWorked;
//         }
//       }
//     }

//     // Print final project duration map for debugging
//     print('Final Project Duration Map: $projectDurationMap');

//     return Scaffold(
//       appBar: AppbarAdmin(
//        'Analytics Dashboard'),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Total Time Worked on Each Project:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             for (var entry in projectDurationMap.entries) ...[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Project ${entry.key}: ${entry.value.inHours} hours ${entry.value.inMinutes.remainder(60)} minutes',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:attendanaceapp/components/app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class AnalyticsDashboard extends StatelessWidget {
//   final List<Map<String, dynamic>> allEmployeeData;
//   final String employeeId;

//   AnalyticsDashboard({required this.allEmployeeData, required this.employeeId});

//   @override
//   Widget build(BuildContext context) {
//     Map<String, Duration> projectDurationMap = {};
//     Map<String, int> attendanceMap = {};

//     DateTime now = DateTime.now();
//     int currentMonth = now.month;
//     int currentYear = now.year;
//     int currentDay = now.day;

//     DateFormat dateFormat = DateFormat('yyyy-MMM-dd HH:mm');

//     List<String> holidays = [];

//     return FutureBuilder<Map<String, dynamic>?>(
//       future: fetchHolidaysData('holidays', 'month_${currentMonth}_$currentYear'),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // You can return a loading indicator here if needed
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // Handle errors
//           print('Error fetching holidays: ${snapshot.error}');
//           return Text('Error fetching holidays');
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           // Handle the case where data is not available
//           return Text('No holidays data available');
//         } else {
//           // Data is available, proceed with the build
//           Map<String, dynamic>? holidaysData = snapshot.data;

//           // Calculate total working days by subtracting holidays
//           int totalDaysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
//           int totalHolidaysTillToday = 0;

//           for (int day = 1; day <= currentDay; day++) {
//             DateTime currentDate = DateTime(currentYear, currentMonth, day);
//             String formattedDate = dateFormat.format(currentDate);

//             // Check if the current day is a holiday
//             if (holidaysData!.containsKey('holidays') &&
//                 holidaysData['holidays'].contains(formattedDate)) {
//               totalHolidaysTillToday++;
//             }
//           }

//           int totalWorkingDays = totalDaysInMonth - totalHolidaysTillToday;

//           print('Total Working Days in the Current Month: $totalWorkingDays');

//           for (var dayData in allEmployeeData) {
//             for (var project in dayData['projects']) {
//               String projectName = project['name'];
//               String checkinTime = project['login'] ?? '';
//               String logoutTime = project['logout'] ?? '';

//               if (checkinTime.isNotEmpty && logoutTime.isNotEmpty) {
//                 String checkinDateTimeString = '${dayData['date']} $checkinTime';
//                 String logoutDateTimeString = '${dayData['date']} $logoutTime';

//                 print('Checkin DateTime String: $checkinDateTimeString');
//                 print('Logout DateTime String: $logoutDateTimeString');

//                 try {
//                   DateTime checkin = dateFormat.parse(checkinDateTimeString);
//                   DateTime logout = dateFormat.parse(logoutDateTimeString);

//                   print('Parsed Checkin Time: $checkin');
//                   print('Parsed Logout Time: $logout');

//                   Duration durationWorked = logout.difference(checkin);

//                   print('Duration Worked: $durationWorked');

//                   projectDurationMap[projectName] =
//                       (projectDurationMap[projectName] ?? Duration.zero) +
//                           durationWorked;

//                   attendanceMap[dayData['date']] =
//                       (attendanceMap[dayData['date']] ?? 0) + 1;
//                 } catch (e) {
//                   print('Error parsing date: $e');
//                   print('$checkinDateTimeString');
//                 }
//               }
//             }
//           }

//           print('Final Project Duration Map: $projectDurationMap');
//           print('Attendance Map: $attendanceMap');

//           Duration totalWorkingHours =
//               projectDurationMap.values.reduce((value, element) => value + element);
//           print('Total Working Hours: $totalWorkingHours');

//           double attendancePercentage =
//               (attendanceMap.length / totalWorkingDays) * 100;
//           print('Total Working Days: $totalWorkingDays');
//           print('Attendance Percentage: $attendancePercentage');

//           return Scaffold(
//             appBar: AppbarAdmin('Analytics Dashboard'),
//             body: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Total Time Worked on Each Project:',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   for (var entry in projectDurationMap.entries) ...[
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Project ${entry.key}: ${entry.value.inHours} hours ${entry.value.inMinutes.remainder(60)} minutes',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Future<Map<String, dynamic>?> fetchHolidaysData(
//       String collectionName, String documentId) async {
//     try {
//       CollectionReference<Map<String, dynamic>> collection =
//           FirebaseFirestore.instance.collection(collectionName);

//       DocumentSnapshot<Map<String, dynamic>> document =
//           await collection.doc(documentId).get();

//       if (document.exists) {
//         return document.data();
//       } else {
//         print('Document does not exist');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching holidays data: $e');
//       return null;
//     }
//   }
// }
