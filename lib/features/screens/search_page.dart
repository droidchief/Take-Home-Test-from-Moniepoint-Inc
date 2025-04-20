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
import '../models/enums.dart';
import '../widgets/ripple_button.dart';

GlobalKey _markerKey = GlobalKey();

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  String? _mapStyle;
  GoogleMapController? mapController;
  bool _isMapReady = false;
  PropertyFilter selectedPropertyFilter = PropertyFilter.price;

  final List<CustomMarkerModel> markerPositions = [
    CustomMarkerModel(position: Offset(120, 200), price: 10.3, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(140, 255), price: 11, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(300, 280), price: 7.8, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(300, 390), price: 8.5, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(90, 440), price: 13.3, icon: Iconsax.house),
    CustomMarkerModel(position: Offset(250, 490), price: 6.95, icon: Iconsax.house),
  ];

  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;


  @override
  void initState() {
    super.initState();
    _loadMapStyle();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString('assets/uber_style.txt');
    setState(() {
      _mapStyle = style;
      _isMapReady = true;
    });
  }

  IconData getPropertyFilterIcon(PropertyFilter value) {
    switch(value) {
      case PropertyFilter.price:
        return Iconsax.empty_wallet_copy;
      case PropertyFilter.cosyArea:
        return Iconsax.shield_tick_copy;
      case PropertyFilter.infrastructure:
        return Iconsax.bag_copy;
      case PropertyFilter.withoutAnyLayer:
        return Iconsax.layer_copy;
    }
  }

  String getPropertyFilterLabel(PropertyFilter filter) {
    switch (filter) {
      case PropertyFilter.cosyArea:
        return 'Cosy areas';
      case PropertyFilter.price:
        return 'Price';
      case PropertyFilter.infrastructure:
        return 'Infrastructure';
      case PropertyFilter.withoutAnyLayer:
        return 'Without any layer';
    }
  }

  void _showOverlayOnTop(BuildContext context) {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Container(
              color: Colors.transparent,
            ),
          ),

          Positioned(
            left: offset.dx,
            top: offset.dy - 143,
            child: Material(
              color: Colors.transparent,
              child: ScaleTransition(
                alignment: Alignment.bottomLeft,
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: () {}, // Prevents tap from bubbling up to dismiss
                  child: Container(
                    width: 185,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: PropertyFilter.values.map((filter) {
                        final isSelected = selectedPropertyFilter == filter;

                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          horizontalTitleGap: 5,
                          leading: Icon(getPropertyFilterIcon(filter), color: isSelected ? ColorPalette().secondaryColor.withOpacity(0.8) : ColorPalette().darkGray, size: 20,),
                          title: Text(
                              getPropertyFilterLabel(filter),
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? ColorPalette().secondaryColor.withOpacity(0.8) : ColorPalette().darkGray,
                              )
                          ),
                          onTap: () {
                            setState(() {
                              selectedPropertyFilter = filter;
                            });
                            _removeOverlay();
                            debugPrint('Selected: $selectedPropertyFilter');
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    Future.delayed(Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  void _removeOverlay() async {
    await _controller.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
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
              child: Builder(
                builder: (context) {
                  return RippleButton(
                    key: _markerKey,
                    icon: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(getPropertyFilterIcon(selectedPropertyFilter), size: 20, color: ColorPalette().white,),
                    ),
                    onTap: () {
                      _showOverlayOnTop(context);
                    },
                  );
                }
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
