import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:socials/models/User.dart';
import 'package:socials/utils/auth-provider.dart';
import 'package:socials/utils/data.dart';
import 'package:socials/utils/function.dart';
import 'package:toastify/toastify.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _handleSubmitted() async {
      setState((){
        _loading = true;
      });
      dynamic response = await login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      if (response["code"] == '00') {
        UserApp _userData = UserApp(
          id: response["message"]["_id"],
          email: response["message"]["email"],
          username: response["message"]["username"],
          api_token: response["message"]["accessToken"],
        );
        context.read<AuthState>().setUser(
              _userData,
            );
        user = _userData;
        setState((){
        _loading = false;
      });
      } else {
        setState((){
        _loading = false;
      });
        showToast(
          context,
          Toast(
            duration: Duration(milliseconds: 100),
            lifeTime: Duration(seconds: 3),
            title: 'Error',
            description: response["message"],
          ),
        );
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
                  height: 200,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 55,
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
                        "Welcome Back!",
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
                Text("Please enter your login details"),
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
                  controller: _usernameController,
                  minLines: 1,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Username", // Placeholder text
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
                  'Password',
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
                      Text('Login'),
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
