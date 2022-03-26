import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  static const _updateDuration = Duration(milliseconds: 600);

  final Color startColor;
  final Color endColor;
  final Widget? child;

  const Background({
    Key? key,
    required this.startColor,
    required this.endColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: _updateDuration,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [startColor, endColor],
          ),
        ),
        child: child,
      );
}
