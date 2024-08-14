import 'package:flutter/material.dart';
import 'package:socials/screens/auth-screens/login.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  height: 200,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 55,),
                      Text(
                        'Hello,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Let's Chat!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                    // Add your onPressed code here!
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button background color
                    foregroundColor: Colors.white, // Text color
                    side: BorderSide(
                        color: Colors.white, width: 2), // White border
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Login'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
               
                  ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                    // Add your onPressed code here!
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    foregroundColor: Colors.orange, // Text color
                    side: BorderSide(
                        color: Colors.orange, width: 2), // White border
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Signup'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
