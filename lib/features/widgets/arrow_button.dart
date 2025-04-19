import 'package:flutter/material.dart';

import '../theme/color_palette.dart';
class ArrowButton extends StatelessWidget {
  const ArrowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorPalette().white,
        boxShadow: [
          BoxShadow(
            color: ColorPalette().darkGray,
            blurRadius: 25,
            offset: const Offset(-15, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.keyboard_arrow_right_sharp,
        size: 16,
        color: ColorPalette().darkGray,
      ),
    );
  }
}