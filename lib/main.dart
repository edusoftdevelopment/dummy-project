import 'package:dummy_project/feature/pdf_to_image_page/pdf_to_image_page.dart';
import 'package:dummy_project/feature/recipt_page/recept_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dummy Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ReceiptPage(),
    );
  }
}
