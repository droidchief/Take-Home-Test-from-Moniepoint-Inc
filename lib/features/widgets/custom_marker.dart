import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monie_point_flutter_test/features/models/custom_marker_model.dart';
import 'package:monie_point_flutter_test/features/models/enums.dart';
import 'package:monie_point_flutter_test/features/theme/color_palette.dart';

class CustomMarker extends StatefulWidget {
  final PropertyFilter propertyFilter;
  final CustomMarkerModel model;

  const CustomMarker({
    super.key,
    required this.model,
    required this.propertyFilter,
  });

  @override
  State<CustomMarker> createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _widthController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _widthAnimation;

  bool _showText = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _widthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: widget.propertyFilter == PropertyFilter.price ? 1.0 : 0.0,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _widthAnimation = Tween<double>(begin: 45.0, end: 80.0).animate(
      CurvedAnimation(parent: _widthController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerAnimations();
    });
  }

  @override
  void didUpdateWidget(CustomMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.propertyFilter != widget.propertyFilter) {
      _triggerAnimations();
    }
  }

  void _triggerAnimations() {
    if (widget.propertyFilter == PropertyFilter.price) {
      _showText = false;
      _fadeController.reset();
      _widthController.forward();
      _scaleController.forward(from: 0.0);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _showText = true);
          _fadeController.forward();
        }
      });
    } else {
      _fadeController.reverse().then((_) {
        if (mounted) {
          setState(() => _showText = false);
          _widthController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      alignment: Alignment.bottomLeft,
      child: AnimatedBuilder(
        animation: _widthAnimation,
        builder: (_, child) {
          return Container(
            height: 45,
            width: _widthAnimation.value,
            decoration: BoxDecoration(
              color: ColorPalette().secondaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.propertyFilter == PropertyFilter.price
                    ? _showText
                    ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "${widget.model.price} mn P",
                    key: const ValueKey('text'),
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: ColorPalette().beige,
                    ),
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('empty'))
                    : Icon(
                  Icons.apartment,
                  key: const ValueKey('icon'),
                  color: ColorPalette().beige,
                  size: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


