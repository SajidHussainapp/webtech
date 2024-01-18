import 'package:flutter/material.dart';
import 'package:webtech/pages/book_on.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookOn(),
    );
  }
}



