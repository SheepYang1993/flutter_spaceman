import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spaceman/settings.dart';
import 'package:flutter_spaceman/spaceman_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = '星际太空人';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(title),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: SpacemanView(
              settings: Settings(
                videoAssetsUrl: 'assets/video/spaceman.mp4',
                videoWidth: 275,
                videoHeight: 470,
                videoOffsetX: 205,
                videoOffsetY: 390,
                showFrameRate: true,
                showNumberHint: true,
                velocityXRange: 6,
                velocityYRange: 6,
                maxDistance: 90,
                totalCount: 50,
                eachMovePixel: 0.07,
                lineWidth: 1,
                maxAlpha: 1,
                radius: 1,
                touchRadius: 100,
                touchColor: Color.fromARGB(81, 176, 176, 176),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                ballColors: [
                  Colors.blue,
                  Colors.green,
                  Colors.teal,
                  Colors.red,
                  Colors.pink,
                  Colors.purple,
                  Colors.orange,
                  Colors.yellow,
                  Colors.amber,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
