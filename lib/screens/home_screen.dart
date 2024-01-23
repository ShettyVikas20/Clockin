import 'package:attendanaceapp/screens/emp_login.dart';
import 'package:attendanaceapp/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: Text(
      //     'ATTENDANCE MANAGER',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: Color.fromARGB(255, 59, 58, 58),
      //     ),
      //   ),
      //   backgroundColor: Color.fromARGB(255, 142, 162, 253),
      //   centerTitle: true,
      //   elevation: 0,
      //   shape: ContinuousRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0),
      //   ),
      // ),
      body: Container(
      color: Color.fromARGB(255, 182, 215, 247),
      child:SingleChildScrollView(
        child:
      Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Container(
                  height: height * 0.5,
                 width: width,
                  decoration: BoxDecoration(
                     gradient: LinearGradient(
            colors: [ Color.fromARGB(255, 247, 153, 14),Color.fromARGB(255, 233, 121, 46)],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
                    // color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/images/employe.json',
                        width: 250,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                       SizedBox(height: 64),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Color.fromARGB(255, 250, 224, 78),
                               Color.fromARGB(255, 253, 253, 253)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          child: Text(
                            "Login as Employee",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit-Bold',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
               GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                },
             child: Container(
                 decoration: BoxDecoration(   
                   gradient: LinearGradient(
            colors: [ Color.fromARGB(255, 247, 153, 14),Color.fromARGB(255, 233, 121, 46)],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),              
                    color: Colors.yellow,
                    
                  ),
                child: Container(
                    height: height * 0.5,
                   width: width,
                      decoration: BoxDecoration(
                        
                     gradient: LinearGradient(
            colors: [ Color.fromARGB(255, 182, 215, 247),Color.fromARGB(255, 39, 179, 235),],
            begin: Alignment.topRight,
            end: Alignment.topLeft,
          ),
                    // color: Colors.yellow,
                    // borderRadius: BorderRadius.only(
                    //   bottomRight: Radius.circular(50),
                    // ),
                    
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50),
                  ),
                      ),
                    // decoration: BoxDecoration(
                      
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(50),
                    //   ),
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/images/admin.json',
                          width: 250,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                         SizedBox(height: 64),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                               Color.fromARGB(255, 18, 2, 109), Color.fromARGB(255, 167, 165, 165)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          child: Text(
                            "Login as Admin",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit-Bold',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
               ),
            ],
          ),
        ],
      ),
      ),
      ),
    );
  }
}
