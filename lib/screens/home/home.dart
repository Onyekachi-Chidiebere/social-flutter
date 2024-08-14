import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:socials/components/post.dart';
import 'package:socials/main.dart';
import 'package:socials/utils/data.dart';
import 'package:socials/utils/function.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver,RouteAware {
  List<dynamic> posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer
    updatePosts(); // Fetch posts when the widget is initialized
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Page is focused on/resumed
      updatePosts(); // Call getPosts function when the page is resumed
    }
  }
@override
  void didPopNext() {
    // Called when this route is now visible after popping the next route
    updatePosts(); // Refresh posts when returning to this screen
  }


  @override
  void didPush() {
    super.didPush();
  }

  @override
  void didPop() {
    super.didPop();
  }

  @override
  void didPushNext() {
    super.didPushNext();
  }
  Future<void> updatePosts() async {
    // Replace with actual function to fetch posts from the server or local storage
    var response = await getPost();
    if (response["code"] == '00') {
      setState(() {
        _loading = false;
        posts = response["message"]["data"]; // Update the posts list
      });
    }
  }

  Future _handleDeletePost(postId) async {
    var response = await deletePost(id: postId);
    if (response["code"] == '00') {
      setState(() {
        posts.removeWhere((item) => item['_id'] == postId);
      });
    }
  }
  void _showWarningAlert(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Text('Warning'),
            ],
          ),
          content: Text('Are you sure you want to delete post?'),
          actions: [
            TextButton(
              child: Text('Cancel',style:TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, 
              ),
              child: Text('Delete',style:TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),),
              onPressed: ()async {
                print(postId);
                // Handle the action here
                await _handleDeletePost(postId);
                Navigator.of(context).pop(); // Dismiss the dialog

              },
            ),
          ],
        );
      },
    );
  }

  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Subscribe this screen to the RouteObserver if the route is a PageRoute
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); 
         routeObserver.unsubscribe(this); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Text(
                'Welcome ${user.username}!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            if (_loading) SizedBox(height: 60),
            if (_loading)
              const SpinKitFadingCircle(
                color: Colors.orange,
                size: 50.0,
              ),
            for (int i = 0; i < posts.length; i++)
              Post(
                id: posts[i]["_id"],
                username: posts[i]["title"],
                time: DateTime.parse(posts[i]["created_at"]),
                content: posts[i]["description"],
                imageData: posts[i]["image_url"],
                likes: posts[i]["likes"],
                comments: posts[i]["comments"],
                userImage: posts[i]["assigned_to"]["profile_picture"] ?? '',
                posterId: posts[i]["assigned_to"]["_id"],
                delete: (){
                  _showWarningAlert(context, posts[i]["_id"]);
                },
              ),
          ],
        ),
      ),
    );
  }
}
