import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final String employeeName;
  final String employeeId;
  final List<Map<String, dynamic>> presentDayData;

  EmployeeDetailsPage({
    required this.employeeName,
    required this.employeeId,
    required this.presentDayData,
  });

  @override
  _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  late List<Map<String, dynamic>> allEmployeeData;

  @override
  void initState() {
    super.initState();

    allEmployeeData = [];

    // Fetch all data for the employee
    FirebaseFirestore.instance
        .collection('emp_daily_activity')
        .doc('${widget.employeeName}_${widget.employeeId}')
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        allEmployeeData = data['daily_activity'][0]['projects'].cast<Map<String, dynamic>>();
        // Now, allEmployeeData contains all the data for the employee
        // TODO: Implement your logic to update the UI or perform other actions
        setState(() {
          // Trigger a rebuild to reflect changes
        });
      } else {
        // Handle the case when the document doesn't exist
      }
    }).catchError((error) {
      // Handle errors
      print('Error fetching employee data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details - ${widget.employeeName}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Select a day to view details:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildDateButtons(),
          SizedBox(height: 20),
          _buildDetailsContainer(),
        ],
      ),
    );
  }

  Widget _buildDateButtons() {
    // Assuming 'created_at' is the field in your data containing the date
    var recentDates = allEmployeeData
        .map<String>((project) => project['created_at'].toString())
        .toSet()
        .toList()
        ..sort((a, b) => b.compareTo(a)); // Sort in descending order

    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentDates.length > 6 ? 6 : recentDates.length,
        itemBuilder: (context, index) {
          var date = recentDates[index];
          return ElevatedButton(
            onPressed: () {
              // TODO: Handle button click, update UI with details for the selected date
              print('Button clicked for date: $date');
            },
            child: Text(date),
          );
        },
      ),
    );
  }

  Widget _buildDetailsContainer() {
    return Expanded(
      child: ListView.builder(
        itemCount: allEmployeeData.length,
        itemBuilder: (context, index) {
          var project = allEmployeeData[index];
          return ListTile(
            title: Text(project['name'] ?? 'Unknown Project'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Check-in Time: ${project['checkin_time'] ?? ''}'),
                Text('Check-out Time: ${project['checkout_time'] ?? ''}'),
                Text('Check-in Location: ${project['checkin_location'] ?? ''}'),
                Text('Check-out Location: ${project['checkout_location'] ?? ''}'),
                Text('Notes: ${project['notes'] ?? ''}'),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
