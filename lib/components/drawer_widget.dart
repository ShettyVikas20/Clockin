import 'package:attendanaceapp/screens/add_project.dart';
import 'package:attendanaceapp/screens/calender.dart';
import 'package:flutter/material.dart';

class YourDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 260,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 62, 136),
            Color.fromARGB(255, 182, 215, 247),
                  
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'CLOCKIN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Kanit-Bold',
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month,color: Colors.black,),
            title: Text('Calender',style: TextStyle(fontSize: 16,fontFamily: 'Kanit-Bold'),),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Home ()), // Replace CalenderPage with your actual page
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add,color: Colors.black),
            title: Text('Projects',style: TextStyle(fontSize: 16,fontFamily: 'Kanit-Bold'),),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AddProject()), // Replace CalenderPage with your actual page
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person,color: Colors.black),
            title: Text('Profile',style: TextStyle(fontSize: 16,fontFamily: 'Kanit-Bold'),),
            onTap: () {
              // Navigate to settings or perform any action
              Navigator.pop(context);
            },
          ),
          // Add more ListTile items as needed
        ],
      ),
    );
  }
}
