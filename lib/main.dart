import 'package:creditscanner/pages/scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'pages/home_page.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Camera error: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orange Recharge App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(cameras: cameras),
        '/scanner': (context) => ScannerPage(cameras: cameras),
      },
    );
  }
}