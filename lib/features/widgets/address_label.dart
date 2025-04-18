import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/color_palette.dart';
import 'arrow_button.dart';

class AddressLabel extends StatelessWidget {
  final String address;

  const AddressLabel({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorPalette().darkBeige,
            ColorPalette().darkBeige,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              address,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorPalette().black.withOpacity(0.8),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ArrowButton(),
          )
        ],
      ),
    );
  }
}
