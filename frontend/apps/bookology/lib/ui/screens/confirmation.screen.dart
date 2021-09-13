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
import 'dart:math';

import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/location.service.dart';
import 'package:bookology/ui/widgets/image_container.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

class ConfirmationScreen extends StatefulWidget {
  final String isbn;
  final String bookName;
  final String bookAuthor;
  final String bookPublisher;
  final String bookCondition;
  final String bookOriginalPrice;
  final String bookSellingPrice;
  final String bookDescription;
  final String bookImage1;
  final String bookImage2;
  final String bookImage3;
  final String bookImage4;

  const ConfirmationScreen({
    Key? key,
    required this.isbn,
    required this.bookName,
    required this.bookAuthor,
    required this.bookPublisher,
    required this.bookCondition,
    required this.bookOriginalPrice,
    required this.bookSellingPrice,
    required this.bookDescription,
    required this.bookImage1,
    required this.bookImage2,
    required this.bookImage3,
    required this.bookImage4,
  }) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final ApiService apiService = new ApiService();
  final locationService = new LocationService();
  String currentLocation = '';
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String imageDownloadURL1 = '';
  String imageDownloadURL2 = '';
  String imageDownloadURL3 = '';
  String imageDownloadURL4 = '';
  bool isUploading = false;
  String imagesCollectionsID = '';
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890_';
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setState(() {
      imagesCollectionsID = getRandomString(20);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        title: Text(
          StringConstants.TITLE_CONFIRMATION,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SafeArea(
          child: isUploading
              ? Container(
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: LiquidCircularProgressIndicator(
                        value: 0.35,
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.secondary,
                        ),
                        backgroundColor: Colors.white,
                        borderColor: ColorsConstant.DARK_COLOR,
                        borderWidth: 5.0,
                        direction: Axis.vertical,
                        center: Text(
                          StringConstants.DIALOG_UPLOADING,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '${StringConstants.ISBN}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.isbn,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '${StringConstants.BOOK_NAME}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.bookName,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '${StringConstants.AUTHOR}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.bookAuthor,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '${StringConstants.PUBLISHER}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.bookPublisher,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              text: TextSpan(
                                text: '${StringConstants.DESCRIPTION}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.bookDescription.trim() + '...',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '${StringConstants.ORIGINAL_PRICE}:  ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: widget.bookOriginalPrice,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '${StringConstants.SELLING_PRICE}:  ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: widget.bookSellingPrice,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ImageHolder(
                                    onPressed: () {},
                                    onCancelled: () {},
                                    imageURL: widget.bookImage1,
                                    showCloseButton: false,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ImageHolder(
                                    onPressed: () {},
                                    onCancelled: () {},
                                    imageURL: widget.bookImage2,
                                    showCloseButton: false,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ImageHolder(
                                    onPressed: () {},
                                    onCancelled: () {},
                                    imageURL: widget.bookImage3,
                                    showCloseButton: false,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ImageHolder(
                                    onPressed: () {},
                                    onCancelled: () {},
                                    imageURL: widget.bookImage4,
                                    showCloseButton: false,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                OutLinedButton(
                                  text: StringConstants.UPLOAD,
                                  showText: true,
                                  showIcon: false,
                                  onPressed: () async {
                                    setState(() {
                                      isUploading = true;
                                    });
                                    await uploadFile(widget.bookImage1, user)
                                        .then((value) {
                                      setState(() {
                                        imageDownloadURL1 = value;
                                      });
                                    }).then((value) async {
                                      await uploadFile(widget.bookImage2, user)
                                          .then((value) {
                                        setState(() {
                                          imageDownloadURL2 = value;
                                        });
                                      }).then((value) async {
                                        await uploadFile(
                                                widget.bookImage3, user)
                                            .then((value) {
                                          setState(() {
                                            imageDownloadURL3 = value;
                                          });
                                        }).then((value) async {
                                          await uploadFile(
                                                  widget.bookImage4, user)
                                              .then((value) {
                                            setState(() {
                                              imageDownloadURL4 = value;
                                            });
                                          });
                                        });
                                      });
                                    });

                                    final result =
                                        await apiService.postBookData(
                                      isbn: widget.isbn,
                                      bookName: widget.bookName,
                                      bookAuthor: widget.bookAuthor,
                                      bookPublisher: widget.bookPublisher,
                                      bookDescription: widget.bookDescription,
                                      bookCondition: widget.bookCondition,
                                      originalPrice: widget.bookOriginalPrice,
                                      sellingPrice: widget.bookSellingPrice,
                                      location: this.currentLocation,
                                      imagesCollectionID: imagesCollectionsID,
                                      imageDownloadURL1: imageDownloadURL1,
                                      imageDownloadURL2: imageDownloadURL2,
                                      imageDownloadURL3: imageDownloadURL3,
                                      imageDownloadURL4: imageDownloadURL4,
                                    );
                                    if (result == true) {
                                      setState(() {
                                        isUploading = false;
                                      });
                                      Navigator.pushReplacementNamed(
                                          context, '/profile');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  getCurrentLocation() async {
    final currentLocation =
        await locationService.determinePosition(context: context);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);

    Placemark place = placemarks[0];
    setState(() {
      this.currentLocation =
          '${place.locality}, ${place.administrativeArea}, ${place.country}';
    });
  }

  Future<dynamic> uploadFile(String filePath, AuthService user) async {
    final name =
        '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().hashCode}';
    File file = File(filePath.split('file://')[1]);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('Users/${user.user?.uid}/BookImages/$imagesCollectionsID/$name'
              '.png')
          .putFile(file);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(
              'Users/${user.user?.uid}/BookImages/$imagesCollectionsID/$name.png')
          .getDownloadURL();
      return downloadURL;
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      return e;
    }
  }

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _random.nextInt(_chars.length),
          ),
        ),
      );
}
