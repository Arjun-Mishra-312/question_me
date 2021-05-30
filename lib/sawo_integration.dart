import 'package:flutter/material.dart';
import 'package:question_me/pickpdf.dart';
import 'package:sawo/sawo.dart';

class SawoLogin extends StatefulWidget {
  @override
  _SawoLoginState createState() => _SawoLoginState();
}

class _SawoLoginState extends State<SawoLogin> {
  // user payload
  String? user;
  void payloadCallback(context, payload) {
    if (payload == null || (payload is String && payload.length == 0)) {
      payload = "Login Failed :(";
    }
    setState(() {
      user = payload;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdftoText(),
      ),
    );
  }

  login(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Sawo(
              apiKey: "a9b60e57-6c15-4b8e-b987-6fc3200ce4c5",
              secretKey: "60b3b1bfc3c4efd4eaf3e7cdFj3XHbJ2Xb0wKgZgUdgILM5s",
            ).signIn(
              context: context,
              identifierType: 'phone_number_sms',
              callback: payloadCallback,
            );
          },
          child: Text('Phone Login'),
        ),
      ),
    );
  }
}
