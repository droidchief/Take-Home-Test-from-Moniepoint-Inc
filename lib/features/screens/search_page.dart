import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:monie_point_flutter_test/features/theme/color_palette.dart';
import 'package:monie_point_flutter_test/features/widgets/custom_marker.dart';

import '../models/constants.dart';
import '../models/enums.dart';
import '../widgets/ripple_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final _markerKey = GlobalKey();

  GoogleMapController? _mapController;
  String? _mapStyle;
  bool _isMapReady = false;
  bool _showMarkers = false;
  PropertyFilter selectedPropertyFilter = PropertyFilter.price;

  OverlayEntry? _overlayEntry;
  late AnimationController _overlayAnimationController;
  late Animation<double> _overlayAnimation;
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;

  // Preload map style
  final Future<String> _mapStyleFuture = rootBundle.loadString('assets/uber_style.txt');

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _prepareMapStyle();
  }

  void _initializeAnimations() {
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeOutCubic,
    );

    _overlayAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _overlayAnimation = CurvedAnimation(
        parent: _overlayAnimationController,
        curve: Curves.easeOutCubic
    );

    _scaleAnimationController.addStatusListener(_handleScaleAnimationStatus);
  }

  void _handleScaleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      setState(() {
        _showMarkers = true;
      });
    }
  }

  Future<void> _prepareMapStyle() async {
    try {
      _mapStyle = await _mapStyleFuture;
      if (mounted) {
        setState(() {
          _isMapReady = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _scaleAnimationController.removeStatusListener(_handleScaleAnimationStatus);
    _scaleAnimationController.dispose();
    _overlayAnimationController.dispose();
    _mapController?.dispose();
    super.dispose();
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
      builder: (context) => _buildOverlay(offset),
    );

    Overlay.of(context).insert(_overlayEntry!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayAnimationController.forward();
    });
  }

  Widget _buildOverlay(Offset offset) {
    return Stack(
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
              scale: _overlayAnimation,
              child: _buildFilterMenu(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterMenu() {
    final colorPalette = ColorPalette();
    return Container(
      width: 185,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
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
          return _buildFilterOption(filter, isSelected, colorPalette);
        }).toList(),
      ),
    );
  }

  Widget _buildFilterOption(PropertyFilter filter, bool isSelected, ColorPalette colorPalette) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      horizontalTitleGap: 5,
      leading: Icon(
        getPropertyFilterIcon(filter),
        color: isSelected ? colorPalette.secondaryColor.withOpacity(0.8) : colorPalette.darkGray,
        size: 20,
      ),
      title: Text(
          getPropertyFilterLabel(filter),
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isSelected ? colorPalette.secondaryColor.withOpacity(0.8) : colorPalette.darkGray,
          )
      ),
      onTap: () => _selectFilter(filter),
    );
  }

  void _selectFilter(PropertyFilter filter) {
    setState(() {
      selectedPropertyFilter = filter;
    });
    _removeOverlay();
  }

  void _removeOverlay() async {
    if (_overlayEntry == null) return;

    await _overlayAnimationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController?.setMapStyle(_mapStyle);

    // Small delay to prevent flicker
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      _scaleAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPalette = ColorPalette();

    return Scaffold(
      backgroundColor: colorPalette.mapBackground,
      floatingActionButtonLocation: ExpandableFab.location,
      body: SafeArea(
        child: FutureBuilder<String>(
            future: _mapStyleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return _buildMapLayout(colorPalette);
              }
              return Container(
                color: colorPalette.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget _buildMapLayout(ColorPalette colorPalette) {
    return Stack(
      children: [
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
          onMapCreated: _onMapCreated,
        ),

        _buildSearchBar(colorPalette),

        _buildBottomLeftButtons(colorPalette),

        _buildVariantsButton(colorPalette),

        if(_showMarkers) _buildCustomMarkers(),
      ],
    );
  }

  Widget _buildSearchBar(ColorPalette colorPalette) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration: BoxDecoration(
                  color: colorPalette.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.search_normal_copy,
                        size: 20,
                        color: colorPalette.black.withOpacity(0.7)),
                    const Gap(5),
                    Text(
                      "Saint Petersburg",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colorPalette.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(10),
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: colorPalette.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Iconsax.arrow_2, size: 16,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomLeftButtons(ColorPalette colorPalette) {
    return Positioned(
      bottom: 85,
      left: 35,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Builder(
              builder: (context) => RippleButton(
                key: _markerKey,
                icon: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    getPropertyFilterIcon(selectedPropertyFilter),
                    size: 20,
                    color: colorPalette.white,
                  ),
                ),
                onTap: () => _showOverlayOnTop(context),
              ),
            ),
          ),
          const Gap(8),
          ScaleTransition(
            scale: _scaleAnimation,
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
                  child: Icon(
                    Iconsax.direct_up_copy,
                    size: 20,
                    color: colorPalette.white,
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsButton(ColorPalette colorPalette) {
    return Positioned(
      bottom: 85,
      right: 35,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: colorPalette.darkGray.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(
                  Iconsax.textalign_left,
                  size: 20,
                  color: colorPalette.white,
                ),
                const Gap(8),
                Text(
                  "List of variants",
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorPalette.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomMarkers() {
    return Stack(
      children: markerPositions.map((data) {
        return Positioned(
          left: data.position.dx,
          top: data.position.dy,
          child: CustomMarker(
              model: data,
              propertyFilter: selectedPropertyFilter
          ),
        );
      }).toList(),
    );
  }
}