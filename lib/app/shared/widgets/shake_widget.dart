import 'dart:math';
import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    super.key,
    required this.child,
    this.shakeOffset = 3.0,
    this.shakeCount = 3,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration duration;

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    animationController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void shake() {
    animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final double sineValue = sin(
      widget.shakeCount * 2 * pi * animationController.value,
    );

    return Transform.translate(
      offset: Offset(sineValue * widget.shakeOffset, 0),
      child: widget.child,
    );
  }
}
