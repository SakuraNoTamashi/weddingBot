import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_example/reproductor_widget.dart';

import './MainPage.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => VideoPlayerWidget(),
        '/devices': (context) => MainPage()
      },
    );
  }
}
