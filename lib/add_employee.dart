import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;
  bool _isUploading = false;
  String? _phoneValidationError;
  String? _nameValidationError;
  String? _emailValidationError;
 

void showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        alignment: Alignment.center,
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}

void showSnackbarError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        alignment: Alignment.center,
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor:Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}
 


String? _validateName(String value) {
  if (value.isEmpty) {
    setState(() {
      // Show Snackbar if the name is empty
      showSnackbar('Please Enter Name');
      // Set the error message for the TextField
      _nameValidationError = 'Please Enter Name';
    });
    showSnackbar( 'Please Enter Name'); // Return the error message
  } else {
    // Clear any previous validation error
    setState(() {
      _nameValidationError = null;
    });
  }
  return null; // No error
}
String? _validatePhoneNumber(String value) {
  if (value.length != 10) {
    setState(() {
      // Show Snackbar if the name is empty
     showSnackbarError('Please Enter Correct Phone Number');
      // Set the error message for the TextField
       _phoneValidationError = 'Please Enter Correct Phone Number';
    });
   showSnackbarError( 'Please Enter Correct Phone Number'); // Return the error message
  } else {
    // Clear any previous validation error
    setState(() {
       _phoneValidationError = null;
    });
  }
  return null; // No error
}


String? _validateEmail(String value) {
   final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
 if (!emailRegex.hasMatch(value)) {
    setState(() {
      // Show Snackbar if the name is empty
     showSnackbarError('Enter a valid email address');
      // Set the error message for the TextField
     _emailValidationError = 'Enter a valid email address';
    });
   showSnackbarError( 'Enter a valid email address'); // Return the error message
  } else {
    // Clear any previous validation error
    setState(() {
      _emailValidationError = null;
    });
  }
  return null; // No error
}

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_updatePhoneValidation);
  }

  void _updatePhoneValidation() {
    setState(() {
      // Clear previous validation error when the user starts typing
      _phoneValidationError = null;
    });
  }

  Future<void> _saveToFirestore() async {
    try {
     String? nameError = _validateName(_nameController.text);
    if (nameError != null) {
      showSnackbar(nameError);
    }
      // Validate phone number
     
      // ignore: unused_local_variable
      String? phoneError = _validatePhoneNumber(_phoneController.text);
      if (phoneError != null) {
        showSnackbar(phoneError);
      }

      // Validate email
      String? emailError = _validateEmail(_emailController.text);
      if (emailError != null) {
        showSnackbarError(emailError);
      }

      // Check if an image is selected
      if (_image == null) {
       showSnackbarError('Please select an image');
      }

      // Set _isUploading to true to show the progress indicator
      setState(() {
        _isUploading = true;
      });

      // Upload the image to Firebase Storage
      final String imageName =
          DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('employeesPhotos/$imageName.jpg');
      final UploadTask uploadTask = storageReference.putFile(_image!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Create a map with employee details
      Map<String, dynamic> employeeData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'photo_url': downloadURL,
      };

      // Add the map as a document to the Firestore collection
      await FirebaseFirestore.instance.collection('Employees').add(employeeData);

      // Clear the text fields and image after saving to Firestore
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      setState(() {
        _image = null;
        _isUploading = false;
      });

      // Show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Container( 
              alignment: Alignment.center,
            child:Text('Employee Details Saved Succesfully',
             style: TextStyle( color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold,
             ),  
              textAlign: TextAlign.center,
          ),
          ),
       backgroundColor:   Colors.green,
      behavior: SnackBarBehavior.floating,
      // width: 150,
      margin: EdgeInsets.all(50),
      elevation: 10,
    
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
      ),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // showSnackbar('Error saving to Firestore: $e');
      // Show an error message to the user
     
      // Set _isUploading to false in case of an error
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _selectPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Employees',
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
               
               Color.fromARGB(255, 39, 179, 235), Color.fromARGB(255, 182, 215, 247),
              // Add more colors if you want a gradient effect
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: GestureDetector(
                  onTap: _isUploading ? null : _selectPhoto,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 400,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          image: _image != null
                              ? DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                )
                              : null,
                        ),
                        child: _image == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                      if (_isUploading)
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 142, 162, 253),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: _nameValidationError, 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  errorText: _phoneValidationError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                  errorText: _emailValidationError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  primary:Color.fromARGB(255, 39, 179, 235),
                  elevation: 0,
                  minimumSize: Size(70, 60),
                ),
                onPressed: _isUploading ? null : _saveToFirestore,
                child: const Text('Register',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 59, 58, 58)),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
