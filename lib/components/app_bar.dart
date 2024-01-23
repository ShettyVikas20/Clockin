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