import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pdf_text/pdf_text.dart';

class PdftoText extends StatefulWidget {
  @override
  _PdftoText createState() => _PdftoText();
}

class _PdftoText extends State<PdftoText> {
  PDFDoc? _pdfDoc;
  String _text = "";

  bool _buttonsEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
              child: Scaffold(
            body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextButton(
                child: Text(
                  "Pick PDF document",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    backgroundColor: Colors.blueAccent),
                onPressed: _pickPDFText,
              ),
              TextButton(
                child: Text(
                  "Read whole document",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    backgroundColor: Colors.blueAccent),
                onPressed: _buttonsEnabled ? _readWholeDoc : () {},
              ),
              Spacer(),
              Text(
                _text
              )
            ],
          ),
        )),
      ),
    );
  }

  /// Picks a new PDF document from the device
  Future _pickPDFText() async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      _pdfDoc = await PDFDoc.fromPath(filePickerResult.files.single.path!);
      setState(() {});
    }
  }

  /// Reads the whole document
  Future _readWholeDoc() async {
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text = await _pdfDoc!.text;
    print(text);
    // final rake = Rake();
    // print(rake.rank(text));
    setState(() {
      _text = text;
      _buttonsEnabled = true;
    });
  }
}
