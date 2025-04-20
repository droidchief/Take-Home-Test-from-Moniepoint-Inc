import 'package:flutter/material.dart';

class RippleButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget icon;
  final double buttonSize;

  const RippleButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.buttonSize = 50,
  });

  @override
  State<RippleButton> createState() => _RippleButtonState();
}

class _RippleButtonState extends State<RippleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _rippleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _controller.reset();
    });
  }

  void _startRipple() {
    _controller.forward();
    widget.onTap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startRipple,
      child: SizedBox(
        height: widget.buttonSize,
        width: widget.buttonSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _RipplePainter(_rippleAnimation.value),
                  size: Size(widget.buttonSize, widget.buttonSize),
                );
              },
            ),
            widget.icon,
          ],
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  _RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(1 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final radius = size.width * 0.565 * progress;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
