import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../theme/color_palette.dart';
import 'arrow_button.dart';
class AddressLabel extends StatefulWidget {
  final String address;
  final bool isCenter;
  final bool startAddressAnimation;

  const AddressLabel({super.key, required this.address, this.isCenter = false, required this.startAddressAnimation});

  @override
  State<AddressLabel> createState() => _AddressLabelState();
}

class _AddressLabelState extends State<AddressLabel> with SingleTickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _widthAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const double _minWidth = 60;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        _widthAnimation = Tween<double>(
          begin: _minWidth,
          end: maxWidth,
        ).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.startAddressAnimation &&
              !_mainController.isAnimating &&
              !_mainController.isCompleted) {
            _mainController.forward();
          }
        });

        return AnimatedBuilder(
          animation: _mainController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: _widthAnimation.value,
                    height: 60,
                    padding: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorPalette().darkBeige.withOpacity(0.85),
                          ColorPalette().darkBeige.withOpacity(0.75),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: widget.isCenter
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Padding(
                              padding: EdgeInsets.only(left: widget.isCenter ? 0 : 10),
                              child: Text(
                                widget.address,
                                style: GoogleFonts.manrope(
                                  fontSize: widget.isCenter ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorPalette().black.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: ArrowButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
