import 'package:flutter/material.dart';
import 'package:question_me/video_recorder.dart';
import 'pickpdf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker Demo',
      home: PdftoText(),
    );
  }
}
