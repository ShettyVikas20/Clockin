import 'package:attendanaceapp/screens/admin_holiday_calender.dart';
import 'package:attendanaceapp/screens/calender.dart';
import 'package:flutter/material.dart';

AppBar AppbarAdmin(String text) {
  return AppBar(
    centerTitle: true,
    title: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Kanit-Bold',
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 59, 58, 58),
      ),
    ),
    elevation: 0,
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
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
  );
}

AppBar AppbarEmp(String text) {
  return AppBar(
    centerTitle: true,
    title: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Kanit-Bold',
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 59, 58, 58),
      ),
    ),
    elevation: 0,
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [         
                 Color.fromARGB(255, 233, 121, 46),
                Color.fromARGB(255, 247, 153, 14),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  );
}

AppBar AppbarAdminHome(String text) {
  return AppBar(
    centerTitle: true,
    title: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Kanit-Bold',
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 59, 58, 58),
      ),
    ),
    elevation: 0,
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
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
    actions: [
      // Add a menu icon on the right side of the appbar
      CustomPopupMenuButton(),
    ],
  );
}


class CustomPopupMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.menu, color: Colors.white),
      itemBuilder: (context) => [
        buildPopupMenuItem(1, Icons.calendar_month, "Calendar", context),
        buildPopupMenuItem(3, Icons.add, "Add Project", context),
        buildPopupMenuItem(2, Icons.person, "Profile", context),
      ],
      offset: Offset(0, 100),
      color: Color.fromARGB(255, 91, 148, 233).withOpacity(0.3),
      elevation: 0,
    );
  }

  PopupMenuItem<int> buildPopupMenuItem(int value, IconData iconData, String text, BuildContext context) {
    return PopupMenuItem(
      value: value,
      child: GestureDetector(
        onTap: () {
          handlePopupMenuItemClick(value, context);
        },
        child: Row(
          children: [
            Icon(iconData, color: Color.fromARGB(255, 2, 44, 78)),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Color.fromARGB(255, 2, 44, 78),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handlePopupMenuItemClick(int value, BuildContext context) {
    switch (value) {
      case 1: // Calendar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()), // Replace Home with your actual page
        );
        break;
      case 3: // Add Project
        _showAddProjectDialog(context);
        break;
      // Add more cases for other menu items if needed
    }
  }

  void _showAddProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: 100,
            height: 600,
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
           child: Column(
              children: [
               
              // Your dialog content goes here

              // Add a button at the bottom
              SizedBox(height: 20), // Adjust spacing as needed
              ElevatedButton(
                onPressed: () {
                  // Add your button action here
                  Navigator.pop(context); // Close the dialog if needed
                },
                child: Text('Add Project'),
              ),
               
              ],
            ),
            ),
          ),
        );
      },
    );
  }
}
