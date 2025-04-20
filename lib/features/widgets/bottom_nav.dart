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

class _BottomNavState extends State<BottomNav> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  List<Widget> pages = [
    SearchPage(),
    Text("Chats"),
    HomePage(),
    Text("Favourites"),
    Text("Account"),
  ];

  int selectedNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: pages[selectedNavIndex],
          ),

          // Slide in Bottom Nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Container(
                  height: 66,
                  margin: const EdgeInsets.symmetric(horizontal: 75),
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
                          margin: const EdgeInsets.symmetric(horizontal: 5),
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
          ),
        ],
      ),
    );
  }
}
