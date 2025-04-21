import 'package:flutter/material.dart';
import 'package:monie_point_flutter_test/features/screens/favourite_page.dart';
import 'package:monie_point_flutter_test/features/screens/home_page.dart';
import 'package:monie_point_flutter_test/features/screens/profile_page.dart';
import 'package:monie_point_flutter_test/features/screens/search_page.dart';
import 'package:monie_point_flutter_test/features/theme/color_palette.dart';

import '../models/bottom_nav_model.dart';
import '../screens/chats_page.dart';

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
    ChatsPage(),
    HomePage(),
    FavouritePage(),
    ProfilePage(),
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

    // Start the animation 6 seconds after when widget is ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 6000));
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
                  margin: const EdgeInsets.symmetric(horizontal: 70),
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
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: selectedNavIndex == index
                                    ? ColorPalette().secondaryColor
                                    : ColorPalette().inActiveNavIcon,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  transitionBuilder: (child, animation) =>
                                      FadeTransition(opacity: animation, child: child),
                                  child: Icon(
                                    bottomNavItems[index].icon,
                                    key: ValueKey<bool>(selectedNavIndex == index),
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
            ),
          ),
        ],
      ),
    );
  }
}
