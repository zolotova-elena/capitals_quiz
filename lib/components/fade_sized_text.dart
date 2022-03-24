import 'package:flutter/material.dart';

class FadeSizedText extends StatelessWidget {
  final String text;
  final Duration duration;
  final TextStyle? style;

  const FadeSizedText(
    this.text, {
    Key? key,
    this.duration = const Duration(milliseconds: 200),
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: AnimatedSwitcher(
        duration: duration,
        child: Text(
          text,
          key: ValueKey(text),
          style: style,
        ),
      ),
    );
  }
}
