// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class EmployeeHistoryPage extends StatelessWidget {
//   final String employeeName;
//   final String employeePhone;

//   EmployeeHistoryPage({required this.employeeName, required this.employeePhone});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Employee Details - $employeeName',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color.fromARGB(255, 59, 58, 58),
//           ),
//         ),
//         elevation: 0,
//       shape: ContinuousRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [

//                Color.fromARGB(255, 39, 179, 235), Color.fromARGB(255, 182, 215, 247),
//               // Add more colors if you want a gradient effect
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//       ),
//     ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   // Replace 'assets/path_to_your_image' with the actual path or URL of the image
//                   backgroundImage: AssetImage('photo_url'),
//                   radius: 75.0,
//                 ),
//                 SizedBox(width: 16.0),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Name: $employeeName',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'lemon',
//                         fontSize: 18.0,
//                       ),
//                     ),
//                     Text(
//                       'Ph.no: $employeePhone', // Replace with the actual phone number
//                       style: TextStyle(
//                         fontSize: 12.0,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'lemon',
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16.0),
//           Container(
//             height: 100.0,
//             child: _buildDayList(),
//           ),
//           Expanded(
//             child: EmployeeHistoryList(
//               employeeName: employeeName,
//               employeePhone: employeePhone,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDayList() {
//     List<String> days = List.generate(31, (index) => (index + 1).toString());

//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: days.length,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: EdgeInsets.all(8.0),
//           padding: EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.blue),
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Day ${days[index]}',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'lemon',
//                   fontSize: 18.0,
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 DateFormat('dd').format(DateTime.now().add(Duration(days: index))),
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'lemon',
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
// class EmployeeHistoryList extends StatelessWidget {
//   final String employeeName;
//   final String employeePhone;

//   EmployeeHistoryList({required this.employeeName, required this.employeePhone});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('emp_daily_activity')
//           .where('name', isEqualTo: employeeName)
//           .where('phone', isEqualTo: employeePhone)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         var employeeDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Total Working Days
//             SizedBox(height: 10),
//             Text('Total Working Days: ${employeeDocs.length}',
//             style: TextStyle(

//                       fontFamily: 'lemon',
//                         fontSize: 15.0,
//                       ),
//                     ),

//            SizedBox(height:10),
//             Text(
//               'Working Days This Month: ${_calculateWorkingDaysThisMonth(employeeDocs)}',
//                style: TextStyle(

//                       fontFamily: 'lemon',
//                         fontSize: 14.0,
//                       ),
//                     ),

//             Expanded(
//               child: ListView(
//                 children: employeeDocs.map((document) {
//                   var data = document.data() as Map<String, dynamic>;
//                   return EmployeeHistoryCard(data: data);
//                 }).toList(),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   int _calculateWorkingDaysThisMonth(List<DocumentSnapshot> employeeDocs) {
//     var now = DateTime.now();
//     var thisMonthDays = employeeDocs.where((doc) {
//       var date = DateTime.parse(doc['date']);
//       return date.year == now.year && date.month == now.month;
//     }).toList();

//     return thisMonthDays.length;
//   }
// }

// class EmployeeHistoryCard extends StatelessWidget {
//   final Map<String, dynamic> data;

//   EmployeeHistoryCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildTimeContainer('Check-In', data['login'], width: 160.0),
//               _buildTimeContainer('Check-Out', data['logout'], width: 160.0),
//             ],
//           ),
//           SizedBox(height: 8.0),
//           _buildNotesContainer('Notes', data['notes']),
//         ],
//     );

//   }

//   Widget _buildTimeContainer(String label, String time, {double width = 100.0}) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6.0),
//       padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
//       width: 170,
//       height: 150,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.0), // Rounded edges
//         border: Border.all(color: Colors.blue),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color.fromARGB(255, 168, 209, 243),
//               fontSize: 22,
//               fontFamily: 'lemon',
//             ),
//           ),
//           SizedBox(height: 14.0),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16.0), // Rounded edges for the image container
//               color: Color.fromARGB(255, 174, 218, 247).withOpacity(0.4),
//             ),
//             padding: EdgeInsets.all(8.0),
//             child: Image.asset(
//               'assets/images/checkout.png', // Replace with the actual path to your image
//               height: 25,
//               width: 25,
//               fit: BoxFit.cover,
//               color: Color.fromARGB(255, 8, 41, 131), // Apply blue color to the icon
//             ),
//           ),
//           SizedBox(height: 8.0),
//           Text(
//             time,
//             style: TextStyle(
//               fontSize: 25,
//               fontFamily: 'lemon',
//               color: const Color.fromARGB(255, 0, 0, 0),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotesContainer(String label, String notes) {
//     return Container(
//       height: 170,
//       width: 300,
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [ Color.fromARGB(255, 182, 215, 247), Color.fromARGB(255, 39, 179, 235), ],
//             begin: Alignment.topRight,
//             end: Alignment.topLeft,
//           ),
//         borderRadius: BorderRadius.circular(8.0),
//         color: Color.fromARGB(255, 174, 218, 247),
//       ),
//       child: Column(

//         children: [
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 25,
//               color: Colors.white,
//               fontFamily: 'lemon',
//             ),
//           ),
//           SizedBox(height: 4.0),
//           Text(
//             notes,
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               color: const Color.fromARGB(255, 0, 0, 0),
//               fontWeight: FontWeight.bold,
//               fontSize: 17
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

  @override
  void initState() {
    super.initState();
    // Fetch photo_url when the widget is initialized
    fetchPhotoUrl();
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
      }
    } catch (e) {
      print('Error fetching photo_url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Employee Details - ${widget.employeeName}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 58, 58),
          ),
        ),
        elevation: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 39, 179, 235),
                Color.fromARGB(255, 182, 215, 247),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        fontFamily: 'lemon',
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
          SizedBox(height: 16.0),
          Container(
            height: 100.0,
            child: _buildRecentDayList(widget.employeeName,widget.employeePhone),
          ),
          Expanded(
            child: EmployeeHistoryList(
              employeeName: widget.employeeName,
              employeePhone: widget.employeePhone,
            ),
          ),
        ],
      ),
    );
  }

// The rest of your EmployeeHistoryList, EmployeeHistoryCard, and other widgets remain unchanged.

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

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      var recentDocs = (snapshot.data as QuerySnapshot?)?.docs ?? [];

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentDocs.length,
        itemBuilder: (context, index) {
          dynamic date = recentDocs[index]['date'];
          DateTime dateTime;

          if (date is Timestamp) {
            dateTime = date.toDate();
          } else if (date is String) {
            dateTime = DateFormat('yyyy-MMM-dd').parse(date);
          } else {
            throw ArgumentError('Invalid date format: $date');
          }

          var formattedDate = DateFormat('yyyy-MMM-dd').format(dateTime);

          return Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   'Day ${index + 1}',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontFamily: 'lemon',
                //     fontSize: 18.0,
                //   ),
                // ),
                SizedBox(height: 6.0),
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
          );
        },
      );
    },
  );
}

}

class EmployeeHistoryList extends StatelessWidget {
  final String employeeName;
  final String employeePhone;

  EmployeeHistoryList(
      {required this.employeeName, required this.employeePhone});

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
                children: employeeDocs.map((document) {
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
    var dateString = doc['date'] as String;
    var date = DateFormat('yyyy-MMM-dd').parse(dateString);
    return date.year == now.year && date.month == now.month;
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