import 'package:attendanaceapp/components/app_bar.dart';
import 'package:attendanaceapp/components/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProject extends StatefulWidget {
  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  TextEditingController projectNameController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarAdmin('Add Project'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: projectNameController,
                decoration: InputDecoration(
                  hintText: 'Project Name',
                  errorText: errorMessage.isNotEmpty ? errorMessage : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  primary: Color.fromARGB(255, 39, 179, 235),
                ),
                onPressed: () {
                  if (projectNameController.text.isNotEmpty) {
                    _saveProjectToDatabase(projectNameController.text);
                    projectNameController.clear();
                    setState(() {
                      errorMessage = '';
                    });
                     // Show SnackBar on successful project addition
                 showSuccess (context,'Project added successfully!');
                    
                  } else {
                    setState(() {
                      errorMessage = 'Please Enter A Project Name';
                    });
                  }
                },
                child: Text(
                  'Add Project',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Existing Projects:',
                style: TextStyle(fontFamily: 'Kanit-Bold', fontSize: 16),
              ),
              SizedBox(height: 10),
              _buildExistingProjectsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingProjectsList(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('projects').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<DocumentSnapshot> projects = snapshot.data!.docs;

            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                String projectName = projects[index]['projectName'];
                bool isComplete = projects[index]['isComplete'] ?? false;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          projectName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Color.fromARGB(255, 39, 179, 235),
                        ),
                        onPressed: () {
                          if (!isComplete) {
                            _markProjectAsComplete(projects[index].id, context);
                          } else {
                            _restartProject(projects[index].id, context);
                          }
                        },
                        child: Text(
                          isComplete ? 'Restart' : 'Mark as Complete',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_rounded, color: Colors.blue),
                        onPressed: () {
                          _deleteProject(projects[index].id, context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _deleteProject(String projectId, BuildContext context) {
    FirebaseFirestore.instance.collection('projects').doc(projectId).delete().then((_) {
    showSuccess(context,'Project deleted successfully!');
        //  Trigger a rebuild of the widget after deletion
      setState(() {});
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting project: $error'),
        ),
      );
    });
  }

  void _markProjectAsComplete(String projectId, BuildContext context) {
    FirebaseFirestore.instance.collection('projects').doc(projectId).update({
      'isComplete': true,
    }).then((_) {
      // Trigger a rebuild of the widget after marking as complete
      setState(() {});
    });
  }

  void _restartProject(String projectId, BuildContext context) {
    FirebaseFirestore.instance.collection('projects').doc(projectId).update({
      'isComplete': false,
    }).then((_) {
      // Trigger a rebuild of the widget after restarting
      setState(() {});
    });
  }

  void _refreshDialog(BuildContext context) {
    // Rebuild the dialog content
    Navigator.pop(context);
    // _showAddProjectDialog(context);
  }

  void _saveProjectToDatabase(String projectName) {
    FirebaseFirestore.instance.collection('projects').add({
      'projectName': projectName,
      'isComplete': false,
      // Add other project details if needed
    }).then((_) {
      // Trigger a rebuild of the widget after adding
      setState(() {});
    });
  }
}
