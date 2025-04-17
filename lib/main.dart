import 'package:flutter/material.dart';
import 'package:monie_point_flutter_test/features/widgets/bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monie Point Flutter Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: BottomNav(),
    );
  }
}

