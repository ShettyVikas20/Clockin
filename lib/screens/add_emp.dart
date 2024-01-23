import 'package:attendanaceapp/components/app_bar.dart';
import 'package:attendanaceapp/components/snack_bar.dart';
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
 
String? _validateName(String value) {
  if (value.isEmpty) {
    setState(() {
     
      _nameValidationError = 'Please Enter Name';
    });
  } 
   else {
    setState(() {
      _nameValidationError = null;
    });
  }
  return null; 
}

String? _validatePhoneNumber(String value) {
  if (value.length != 10) {
    setState(() {
       _phoneValidationError = 'Please Enter Correct Phone Number';
    });
  } 
  else {
   
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
      // Set the error message for the TextField
     _emailValidationError = 'Enter a valid email address';
    });
 
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
      
    }
      // Validate phone number
      String? phoneError = _validatePhoneNumber(_phoneController.text);
      if (phoneError != null) {
       
      }

      // Validate email
      String? emailError = _validateEmail(_emailController.text);
      if (emailError != null) {
        
      }

      // Check if an image is selected
      if (_image == null) {
      showError(context,'Please select an image');
      }
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
       showSuccess(context,'Employee Details Saved Succesfully');
    } catch (e) {
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
      appBar:AppbarAdmin('Add Employee'),
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
                        const CircularProgressIndicator(
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
                    borderSide: const BorderSide(
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
                    borderSide: const BorderSide(
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
                    borderSide: const BorderSide(
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
