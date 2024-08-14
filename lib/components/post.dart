import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socials/screens/post/create-post.dart';
import 'package:socials/screens/post/view-post.dart';
import 'package:socials/screens/profile/profile.dart';
import 'package:socials/utils/data.dart';
import 'package:socials/utils/function.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toastify/toastify.dart';

class Like extends StatefulWidget {
  final String id;
  final List likes;
  const Like({
    super.key,
    required this.id,
    required this.likes,
  });

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> {
  @override
  Widget build(BuildContext context) {
    void _handleLike() async {
      dynamic response = await likePost(
        postId: widget.id,
      );
      if (response["code"] == '00') {
        if (response["message"]["data"]) {
          setState(() {
            widget.likes.add(user.id);
          });
        } else {
          setState(() {
            widget.likes.remove(user.id);
          });
        }
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

    return Row(
      children: [
        InkWell(
          onTap: _handleLike,
          child: SvgPicture.asset(
            widget.likes.contains(user.id) ? likeOrange : likeImage,
            height: 16.0,
            width: 16.0,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(widget.likes.length.toString()),
      ],
    );
  }
}

class Post extends StatefulWidget {
  final String id;
  final String posterId;
  final String username;
  final DateTime time;
  final String content;
  final String imageData;
  final String userImage;
  final List likes;
  final List comments;
  Function? delete;

   Post({
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
    this.delete,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String timeAgo = timeago.format(widget.time);
    Uint8List imageBytes = getBase64String(widget.imageData);
    Uint8List userImageBytes = getBase64String(widget.userImage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: widget.userImage != ''
                    ? Image.memory(
                        userImageBytes,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.person, color: Colors.grey, size: 40),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: screenWidth * .76,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                             Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile(id: widget.posterId,)),
                      );
                          },
                          child: Text(
                            widget.username,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        Text(
                          timeAgo,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                      initialValue: '',
                      onSelected: (dynamic item) {
                        if (item == 'view_post') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPost(
                                id: widget.id,
                                username: widget.username,
                                userImage: widget.userImage,
                                time: widget.time,
                                content: widget.content,
                                imageData: widget.imageData,
                                likes: widget.likes,
                                comments: widget.comments,
                                posterId:widget.posterId
                              ),
                            ),
                          );
                        }
                        if (item == 'edit_post') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePost(
                                id: widget.id,
                                content: widget.content,
                                imageData: widget.imageData,
                              ),
                            ),
                          );
                        }
                        if (item == 'delete_post') {
                         widget.delete!();
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        const PopupMenuItem(
                          value: 'view_post',
                          child: Text('View '),
                        ),
                        if(user.username == widget.username )
                         const PopupMenuItem(
                          value: 'edit_post',
                          child: Text('Edit '),
                        ),
                        if(widget.delete!=null && user.username == widget.username)
                         const PopupMenuItem(
                          value: 'delete_post',
                          child: Text('Delete '),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(widget.content),
        ),
        if (widget.imageData != '')
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.memory(
                imageBytes,
                height: 150,
                width: screenWidth * .9,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Like(
                id: widget.id,
                likes: widget.likes,
              ),
              SizedBox(
                width: 20,
              ),
              SvgPicture.asset(
                commentImage,
                height: 16.0,
                width: 16.0,
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.comments.length.toString()),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
