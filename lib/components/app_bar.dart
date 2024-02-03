import 'package:attendanaceapp/screens/add_project.dart';
import 'package:attendanaceapp/screens/admin_holiday_calender.dart';
import 'package:attendanaceapp/screens/calender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

// AppBar AppbarAdminHome(String text) {
//   return AppBar(
//     centerTitle: true,
//     title: Text(
//       text,
//       style: const TextStyle(
//         fontFamily: 'Kanit-Bold',
//         fontWeight: FontWeight.bold,
//         color: Color.fromARGB(255, 59, 58, 58),
//       ),
//     ),
//     elevation: 0,
//     shape: ContinuousRectangleBorder(
//       borderRadius: BorderRadius.circular(30.0),
//     ),
//     flexibleSpace: Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color.fromARGB(255, 39, 179, 235),
//             Color.fromARGB(255, 182, 215, 247),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//     ),
//     actions: [
//       // Add a menu icon on the right side of the appbar
//       CustomPopupMenuButton(),
//     ],
//   );
// }

// class CustomPopupMenuButton extends StatelessWidget {
  //  void _showAddProjectDialog(BuildContext context) {
  //   TextEditingController projectNameController = TextEditingController();
  //   String errorMessage = '';

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return     Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20.0),
  //             ),
  //             child: SingleChildScrollView(
  //            child: 
  //             Container(
  //               height: 600,
  //               width: 900,
  //               padding: EdgeInsets.all(16.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text('Add Project'),
  //                   SizedBox(height: 10),
  //                   TextField(
  //                     controller: projectNameController,
  //                     decoration: InputDecoration(
  //                       hintText: 'Project Name',
  //                       errorText: errorMessage.isNotEmpty ? errorMessage : null,
  //                     ),
  //                   ),
  //                   SizedBox(height: 20),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       if (projectNameController.text.isNotEmpty) {
  //                         _saveProjectToDatabase(projectNameController.text);
  //                         projectNameController.clear();
  //                         setState(() {
  //                           errorMessage = '';
  //                         });
  //                       } else {
  //                         setState(() {
  //                           errorMessage = 'Please enter a project name';
  //                         });
  //                       }
  //                     },
  //                     child: Text('Add Project'),
  //                   ),
  //                   SizedBox(height: 20),
  //                   Text('Existing Projects:'),
  //                   SizedBox(height: 10),
  //                   _buildExistingProjectsList(context),
  //                 ],
  //               ),
  //             ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget _buildExistingProjectsList(BuildContext context) {
  //   return FutureBuilder<QuerySnapshot>(
  //     future: FirebaseFirestore.instance.collection('projects').get(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator(); // Display a loading indicator while fetching data
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else {
  //         List<DocumentSnapshot> projects = snapshot.data!.docs;

  //         return ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: projects.length,
  //           itemBuilder: (context, index) {
  //             String projectName = projects[index]['projectName'];
  //             bool isComplete = projects[index]['isComplete'] ?? false;

  //             return Row(
  //               children: [
  //                 Expanded(child: Text(projectName)),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     if (!isComplete) {
  //                       _markProjectAsComplete(projects[index].id, context);
  //                     } else {
  //                       _restartProject(projects[index].id, context);
  //                     }
  //                   },
  //                   child: Text(isComplete ? 'Restart' : 'Mark as Complete'),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  // void _markProjectAsComplete(String projectId, BuildContext context) {
  //   // Implement the logic to mark the project as complete in the database
  //   // You can update a field like 'isComplete' to true for the selected project
  //   FirebaseFirestore.instance.collection('projects').doc(projectId).update({
  //     'isComplete': true,
  //   }).then((_) {
  //     // Trigger a rebuild of the dialog content
  //     _refreshDialog(context);
  //   });
  // }

  // void _restartProject(String projectId, BuildContext context) {
  //   // Implement the logic to restart the project in the database
  //   // You can update a field like 'isComplete' to false for the selected project
  //   FirebaseFirestore.instance.collection('projects').doc(projectId).update({
  //     'isComplete': false,
  //   }).then((_) {
  //     // Trigger a rebuild of the dialog content
  //     _refreshDialog(context);
  //   });
  // }

  // void _refreshDialog(BuildContext context) {
  //   // Rebuild the dialog content
  //   Navigator.pop(context);
  //   _showAddProjectDialog(context);
  // }
  // void _saveProjectToDatabase(String projectName) {
  //   FirebaseFirestore.instance.collection('projects').add({
  //     'projectName': projectName,
  //     'isComplete': false,
  //     // Add other project details if needed
  //   });
  // }

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<int>(
//       icon: Icon(Icons.menu, color: Colors.white),
//       itemBuilder: (context) => [
//         buildPopupMenuItem(1, Icons.calendar_month, "Calendar", context),
//         buildPopupMenuItem(3, Icons.add_rounded, "Projects", context),
//         buildPopupMenuItem(2, Icons.person, "Profile", context),
//       ],
//       offset: Offset(0, 100),
//       color: Color.fromARGB(255, 13, 49, 102),
//       elevation: 0,
//     );
//   }

//   PopupMenuItem<int> buildPopupMenuItem(
//       int value, IconData iconData, String text, BuildContext context) {
//     return PopupMenuItem(
//       value: value,
//       child: GestureDetector(
//         onTap: () {
//           handlePopupMenuItemClick(value, context);
//         },
//         child: Row(
//           children: [
//             Icon(iconData, color: Color.fromARGB(255, 255, 255, 255)),
//             SizedBox(width: 10),
//             Text(
//               text,
//               style: TextStyle(
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void handlePopupMenuItemClick(int value, BuildContext context) {
//     switch (value) {
//       case 1: // Calendar
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   Home()), // Replace Home with your actual page
//         );
//         break;
//       case 3:
//        Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                  AddProject()), // Replace Home with your actual page
//         );
//         break;
//       // Add more cases for other menu items if needed
//     }
//   }
// }


AppBar AppbarAdminHome(String text, GlobalKey<ScaffoldState> scaffoldKey) {
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
     leading: Align(
      alignment: Alignment.centerRight,
      child: IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
    ),
     ),
  );
}