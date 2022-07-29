import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_sample/display_picture_screen.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //写真を撮る
          final image = await _controller.takePicture();
          final path = image.path;
          print(path);
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(imagePath: path),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
