import 'package:attendanaceapp/components/app_bar.dart';
import 'package:flutter/material.dart';


class DashBoard  extends StatefulWidget {
  final String name;
  final String imageUrl;
 
  DashBoard ({
    required this.name,
    required this.imageUrl,
  });
@override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
Widget _buildCircularProgress(double percentage, String projectName) {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 8,
              color: _getProgressColor(percentage),
            ),
          ),
          Text(
            (percentage * 100).toInt().toString() + '%',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        projectName,
        style: TextStyle(fontSize: 12,color: const Color.fromARGB(255, 134, 134, 134),fontWeight: FontWeight.bold ),
      ),
    ],
  );
}

Color _getProgressColor(double percentage) {
  if (percentage < 50) {
    return Colors.red;
  } else if (percentage < 70) {
    return Colors.blue;
  } else {
    return Colors.green;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppbarEmp('DashBoard'),
body: Center(
  child: Column(
    children: [
      // Container with employee photo and orange border
      Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.only(top: 60), 
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color.fromARGB(255, 243, 181, 89), width: 4),
          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
                            fit: BoxFit.cover,
                          ),
        ),
      ),
      const SizedBox(height: 16),
      // Employee name
      Text(
        widget.name, // Replace with the actual employee name
        style: TextStyle(fontSize: 25, fontFamily: 'Kanit-Bold',),
      ),
      const SizedBox(height: 66),
      // Circular progress indicator for attendance percentage
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: CircularProgressIndicator(
              value: 0.80, // Replace with the actual attendance percentage (0.75 is just an example)
              strokeWidth: 10,
              color: Colors.blue, // Choose the color you prefer
            ),
          ),
          Text(
            '80%', // Replace with the actual attendance percentage
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Text(
        'TOTAL ATTENDANCE',
        style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 134, 134, 134)),
      ),
      const SizedBox(height: 55),
      // Row with three circular progress indicators
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCircularProgress(0.75, 'Work From Home'),
          const SizedBox(width: 16),
          _buildCircularProgress(0.60, 'In Office'),
          const SizedBox(width: 16),
          _buildCircularProgress(0.90, 'On Leave'),
        ],
      ),
    ],
  ),
),
);

  }
}