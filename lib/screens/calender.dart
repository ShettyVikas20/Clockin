import 'package:attendanaceapp/components/app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  DateTime? selectedDate;
  late CalendarCarousel _calendarCarouselNoHeader;
  List<DateTime> _markedDateList = [];

  @override
  void initState() {
    super.initState();
    _fetchHolidaysForMonth(_currentDate);
    _configureFCM();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FCM Message Received: ${message.notification?.body}");

      // Display an in-app notification when the app is in the foreground
      // You can customize this based on your UI design
      _showInAppNotification(message.notification);
    });

    // Handle tapping on the notification when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("FCM Message Tapped: ${message.notification?.body}");

      // Navigate to a specific screen or handle the tap as needed
      _handleNotificationTap(message);
    });
  }
 Future<void> _configureFCM() async {
    // Request permission for receiving push notifications (required on iOS)
   FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

    // Subscribe to a topic if needed
    FirebaseMessaging.instance.subscribeToTopic('all');
    
     String? token = await FirebaseMessaging.instance.getToken();
  // Print the device token
  print('Device Token: $token');
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FCM Message Received in Foreground: ${message.notification?.body}");
    _showInAppNotification(message.notification);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("FCM Message Tapped: ${message.notification?.body}");
    _handleNotificationTap(message);
  });

  }
   void _showInAppNotification(RemoteNotification? notification) {
    // You can use a package like 'flutter_local_notifications' to show in-app notifications
    // Example: https://pub.dev/packages/flutter_local_notifications
  }

  // Handle tapping on the notification when the app is in the background
  void _handleNotificationTap(RemoteMessage message) {
    // Navigate to a specific screen or handle the tap as needed
    // Example: Navigator.pushNamed(context, '/details');
  }



 EventList<Event> _getMarkedDates() {
  EventList<Event> markedDates = EventList<Event>(events: {});

  for (DateTime date in _markedDateList) {
    markedDates.add(date, Event(date: date, icon: _buildHolidayEvent(date)));
  }

  return markedDates;
}

Widget _buildHolidayEvent(DateTime date) {
  return Container(
    margin: EdgeInsets.all(4),
    width: 4,
    height: 4,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.red,
    ),
  );
}
////////////////////////////////////////////////////////////////////////////////////////////
Future<void> _addHoliday(DateTime date, String description, String docName) async {
  try {
    await FirebaseFirestore.instance.collection('holidays').doc(docName).set(
      {
        'holidays': FieldValue.arrayUnion([
          {
            'date': Timestamp.fromDate(date),
            'description': description,
          },
        ]),
      },
      SetOptions(merge: true),
    );

    // Send a notification after successfully saving the holiday
    _sendNotification('Holiday Added', 'Holiday saved successfully!');
  } catch (e) {
    print('Error adding holiday: $e');
  }
}
void subscribeToTopic(String topic) async {
  try {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  } catch (e) {
    print('Error subscribing to topic: $e');
  }
}

Future<void> _sendNotification(String title, String body) async {
  try {
    // You can customize the notification payload here
    await FirebaseMessaging.instance.subscribeToTopic('all'); // Subscribe to a topic

    // Simulate a notification by displaying a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(body),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            // Perform an action when the user dismisses the notification
          },
        ),
      ),
    );
  } catch (e) {
    print('Error sending notification: $e');
  }
}

//   Future<void> _addHoliday(DateTime date, String description, String docName) async {
//   try {
//     await FirebaseFirestore.instance.collection('holidays').doc(docName).set(
//       {
//         'holidays': FieldValue.arrayUnion([
//           {
//             'date': Timestamp.fromDate(date),
//             'description': description,
//           },
//         ]),
//       },
//       SetOptions(merge: true),
//     );
   
//   } catch (e) {
//     print('Error adding holiday: $e');
//   }
// }


  // Function to fetch holidays for the given month and update the marked date list
  // Function to fetch holidays for the given month and update the marked date list
void _fetchHolidaysForMonth(DateTime targetDateTime) async {
  try {
    String docName = 'month_${targetDateTime.month}_${targetDateTime.year}';
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('holidays').doc(docName).get();

    if (snapshot.exists) {
      List<Map<String, dynamic>> holidays =
          List<Map<String, dynamic>>.from(snapshot['holidays']);

      List<DateTime> markedDates = holidays
          .map((holiday) =>
              (holiday['date'] as Timestamp).toDate().toLocal())
          .toList();

      setState(() {
        _markedDateList = markedDates;
      });
    }
  } catch (e) {
    print('Error fetching holidays: $e');
  }
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
    await _addHoliday(
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
/////////////////////////////////////////////////////////////////yooooooooo/////////////////

  void _showCircularDialog(DateTime date) async {
    String? description;

    try {
      String docName = 'month_${date.month}_${date.year}';
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('holidays').doc(docName).get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> holidays =
            List<Map<String, dynamic>>.from(snapshot['holidays']);
        DateTime selectedDate = DateTime(date.year, date.month, date.day);

        for (var holiday in holidays) {
          DateTime holidayDate = (holiday['date'] as Timestamp).toDate();
          if (holidayDate.isAtSameMomentAs(selectedDate)) {
            description = holiday['description'] as String;
            break;
          }
        }
      }
    } catch (e) {
      print('Error fetching holiday description: $e');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selected Date:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                if (description != null)
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Happy Holiday🎊',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanti-Bold',
                          fontSize: 16.0,
                          color:Colors.red,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Perform any action on button press
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
  todayBorderColor: Color.fromARGB(255, 2, 15, 24),
  onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() {
          _currentDate2 = date;
          if (selectedDate != null && selectedDate == date) {
            // If the date is already selected, unselect it
            selectedDate = null;
          } else {
            // Otherwise, set the selected date
            selectedDate = date;
          }
        });
        events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: true,
  showOnlyCurrentMonthDate: false,
  weekendTextStyle: TextStyle(
    color: Colors.black,
  ),
  thisMonthDayBorderColor: Colors.grey,
  weekFormat: false,
  height: 420.0,
  selectedDateTime: _currentDate2,
  targetDateTime: _targetDateTime,
  customGridViewPhysics: NeverScrollableScrollPhysics(),

  // Add the following lines for marking holidays
  markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: const Color.fromARGB(255, 255, 59, 59))),
  markedDateCustomTextStyle: TextStyle(
    fontSize: 18,
    color: Colors.blue,
  ),
   markedDatesMap: _getMarkedDates(),

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
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
          _fetchHolidaysForMonth(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        _showCircularDialog(date);
      },
    );

    return Scaffold(
      appBar: AppbarAdmin( 'Calendar' ),
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
                      _currentMonth,
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
                            _targetDateTime.year, _targetDateTime.month - 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                        _fetchHolidaysForMonth(_targetDateTime);
                      });
                    },
                  ),
                  TextButton(
                    child: Text('NEXT'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month + 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                        _fetchHolidaysForMonth(_targetDateTime);
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: _calendarCarouselNoHeader,
            ),
            Visibility(
              visible: selectedDate != null,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
