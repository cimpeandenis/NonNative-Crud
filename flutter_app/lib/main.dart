import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/phone_list.dart';

void main() {
  runApp(PhoneApp());
}

class PhoneApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'PhoneList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: PhoneList(),
    );
  }
}