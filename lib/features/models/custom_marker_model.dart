
import 'package:flutter/cupertino.dart';

class CustomMarkerModel {
  final Offset position;
  final double price;
  final IconData icon;

  CustomMarkerModel({
    required this.position,
    required this.price,
    required this.icon,
  });
}
