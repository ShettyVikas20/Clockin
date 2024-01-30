import 'package:attendanaceapp/components/app_bar.dart';
import 'package:attendanaceapp/screens/admin_holiday_calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
   final FirestoreService _firestoreService = FirestoreService();
  DateTime? selectedDate;
    late CalendarCarousel _calendarCarouselNoHeader;

  
  // void _addSundaysForCurrentMonth() async {
  //   await _firestoreService.addSundaysForMonth(
  //     'month_${DateTime.now().month}_${DateTime.now().year}',
  //   );
  // }


  // static Widget _eventIcon = new Container(
  //   decoration: new BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.all(Radius.circular(1000)),
  //       border: Border.all(color: Colors.blue, width: 2.0)),
  //   child: new Icon(
  //     Icons.person,
  //     color: Colors.amber,
  //   ),
  // );

  // EventList<Event> _markedDateMap = new EventList<Event>(
  //   events: {
  //     new DateTime(2020, 2, 10): [
  //       new Event(
  //         date: new DateTime(2020, 2, 14),
  //         title: 'Event 1',
  //         icon: _eventIcon,
  //         dot: Container(
  //           margin: EdgeInsets.symmetric(horizontal: 1.0),
  //           color: Colors.red,
  //           height: 5.0,
  //           width: 5.0,
  //         ),
  //       ),
  //       new Event(
  //         date: new DateTime(2020, 2, 10),
  //         title: 'Event 2',
  //         icon: _eventIcon,
  //       ),
  //       new Event(
  //         date: new DateTime(2020, 2, 15),
  //         title: 'Event 3',
  //         icon: _eventIcon,
  //       ),
  //     ],
  //   },
  // );

  @override
  void initState() {
     super.initState();
    // _addSundaysForCurrentMonth();
    // _markedDateMap.add(
    //     new DateTime(2020, 2, 25),
    //     new Event(
    //       date: new DateTime(2020, 2, 25),
    //       title: 'Event 5',
    //       icon: _eventIcon,
    //     ));

    // _markedDateMap.add(
    //     new DateTime(2020, 2, 10),
    //     new Event(
    //       date: new DateTime(2020, 2, 10),
    //       title: 'Event 4',
    //       icon: _eventIcon,
    //     ));

    // _markedDateMap.addAll(new DateTime(2019, 2, 11), [
    //   new Event(
    //     date: new DateTime(2019, 2, 11),
    //     title: 'Event 1',
    //     icon: _eventIcon,
    //   ),
    //   new Event(
    //     date: new DateTime(2019, 2, 11),
    //     title: 'Event 2',
    //     icon: _eventIcon,
    //   ),
    //   new Event(
    //     date: new DateTime(2019, 2, 11),
    //     title: 'Event 3',
    //     icon: _eventIcon,
    //   ),
    // ]);
    super.initState();
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

    void _showCircularDialog(DateTime date) {
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
        color: Colors.black
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      // markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.bold
      ),

      todayButtonColor: Color.fromARGB(255, 145, 176, 243),
       selectedDayButtonColor: Colors.orange,
        selectedDayBorderColor:Colors.black ,
      selectedDayTextStyle: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.bold,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color:Colors.grey,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        _showCircularDialog(date);
      },
    );

    return new Scaffold(
        appBar:  AppbarAdmin('Calendar'),
        body: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //custom icon

              Container(
                height: 90,
                margin: EdgeInsets.only(
          
                  top: 70,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit-Bold',
                        fontSize: 24.0,
                      ),
                    )),
                    TextButton(
                      child: Text('PREV'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month - 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
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
          
        ));
  }
}
