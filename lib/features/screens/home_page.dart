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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _mainController;

  // Animations
  late Animation<double> _profileScaleAnimation;
  late Animation<double> _dashboardScaleAnimation;
  late Animation<double> _locationBarWidthAnimation;
  late Animation<double> _locationContentFadeAnimation;
  late Animation<double> _welcomeTextFadeAnimation;
  late Animation<Offset> _welcomeTextSlideAnimation;
  late Animation<double> _welcomeTextRevealAnimation;
  late Animation<double> _countAnimation;

  // Count values for animations
  String _buyCount = "0";
  String _rentCount = "0";

  // Property sheet controller
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Profile scale animation
    _profileScaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
    );

    // Location bar width animation
    _locationBarWidthAnimation = Tween<double>(begin: 0, end: 180).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    // Location content fade animation
    _locationContentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.5, curve: Curves.easeIn),
      ),
    );

    // Welcome text animations
    _welcomeTextFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.6, curve: Curves.easeIn),
      ),
    );

    _welcomeTextSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _welcomeTextRevealAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Dashboard entry animation
    _dashboardScaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.6, 0.8, curve: Curves.easeOutCubic),
    );

    // Count animation
    _countAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    _countAnimation.addListener(_updateCounts);

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mainController.forward().then((_) {
        _sheetController.animateTo(
          0.68,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _updateCounts() {
    if (!mounted) return;
    setState(() {
      _buyCount = (_countAnimation.value * 1034).toInt().toString();
      _rentCount = (_countAnimation.value * 2212).toInt().toString();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _mainController.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (_mainController.status == AnimationStatus.forward) {
        _mainController.forward();
      }
    }
  }

  @override
  void dispose() {
    _mainController.removeListener(_updateCounts);
    _mainController.dispose();
    _sheetController.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
                        RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: _locationBarWidthAnimation,
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
                        ),

                        RepaintBoundary(
                          child: ScaleTransition(
                            scale: _profileScaleAnimation,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorPalette().lightBrown,

                                  image: DecorationImage(image: AssetImage("assets/images/profile.jpg"))
                              ),
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
                                  alignment: Alignment.topLeft,
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

                    // Dashboard cards
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: RepaintBoundary(
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
                                                text: "$_buyCount\n",
                                                style: GoogleFonts.manrope(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w900,
                                                  color: ColorPalette().white,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "offers",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorPalette().warmPeach,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 1,
                          child: RepaintBoundary(
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
                                                text: "$_rentCount\n",
                                                style: GoogleFonts.manrope(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w900,
                                                  color: ColorPalette().brown,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "offers",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorPalette().lightBrown,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
            controller: _sheetController,
            initialChildSize: 0,
            minChildSize: 0,
            maxChildSize: 0.68,
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
                  padding: const EdgeInsets.only(top: 8),
                  controller: scrollController,
                  children: const [
                    PropertyCard(
                      imageAsset: "assets/images/random_image_1.jpg",
                      address: "Gladkova St., 25",
                      height: 250,
                      isAddressCenter: true,
                    ),
                    Gap(10),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: PropertyCard(
                            imageAsset: "assets/images/random_image_2.jpg",
                            address: "Gubina St., 11",
                            height: 360,
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              PropertyCard(
                                imageAsset: "assets/images/random_image_3.jpg",
                                address: "Trefoleva St., 43",
                                height: 175,
                              ),
                              Gap(10),
                              PropertyCard(
                                imageAsset: "assets/images/random_image_4.jpg",
                                address: "Sedova St., 22",
                                height: 175,
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