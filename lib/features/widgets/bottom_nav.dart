import 'package:flutter/material.dart';
import 'package:monie_point_flutter_test/features/screens/home_page.dart';
import 'package:monie_point_flutter_test/features/screens/search_page.dart';
import 'package:monie_point_flutter_test/features/theme/color_palette.dart';

import '../models/bottom_nav_model.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Widget> pages = [
    SearchPage(),
    Text("Chats"),
    HomePage(),
    Text("Favourites"),
    Text("Account"),
  ];

  int selectedNavIndex = 2;

  Color getBottomBarColor(int page) {
    switch(page) {
      case 0:
        return ColorPalette().black;
      case 2:
        return ColorPalette().warmPeach;
    }

    return ColorPalette().black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBottomBarColor(selectedNavIndex),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: pages[selectedNavIndex],
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Container(
                height: 66,
                margin: EdgeInsets.symmetric(horizontal: 80),
                decoration: BoxDecoration(
                  color: ColorPalette().background,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette().background.withOpacity(0.3),
                      offset: Offset(0, 20),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    bottomNavItems.length,
                        (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedNavIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: selectedNavIndex == index
                              ? ColorPalette().secondaryColor
                              : ColorPalette().inActiveNavIcon,
                          shape: BoxShape.circle,
                        ),
                        height: selectedNavIndex == index ? 50 : 40,
                        width: selectedNavIndex == index ? 50 : 40,
                        child: Icon(
                          bottomNavItems[index].icon,
                          color: ColorPalette().white,
                          size: selectedNavIndex == index ? 24 : 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
