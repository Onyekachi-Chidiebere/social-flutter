import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:socials/utils/function.dart';
import 'package:toastify/toastify.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _handleSubmitted() async {
         setState((){
        _loading = true;
      });
      dynamic response = await creatAccount(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      if (response["code"] == '00') {
           setState((){
        _loading = false;
      });
        Navigator.pushNamed(context, '/login');
      } else {
        showToast(
          context,
          Toast(
            duration: Duration(milliseconds: 100),
            lifeTime: Duration(seconds: 3),
            title: 'Error',
            description: response["message"],
          ),
        );
           setState((){
        _loading = false;
      });
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  height: 170,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Hello,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Welcome!",
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
                  height: 80,
                ),
                Text("Please enter your perosnal details"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Username ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextField(
                  minLines: 1,
                  maxLines: 1,
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Enter a username", // Placeholder text
                    contentPadding: EdgeInsets.all(10.0), // Reduce height
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Rounded corners when focused
                      borderSide: BorderSide(
                        color: Colors.orange, // Border color when focused
                        width: 1.0, // Border width
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Email address ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextField(
                  minLines: 1,
                  maxLines: 1,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter email address", // Placeholder text
                    contentPadding: EdgeInsets.all(10.0), // Reduce height
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Rounded corners when focused
                      borderSide: BorderSide(
                        color: Colors.orange, // Border color when focused
                        width: 1.0, // Border width
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Password ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextField(
                  obscureText: true,
                  minLines: 1,
                  maxLines: 1,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter password", // Placeholder text
                    contentPadding: EdgeInsets.all(10.0), // Reduce height
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Rounded corners when focused
                      borderSide: BorderSide(
                        color: Colors.orange, // Border color when focused
                        width: 1.0, // Border width
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Confirm password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextField(
                  obscureText: true,
                  minLines: 1,
                  maxLines: 1,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: "Enter password", // Placeholder text
                    contentPadding: EdgeInsets.all(10.0), // Reduce height
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Rounded corners when focused
                      borderSide: BorderSide(
                        color: Colors.orange, // Border color when focused
                        width: 1.0, // Border width
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _handleSubmitted,
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
                      Text('Signup'),
                       if(_loading)
                      SizedBox(width:10),
                      if(_loading)
                      const SpinKitFadingCircle(
                        color: Colors.white,
                        size: 20.0,
                      ),
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
