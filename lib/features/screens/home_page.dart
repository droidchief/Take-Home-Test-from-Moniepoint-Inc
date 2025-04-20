import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:monie_point_flutter_test/features/theme/color_palette.dart';

import '../widgets/property_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _profileEntryController;
  late AnimationController _dashboardEntryController;
  late AnimationController _locationBarExpandController;
  late AnimationController _locationIconController;
  late AnimationController _welcomeTextController;

  late Animation<double> _profileScaleAnimation;
  late Animation<double> _dashboardScaleAnimation;
  late Animation<double> _locationBarWidthAnimation;
  late Animation<double> _locationContentFadeAnimation;
  late Animation<double> _welcomeTextFadeAnimation;
  late Animation<Offset> _welcomeTextSlideAnimation;
  late Animation<double> _welcomeTextRevealAnimation;


  @override
  void initState() {
    _profileEntryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _dashboardEntryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _profileScaleAnimation = CurvedAnimation(
      parent: _profileEntryController,
      curve: Curves.easeOutCubic,
    );

    _dashboardScaleAnimation = CurvedAnimation(
      parent: _dashboardEntryController,
      curve: Curves.easeOutCubic,
    );

    _locationBarExpandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _locationBarWidthAnimation = Tween<double>(begin: 0, end: 180).animate(
      CurvedAnimation(
        parent: _locationBarExpandController,
        curve: Curves.easeOut,
      ),
    );

    _locationIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Fade-in animation (opacity goes from 0 to 1)
    _locationContentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _locationIconController,
        curve: Curves.easeIn,
      ),
    );

    _welcomeTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _welcomeTextFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _welcomeTextController,
        curve: Curves.easeIn,
      ),
    );

    _welcomeTextSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _welcomeTextController,
        curve: Curves.easeOutCubic,
      ),
    );

    _welcomeTextRevealAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _welcomeTextController,
        curve: Curves.easeOutCubic,
      ),
    );

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback( (_) {
      _profileEntryController.forward();
      // Start the width animation
      _locationBarExpandController.forward().then((_) {
        _locationIconController.forward().then((_) {
          _welcomeTextController.forward();
          _dashboardEntryController.forward();
        });
      });

    });

    super.initState();
  }

  @override
  void dispose() {
    _profileEntryController.dispose();
    _locationBarExpandController.dispose();
    _locationIconController.dispose();
    _welcomeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorPalette().beige,
                  ColorPalette().warmPeach,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedBuilder(
                          animation: _locationBarExpandController,
                          builder: (context, child) {
                            return ClipRect(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                widthFactor: _locationBarWidthAnimation.value / 180,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ColorPalette().white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      FadeTransition(
                                        opacity: _locationContentFadeAnimation,
                                        child: Icon(Iconsax.location, size: 20, color: ColorPalette().lightBrown),
                                      ),
                                      const Gap(3),
                                      FadeTransition(
                                        opacity: _locationContentFadeAnimation,
                                        child: Text(
                                          "Saint Petersburg",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: ColorPalette().lightBrown,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        ScaleTransition(
                          scale: _profileScaleAnimation,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorPalette().lightBrown,
                              image: DecorationImage(image: AssetImage("assets/images/profile.png"))
                            ),
                          ),
                        )
                      ],
                    ),
                    const Gap(40),
                    FadeTransition(
                      opacity: _welcomeTextFadeAnimation,
                      child: Text(
                        "Hi, Marina",
                        style: GoogleFonts.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette().lightBrown,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: FadeTransition(
                        opacity: _welcomeTextFadeAnimation,
                        child: SlideTransition(
                          position: _welcomeTextSlideAnimation,
                          child: AnimatedBuilder(
                            animation: _welcomeTextRevealAnimation,
                            builder: (context, child) {
                              return ClipRect(
                                child: Align(
                                  alignment: Alignment.topLeft, // Change from bottomLeft to topLeft
                                  heightFactor: _welcomeTextRevealAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              "let's select your \nperfect place",
                              style: GoogleFonts.manrope(
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                                color: ColorPalette().black,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(40),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ScaleTransition(
                            scale: _dashboardScaleAnimation,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorPalette().secondaryColor,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 20,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        "BUY",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: ColorPalette().warmPeach,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "1034\n",
                                              style: GoogleFonts.manrope(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w700,
                                                color: ColorPalette().white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "offers",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorPalette().warmPeach,
                                                  height: 0
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 1,
                          child: ScaleTransition(
                            scale: _dashboardScaleAnimation,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: ColorPalette().offWhite,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 20,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        "RENT",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: ColorPalette().lightBrown,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "2 212\n",
                                              style: GoogleFonts.manrope(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w700,
                                                color: ColorPalette().lightBrown,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "offers",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorPalette().lightBrown,
                                                  height: 0
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.38,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: ColorPalette().white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.only(top: 8),
                  controller: scrollController,
                  children: [
                    PropertyCard(
                      imageAsset: "assets/images/random_image_1.png",
                      address: "Gladkova St., 25",
                      height: 200,
                      isAddressCenter: true,
                    ),
                    const Gap(10),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: PropertyCard(
                            imageAsset: "assets/images/random_image_2.png",
                            address: "Gubina St., 11",
                            height: 350,
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              PropertyCard(
                                imageAsset: "assets/images/random_image_3.png",
                                address: "Trefoleva St., 43",
                                height: 170,
                              ),
                              const Gap(10),
                              PropertyCard(
                                imageAsset: "assets/images/random_image_4.png",
                                address: "Sedova St., 22",
                                height: 170,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}