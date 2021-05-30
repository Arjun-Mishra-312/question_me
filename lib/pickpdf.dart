import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:pdf_text/pdf_text.dart';
import 'package:question_me/video_recorder.dart';

class PdftoText extends StatefulWidget {
  @override
  _PdftoText createState() => _PdftoText();
}

class _PdftoText extends State<PdftoText> {
  PDFDoc? _pdfDoc;
  String _text = "";



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: AssetImage("assets/rocket-image.jpg"), fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Question Me According To Me",
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w600, letterSpacing: 0.6,fontFamily: GoogleFonts.robotoMono().fontFamily),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Choose your resume PDF to get started",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.6,fontFamily: GoogleFonts.robotoMono().fontFamily),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            TextButton(
              child: Text(
                "Pick PDF document",
                style: TextStyle(color: Colors.white,fontFamily: GoogleFonts.robotoMono().fontFamily),
              ),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(5),
                  backgroundColor: Colors.blueAccent),
              onPressed: _pickPDFText,
            ),
            // TextButton(
            //   child: Text(
            //     "Read whole document",
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   style: TextButton.styleFrom(
            //       padding: EdgeInsets.all(5),
            //       backgroundColor: Colors.blueAccent),
            //   onPressed: _buttonsEnabled ? _readWholeDoc : () {},
            // ),
            // Spacer(),
            // Text(_text)
          ],
        ),
      )),
    );
  }

  /// Picks a new PDF document from the device
  Future _pickPDFText() async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);
      setState(() {});
      _readWholeDoc();
    }
  }

  /// Reads the whole document
  Future _readWholeDoc() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
    });

    String text = await _pdfDoc!.text;
    print(text);
    setState(() {
      _text = text;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyHomePage(
                text: _text,
              )),
    );
  }
}
