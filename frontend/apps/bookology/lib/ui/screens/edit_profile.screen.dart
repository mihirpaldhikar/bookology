/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *  the Software, and to permit persons to whom the Software is furnished to do so,
 *  subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 *  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 *  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:io';

import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/ui/widgets/drag_indicator.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String userID;
  final String profilePicture;
  final String userName;
  final bool? isVerified;
  final String firstName;
  final String lastName;
  final String bio;
  final bool isInitialUpdate;

  const EditProfileScreen({
    Key? key,
    required this.userID,
    required this.profilePicture,
    required this.userName,
    this.isVerified = false,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.isInitialUpdate,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final apiService = new ApiService();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final CacheService cacheService = new CacheService();
  String imageURL = '';

  bool isImageUpdated = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      imageURL = widget.profilePicture;
      userNameController.text = widget.userName;
      firstNameController.text = widget.firstName;
      lastNameController.text = widget.lastName;
      bioController.text = widget.bio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.isInitialUpdate,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: !widget.isInitialUpdate
            ? Text(
                'Edit '
                'Profile',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              )
            : Text(
                'Complete Profile',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                showLoaderDialog(context);
                if (widget.profilePicture.toString() != imageURL.toString()) {
                  await uploadFile(imageURL).then((value) async {
                    final result = await apiService.updateUserProfile(
                      userID: widget.userID,
                      userName: userNameController.text,
                      isVerified: widget.isVerified,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      bio: bioController.text,
                      profilePicture: value,
                    );
                    if (result == true) {
                      if (widget.isInitialUpdate) {
                        cacheService.setIntroScreenView(seen: true);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewManager(currentIndex: 0),
                          ),
                          (_) => false,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewManager(currentIndex: 3),
                          ),
                          (_) => false,
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('An error occurred.'),
                        ),
                      );
                    }
                  });
                } else {
                  final result = await apiService.updateUserProfile(
                    userID: widget.userID,
                    userName: userNameController.text,
                    isVerified: widget.isVerified,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    bio: bioController.text,
                    profilePicture: widget.profilePicture,
                  );
                  if (result == true) {
                    if (widget.isInitialUpdate) {
                      cacheService.setIntroScreenView(seen: true);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewManager(currentIndex: 0),
                        ),
                        (_) => false,
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewManager(currentIndex: 3),
                        ),
                        (_) => false,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An error occurred.'),
                      ),
                    );
                  }
                }
              }
            },
            icon: Icon(
              Icons.done_outlined,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 10,
            right: 20,
            left: 20,
          ),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _imagePickerBottomSheet(onCameraPressed: () async {
                      final pickedImage = await _picImage(
                          source: ImageSource.camera, imageURI: imageURL);
                      setState(() {
                        imageURL = pickedImage;
                        isImageUpdated = true;
                      });
                      Navigator.pop(context);
                    }, onGalleryPressed: () async {
                      final pickedImage = await _picImage(
                          source: ImageSource.gallery, imageURI: imageURL);
                      setState(() {
                        imageURL = pickedImage;
                        isImageUpdated = true;
                      });
                      Navigator.pop(context);
                    });
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      isImageUpdated
                          ? SizedBox(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                    File.fromUri(Uri.parse(imageURL))),
                              ),
                            )
                          : CircularImage(
                              image: imageURL,
                              radius: 100,
                            ),
                      Positioned(
                        bottom: -5,
                        right: -10,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFE0E0E0),
                                  blurRadius: 2,
                                  offset: Offset(-4, 4),
                                )
                              ]),
                          child: Icon(
                            Icons.add_a_photo_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Username",
                        fillColor: Colors.white,
                      ),
                      controller: userNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            new RegExp("[^a-z^A-Z^0-9]+"))
                        //Regex for accepting only alphanumeric characters
                      ],
                      validator: (val) {
                        if (val?.length == 0) {
                          return "Username cannot be empty.";
                        } else {
                          if (val!.length < 2) {
                            return "Username is not valid.";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: new InputDecoration(
                        labelText: "First Name",
                        fillColor: Colors.white,
                      ),
                      controller: firstNameController,
                      validator: (val) {
                        if (val?.length == 0) {
                          return "First Name cannot be empty.";
                        } else {
                          if (val!.length < 1) {
                            return "First Name is not valid.";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Last Name",
                        fillColor: Colors.white,
                      ),
                      controller: lastNameController,
                      validator: (val) {
                        if (val?.length == 0) {
                          return "Last Name cannot be empty.";
                        } else {
                          if (val!.length < 1) {
                            return "Last Name is not valid.";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Bio",
                        fillColor: Colors.white,
                      ),
                      controller: bioController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _imagePickerBottomSheet(
      {required VoidCallback onCameraPressed,
      required VoidCallback onGalleryPressed}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                dragIndicator(),
                Center(
                  child: Text(
                    'Pic Image From',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                OutLinedButton(
                  onPressed: onCameraPressed,
                  text: 'Camera',
                  icon: Icons.photo_camera_outlined,
                  showText: true,
                  showIcon: true,
                  align: Alignment.center,
                ),
                SizedBox(
                  height: 20,
                ),
                OutLinedButton(
                  onPressed: onGalleryPressed,
                  text: 'Gallery',
                  icon: Icons.collections_outlined,
                  showText: true,
                  showIcon: true,
                  align: Alignment.center,
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> _picImage(
      {required ImageSource source, required String imageURI}) async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile? photo =
        (await _picker.pickImage(source: source)) as PickedFile?;

    final croppedImage =
        await _cropImage(pickedImage: photo, imageURI: imageURI);

    return croppedImage;
  }

  Future<dynamic> _cropImage(
      {required PickedFile? pickedImage, required String imageURI}) async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: pickedImage!.path,
      cropStyle: CropStyle.circle,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: 'Crop Image',
      ),
      compressQuality: 50,
    ) as File;
    return imageURI = 'file://${cropped.path}';
  }

  Future<dynamic> uploadFile(String filePath) async {
    final name =
        '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().hashCode}';
    File file = File(filePath.split('file://')[1]);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('Users/${widget.userID}/profile/$name.png')
          .putFile(file);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('Users/${widget.userID}/profile/$name.png')
          .getDownloadURL();
      return downloadURL;
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      return e;
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Text("Updating..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
