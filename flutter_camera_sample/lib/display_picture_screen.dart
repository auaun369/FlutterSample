import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('撮れた写真')),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
