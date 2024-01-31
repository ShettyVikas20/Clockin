import 'package:attendanaceapp/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EmployeeHistoryPage extends StatefulWidget {
  final String employeeName;
  final String employeePhone;

  EmployeeHistoryPage({
    required this.employeeName,
    required this.employeePhone,
  });

  @override
  _EmployeeHistoryPageState createState() => _EmployeeHistoryPageState();
}

class _EmployeeHistoryPageState extends State<EmployeeHistoryPage> {
  String? photoUrl;
  DateTime? selectedDate; // New variable to track the selected date

  @override
  void initState() {
    super.initState();
    // Fetch photo_url when the widget is initialized
    fetchPhotoUrl();
    selectMostRecentDay();
  }
  void selectMostRecentDay() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('emp_daily_activity')
          .where('name', isEqualTo: widget.employeeName)
          .where('phone', isEqualTo: widget.employeePhone)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var mostRecentDay = snapshot.docs.first.data()['date'] as String;
        setState(() {
          selectedDate = DateFormat('yyyy-MMM-dd').parse(mostRecentDay);
        });
      }
    } catch (e) {
      print('Error selecting most recent day: $e');
    }
  }

  Future<void> fetchPhotoUrl() async {
    try {
      // Replace 'Employees' with your actual collection name
      var snapshot = await FirebaseFirestore.instance
          .collection('Employees')
          .where('name', isEqualTo: widget.employeeName)
          .where('phone', isEqualTo: widget.employeePhone)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var employeeData = snapshot.docs.first.data();
        setState(() {
          photoUrl = employeeData['photo_url'];
        });
        print("Data fetched from database: $employeeData");
      }
    } catch (e) {
      print('Error fetching photo_url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarAdmin('Employee Details - ${widget.employeeName}'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
               child:
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl!)
                      : AssetImage('assets/ganglia_logo.png') as ImageProvider,
                  radius: 75.0,
                ), 
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${widget.employeeName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit-Bold',
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      'Ph.no: ${widget.employeePhone}',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lemon',
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
          ),
           ),
          SizedBox(height: 16.0),
          Container(
            height: 100.0,
            child:
                _buildRecentDayList(widget.employeeName, widget.employeePhone),
          ),
          Expanded(
            child: EmployeeHistoryList(
              employeeName: widget.employeeName,
              employeePhone: widget.employeePhone,
              selectedDate: selectedDate, // Pass the selected date
            ),
          ),
        ],
      ),
    );
  }

Widget _buildRecentDayList(String employeeName, String employeePhone) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('emp_daily_activity')
        .where('name', isEqualTo: employeeName)
        .where('phone', isEqualTo: employeePhone)
        .orderBy('date', descending: true)
        .limit(6)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No data available.'));
      }

      var recentDocs = snapshot.data!.docs;

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentDocs.length,
        itemBuilder: (context, index) {
          var dateString = recentDocs[index]['date'] as String;
          var formattedDate = DateFormat('yyyy-MMM-dd').format(_formatDate(dateString));

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = _formatDate(dateString);
              });
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
                color: selectedDate == _formatDate(dateString) ? Colors.lightBlueAccent : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'lemon',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

DateTime _formatDate(String dateString) {
  return DateFormat('yyyy-MMM-dd').parse(dateString);
}


}

class EmployeeHistoryList extends StatelessWidget {
  final String employeeName;
  final String employeePhone;
  final DateTime? selectedDate; // New variable

  EmployeeHistoryList({
    required this.employeeName,
    required this.employeePhone,
    required this.selectedDate, // Updated constructor
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('emp_daily_activity')
          .where('name', isEqualTo: employeeName)
          .where('phone', isEqualTo: employeePhone)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var employeeDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

        var filteredDocs = employeeDocs;

        if (selectedDate != null) {
          filteredDocs = employeeDocs.where((document) {
            var data = document.data() as Map<String, dynamic>;
            var dateString = data['date'] as String;

            // Adjust the date format based on the stored format
            var formattedDate = DateFormat('yyyy-MMM-dd').parse(dateString);

            return formattedDate.year == selectedDate!.year &&
                formattedDate.month == selectedDate!.month &&
                formattedDate.day == selectedDate!.day;
          }).toList();
        }
            return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Working Days
            SizedBox(height: 10),
            Text(
              'Total Working Days: ${employeeDocs.length}',
              style: TextStyle(
                fontFamily: 'lemon',
                fontSize: 15.0,
              ),
            ),

            SizedBox(height: 10),
            Text(
              'Working Days This Month: ${_calculateWorkingDaysThisMonth(employeeDocs)}',
              style: TextStyle(
                fontFamily: 'lemon',
                fontSize: 14.0,
              ),
            ),

             Expanded(
              child: ListView(
                children: filteredDocs.map((document) {
                  var data = document.data() as Map<String, dynamic>;
                  return EmployeeHistoryCard(data: data);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  int _calculateWorkingDaysThisMonth(List<DocumentSnapshot> employeeDocs) {
    var now = DateTime.now();
    var thisMonthDays = employeeDocs.where((doc) {
      dynamic date = doc['date'];

      if (date is Timestamp) {
        var dateTime = date.toDate();
        return dateTime.year == now.year && dateTime.month == now.month;
      } else if (date is String) {
        var parsedDate = DateFormat('yyyy-MMM-dd').parse(date);
        return parsedDate.year == now.year && parsedDate.month == now.month;
      } else {
        throw ArgumentError('Invalid date format: $date');
      }
    }).toList();

    return thisMonthDays.length;
  }
}

class EmployeeHistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  EmployeeHistoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeContainer('Check-In', data['login'], width: 160.0),
            _buildTimeContainer('Check-Out', data['logout'], width: 160.0),
          ],
        ),
        SizedBox(height: 8.0),
        _buildNotesContainer('Notes', data['notes']),
      ],
    );
  }

  Widget _buildTimeContainer(String label, String time,
      {double width = 100.0}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
      width: 170,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // Rounded edges
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 168, 209, 243),
              fontSize: 22,
              fontFamily: 'lemon',
            ),
          ),
          SizedBox(height: 14.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  16.0), // Rounded edges for the image container
              color: Color.fromARGB(255, 174, 218, 247).withOpacity(0.4),
            ),
            padding: EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/checkout.png', // Replace with the actual path to your image
              height: 25,
              width: 25,
              fit: BoxFit.cover,
              color: Color.fromARGB(
                  255, 8, 41, 131), // Apply blue color to the icon
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            time,
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'lemon',
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesContainer(String label, String notes) {
    return Container(
      height: 170,
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 182, 215, 247),
            Color.fromARGB(255, 39, 179, 235),
          ],
          begin: Alignment.topRight,
          end: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: Color.fromARGB(255, 174, 218, 247),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'lemon',
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            notes,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ],
      ),
    );
  }
}

