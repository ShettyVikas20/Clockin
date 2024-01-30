// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// extension DaysInMonth on DateTime {
//   int get daysInMonth {
//     final DateTime firstDayThisMonth = DateTime(year, month, 1);
//     final DateTime firstDayNextMonth = DateTime(year, month + 1, 1);
//     return firstDayNextMonth.subtract(Duration(days: 1)).day;
//   }
// }

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final CollectionReference<Map<String, dynamic>> _holidaysCollection =
//       FirebaseFirestore.instance.collection('holidays');

//   Future<void> addHoliday(DateTime date, String description) async {
//     try {
//       await _holidaysCollection.add({
//         'date': date,
//         'description': description,
//       });
//     } catch (e) {
//       print('Error adding holiday: $e');
//     }
//   }

//   Future<List<Map<String, dynamic>>> getHolidaysForMonth(
//       DateTime startOfMonth, DateTime endOfMonth) async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot = await _holidaysCollection
//           .where('date', isGreaterThanOrEqualTo: startOfMonth, isLessThan: endOfMonth)
//           .get();

//       return querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> document) {
//         return document.data()!;
//       }).toList();
//     } catch (e) {
//       print('Error fetching holidays: $e');
//       return [];
//     }
//   }
// }

// class CalendarApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Calendar Demo',
//       theme: ThemeData(useMaterial3: false),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final FirestoreService _firestoreService = FirestoreService();
//   DateTime? selectedDate;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _firestoreService.getHolidaysForMonth(
//           DateTime.now().subtract(Duration(days: DateTime.now().day - 1)),
//           DateTime.now().add(Duration(days: DateTime.now().daysInMonth)),
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             List<Map<String, dynamic>> holidays = snapshot.data ?? [];
//             return Column(
//               children: [
//                 Container(
//                   height: 400,
//                   child: SfCalendar(
//                     view: CalendarView.month,
//                     dataSource: MeetingDataSource(_getDataSource(holidays)),
//                     monthViewSettings: MonthViewSettings(
//                       appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
//                     ),
//                     onTap: calendarTapped,
//                   ),
//                 ),
//                 if (selectedDate != null)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         _showAddHolidayDialog();
//                       },
//                       child: Text('Add Holiday for ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}'),
//                     ),
//                   ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   void calendarTapped(CalendarTapDetails calendarTapDetails) {
//     setState(() {
//       selectedDate = calendarTapDetails.date;
//     });
//   }

//   void _showAddHolidayDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String description = '';
//         return AlertDialog(
//           title: Text('Add Holiday'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Date: ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}'),
//               SizedBox(height: 10),
//               TextField(
//                 onChanged: (value) {
//                   description = value;
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Description',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 _firestoreService.addHoliday(selectedDate!, description);
//                 Navigator.pop(context);
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   List<Meeting> _getDataSource(List<Map<String, dynamic>> holidays) {
//     final List<Meeting> meetings = <Meeting>[];
//     final DateTime today = DateTime.now();
//     final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
//     final DateTime endTime = startTime.add(const Duration(hours: 2));
//     meetings.add(Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));

//     for (var holiday in holidays) {
//       DateTime date = (holiday['date'] as Timestamp).toDate();
//       meetings.add(Meeting(holiday['description'] as String, date, date, Colors.red, true));
//     }

//     return meetings;
//   }
// }

// class MeetingDataSource extends CalendarDataSource {
//   late List<Meeting> _appointments;

//   List<Meeting> get appointments => _appointments;

//   @override
//   set appointments(List<dynamic>? value) {
//     if (value != null) {
//       _appointments = List<Meeting>.from(value);
//     } else {
//       _appointments = <Meeting>[];
//     }
//   }

//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }

//   @override
//   DateTime getStartTime(int index) {
//     return _appointments[index].from;
//   }

//   @override
//   DateTime getEndTime(int index) {
//     return _appointments[index].to;
//   }

//   @override
//   String getSubject(int index) {
//     return _appointments[index].eventName;
//   }

//   @override
//   Color getColor(int index) {
//     return _appointments[index].background;
//   }

//   @override
//   bool isAllDay(int index) {
//     return _appointments[index].isAllDay;
//   }
// }

// class Meeting {
//   String eventName;
//   DateTime from;
//   DateTime to;
//   Color background;
//   bool isAllDay;

//   Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
// }



// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// extension DaysInMonth on DateTime {
//   int get daysInMonth {
//     final DateTime firstDayThisMonth = DateTime(year, month, 1);
//     final DateTime firstDayNextMonth = DateTime(year, month + 1, 1);
//     return firstDayNextMonth.subtract(Duration(days: 1)).day;
//   }
// }

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final CollectionReference<Map<String, dynamic>> _holidaysCollection =
//       FirebaseFirestore.instance.collection('holidays');

//   Future<void> addHoliday(
//       DateTime date, String description, String documentName) async {
//     try {
//       DocumentReference<Map<String, dynamic>> docRef =
//           _holidaysCollection.doc(documentName);

//       // Check if the document exists
//       DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();

//       if (!docSnapshot.exists) {
//         // If the document doesn't exist, create it
//         await docRef.set({
//           'holidays': [],
//           'sundaysAdded': false, // New field to indicate whether Sundays are added
//         });
//       }

//       // Append the new holiday to the 'holidays' array
//       await docRef.update({
//         'holidays': FieldValue.arrayUnion([
//           {'date': date, 'description': description}
//         ]),
//       });
//     } catch (e) {
//       print('Error adding holiday: $e');
//     }
//   }

//   Future<List<Map<String, dynamic>>> getHolidaysForMonth(String documentName) async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> docSnapshot =
//           await _holidaysCollection.doc(documentName).get();

//       if (docSnapshot.exists) {
//         Map<String, dynamic>? data = docSnapshot.data();
//         List<Map<String, dynamic>> holidays = data?['holidays']?.cast<Map<String, dynamic>>() ?? [];
//         return holidays;
//       } else {
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching holidays: $e');
//       return [];
//     }
//   }

//   Future<void> addSundaysForMonth(String documentName) async {
//     try {
//       DocumentReference<Map<String, dynamic>> docRef =
//           _holidaysCollection.doc(documentName);

//       // Check if the document exists
//       DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();

//       if (!docSnapshot.exists || !(docSnapshot.data()?['sundaysAdded'] ?? false)) {
//         // If the document doesn't exist or Sundays are not added, create/add them
//         await docRef.set({
//           'holidays': [],
//           'sundaysAdded': true,
//         });

//         // Add every Sunday of the month to the 'holidays' array
//         int daysInMonth = DateTime.now().daysInMonth;
//         for (int day = 1; day <= daysInMonth; day++) {
//           DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, day);
//           if (currentDate.weekday == DateTime.sunday) {
//             await addHoliday(
//               currentDate,
//               'Sunday',
//               documentName,
//             );
//           }
//         }
//       }
//     } catch (e) {
//       print('Error adding Sundays for the month: $e');
//     }
//   }
// }



// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final FirestoreService _firestoreService = FirestoreService();
//   DateTime? selectedDate;

//   void initState() {
//     super.initState();
//     _addSundaysForCurrentMonth();
//   }
//   void _addSundaysForCurrentMonth() async {
//     await _firestoreService.addSundaysForMonth(
//       'month_${DateTime.now().month}_${DateTime.now().year}',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//   future: _firestoreService.getHolidaysForMonth(
//     'month_${DateTime.now().month}_${DateTime.now().year}',
//   ),

//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             List<Map<String, dynamic>> holidays = snapshot.data ?? [];
//             return Column(
//               children: [
//                 Container(
//                   height: 400,
//                   child: SfCalendar(
//                     view: CalendarView.month,
//                     dataSource: MeetingDataSource(_getDataSource(holidays)),
//                     monthViewSettings: MonthViewSettings(
//                       appointmentDisplayMode:
//                           MonthAppointmentDisplayMode.appointment,
//                     ),
//                     onTap: calendarTapped,
//                   ),
//                 ),
//                 if (selectedDate != null)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         _showAddHolidayDialog();
//                       },
//                       child: Text(
//                           'Add Holiday for ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}'),
//                     ),
//                   ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   void calendarTapped(CalendarTapDetails calendarTapDetails) {
//     setState(() {
//       selectedDate = calendarTapDetails.date;
//     });
//   }

//   void _showAddHolidayDialog() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       String description = '';
//       return AlertDialog(
//         title: Text('Add Holiday'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Date: ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}',
//             ),
//             SizedBox(height: 10),
//             TextField(
//               onChanged: (value) {
//                 description = value;
//               },
//               decoration: InputDecoration(
//                 labelText: 'Description',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () async {
//               await _firestoreService.addHoliday(
//                 selectedDate!,
//                 description,
//                 'month_${selectedDate?.month}_${selectedDate?.year}',
//               );
//               Navigator.pop(context);

//               // Refresh the UI by triggering a rebuild
//               setState(() {});
//             },
//             child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// List<Meeting> _getDataSource(List<Map<String, dynamic>> holidays) {
//   final List<Meeting> meetings = <Meeting>[];

//   for (var holiday in holidays) {
//     DateTime date = (holiday['date'] as Timestamp).toDate();
//     meetings.add(Meeting(holiday['description'] as String, date, date, Colors.red, true));
//   }

//   return meetings;
// }

// }

// class MeetingDataSource extends CalendarDataSource {
//   late List<Meeting> _appointments;

//   List<Meeting> get appointments => _appointments;

//   @override
//   set appointments(List<dynamic>? value) {
//     if (value != null) {
//       _appointments = List<Meeting>.from(value);
//     } else {
//       _appointments = <Meeting>[];
//     }
//   }

//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }

//   @override
//   DateTime getStartTime(int index) {
//     return _appointments[index].from;
//   }

//   @override
//   DateTime getEndTime(int index) {
//     return _appointments[index].to;
//   }

//   @override
//   String getSubject(int index) {
//     return _appointments[index].eventName;
//   }

//   @override
//   Color getColor(int index) {
//     return _appointments[index].background;
//   }

//   @override
//   bool isAllDay(int index) {
//     return _appointments[index].isAllDay;
//   }
// }

// class Meeting {
//   String eventName;
//   DateTime from;
//   DateTime to;
//   Color background;
//   bool isAllDay;

//   Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
// }

import 'package:attendanaceapp/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension DaysInMonth on DateTime {
  int get daysInMonth {
    final DateTime firstDayThisMonth = DateTime(year, month, 1);
    final DateTime firstDayNextMonth = DateTime(year, month + 1, 1);
    return firstDayNextMonth.subtract(Duration(days: 1)).day;
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _holidaysCollection =
      FirebaseFirestore.instance.collection('holidays');

  Future<void> addHoliday(
      DateTime date, String description, String documentName) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          _holidaysCollection.doc(documentName);

      // Check if the document exists
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // If the document doesn't exist, create it
        await docRef.set({
          'holidays': [],
          'sundaysAdded': false, // New field to indicate whether Sundays are added
        });
      }

      // Append the new holiday to the 'holidays' array
      await docRef.update({
        'holidays': FieldValue.arrayUnion([
          {'date': date, 'description': description}
        ]),
      });
    } catch (e) {
      print('Error adding holiday: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHolidaysForMonth(String documentName) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _holidaysCollection.doc(documentName).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        List<Map<String, dynamic>> holidays = data?['holidays']?.cast<Map<String, dynamic>>() ?? [];
        return holidays;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching holidays: $e');
      return [];
    }
  }

  Future<void> addSundaysForMonth(String documentName) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          _holidaysCollection.doc(documentName);

      // Check if the document exists
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();

      if (!docSnapshot.exists || !(docSnapshot.data()?['sundaysAdded'] ?? false)) {
        // If the document doesn't exist or Sundays are not added, create/add them
        await docRef.set({
          'holidays': [],
          'sundaysAdded': true,
        });

        // Add every Sunday of the month to the 'holidays' array
        int daysInMonth = DateTime.now().daysInMonth;
        for (int day = 1; day <= daysInMonth; day++) {
          DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, day);
          if (currentDate.weekday == DateTime.sunday) {
            await addHoliday(
              currentDate,
              'Sunday',
              documentName,
            );
          }
        }
      }
    } catch (e) {
      print('Error adding Sundays for the month: $e');
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  DateTime? selectedDate;

  void initState() {
    super.initState();
    _addSundaysForCurrentMonth();
  }
  void _addSundaysForCurrentMonth() async {
    await _firestoreService.addSundaysForMonth(
      'month_${DateTime.now().month}_${DateTime.now().year}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarAdmin('Calender'),
      body: Center(
        child: Padding(padding: EdgeInsets.only(top: 110),
        child:  FutureBuilder<List<Map<String, dynamic>>>(
  future: _firestoreService.getHolidaysForMonth(
    'month_${DateTime.now().month}_${DateTime.now().year}',
  ),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> holidays = snapshot.data ?? [];
            return Column(
              children: [
                Container(
  height: 400,
  width: 350,
  child: SfCalendar(
    headerStyle: CalendarHeaderStyle(
      textAlign: TextAlign.center,
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Kanit-Bold',
        color: Color.fromARGB(255, 6, 30, 138),
      ),
    ),
    view: CalendarView.month,
    dataSource: MeetingDataSource(_getDataSource(holidays)),
    monthViewSettings: MonthViewSettings(
      monthCellStyle: MonthCellStyle(
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        leadingDatesBackgroundColor: Colors.grey[200],
        trailingDatesBackgroundColor: Colors.grey[200],
        todayBackgroundColor: Colors.blue,
        todayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
         // Set the border radius here
      ),
      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
    ),
    onTap: calendarTapped,
  ),
),
                if (selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top:50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _showAddHolidayDialog();
                      },
                      child: Text(
                          'Add Holiday For ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}',
                           style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 58, 58),
          ),
                          ),
                          style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Color.fromARGB(255, 39, 179, 235),
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.8,
            50,
          ),
        ), 
                          
                    ),
                  ),
              ],
            );
          }
        },
      ),
      ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    setState(() {
      selectedDate = calendarTapDetails.date;
    });
  }

  void _showAddHolidayDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String description = '';
      return AlertDialog(
        title: Text('Add Holiday'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Date: ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}',
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                description = value;
              },
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _firestoreService.addHoliday(
                selectedDate!,
                description,
                'month_${selectedDate?.month}_${selectedDate?.year}',
              );
              Navigator.pop(context);

              // Refresh the UI by triggering a rebuild
              setState(() {});
            },
            child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
List<Meeting> _getDataSource(List<Map<String, dynamic>> holidays) {
  final List<Meeting> meetings = <Meeting>[];

  for (var holiday in holidays) {
    DateTime date = (holiday['date'] as Timestamp).toDate();
    meetings.add(Meeting(holiday['description'] as String, date, date, Colors.red, true));
  }

  return meetings;
}

}

class MeetingDataSource extends CalendarDataSource {
  late List<Meeting> _appointments;

  List<Meeting> get appointments => _appointments;

  @override
  set appointments(List<dynamic>? value) {
    if (value != null) {
      _appointments = List<Meeting>.from(value);
    } else {
      _appointments = <Meeting>[];
    }
  }

  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return _appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return _appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return _appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return _appointments[index].isAllDay;
  }
}

class Meeting {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
}

