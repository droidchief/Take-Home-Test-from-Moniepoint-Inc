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

class _HomePageState extends State<HomePage> {
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          decoration: BoxDecoration(
                              color: ColorPalette().white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.location, size: 20, color: ColorPalette().lightBrown),
                              const Gap(3),
                              Text(
                                "Saint Petersburg",
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorPalette().lightBrown,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette().lightBrown,
                            image: DecorationImage(image: AssetImage("assets/images/profile.png"))
                          ),
                        )
                      ],
                    ),
                    const Gap(40),
                    Text(
                      "Hi, Marina",
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: ColorPalette().lightBrown,
                      ),
                    ),
                    Text(
                      "let's select your \nperfect place",
                      style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette().black,
                          height: 0
                      ),
                    ),
                    const Gap(50),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
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
                                        fontWeight: FontWeight.w700,
                                        color: ColorPalette().white,
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: ColorPalette().white,
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
                        const Gap(10),
                        Expanded(
                          flex: 1,
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
                                        fontWeight: FontWeight.w700,
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
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