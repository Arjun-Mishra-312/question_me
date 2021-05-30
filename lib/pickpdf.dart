import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:pdf_text/pdf_text.dart';
import 'package:question_me/video_recorder.dart';
import 'package:sawo/sawo.dart';

class PdftoText extends StatefulWidget {
  @override
  _PdftoText createState() => _PdftoText();
}

class _PdftoText extends State<PdftoText> {
  PDFDoc? _pdfDoc;
  String _text = "";
  bool loggedin = false;

  // user payload
  String? user;
  void payloadCallback(context, payload) {
    if (payload == null || (payload is String && payload.length == 0)) {
      payload = "Login Failed :(";
    }
    setState(() {
      user = payload;
      loggedin = !loggedin;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdftoText(),
      ),
    );
  }

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
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  fontFamily: GoogleFonts.robotoMono().fontFamily),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Visibility(
              visible: true,
              child: Text(
                loggedin
                    ? "Choose your resume PDF to get started"
                    : "Login with phone number to get started",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    fontFamily: GoogleFonts.robotoMono().fontFamily),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(flex: 2),
            Visibility(
              visible: loggedin,
              child: TextButton(
                child: Text(
                  "Upload resume",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: GoogleFonts.robotoMono().fontFamily),
                ),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    backgroundColor: Colors.blueAccent),
                onPressed: _pickPDFText,
              ),
            ),
            Visibility(
              visible: !loggedin,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Sawo(
                      apiKey: "a9b60e57-6c15-4b8e-b987-6fc3200ce4c5",
                      secretKey:
                          "60b3b1bfc3c4efd4eaf3e7cdFj3XHbJ2Xb0wKgZgUdgILM5s",
                    ).signIn(
                      context: context,
                      identifierType: 'phone_number_sms',
                      callback: payloadCallback,
                    );
                  },
                  child: Text('Phone Login',
                      style: GoogleFonts.robotoMono(
                          fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
            Spacer(
              flex: 18,
            ),
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
    setState(() {});

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
        ),
      ),
    );
  }
}
