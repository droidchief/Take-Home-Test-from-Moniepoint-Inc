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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pages[selectedNavIndex],),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 66,
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 70),
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
                  (index) =>
                  GestureDetector(
                    onTap: () {
                      selectedNavIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedNavIndex == index
                              ? ColorPalette().activeNavIcon
                              : ColorPalette().inActiveNavIcon ,
                          shape: BoxShape.circle
                      ),
                      height: selectedNavIndex == index ? 50 : 40,
                      width: selectedNavIndex == index ? 50 : 40,
                      child: Icon(
                        bottomNavItems[index].icon,
                        color: Colors.white, size: 20,
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
