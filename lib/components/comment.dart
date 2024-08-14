import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socials/utils/data.dart';
import 'package:socials/utils/function.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comment extends StatefulWidget {
  final String username;
  final DateTime time;
  final String content;
  final String userImage;

  Comment({
    super.key,
    required this.username,
    required this.userImage,
    required this.time,
    required this.content,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String timeAgo = timeago.format(widget.time);
    Uint8List imageBytes = getBase64String(widget.userImage);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: widget.userImage != ''
                    ? Image.memory(
                        imageBytes,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.person),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: screenWidth * .74,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Container(
                          width: screenWidth * .6,
                          child: Text(widget.content),
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
                    SvgPicture.asset(
                      likeImage,
                      height: 16.0,
                      width: 16.0,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
