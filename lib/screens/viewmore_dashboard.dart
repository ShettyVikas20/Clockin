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



import 'package:flutter/material.dart';

class AnalyticsDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> allEmployeeData;

  AnalyticsDashboard({required this.allEmployeeData});

  @override
  Widget build(BuildContext context) {
    Map<String, Duration> projectDurationMap = {};

    // Calculate total hours for each project
    for (var dayData in allEmployeeData) {
      for (var project in dayData['projects']) {
        String projectName = project['name'];
        String checkinTime = project['login'] ?? '';
        String checkoutTime = project['logout'] ?? '';

        if (checkinTime.isNotEmpty && checkoutTime.isNotEmpty) {
          // Print debug information
          print('Project Name: $projectName');
          print('Checkin Time: $checkinTime');
          print('Checkout Time: $checkoutTime');

          DateTime checkin = DateTime.parse('2022-01-01 $checkinTime');
          DateTime checkout = DateTime.parse('2022-01-01 $checkoutTime');

          // Print debug information
          print('Parsed Checkin Time: $checkin');
          print('Parsed Checkout Time: $checkout');

          // Calculate time difference
          Duration durationWorked = checkout.difference(checkin);

          // Print debug information
          print('Duration Worked: $durationWorked');

          // Update total duration for the project
          projectDurationMap[projectName] =
              (projectDurationMap[projectName] ?? Duration.zero) + durationWorked;
        }
      }
    }

    // Print final project duration map for debugging
    print('Final Project Duration Map: $projectDurationMap');

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Time Worked on Each Project:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            for (var entry in projectDurationMap.entries) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Project ${entry.key}: ${entry.value.inHours} hours ${entry.value.inMinutes.remainder(60)} minutes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
