import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String imageURl;

  const ImageViewer({Key? key, required this.imageURl}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'View Image',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.white),
            imageProvider: FileImage(
              File.fromUri(
                Uri.parse(widget.imageURl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
