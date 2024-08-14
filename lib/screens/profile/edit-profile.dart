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

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with WidgetsBindingObserver {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _image;
  bool _loading = true;
  bool _saving = false;
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

  dynamic userData;

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
    var response = await fetchProfile(id: user.id);
    if (response["code"] == '00') {
      setState(() {
        userData = response["message"]["data"];
        _descriptionController.text =
            response["message"]["data"]?["title"] ?? "";
        _addressController.text =
            response["message"]["data"]?["location"] ?? "";
        base64Image = response["message"]["data"]?["profile_picture"] ?? "";
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Uint8List imageBytes = getBase64String(base64Image);

    void _handleSave() async {
      setState(() {
        _saving = true;
      });
      dynamic response = await saveProfile(
        picture: base64Image,
        description: _descriptionController.text,
        address: _addressController.text,
      );
      if (response["code"] == '00') {
        showToast(
          context,
          Toast(
            duration: Duration(milliseconds: 100),
            lifeTime: Duration(seconds: 3),
            title: 'Success',
            description: response["message"]["info"],
          ),
        );
        setState(() {
        _saving = false;
      });
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
        setState(() {
        _saving = false;
      });
      }
    }
    if(_loading)
    return Scaffold(
      body: SpinKitFadingCircle(
                color: Colors.orange,
                size: 50.0,
              ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EDIT PROFILE',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
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
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: base64Image == ''
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
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: InkWell(
                        onTap: _pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.orange, // Black border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(
                                  80), // Same border radius as ClipRRect
                            ),
                            padding: EdgeInsets.all(7),
                            child: SvgPicture.asset(
                              cameraImage,
                              height: 20.0,
                              width: 20.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                minLines: 1,
                maxLines: 1,
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: "Enter your description", // Placeholder text
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
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Text(
                'Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                minLines: 1,
                maxLines: 1,
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Enter your address", // Placeholder text
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
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button background color
                  foregroundColor: Colors.white, // Text color
                  side:
                      BorderSide(color: Colors.white, width: 2), // White border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save'),
                     if(_saving)
                      SizedBox(width:10),
                      if(_saving)
                      const SpinKitFadingCircle(
                        color: Colors.white,
                        size: 20.0,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
