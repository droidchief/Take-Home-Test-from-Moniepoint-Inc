import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monie_point_flutter_test/features/models/custom_marker_model.dart';
import 'package:monie_point_flutter_test/features/theme/color_palette.dart';

class CustomMarker extends StatefulWidget {
  final CustomMarkerModel model;
  CustomMarker({super.key, required this.model});

  @override
  State<CustomMarker> createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 80,
      decoration: BoxDecoration(
        color: ColorPalette().secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Text(
          "${widget.model.price} mn P",
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: ColorPalette().beige,
          ),
        ),
      ),
    );
  }
}
