import 'package:attendanaceapp/components/app_bar.dart';
import 'package:attendanaceapp/screens/dashboard_emp.dart';
import 'package:attendanaceapp/screens/viewmore_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeDetailsPage extends StatefulWidget {
  final String employeeName;
  final String employeeId;

  EmployeeDetailsPage({
    required this.employeeName,
    required this.employeeId,

  });

  @override
  _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  late List<Map<String, dynamic>> allEmployeeData;
  late String selectedDate;
  late String employeeImageUrl; 





  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MMM-dd').format(DateTime.now());
    allEmployeeData = [];
    employeeImageUrl = ''; 
    fetchEmployeeImageUrl(widget.employeeId);

    FirebaseFirestore.instance
        .collection('emp_daily_activity')
        .doc('${widget.employeeName}_${widget.employeeId}_dailyactivity')
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        allEmployeeData = data['daily_activity'].cast<Map<String, dynamic>>();
        print('Fetched employee data: $allEmployeeData');
        setState(() {});
      } else {
        print(
            'Document does not exist for employee: ${widget.employeeName}_${widget.employeeId}_dailyactivity');
      }
    }).catchError((error) {
      print('Error fetching employee data: $error');
    });
  }

   Future<void> fetchEmployeeImageUrl(String employeeId) async {
  try {
    // Assuming you have a Firestore collection named 'Employees'
    CollectionReference employeesCollection = FirebaseFirestore.instance.collection('Employees');

    // Fetch the document where 'id' is equal to the provided employeeId
    QuerySnapshot querySnapshot = await employeesCollection.where('id', isEqualTo: employeeId).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming each employee has a unique 'id', so there should be at most one document
      // Retrieve the 'photo_url' field from the document
      String imageUrl = querySnapshot.docs.first['photo_url'];

      setState(() {
        // Update the state variable with the fetched image URL
        employeeImageUrl = imageUrl;
      });
    } else {
      // No matching document found for the given employeeId
      print('Employee not found for ID: $employeeId');
    }
  } catch (error) {
    print('Error fetching employee image URL: $error');
  }
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

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppbarAdmin('Employee Details - ${widget.employeeName}'),
     body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                     child: CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(employeeImageUrl), // Replace with the actual URL or ImageProvider
                    ),
                  ),
                  SizedBox(width: 25),
                  Text(
                    widget.employeeName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildDateButtons(),
            SizedBox(height: 17),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    // builder: (context) => AnalyticsDashboard(allEmployeeData: allEmployeeData, employeeId: widget.employeeId),
                    builder: (context) => DashBoard(id:widget.employeeId,imageUrl:employeeImageUrl,name: widget.employeeName,),
                    ),
                  );
                },
                child: Text(
                  'view more...',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailsContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButtons() {
    var recentDates = allEmployeeData
        .map<String>((day) => day['date'].toString())
        .toSet()
        .toList()
      ..sort((a, b) {
        var dateA = DateFormat('yyyy-MMM-dd').parse(a);
        var dateB = DateFormat('yyyy-MMM-dd').parse(b);
        return dateB.compareTo(dateA);
      });

    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentDates.length > 6 ? 6 : recentDates.length,
        itemBuilder: (context, index) {
          var date = recentDates[index];
          return GestureDetector(
            onTap: () {
              print('Button clicked for date: $date');
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: selectedDate == date ? Colors.blue.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: const Color.fromARGB(255, 90, 90, 90).withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    date,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

 Widget _buildDetailsContainer() {
  var projectsForSelectedDate = allEmployeeData.where((day) {
    return day['date'] == selectedDate;
  }).toList();

  print('Projects for selected date ($selectedDate): $projectsForSelectedDate');

  return Column(
    children: projectsForSelectedDate.map((day) {
      var projects = day['projects'] as List<dynamic>;

      return Column(
        children: [
          // Text('Date: ${day['date']}'),
          SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // To prevent scrolling conflicts
              itemCount: projects.length,
              itemBuilder: (context, index) {
                var project = projects[index];
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
                            offset: Offset(10.0, 0.0), // Adjust the offset to shift the indicator
                            child: Transform.scale(
                              scale: 0.1, // Adjust the scale to control the size of the circular indicator
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
                                  offset: Offset(10.0, 0.0), // Adjust the offset to shift the indicator
                                  child: Transform.scale(
                                    scale: 0.1, // Adjust the scale to control the size of the circular indicator
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
                                        offset: Offset(0, 2), // changes position of shadow
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
              },
            ),
          ),
        ],
      );
    }).toList(),
  );
}
}

