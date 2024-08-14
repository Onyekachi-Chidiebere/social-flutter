import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:socials/components/Post.dart';
import 'package:socials/components/comment.dart';
import 'package:socials/utils/function.dart';
import 'package:toastify/toastify.dart';

class ViewPost extends StatefulWidget {
  final String id;
  final String posterId;
  final String username;
  final DateTime time;
  final String content;
  final String imageData;
  final String userImage;
  final List likes;
  List comments;

  ViewPost({
    super.key,
    required this.id,
    required this.posterId,
    required this.username,
    required this.userImage,
    required this.time,
    required this.content,
    required this.imageData,
    required this.likes,
    required this.comments,
  });

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.comments.toString());

    double screenHeight = MediaQuery.of(context).size.height;
    void _handleSubmitted() async {
      dynamic response = await commentPost(
        comment: _commentController.text,
        postId: widget.id,
      );
      if (response["code"] == '00') {
        setState(() {
          widget.comments = response["message"]["data"]["comments"];
          _commentController.text = '';
        });
        showToast(
          context,
          Toast(
            duration: Duration(milliseconds: 100),
            lifeTime: Duration(seconds: 3),
            title: 'Success',
            description: response["message"]["info"],
          ),
        );
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
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POST',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Post(
                    id: widget.id,
                    username: widget.username,
                    time: widget.time,
                    content: widget.content,
                    imageData: widget.imageData,
                    likes: widget.likes,
                    comments: widget.comments,
                    userImage: widget.userImage,
                    posterId: widget.posterId,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'COMMENTS (${widget.comments.length})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  for (int i = 0; i < widget.comments.length; i++)
                    Comment(
                      username: widget.comments[i]["user"]["username"],
                      userImage:
                          widget.comments[i]["user"]['profile_picture'] != null
                              ? widget.comments[i]["user"]['profile_picture']
                              : '',
                      time: DateTime.parse(widget.comments[i]["timestamp"]),
                      content: widget.comments[i]["comment"],
                    ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * .75,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 10,
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText:
                                "Type your comment here ...", // Placeholder text
                            contentPadding:
                                EdgeInsets.all(10.0), // Reduce height
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Rounded corners
                              borderSide: BorderSide(
                                color: Colors.grey, // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Rounded corners when focused
                              borderSide: BorderSide(
                                color:
                                    Colors.orange, // Border color when focused
                                width: 1.0, // Border width
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: _handleSubmitted,
                        child: Icon(Icons.send),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
