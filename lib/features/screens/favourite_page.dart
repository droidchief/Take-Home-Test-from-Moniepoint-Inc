import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/color_palette.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            "Favourites",
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: ColorPalette().white.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}
