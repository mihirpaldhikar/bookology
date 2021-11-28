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

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/handlers/image.handler.dart';
import 'package:bookology/managers/bottom_sheet.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/ui/widgets/rounded_button.widget.dart';
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
  final _apiService = ApiService();
  final _userNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final PreferencesManager _cacheService = PreferencesManager();
  String _imageURL = '';

  bool _isImageUpdated = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _imageURL = widget.profilePicture;
      _userNameController.text = widget.userName;
      _firstNameController.text = widget.firstName;
      _lastNameController.text = widget.lastName;
      _bioController.text = widget.bio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
        builder: (_, mode, child) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: !widget.isInitialUpdate,
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
                      child: RoundedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            DialogsManager(context).showProgressDialog(
                              content: StringConstants.dialogUpdating,
                            );
                            if (widget.profilePicture.toString() !=
                                _imageURL.toString()) {
                              await ImageHandler(context)
                                  .uploadImage(
                                filePath: _imageURL,
                                imageName: 'profile_pic',
                                imagePath: 'Users/${widget.userID}/profile',
                              )
                                  .then(
                                (value) async {
                                  final result =
                                      await _apiService.updateUserProfile(
                                    userID: widget.userID,
                                    userName: _userNameController.text,
                                    isVerified: widget.isVerified,
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    bio: _bioController.text,
                                    profilePicture: value,
                                  );
                                  if (result == true) {
                                    if (widget.isInitialUpdate) {
                                      _cacheService.setIntroScreenView(
                                          seen: true);
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
                                        content:
                                            Text(StringConstants.errorOccurred),
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              final result =
                                  await _apiService.updateUserProfile(
                                userID: widget.userID,
                                userName: _userNameController.text,
                                isVerified: widget.isVerified,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                bio: _bioController.text,
                                profilePicture: widget.profilePicture,
                              );
                              if (result == true) {
                                if (widget.isInitialUpdate) {
                                  _cacheService.setIntroScreenView(seen: true);
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
                                    content:
                                        Text(StringConstants.errorOccurred),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        text: StringConstants.wordDone,
                        textColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
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
                              final pickedImage = await ImageHandler(context)
                                  .picImage(
                                      source: ImageSource.camera,
                                      imageURI: _imageURL);
                              setState(() {
                                _imageURL = pickedImage;
                                _isImageUpdated = true;
                              });
                              Navigator.pop(context);
                            }, onGalleryPressed: () async {
                              final pickedImage = await ImageHandler(context)
                                  .picImage(
                                      source: ImageSource.gallery,
                                      imageURI: _imageURL);
                              setState(() {
                                _imageURL = pickedImage;
                                _isImageUpdated = true;
                              });
                              Navigator.pop(context);
                            });
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _isImageUpdated
                                  ? SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          File.fromUri(
                                            Uri.parse(_imageURL),
                                          ),
                                        ),
                                      ),
                                    )
                                  : CircularImage(
                                      image: _imageURL,
                                      radius: 100,
                                    ),
                              Positioned(
                                bottom: -5,
                                right: -10,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? const Color(0xFF2B2A2A)
                                              : const Color(0xFFE0E0E0),
                                          blurRadius: 2,
                                          offset: const Offset(-4, 4),
                                        )
                                      ]),
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
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
                              style: TextStyle(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                              ),
                              decoration: const InputDecoration(
                                labelText: StringConstants.wordUsername,
                                fillColor: Colors.white,
                              ),
                              controller: _userNameController,
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
                              style: TextStyle(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                              ),
                              decoration: const InputDecoration(
                                labelText: "First Name",
                                fillColor: Colors.white,
                              ),
                              controller: _firstNameController,
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
                              style: TextStyle(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Last Name",
                                fillColor: Colors.white,
                              ),
                              controller: _lastNameController,
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
                              style: TextStyle(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Bio",
                                fillColor: Colors.white,
                              ),
                              controller: _bioController,
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
            ),
          );
        });
  }
}
