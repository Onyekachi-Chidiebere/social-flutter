import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socials/utils/data.dart';

Uint8List getBase64String(val) {
  String result = val.split(',').last;
  Uint8List imageBytes = base64Decode(result);
  return imageBytes;
}

dynamic login({username, password}) async {
  dynamic result;
  try {
    var response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        "password": password,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}

dynamic creatAccount({username, password, email, confirmPassword}) async {
  dynamic result;
  try {
    var response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        "password": password,
        "confirm_password": confirmPassword,
        "email": email,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}

dynamic creatPost({
  description,
  imageUrl,
}) async {
  dynamic result;
  try {
    var response = await http.post(
      Uri.parse('$baseUrl/post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': user.username,
        "description": description,
        "user_id": user.id,
        "image_url": imageUrl,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}


dynamic editPost({
  description,
  imageUrl,
  id
}) async {
  dynamic result;
  try {
    var response = await http.patch(
      Uri.parse('$baseUrl/post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "description": description,
        "post_id": id,
        "image_url": imageUrl,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}


dynamic deletePost({
  id
}) async {
  dynamic result;
  try {
    var response = await http.delete(
      Uri.parse('$baseUrl/post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "post_id": id,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}

dynamic commentPost({
  comment,
  postId,
}) async {
  dynamic result;
  try {
    var response = await http.post(
      Uri.parse('$baseUrl/comment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user": user.id,
        "comment": comment,
        "post_id": postId,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}



dynamic followUser({
  id
}) async {
  dynamic result;
  try {
    var response = await http.post(
      Uri.parse('$baseUrl/follow'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": id,
        "follower_id": user.id,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}


dynamic likePost({
  postId,
}) async {
  dynamic result;
  try {
    var response = await http.post(
      Uri.parse('$baseUrl/like'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": user.id,
        "post_id": postId,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}

dynamic fetchProfile({
  id,
}) async {
  dynamic result;
  try {
    var response = await http.post(
      Uri.parse('$baseUrl/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": id ?? user.id,
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}

dynamic saveProfile({picture, address, description}) async {
  dynamic result;
  try {
    var response = await http.patch(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": user.id,
        "profile_picture": picture,
        "location": address,
        "title": description
      }),
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}

dynamic getPost() async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('$baseUrl/post'),
      headers: {'Content-Type': 'application/json'},
    );
    debugPrint(response.body);
    result = jsonDecode(response.body);
    return result;
  } catch (e) {
    debugPrint('Error: ${e.toString()}');
    if (e is SocketException) {}
  }
}
