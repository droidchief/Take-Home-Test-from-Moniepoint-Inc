import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:monie_point_flutter_test/features/theme/color_palette.dart';
import 'package:monie_point_flutter_test/features/widgets/custom_marker.dart';

import '../models/custom_marker_model.dart';
import '../widgets/ripple_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _mapStyle;
  GoogleMapController? mapController;
  bool _isMapReady = false;

  final List<CustomMarkerModel> markerPositions = [
    CustomMarkerModel(position: Offset(120, 160), price: 10.3, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(140, 215), price: 11, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(300, 240), price: 7.8, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(300, 350), price: 8.5, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(80, 400), price: 13.3, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(250, 450), price: 6.95, icon: Iconsax.house),
  ];


  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString('assets/uber_style.txt');
    setState(() {
      _mapStyle = style;
      _isMapReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette().black,
      floatingActionButtonLocation: ExpandableFab.location,
      body: SafeArea(
        child: Stack(
          children: [
            if (_isMapReady)
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(9.1099, 7.4042),
                  zoom: 11,
                ),
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                compassEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle);
                  mapController ??= controller;
                },
              )
            else
              Container(
                color: ColorPalette().black,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorPalette().white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.search_normal_copy,
                                  size: 20,
                                  color: ColorPalette().black.withOpacity(0.7)),
                              const Gap(5),
                              Text(
                                "Saint Petersburg",
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPalette().black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: ColorPalette().white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Iconsax.arrow_2, size: 16,),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 143,
              left: 35,
              child: RippleButton(
                icon: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Iconsax.empty_wallet_copy, size: 20, color: ColorPalette().white,),
                ),
                onTap: () {

                },
              ),
            ),

            Positioned(
              bottom: 85,
              left: 35,
              child: RippleButton(
                icon: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Transform.rotate(
                    angle: 0.8,
                    child: Icon(Iconsax.direct_up_copy, size: 20, color: ColorPalette().white,),
                  ),
                ),
                onTap: () {

                },
              ),
            ),

            Positioned(
              bottom: 85,
              right: 35,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: ColorPalette().darkGray.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Iconsax.textalign_left, size: 20, color: ColorPalette().white,),
                      const Gap(8),
                      Text(
                        "List of variants",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: ColorPalette().white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              ,
            ),

            Stack(
              children: markerPositions.map((data) {
                return Positioned(
                  left: data.position.dx,
                  top: data.position.dy,
                  child: CustomMarker(model: data),
                );
              }).toList(),
            )


          ],
        ),
      ),
    );
  }
}
