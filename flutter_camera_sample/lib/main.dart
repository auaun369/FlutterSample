import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_sample/camera_preview.dart';

Future<void> main() async {
  //main関数内で非同期処理を呼び出すための設定
  WidgetsFlutterBinding.ensureInitialized();

  //デバイスで使用可能なカメラのリストを取得
  final cameras = await availableCameras();

  //使用可能なカメラのリストから特定のカメラを取得
  final firstCamera = cameras.first;

  //取得できているか確認
  print(firstCamera);

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TakePictureScreen(camera: camera),
    );
  }
}