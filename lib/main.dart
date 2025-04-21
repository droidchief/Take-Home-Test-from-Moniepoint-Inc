import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monie_point_flutter_test/features/theme/color_palette.dart';
import 'package:monie_point_flutter_test/features/widgets/bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ColorPalette();

    return MaterialApp(
      title: 'Monie Point Flutter Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: palette.mapBackground,
        textTheme: GoogleFonts.manropeTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: palette.beige,
          brightness: Brightness.dark,
          background: palette.mapBackground,
        ),
      ),
      home: BottomNav(),
    );
  }
}
