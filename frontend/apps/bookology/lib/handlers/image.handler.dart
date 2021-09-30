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

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHandler {
  final BuildContext context;

  ImageHandler(this.context);

  Future<dynamic> picImage({
    required ImageSource source,
    required String imageURI,
    double? aspectRatioX = 1,
    double? aspectRatioY = 1,
    CropStyle? cropStyle = CropStyle.circle,
  }) async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile? photo = (await _picker.getImage(source: source));

    final croppedImage = await _cropImage(
      pickedImage: photo,
      imageURI: imageURI,
      aspectRatioX: aspectRatioX,
      aspectRatioY: aspectRatioY,
      cropStyle: cropStyle,
    );

    return croppedImage;
  }

  Future<dynamic> _cropImage({
    required PickedFile? pickedImage,
    required String imageURI,
    double? aspectRatioX,
    double? aspectRatioY,
    CropStyle? cropStyle,
  }) async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: pickedImage!.path,
      cropStyle: cropStyle!,
      aspectRatio:
          CropAspectRatio(ratioX: aspectRatioX!, ratioY: aspectRatioY!),
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Theme.of(context).appBarTheme.backgroundColor,
        toolbarTitle: 'Crop Image',
      ),
      compressQuality: 50,
    ) as File;
    return imageURI = 'file://${cropped.path}';
  }

  Future<dynamic> uploadImage({
    required String filePath,
    required String imagePath,
    required String imageName,
  }) async {
    File file = File(filePath.split('file://')[1]);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('$imagePath/$imageName.png')
          .putFile(file);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('$imagePath/$imageName.png')
          .getDownloadURL();
      return downloadURL;
    } on firebase_core.FirebaseException {
      rethrow;
    }
  }
}
