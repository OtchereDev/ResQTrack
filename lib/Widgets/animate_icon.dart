import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlinkingSvg extends StatefulWidget {
  final bool forLogin;
  final bool isBig;

  const BlinkingSvg({super.key, required this.forLogin, this.isBig = false});
  @override
  _BlinkingSvgState createState() => _BlinkingSvgState();
}

class _BlinkingSvgState extends State<BlinkingSvg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Blink duration
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
            opacity: _controller.value, // This controls the blinking
            child: SvgPicture.asset(
              height: widget.isBig ? 100 : null,
              width: widget.isBig ? 100 : null,
              widget.forLogin
                  ? 'assets/icons/alarm.svg'
                  : 'assets/icons/siren.svg',
            ));
      },
    );
  }
}
