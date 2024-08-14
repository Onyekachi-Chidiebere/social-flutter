import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:socials/components/post.dart';
import 'package:socials/screens/profile/edit-profile.dart';
import 'package:socials/utils/data.dart';
import 'package:socials/utils/function.dart';

class FollowRow extends StatefulWidget {
  final String? id;
  final List followers;
  final List following;
  const FollowRow({
    super.key,
    this.id,
    required this.followers,
    required this.following,
  });

  @override
  State<FollowRow> createState() => _FollowRowState();
}

class _FollowRowState extends State<FollowRow> {
  bool _fetching = false;

  void _handleFollow() async {
    setState(() {
      _fetching = true;
    });
    var response = await followUser(id: widget.id);
    if (response["code"] == '00') {
      if (response["message"]["data"]) {
        setState(() {
          widget.followers.add(user.id);
        });
      } else {
        setState(() {
          widget.followers.remove(user.id);
        });
      }
    }
    setState(() {
      _fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.followers.length.toString() ?? '0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Followers',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400]),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.following.length.toString() ?? '0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Following',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400]),
              ),
            ],
          ),
          if (widget.id == user.id||widget.id==null)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white, width: 2), // White border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
              child: Text('Edit Profile'),
            ),
          if (widget.id != user.id&&widget.id!=null)
            ElevatedButton(
              onPressed: _handleFollow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white, width: 2), // White border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
              child: Row(
                children: [
                  Text(widget.followers.contains(user.id)
                      ? 'Unfollow'
                      : 'Follow'),
                  if (_fetching)
                    SizedBox(
                      width: 10,
                    ),
                  if (_fetching)
                    const SpinKitFadingCircle(
                      color: Colors.white,
                      size: 20.0,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class Profile extends StatefulWidget {
  final String? id;

  const Profile({
    super.key,
    this.id,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver {
  dynamic userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateProfile();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Page is focused on/resumed
      updateProfile();
    }
  }

  Future<void> updateProfile() async {
    // Replace with actual function to fetch userData from the server
    var response = await fetchProfile(id: widget.id);
    if (response["code"] == '00') {
      setState(() {
        userData = response["message"]["data"];
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Uint8List imageBytes = getBase64String(userData?["profile_picture"] ?? '');
    if (_loading)
      return Scaffold(
        body: SpinKitFadingCircle(
          color: Colors.orange,
          size: 50.0,
        ),
      );
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  color: Colors.orange.withOpacity(0.5),
                  height: 150,
                  width: 400,
                ),
                Positioned(
                  width: screenWidth,
                  top: 80,
                  child: Center(
                      child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange, // Black border color
                        width: 4, // Border width
                      ),
                      borderRadius: BorderRadius.circular(
                          80), // Same border radius as ClipRRect
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Container(
                        color: Colors.white,
                        child: userData?["profile_picture"] == null
                            ? Icon(
                                Icons.person,
                                size: 150,
                                color: Colors.grey,
                              )
                            : Image.memory(
                                imageBytes,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  )),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                userData?["username"] ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Center(
              child: Text(
                userData?["location"] ?? '',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400]),
              ),
            ),
            Center(
              child: Text(
                userData?["title"] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            FollowRow(followers: userData?["followers"]??[],id: widget.id, following:userData?["following"]??[],),
            if (userData?["posts"] != null)
              for (int i = 0; i < userData?["posts"]?.length; i++)
                Post(
                  id: userData?["posts"][i]["_id"],
                  username: userData?["posts"][i]["title"],
                  time: DateTime.parse(userData?["posts"][i]["created_at"]),
                  content: userData?["posts"][i]["description"],
                  imageData: userData?["posts"][i]["image_url"],
                  likes: userData?["posts"][i]["likes"],
                  comments: userData?["posts"][i]["comments"],
                  userImage: userData?["posts"][i]["assigned_to"]
                          ["profile_picture"] ??
                      '',
                  posterId: userData?["posts"][i]["assigned_to"]["_id"],
                ),
          ],
        ),
      ),
    );
  }
}
