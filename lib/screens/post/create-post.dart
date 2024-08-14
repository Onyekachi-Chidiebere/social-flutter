import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socials/utils/data.dart';
import 'package:socials/utils/function.dart';
import 'package:toastify/toastify.dart';
import 'package:path/path.dart' as path;

class CreatePost extends StatefulWidget {
  final String? id;
  final String? content;
  final String? imageData;

  const CreatePost({super.key, this.id, this.content, this.imageData});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Uint8List imageBytes = getBase64String(imageData);
  final TextEditingController _descriptionController = TextEditingController();
    bool _loading = false;

  File? _image;
  String base64Image = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    File imageFile = File(pickedFile!.path);
    // Get the file extension to determine the MIME type
    String fileExtension = path.extension(pickedFile.path).toLowerCase();

    String mimeType;
    if (fileExtension == '.png') {
      mimeType = 'image/png';
    } else if (fileExtension == '.jpg' || fileExtension == '.jpeg') {
      mimeType = 'image/jpeg';
    } else {
      mimeType = 'image/*'; // Default fallback
    }
    // Convert the image to bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Convert bytes to base64 string
    String base64String = base64Encode(imageBytes);

    // Store or use the base64 string
    setState(() {
      base64Image = 'data:$mimeType;base64,$base64String';
    });
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateComment();
  }

  void updateComment() {
    setState(() {
      _descriptionController.text = widget.content ?? '';
      base64Image = widget.imageData ?? "";
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = getBase64String(base64Image);

    void _handleSubmitted() async {
      setState(() {
        _loading = true;
      });
      dynamic response;
      if (widget.id != null) {
        response = await editPost(
          id: widget.id,
          imageUrl: base64Image,
          description: _descriptionController.text,
        );
      } else {
        response = await creatPost(
          description: _descriptionController.text,
          imageUrl: base64Image,
        );
      }
      if (response["code"] == '00') {
        setState(() {
          _loading = false;
          _image = null;
          _descriptionController.text = '';
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
        setState(() {
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

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: _handleSubmitted,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button background color
                foregroundColor: Colors.white, // Text color
                side: BorderSide(color: Colors.white, width: 2), // White border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
              child: Row(
                children: [
                   if(!_loading)
                  Text('Publish'),
                   if(_loading)
                      const SpinKitFadingCircle(
                        color: Colors.white,
                        size: 20.0,
                      ),
                ],
              ),
            ),
          ),
        ],
        title: Text(
          widget.id != null ? 'EDIT' : 'CREATE',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?", // Placeholder text
                        contentPadding: EdgeInsets.all(10.0), // Reduce height
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Rounded corners
                          borderSide: BorderSide(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Rounded corners when focused
                          borderSide: BorderSide(
                            color: Colors.orange, // Border color when focused
                            width: 1.0, // Border width
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (base64Image != '')
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                  ),
                ),
              if (base64Image != '') SizedBox(height: 20),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  padding:
                      EdgeInsets.all(5.0), // Adjust padding for border width
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color (optional)
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                    border: Border.all(
                      color: Colors.orange, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8.0), // Inner rounding for image
                    child: SvgPicture.asset(
                      attachmentImage,
                      height: 20,
                      width: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
