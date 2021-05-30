import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_me/video_recorder.dart';
import 'pickpdf.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  runApp(MyApp());
  await dotenv.load(fileName: '.env');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(225, 245, 252, 1.0),
      statusBarColor: Color.fromRGBO(0, 111, 138, 1.0),
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PdftoText(),
    );
  }
}
