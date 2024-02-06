
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
// import 'package:intl/intl.dart';

// class Holiday {
//   final DateTime date;
//   final String description;

//   Holiday({required this.date, required this.description});
// }

// class EntireEmployeeHistroryInCalender extends StatefulWidget {
//   final String employeeId;
//   final String employeeName;

//   EntireEmployeeHistroryInCalender({
//     required this.employeeId,
//     required this.employeeName,
//   });

//   @override
//   _EntireEmployeeHistroryInCalenderState createState() =>
//       _EntireEmployeeHistroryInCalenderState();
// }

// class _EntireEmployeeHistroryInCalenderState
//     extends State<EntireEmployeeHistroryInCalender> {
//   int _attendancePercentage = 0;
//   int _leavePercentage = 0;
//   List<DateTime> holidayDates = [];

//   DateTime _currentDate = DateTime.now();
//   DateTime _targetDateTime = DateTime.now();
//   List<List<Map<String, dynamic>>> _monthlyData = [];

//   // Placeholder for fetching data from Firebase for the specified month
//   void _fetchDataForMonth(DateTime targetDateTime) async {
//     // Get the start and end dates of the month
//     DateTime startDate = DateTime(targetDateTime.year, targetDateTime.month, 1);
//     DateTime endDate = DateTime(
//       targetDateTime.year,
//       targetDateTime.month + 1,
//       0,
//     );

//     int totalDaysInMonth = endDate.day;
//     // Only initialize _monthlyData if it's empty or has a different length
//     // Only initialize _monthlyData if it's empty or has a different length
//     if (_monthlyData.isEmpty || _monthlyData.length != totalDaysInMonth) {
//       _monthlyData = List.generate(
//         totalDaysInMonth,
//         (index) => [],
//       );
//     }

//     // Format dates to match Firestore date format
//     String startFormatted = DateFormat('yyyy-MMM-dd').format(startDate);
//     String endFormatted = DateFormat('yyyy-MMM-dd').format(endDate);

//     // Build the document reference
//     String documentId =
//         '${widget.employeeName}_${widget.employeeId}_dailyactivity';
//     DocumentReference<Map<String, dynamic>> documentReference =
//         FirebaseFirestore.instance
//             .collection('emp_daily_activity')
//             .doc(documentId);

//     try {
//       // Fetch data from Firestore for the specified month
//       DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//           await documentReference.get();

//       // Clear any previous data in _monthlyData
//       _monthlyData.forEach((dayData) => dayData.clear());
//       print('_monthlyData:$_monthlyData');

//       // Check if the document exists
//       if (documentSnapshot.exists) {
//         // Extract daily activities from the document
//         List<dynamic> dailyActivities =
//             documentSnapshot.data()!['daily_activity'];

//         // Process daily activities
//         if (dailyActivities != null) {
//           for (var activity in dailyActivities) {
//             String activityDate = activity['date'];

//             // Check if the activity date is within the target month
//             if (activityDate.compareTo(startFormatted) >= 0 &&
//                 activityDate.compareTo(endFormatted) <= 0) {
//               // Parse the date to get the day
//               int day = DateFormat('yyyy-MMM-dd').parse(activityDate).day;

//               // Append the activity to the corresponding day's data
//               if (day >= 1 && day <= _monthlyData.length) {
//                 _monthlyData[day - 1].add(activity);
//                 print('activity: $activity');
//               } else {
//                 print('Invalid day: $day');
//               }
//             }
//           }
//         }
//       }

//       // Debugging: Print the fetched data
//       for (int i = 0; i < _monthlyData.length; i++) {
//         print('Day ${i + 1} activities: ${_monthlyData[i]}');
//       }
//       print('_monthlyData.length:${_monthlyData.length}');

//       // Update circular progress bars based on fetched data
//       _updateProgressBars(_monthlyData, targetDateTime);
//     } catch (e) {
//       print('Error fetching data: $e');
//       // Handle errors gracefully, e.g., show an error message to the user
//     }
//   }

//   // Placeholder for updating circular progress bars
//   Future<void> _updateProgressBars(List<List<Map<String, dynamic>>> monthlyData,
//       DateTime targetDateTime) async {
//     // Get the total number of days in the target month
//     int totalDaysInMonth = DateTime(
//       _targetDateTime.year,
//       _targetDateTime.month + 1,
//       0,
//     ).day;

//     // Ensure that the size of _monthlyData matches the total days in the month
//     if (_monthlyData.length != totalDaysInMonth) {
//       print('Error: _monthlyData size does not match total days in month.');
//       return;
//     }
//     print('monthlyData in progress bar"${monthlyData.length}');

//     // Initialize variables for attendance and leave calculation
//     int totalPresentDays = 0;
//     List<DateTime> holidayDates = []; // Store holiday dates

//     // Placeholder for actual holidays data
//     List<Map<String, dynamic>> holidays =
//         await _getHolidaysForMonth(targetDateTime.month, targetDateTime.year);

//     // Extract holiday dates
//     holidayDates = holidays
//         .map((holiday) => (holiday['date'] as Timestamp)
//             .toDate()
//             .toLocal()) // Convert to local DateTime
//         .toList();

//     // Iterate through each day's data
//     for (List<Map<String, dynamic>> dayData in monthlyData) {
//       // Check if the day has any activities
//       if (dayData.isNotEmpty) {
//         print('day date length is :${dayData.length}');
//         // Increment totalPresentDays for each day with activities
//         totalPresentDays++;
//       }
//     }

//     // Calculate attendance and leave percentages
//     int attendance =
//         ((totalPresentDays / (totalDaysInMonth - holidayDates.length)) * 100)
//             .round();
//     int leave = 100 - attendance;

//     // Update the state to trigger a rebuild with the actual values
//     setState(() {
//       _attendancePercentage = attendance;
//       _leavePercentage = leave;
//     });

//     // Debugging: Print calculated values
//     print('Total Days in Month: $totalDaysInMonth');
//     print('Total Present Days: $totalPresentDays');
//     print('Total Holidays: ${holidayDates.length}');
//     print('Attendance: $attendance%');
//     print('Leave: $leave%');

//     // Now you have the list of holiday dates in the `holidayDates` variable
//     // You can use this list in your customDayBuilder to mark these dates differently
//     // using the `isHoliday` check.
//   }

//   Future<List<Map<String, dynamic>>> _getHolidaysForMonth(
//       int targetMonth, int targetYear) async {
//     // Get the start and end dates of the target month
//     print('targetMonth: $targetMonth, targetYear: $targetYear');

//     try {
//       // Query holidays collection for the target month
//       String collectionName = 'holidays';
//       String documentId = 'month_${targetMonth}_$targetYear';

//       DocumentReference<Map<String, dynamic>> documentReference =
//           FirebaseFirestore.instance.collection(collectionName).doc(documentId);

//       DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//           await documentReference.get();

//       // Check if the document exists
//       if (!documentSnapshot.exists) {
//         print('No document found for the query.');
//         return [];
//       }

//       // Extract holidays data
//       Map<String, dynamic> holidaysData = documentSnapshot.data()!;
//     dynamic holidaysDynamic = holidaysData['holidays'];

//     // Explicitly cast the 'holidays' field to List<Map<String, dynamic>>
//     List<Map<String, dynamic>> holidays =
//         (holidaysDynamic as List<dynamic>).cast<Map<String, dynamic>>();

//     // Update the holidayDates list with the extracted holiday dates
//     holidayDates = holidays.map<DateTime>((holiday) {
//       return (holiday['date'] as Timestamp).toDate();
//     }).toList();

//     print('holidays length is: ${holidays.length}');
//     print('holidays of the months are:$holidayDates');
//     print('holidays of the months:$holidays');

//     return holidays;
//   } catch (e) {
//     print('Error fetching holidays: $e');
//     return [];
//     }
//   }

//   // Placeholder for handling day tap
//   void _handleDayTap(DateTime selectedDate) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: _buildDetailsContainer(selectedDate),
//         );
//       },
//     );
//   }

//   Widget _buildDetailsContainer(DateTime selectedDate) {
//     var projectsForSelectedDate = _monthlyData[selectedDate.day - 1];

//     return projectsForSelectedDate.isNotEmpty
//         ? ListView.builder(
//             itemCount: projectsForSelectedDate.length,
//             itemBuilder: (context, index) {
//               var project = projectsForSelectedDate[index];
//               String checkinLocationString = project['checkin_location'] ?? '';
//               String checkoutLocationString = project['checkout_location'] ?? '';

//               // ... (remaining code for fetching and displaying project details)

//               return Container(
//                 // ... (your existing code for displaying project details)
//               );
//             },
//           )
//         : Text('No activities for selected date');
//   }



//   bool isDateHoliday(DateTime date, List<DateTime> holidayDates) {
//     return holidayDates.contains(date);
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Initialize _monthlyData with the correct number of days
//     _monthlyData = List.generate(
//       DateTime(_targetDateTime.year, _targetDateTime.month + 1, 0).day,
//       (index) => [],
//     );
//     // Fetch data for the initial month
//     _fetchDataForMonth(_targetDateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance Calendar'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               height: 90,
//               margin: EdgeInsets.only(top: 70, left: 16.0, right: 16.0),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: Text(
//                       DateFormat.yMMM().format(_targetDateTime),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Kanit-Bold',
//                         fontSize: 24.0,
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     child: Text('PREV'),
//                     onPressed: () {
//                       setState(() {
//                         _targetDateTime = DateTime(
//                           _targetDateTime.year,
//                           _targetDateTime.month - 1,
//                         );
//                         _fetchDataForMonth(_targetDateTime);
//                       });
//                     },
//                   ),
//                   TextButton(
//                     child: Text('NEXT'),
//                     onPressed: () {
//                       setState(() {
//                         _targetDateTime = DateTime(
//                           _targetDateTime.year,
//                           _targetDateTime.month + 1,
//                         );
//                         _fetchDataForMonth(_targetDateTime);
//                       });
//                     },
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 16.0),
//               child: CalendarCarousel(
//                   todayBorderColor: Color.fromARGB(255, 2, 15, 24),
//                   showOnlyCurrentMonthDate: false,
//                   weekendTextStyle: TextStyle(
//                     color: Colors.black,
//                   ),
//                   thisMonthDayBorderColor: Colors.grey,
//                   weekFormat: false,
//                   height: 420.0,
//                   selectedDateTime: _currentDate,
//                   targetDateTime: _targetDateTime,
//                   customGridViewPhysics: NeverScrollableScrollPhysics(),
//                   showHeader: false,
//                   todayTextStyle: TextStyle(
//                     color: Color.fromARGB(255, 255, 255, 255),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   todayButtonColor: Color.fromARGB(255, 145, 176, 243),
//                   selectedDayButtonColor: Colors.orange,
//                   selectedDayBorderColor: Colors.black,
//                   selectedDayTextStyle: TextStyle(
//                     color: Color.fromARGB(255, 255, 255, 255),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   minSelectedDate: _currentDate.subtract(Duration(days: 360)),
//                   maxSelectedDate: _currentDate.add(Duration(days: 360)),
//                   prevDaysTextStyle: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                   inactiveDaysTextStyle: TextStyle(
//                     color: Colors.tealAccent,
//                     fontSize: 16,
//                   ),
//                   onCalendarChanged: (DateTime date) {
//                     setState(() {
//                       _targetDateTime = date;
//                       _fetchDataForMonth(date);
//                     });
//                   },
//                   onDayPressed: (DateTime date, List events) {
//                     _handleDayTap(date);
//                   },
//                   // Add the customDayBuilder here
//                   customDayBuilder: (
//                     bool isSelectable,
//                     int index,
//                     bool isSelectedDay,
//                     bool isToday,
//                     bool isPrevMonthDay,
//                     TextStyle textStyle,
//                     bool isNextMonthDay,
//                     bool isThisMonthDay,
//                     DateTime day,
//                   ) {
//                     int dayNumber = day.day;

//                     if (isThisMonthDay) {
//                       // Only style and display days of the current month
//                       bool isPresent = _monthlyData[dayNumber - 1].isNotEmpty;
//                       bool isHoliday = isDateHoliday(day, holidayDates);

//                       if (isPresent) {
//                         // Mark present days in green
//                         return Center(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 '$dayNumber',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       } else if (isHoliday) {
//                         // Mark holidays in a different color
//                         return Center(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Color.fromARGB(255, 14, 46, 225), // Use your desired color for holidays
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 '$dayNumber',
//                                 style: TextStyle(
//                                   color: Color.fromARGB(255, 213, 216, 240),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       } else {
//                         // Mark absent days in red
//                         return Center(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Color.fromARGB(255, 234, 17, 5),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 '$dayNumber',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//                     } else {
//                       // Display empty container for days outside the current month
//                       return Container();
//                     }
//                   }),
//             ),
//             // Circular progress bars for attendance and leave
//             Container(
//               margin: EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildCircularProgressBar(
//                     label: 'Attendance',
//                     value: _attendancePercentage,
//                     color: Colors.green,
//                   ),
//                   _buildCircularProgressBar(
//                     label: 'Leave',
//                     value: _leavePercentage,
//                     color: Colors.red,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCircularProgressBar({
//     required String label,
//     required int value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 8.0),
//         CircularProgressIndicator(
//           value: value / 100,
//           color: color,
//         ),
//         SizedBox(height: 8.0),
//         Text('$value%'),
//       ],
//     );
//   }
// }







import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Holiday {
  final DateTime date;
  final String description;

  Holiday({required this.date, required this.description});
}

class EntireEmployeeHistroryInCalender extends StatefulWidget {
  final String employeeId;
  final String employeeName;

  EntireEmployeeHistroryInCalender({
    required this.employeeId,
    required this.employeeName,
  });

  @override
  _EntireEmployeeHistroryInCalenderState createState() =>
      _EntireEmployeeHistroryInCalenderState();
}

class _EntireEmployeeHistroryInCalenderState
    extends State<EntireEmployeeHistroryInCalender> {
  int _attendancePercentage = 0;
  int _leavePercentage = 0;
  List<DateTime> holidayDates = [];

  DateTime _currentDate = DateTime.now();
  DateTime _targetDateTime = DateTime.now();
  List<List<Map<String, dynamic>>> _monthlyData = [];

  // Placeholder for fetching data from Firebase for the specified month
  void _fetchDataForMonth(DateTime targetDateTime) async {
    // Get the start and end dates of the month
    DateTime startDate = DateTime(targetDateTime.year, targetDateTime.month, 1);
    DateTime endDate = DateTime(
      targetDateTime.year,
      targetDateTime.month + 1,
      0,
    );

    int totalDaysInMonth = endDate.day;
    // Only initialize _monthlyData if it's empty or has a different length
    // Only initialize _monthlyData if it's empty or has a different length
    if (_monthlyData.isEmpty || _monthlyData.length != totalDaysInMonth) {
      _monthlyData = List.generate(
        totalDaysInMonth,
        (index) => [],
      );
    }

    // Format dates to match Firestore date format
    String startFormatted = DateFormat('yyyy-MMM-dd').format(startDate);
    String endFormatted = DateFormat('yyyy-MMM-dd').format(endDate);

    // Build the document reference
    String documentId =
        '${widget.employeeName}_${widget.employeeId}_dailyactivity';
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection('emp_daily_activity')
            .doc(documentId);

    try {
      // Fetch data from Firestore for the specified month
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await documentReference.get();

      // Clear any previous data in _monthlyData
      _monthlyData.forEach((dayData) => dayData.clear());
      print('_monthlyData:$_monthlyData');

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Extract daily activities from the document
        List<dynamic> dailyActivities =
            documentSnapshot.data()!['daily_activity'];

        // Process daily activities
        if (dailyActivities != null) {
          for (var activity in dailyActivities) {
            String activityDate = activity['date'];

            // Check if the activity date is within the target month
            if (activityDate.compareTo(startFormatted) >= 0 &&
                activityDate.compareTo(endFormatted) <= 0) {
              // Parse the date to get the day
              int day = DateFormat('yyyy-MMM-dd').parse(activityDate).day;

              // Append the activity to the corresponding day's data
              if (day >= 1 && day <= _monthlyData.length) {
                _monthlyData[day - 1].add(activity);
                print('activity: $activity');
              } else {
                print('Invalid day: $day');
              }
            }
          }
        }
      }

      // Debugging: Print the fetched data
      for (int i = 0; i < _monthlyData.length; i++) {
        print('Day ${i + 1} activities: ${_monthlyData[i]}');
      }
      print('_monthlyData.length:${_monthlyData.length}');

      // Update circular progress bars based on fetched data
      _updateProgressBars(_monthlyData, targetDateTime);
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors gracefully, e.g., show an error message to the user
    }
  }

  // Placeholder for updating circular progress bars
  Future<void> _updateProgressBars(List<List<Map<String, dynamic>>> monthlyData,
      DateTime targetDateTime) async {
    // Get the total number of days in the target month
    int totalDaysInMonth = DateTime(
      _targetDateTime.year,
      _targetDateTime.month + 1,
      0,
    ).day;

    // Ensure that the size of _monthlyData matches the total days in the month
    if (_monthlyData.length != totalDaysInMonth) {
      print('Error: _monthlyData size does not match total days in month.');
      return;
    }
    print('monthlyData in progress bar"${monthlyData.length}');

    // Initialize variables for attendance and leave calculation
    int totalPresentDays = 0;
    List<DateTime> holidayDates = []; // Store holiday dates

    // Placeholder for actual holidays data
    List<Map<String, dynamic>> holidays =
        await _getHolidaysForMonth(targetDateTime.month, targetDateTime.year);

    // Extract holiday dates
    holidayDates = holidays
        .map((holiday) => (holiday['date'] as Timestamp)
            .toDate()
            .toLocal()) // Convert to local DateTime
        .toList();

    // Iterate through each day's data
    for (List<Map<String, dynamic>> dayData in monthlyData) {
      // Check if the day has any activities
      if (dayData.isNotEmpty) {
        print('day date length is :${dayData.length}');
        // Increment totalPresentDays for each day with activities
        totalPresentDays++;
      }
    }

    // Calculate attendance and leave percentages
    int attendance =
        ((totalPresentDays / (totalDaysInMonth - holidayDates.length)) * 100)
            .round();
    int leave = 100 - attendance;

    // Update the state to trigger a rebuild with the actual values
    setState(() {
      _attendancePercentage = attendance;
      _leavePercentage = leave;
    });

    // Debugging: Print calculated values
    print('Total Days in Month: $totalDaysInMonth');
    print('Total Present Days: $totalPresentDays');
    print('Total Holidays: ${holidayDates.length}');
    print('Attendance: $attendance%');
    print('Leave: $leave%');

    // Now you have the list of holiday dates in the `holidayDates` variable
    // You can use this list in your customDayBuilder to mark these dates differently
    // using the `isHoliday` check.
  }

  Future<List<Map<String, dynamic>>> _getHolidaysForMonth(
      int targetMonth, int targetYear) async {
    // Get the start and end dates of the target month
    print('targetMonth: $targetMonth, targetYear: $targetYear');

    try {
      // Query holidays collection for the target month
      String collectionName = 'holidays';
      String documentId = 'month_${targetMonth}_$targetYear';

      DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance.collection(collectionName).doc(documentId);

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await documentReference.get();

      // Check if the document exists
      if (!documentSnapshot.exists) {
        print('No document found for the query.');
        return [];
      }

      // Extract holidays data
      Map<String, dynamic> holidaysData = documentSnapshot.data()!;
    dynamic holidaysDynamic = holidaysData['holidays'];

    // Explicitly cast the 'holidays' field to List<Map<String, dynamic>>
    List<Map<String, dynamic>> holidays =
        (holidaysDynamic as List<dynamic>).cast<Map<String, dynamic>>();

    // Update the holidayDates list with the extracted holiday dates
    holidayDates = holidays.map<DateTime>((holiday) {
      return (holiday['date'] as Timestamp).toDate();
    }).toList();

    print('holidays length is: ${holidays.length}');
    print('holidays of the months are:$holidayDates');
    print('holidays of the months:$holidays');

    return holidays;
  } catch (e) {
    print('Error fetching holidays: $e');
    return [];
    }
  }

  // Placeholder for handling day tap
  void _handleDayTap(DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _buildDetailsContainer(selectedDate),
        );
      },
    );
  }
Widget _buildDetailsContainer(DateTime selectedDate) {
  var projectsForSelectedDate = _monthlyData[selectedDate.day - 1];

  if (projectsForSelectedDate.isEmpty) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'No activity',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  return SingleChildScrollView(
    child: Column(
      children: projectsForSelectedDate.map((day) {
        var projects = day['projects'] as List<dynamic>;

        return Column(
          children: projects.map((project) {
            String checkinLocationString = project['checkin_location'] ?? '';
            String checkoutLocationString = project['checkout_location'] ?? '';

            List<String> checkinCoordinates = checkinLocationString.split(', ');
            List<String> checkoutCoordinates = checkoutLocationString.split(', ');

            double checkinLatitude = double.parse(checkinCoordinates[0].split(': ')[1]);
            double checkinLongitude = double.parse(checkinCoordinates[1].split(': ')[1]);

            double checkoutLatitude = double.parse(checkoutCoordinates[0].split(': ')[1]);
            double checkoutLongitude = double.parse(checkoutCoordinates[1].split(': ')[1]);

            return Builder(
              builder: (BuildContext context) {
                return FutureBuilder<String?>(
                  future: getLocationString(checkinLatitude, checkinLongitude),
                  builder: (context, checkinSnapshot) {
                    if (checkinSnapshot.connectionState == ConnectionState.waiting) {
                      return Transform.translate(
                        offset: Offset(10.0, 0.0),
                        child: Transform.scale(
                          scale: 0.1,
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              strokeWidth: 1.0,
                            ),
                          ),
                        ),
                      );
                    } else if (checkinSnapshot.hasError) {
                      return Text('Error loading check-in location');
                    } else {
                      String? checkinLocation = checkinSnapshot.data;

                      return FutureBuilder<String?>(
                        future: getLocationString(checkoutLatitude, checkoutLongitude),
                        builder: (context, checkoutSnapshot) {
                          if (checkoutSnapshot.connectionState == ConnectionState.waiting) {
                            return Transform.translate(
                              offset: Offset(10.0, 0.0),
                              child: Transform.scale(
                                scale: 0.1,
                                child: SizedBox(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              ),
                            );
                          } else if (checkoutSnapshot.hasError) {
                            return Text('Error loading checkout location');
                          } else {
                            String? checkoutLocation = checkoutSnapshot.data;

                            return Container(
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  project['name'] ?? 'Unknown Project',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Kanit-Bold',
                                    fontSize: 17,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Check-In Time: ${project['login'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Check-In Location: ${checkinLocation ?? 'Unknown Location'}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Check-Out Time: ${project['logout'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Check-Out Location: ${checkoutLocation ?? 'Unknown Location'}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Notes: ${project['notes'] ?? ''}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
          }).toList(),
        );
      }).toList(),
    ),
  );
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



  bool isDateHoliday(DateTime date, List<DateTime> holidayDates) {
    return holidayDates.contains(date);
  }

  @override
  void initState() {
    super.initState();
    // Initialize _monthlyData with the correct number of days
    _monthlyData = List.generate(
      DateTime(_targetDateTime.year, _targetDateTime.month + 1, 0).day,
      (index) => [],
    );
    // Fetch data for the initial month
    _fetchDataForMonth(_targetDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 90,
              margin: EdgeInsets.only(top: 70, left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      DateFormat.yMMM().format(_targetDateTime),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit-Bold',
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text('PREV'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                          _targetDateTime.year,
                          _targetDateTime.month - 1,
                        );
                        _fetchDataForMonth(_targetDateTime);
                      });
                    },
                  ),
                  TextButton(
                    child: Text('NEXT'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                          _targetDateTime.year,
                          _targetDateTime.month + 1,
                        );
                        _fetchDataForMonth(_targetDateTime);
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: CalendarCarousel(
                  todayBorderColor: Color.fromARGB(255, 2, 15, 24),
                  showOnlyCurrentMonthDate: false,
                  weekendTextStyle: TextStyle(
                    color: Colors.black,
                  ),
                  thisMonthDayBorderColor: Colors.grey,
                  weekFormat: false,
                  height: 420.0,
                  selectedDateTime: _currentDate,
                  targetDateTime: _targetDateTime,
                  customGridViewPhysics: NeverScrollableScrollPhysics(),
                  showHeader: false,
                  todayTextStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                  todayButtonColor: Color.fromARGB(255, 145, 176, 243),
                  selectedDayButtonColor: Colors.orange,
                  selectedDayBorderColor: Colors.black,
                  selectedDayTextStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                  minSelectedDate: _currentDate.subtract(Duration(days: 360)),
                  maxSelectedDate: _currentDate.add(Duration(days: 360)),
                  prevDaysTextStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  inactiveDaysTextStyle: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 16,
                  ),
                  onCalendarChanged: (DateTime date) {
                    setState(() {
                      _targetDateTime = date;
                      _fetchDataForMonth(date);
                    });
                  },
                  onDayPressed: (DateTime date, List events) {
                    _handleDayTap(date);
                  },
                  // Add the customDayBuilder here
                  customDayBuilder: (
                    bool isSelectable,
                    int index,
                    bool isSelectedDay,
                    bool isToday,
                    bool isPrevMonthDay,
                    TextStyle textStyle,
                    bool isNextMonthDay,
                    bool isThisMonthDay,
                    DateTime day,
                  ) {
                    int dayNumber = day.day;

                    if (isThisMonthDay) {
                      // Only style and display days of the current month
                      bool isPresent = _monthlyData[dayNumber - 1].isNotEmpty;
                      bool isHoliday = isDateHoliday(day, holidayDates);

                      if (isPresent) {
                        // Mark present days in green
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$dayNumber',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (isHoliday) {
                        // Mark holidays in a different color
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 14, 46, 225), // Use your desired color for holidays
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$dayNumber',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 213, 216, 240),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Mark absent days in red
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 234, 17, 5),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$dayNumber',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      // Display empty container for days outside the current month
                      return Container();
                    }
                  }),
            ),
            // Circular progress bars for attendance and leave
            Container(
              margin: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCircularProgressBar(
                    label: 'Attendance',
                    value: _attendancePercentage,
                    color: Colors.green,
                  ),
                  _buildCircularProgressBar(
                    label: 'Leave',
                    value: _leavePercentage,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgressBar({
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        CircularProgressIndicator(
          value: value / 100,
          color: color,
        ),
        SizedBox(height: 8.0),
        Text('$value%'),
      ],
    );
  }
}
