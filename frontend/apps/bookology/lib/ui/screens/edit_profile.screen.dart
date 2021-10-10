/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:io';

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/handlers/image.handler.dart';
import 'package:bookology/managers/bottom_sheet.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final apiService = ApiService();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final CacheService cacheService = CacheService();
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
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: !widget.isInitialUpdate
            ? Text(
                StringConstants.navigationEditProfile,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              )
            : Text(
                StringConstants.navigationCompleteProfile,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              height: 20,
              child: OutLinedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    DialogsManager(context).showProgressDialog(
                      content: StringConstants.dialogUpdating,
                      contentColor: Theme.of(context).primaryColor,
                      progressColor: Theme.of(context).colorScheme.secondary,
                    );
                    if (widget.profilePicture.toString() !=
                        imageURL.toString()) {
                      await ImageHandler(context)
                          .uploadImage(
                        filePath: imageURL,
                        imageName:
                            '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().hashCode}',
                        imagePath: 'Users/${widget.userID}/profile',
                      )
                          .then(
                        (value) async {
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
                                  builder: (context) =>
                                      const ViewManager(screenIndex: 0),
                                ),
                                (_) => false,
                              );
                            } else {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ViewManager(screenIndex: 3),
                                ),
                                (_) => false,
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(StringConstants.errorOccurred),
                              ),
                            );
                          }
                        },
                      );
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
                              builder: (context) =>
                                  const ViewManager(screenIndex: 0),
                            ),
                            (_) => false,
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ViewManager(screenIndex: 3),
                            ),
                            (_) => false,
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(StringConstants.errorOccurred),
                          ),
                        );
                      }
                    }
                  }
                },
                text: StringConstants.wordDone,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 10,
            right: 20,
            left: 20,
          ),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    BottomSheetManager(context).imagePickerBottomSheet(
                        onCameraPressed: () async {
                      final pickedImage = await ImageHandler(context).picImage(
                          source: ImageSource.camera, imageURI: imageURL);
                      setState(() {
                        imageURL = pickedImage;
                        isImageUpdated = true;
                      });
                      Navigator.pop(context);
                    }, onGalleryPressed: () async {
                      final pickedImage = await ImageHandler(context).picImage(
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
                                  File.fromUri(
                                    Uri.parse(imageURL),
                                  ),
                                ),
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
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFE0E0E0),
                                  blurRadius: 2,
                                  offset: Offset(-4, 4),
                                )
                              ]),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: StringConstants.wordUsername,
                        fillColor: Colors.white,
                      ),
                      controller: userNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp("[^a-z^A-Z^0-9]+"),
                        ),
                        //Regex for accepting only alphanumeric characters
                      ],
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Username cannot be empty.";
                        } else {
                          if (val.length < 2) {
                            return "Username is not valid.";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        fillColor: Colors.white,
                      ),
                      controller: firstNameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "First Name cannot be empty.";
                        } else {
                          if (val.isEmpty) {
                            return "First Name is not valid.";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                        fillColor: Colors.white,
                      ),
                      controller: lastNameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Last Name cannot be empty.";
                        } else {
                          if (val.isEmpty) {
                            return "Last Name is not valid.";
                          } else {
                            return null;
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
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
}
