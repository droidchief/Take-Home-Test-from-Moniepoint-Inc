import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../theme/color_palette.dart';
import 'arrow_button.dart';
class AddressLabel extends StatelessWidget {
  final String address;
  final bool isCenter;

  const AddressLabel({super.key, required this.address, this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.only(right: 3, left: 10),
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorPalette().darkBeige.withOpacity(0.85),
                ColorPalette().darkBeige.withOpacity(0.75),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ),
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
                alignment: isCenter ? Alignment.center : Alignment.centerLeft ,
                child: Text(
                  address,
                  style: GoogleFonts.manrope(
                    fontSize: isCenter ? 16 : 14,
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
        ),
      ),
    );
  }
}
