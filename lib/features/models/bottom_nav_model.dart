import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BottomNavModel {
  final String? title;
  final IconData icon;

  BottomNavModel({this.title, required this.icon});
}

List<BottomNavModel> bottomNavItems = [
  BottomNavModel(title: 'Search', icon: Iconsax.search_normal_1),
  BottomNavModel(title: 'Chats', icon: Iconsax.message),
  BottomNavModel(title: 'Home', icon: Iconsax.home),
  BottomNavModel(title: 'Favourite', icon: Iconsax.heart),
  BottomNavModel(title: 'Account', icon: Iconsax.user),
];