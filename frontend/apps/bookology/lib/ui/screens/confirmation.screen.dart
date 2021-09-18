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
import 'package:bookology/managers/currency.manager.dart';
import 'package:bookology/models/book.model.dart';
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
  final BookModel book;

  const ConfirmationScreen({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final ApiService apiService = ApiService();
  final locationService = LocationService();
  String currentLocation = '';
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String imageDownloadURL1 = '';
  String imageDownloadURL2 = '';
  String imageDownloadURL3 = '';
  String imageDownloadURL4 = '';
  bool isUploading = false;
  String imagesCollectionsID = '';
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890_';
  final Random _random = Random();

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
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        title: Text(
          StringConstants.titleConfirmation,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: SafeArea(
          child: isUploading
              ? Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: LiquidCircularProgressIndicator(
                      value: 0.35,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.secondary,
                      ),
                      backgroundColor: Colors.white,
                      borderColor: ColorsConstant.darkColor,
                      borderWidth: 5.0,
                      direction: Axis.vertical,
                      center: const Text(
                        StringConstants.dialogUploading,
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
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
                                text: '${StringConstants.isbn}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.book.bookInformation.isbn,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '${StringConstants.bookName}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.book.bookInformation.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '${StringConstants.author}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.book.bookInformation.author,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '${StringConstants.publisher}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.book.bookInformation.publisher,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              text: TextSpan(
                                text: '${StringConstants.description}:  ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget
                                        .book.additionalInformation.description
                                        .trim(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: '${StringConstants.originalPrice}:  ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: widget.book.pricing.originalPrice,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '${StringConstants.sellingPrice}:  ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: widget.book.pricing.sellingPrice,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ImageHolder(
                                    onPressed: () {},
                                    onCancelled: () {},
                                    imageURL: widget
                                        .book.additionalInformation.images[0],
                                    showCloseButton: false,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ImageHolder(
                                    onPressed: () {},
                                    onCancelled: () {},
                                    imageURL: widget
                                        .book.additionalInformation.images[1],
                                    showCloseButton: false,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ImageHolder(
                                    onPressed: () {},
                                    onCancelled: () {},
                                    imageURL: widget
                                        .book.additionalInformation.images[2],
                                    showCloseButton: false,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ImageHolder(
                                    onPressed: () {},
                                    onCancelled: () {},
                                    imageURL: widget
                                        .book.additionalInformation.images[3],
                                    showCloseButton: false,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                OutLinedButton(
                                  text: StringConstants.upload,
                                  showText: true,
                                  showIcon: false,
                                  onPressed: () async {
                                    setState(() {
                                      isUploading = true;
                                    });
                                    await uploadFile(
                                            widget.book.additionalInformation
                                                .images[0],
                                            user)
                                        .then((value) {
                                      setState(() {
                                        imageDownloadURL1 = value;
                                      });
                                    }).then((value) async {
                                      await uploadFile(
                                              widget.book.additionalInformation
                                                  .images[1],
                                              user)
                                          .then((value) {
                                        setState(() {
                                          imageDownloadURL2 = value;
                                        });
                                      }).then((value) async {
                                        await uploadFile(
                                                widget
                                                    .book
                                                    .additionalInformation
                                                    .images[2],
                                                user)
                                            .then((value) {
                                          setState(() {
                                            imageDownloadURL3 = value;
                                          });
                                        }).then((value) async {
                                          await uploadFile(
                                                  widget
                                                      .book
                                                      .additionalInformation
                                                      .images[3],
                                                  user)
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
                                      book: BookModel(
                                        bookId: widget.book.bookId,
                                        uploaderId: widget.book.uploaderId,
                                        bookInformation:
                                            widget.book.bookInformation,
                                        additionalInformation:
                                            AdditionalInformation(
                                          images: [
                                            imageDownloadURL1,
                                            imageDownloadURL2,
                                            imageDownloadURL3,
                                            imageDownloadURL4,
                                          ],
                                          condition: widget.book
                                              .additionalInformation.condition,
                                          description: widget
                                              .book
                                              .additionalInformation
                                              .description,
                                          imagesCollectionId:
                                              imagesCollectionsID,
                                        ),
                                        pricing: Pricing(
                                          sellingPrice:
                                              widget.book.pricing.sellingPrice,
                                          originalPrice:
                                              widget.book.pricing.originalPrice,
                                          currency:
                                              CurrencyManager().setCurrency(
                                            location: currentLocation,
                                          ),
                                        ),
                                        createdOn: widget.book.createdOn,
                                        slugs: widget.book.slugs,
                                        location: currentLocation,
                                      ),
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
    } on firebase_core.FirebaseException {
      rethrow;
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
