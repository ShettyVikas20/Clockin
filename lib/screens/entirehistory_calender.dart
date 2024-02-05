// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
// import 'package:intl/intl.dart';

// class EntireEmployeeHistroryInCalender extends StatefulWidget {
//   @override
//   _EntireEmployeeHistroryInCalenderState createState() =>
//       _EntireEmployeeHistroryInCalenderState();
// }

// class _EntireEmployeeHistroryInCalenderState
//     extends State<EntireEmployeeHistroryInCalender> {
//   DateTime _currentDate = DateTime.now();
//   DateTime _targetDateTime = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Simple Calendar'),
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
//                       });
//                     },
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 16.0),
//               child: CalendarCarousel(
//                 todayBorderColor: Color.fromARGB(255, 2, 15, 24),
//                 showOnlyCurrentMonthDate: false,
//                 weekendTextStyle: TextStyle(
//                   color: Colors.black,
//                 ),
//                 thisMonthDayBorderColor: Colors.grey,
//                 weekFormat: false,
//                 height: 420.0,
//                 selectedDateTime: _currentDate,
//                 targetDateTime: _targetDateTime,
//                 customGridViewPhysics: NeverScrollableScrollPhysics(),
//                 showHeader: false,
//                 todayTextStyle: TextStyle(
//                   color: Color.fromARGB(255, 255, 255, 255),
//                   fontWeight: FontWeight.bold,
//                 ),
//                 todayButtonColor: Color.fromARGB(255, 145, 176, 243),
//                 selectedDayButtonColor: Colors.orange,
//                 selectedDayBorderColor: Colors.black,
//                 selectedDayTextStyle: TextStyle(
//                   color: Color.fromARGB(255, 255, 255, 255),
//                   fontWeight: FontWeight.bold,
//                 ),
//                 minSelectedDate: _currentDate.subtract(Duration(days: 360)),
//                 maxSelectedDate: _currentDate.add(Duration(days: 360)),
//                 prevDaysTextStyle: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//                 inactiveDaysTextStyle: TextStyle(
//                   color: Colors.tealAccent,
//                   fontSize: 16,
//                 ),
//                 onCalendarChanged: (DateTime date) {
//                   setState(() {
//                     _targetDateTime = date;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
// import 'package:intl/intl.dart';

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
//   DateTime _currentDate = DateTime.now();
//   DateTime _targetDateTime = DateTime.now();

//   // Placeholder for fetching data from Firebase for the specified month
//   void _fetchDataForMonth(DateTime targetDateTime) async {
//   // Get the start and end dates of the month
//   DateTime startDate = DateTime(targetDateTime.year, targetDateTime.month, 1);
//   DateTime endDate = DateTime(
//     targetDateTime.year,
//     targetDateTime.month + 1,
//     0,
//   );

//   // Format dates to match Firestore date format
//   String startFormatted = DateFormat('yyyy-MMM-dd').format(startDate);
//   String endFormatted = DateFormat('yyyy-MMM-dd').format(endDate);

//   // Build the document reference
//   String documentId = '${widget.employeeName}_${widget.employeeId}_dailyactivity';
//   DocumentReference<Map<String, dynamic>> documentReference =
//       FirebaseFirestore.instance.collection('emp_daily_activity').doc(documentId);

//   try {
//     // Fetch data from Firestore for the specified month
//     DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//         await documentReference.get();

//     // Reset any previous data
//     // (Note: You may want to store this data in a more structured way)
//     // For simplicity, here, I'm using a list for each day's data
//     List<List<Map<String, dynamic>>> monthlyData = List.generate(
//       endDate.day,
//       (index) => [],
//     );

//     // Check if the document exists
//     if (documentSnapshot.exists) {
//       // Extract daily activities from the document
//       List<dynamic> dailyActivities = documentSnapshot.data()!['daily_activity'];

//       // Process daily activities
//       for (var activity in dailyActivities) {
//         String activityDate = activity['date'];

//         // Check if the activity date is within the target month
//         if (activityDate.compareTo(startFormatted) >= 0 &&
//             activityDate.compareTo(endFormatted) <= 0) {
//           // Parse the date to get the day
//           int day = DateFormat('yyyy-MMM-dd').parse(activityDate).day;

//           // Add the activity to the corresponding day's data
//           monthlyData[day - 1].add(activity);
//         }
//       }
//     }

//     // Debugging: Print the fetched data
//     for (int i = 0; i < monthlyData.length; i++) {
//       print('Day ${i + 1} activities: ${monthlyData[i]}');
//     }

//     // Update state to trigger a rebuild
//     setState(() {});
//   } catch (e) {
//     print('Error fetching data: $e');
//   }
// }

//   // Placeholder for handling day tap
//   void _handleDayTap(DateTime selectedDate) {
//     // Implement logic to fetch and display activities for the selected date
//     // Update state variables accordingly
//   }

//   @override
//   void initState() {
//     super.initState();
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
//                 todayBorderColor: Color.fromARGB(255, 2, 15, 24),
//                 showOnlyCurrentMonthDate: false,
//                 weekendTextStyle: TextStyle(
//                   color: Colors.black,
//                 ),
//                 thisMonthDayBorderColor: Colors.grey,
//                 weekFormat: false,
//                 height: 420.0,
//                 selectedDateTime: _currentDate,
//                 targetDateTime: _targetDateTime,
//                 customGridViewPhysics: NeverScrollableScrollPhysics(),
//                 showHeader: false,
//                 todayTextStyle: TextStyle(
//                   color: Color.fromARGB(255, 255, 255, 255),
//                   fontWeight: FontWeight.bold,
//                 ),
//                 todayButtonColor: Color.fromARGB(255, 145, 176, 243),
//                 selectedDayButtonColor: Colors.orange,
//                 selectedDayBorderColor: Colors.black,
//                 selectedDayTextStyle: TextStyle(
//                   color: Color.fromARGB(255, 255, 255, 255),
//                   fontWeight: FontWeight.bold,
//                 ),
//                 minSelectedDate: _currentDate.subtract(Duration(days: 360)),
//                 maxSelectedDate: _currentDate.add(Duration(days: 360)),
//                 prevDaysTextStyle: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//                 inactiveDaysTextStyle: TextStyle(
//                   color: Colors.tealAccent,
//                   fontSize: 16,
//                 ),
//                 onCalendarChanged: (DateTime date) {
//                   setState(() {
//                     _targetDateTime = date;
//                     _fetchDataForMonth(date);
//                   });
//                 },
//                 onDayPressed: (DateTime date, List events) {
//                   _handleDayTap(date);
//                 },
//               ),
//             ),
//             // Add other widgets as needed
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

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
    int totalHolidays = 0;

    // Placeholder for actual holidays data
    List<Map<String, dynamic>> holidays =
        await _getHolidaysForMonth(targetDateTime.month, targetDateTime.year);

    // Iterate through each day's data
    for (List<Map<String, dynamic>> dayData in monthlyData) {
      // Check if the day has any activities
      if (dayData.isNotEmpty) {
        print('day date length is :${dayData.length}');
        // Increment totalPresentDays for each day with activities
        totalPresentDays++;
      }
    }

    // Iterate through holidays to count the total number of holidays
    for (Map<String, dynamic> holiday in holidays) {
      // Extract the date from the holiday data
      DateTime holidayDate = (holiday['date'] as Timestamp).toDate();

      // Check if the holiday falls within the target month
      if (holidayDate.month == _targetDateTime.month) {
        totalHolidays++;
      }
    }

    // Calculate attendance and leave percentages
    int attendance =
        ((totalPresentDays / (totalDaysInMonth - totalHolidays)) * 100).round();
    int leave = 100 - attendance;

    // Update the state to trigger a rebuild with the actual values
    setState(() {
      _attendancePercentage = attendance;
      _leavePercentage = leave;
    });

    // Debugging: Print calculated values
    print('Total Days in Month: $totalDaysInMonth');
    print('Total Present Days: $totalPresentDays');
    print('Total Holidays: $totalHolidays');
    print('Attendance: $attendance%');
    print('Leave: $leave%');
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

      print('holidays length is: ${holidays.length}');

      return holidays;
    } catch (e) {
      print('Error fetching holidays: $e');
      return [];
    }
  }

  // Placeholder for handling day tap
  void _handleDayTap(DateTime selectedDate) {
    // Implement logic to fetch and display activities for the selected date
    // Update state variables accordingly
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
    } else {
      // Mark absent days in red
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
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
                  }
                  ),
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
